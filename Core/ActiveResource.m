#import "ActiveResource.h"
#import "HttpEngine.h"
#import "StringRestRepresentation.h"
#import "BasicHttpEngine.h"
#import "ReflectedInstance.h"
#import <objc/runtime.h> 
#import <objc/message.h>

id<HttpEngine> currentHttpEngine;
NSMutableDictionary *resourcesConfiguration;

@implementation ActiveResource

+(void) setHttpEngine:(id<HttpEngine>)resourceHttpEngine {
	currentHttpEngine = resourceHttpEngine;
}

+(id<HttpEngine>) httpEngine {
	if (currentHttpEngine == nil) {
		currentHttpEngine = [[BasicHttpEngine newInstance] retain];
	}
	return currentHttpEngine;
}

+(ResourceConfiguration *)getConfiguration {
	if (resourcesConfiguration == nil) {
		resourcesConfiguration = [[NSMutableDictionary dictionary] retain];
	}
	NSString *key = [[self class] description];
	if ([resourcesConfiguration objectForKey:key] == nil) {
		[resourcesConfiguration setObject:[ResourceConfiguration newInstanceForClass:self] forKey:key];
	}
	return [resourcesConfiguration objectForKey:key];
}

+(void) setSite:(NSString *)resourceSite {
	[self getConfiguration].site = resourceSite;
}

+(void) setRepresentation:(NSString *)representation {
	[self getConfiguration].representation = representation;
}

+(NSString *) getRepresentation {
	return [self getConfiguration].representation;
}

+(void) setElementName:(NSString *)resourceElementName {
	[self getConfiguration].elementName = resourceElementName;
}

+(NSString *) getElementName {
	return [self getConfiguration].elementName;
}

+(JSONResponse *) JSON {
	return [JSONResponse new];
}

+(NSString *) fullResourcePathForIdentifier:(id)identifier {
	return [[[self getConfiguration] resourceBaseUrl] stringByAppendingFormat:@"/%@", identifier]; 
}

+(NSString *) fullResourcePath {
	return [[self getConfiguration] resourceBaseUrl]; 
}

+ (id) buildResourceObjectFromDictionnary: (NSDictionary *) targetObjectAsKeyValues  {
	if ([targetObjectAsKeyValues count] == 0) {
		return nil;
	}	
	ReflectedInstance *reflectedInstance = [ReflectedInstance forClass:self];
	for (NSString *propertyName in [targetObjectAsKeyValues allKeys]) {	
		[reflectedInstance injectValue:[targetObjectAsKeyValues objectForKey:propertyName] intoPropertyNamed:propertyName];
	}	
	return reflectedInstance.targetInstance;
}

+(HttpResponse *)getResponseForUrl:(NSString *)url {
	return [self.httpEngine responseFromUrl:url withForcedMimeType:[self getRepresentation]]; 
}

+(id) findById:(id)identifier {
	HttpResponse *response = [self getResponseForUrl:[self fullResourcePathForIdentifier:identifier]]; 
	return [self buildResourceObjectFromDictionnary:[response getAsKeyValues]];
}

+(NSArray *) findAllAtUrl:(NSString *)url {
	NSMutableArray *results = [NSMutableArray array];
	HttpResponse *response = [self getResponseForUrl:url];
	for (NSDictionary *rawItem in [response getAsArrayOfkeyValues]) {
		[results addObject:[self buildResourceObjectFromDictionnary:rawItem]];
	}
	return results;
}

+(NSArray *) findAll {
	return [self findAllAtUrl:[self fullResourcePath]];
}

+(void) findAllAndCallback:(ArrayCallback)callback {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
		callback([self findAll]);
	});
}

+(void) findById:(id)identifier andCallback:(SingleCallback)callback {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	dispatch_async(queue, ^{
		callback([self findById:identifier]);
	});	
}

- (NSString *) dictionaryToJSON: (NSDictionary *) objectAsKeyValues  {
	NSMutableString *json = [[NSMutableString alloc] initWithString:@"{"];
	int index = 0;
	for (NSString *propertyName in [objectAsKeyValues allKeys]) {
		if(index > 0) [json appendString:@","];
		[json appendFormat:@"\"%@\":\"%@\"", propertyName, [objectAsKeyValues objectForKey:propertyName]];
		index++;
	}
	[json appendString:@"}"];
	return json;
}

-(void)save {
	Class resourceClass = [self class];
	ReflectedInstance *reflectedInstance = [ReflectedInstance withInstance:self];
	NSString *content = [self dictionaryToJSON:[reflectedInstance asDictionary]];
	[[resourceClass httpEngine] postOnUrl:[resourceClass fullResourcePath] withContent:content withMimeType:[resourceClass getRepresentation]];
}

+(NSArray *) parameterNamesInSelector:(SEL) selector {
	NSString *selectorName = NSStringFromSelector(selector);
	selectorName = [selectorName stringByReplacingOccurrencesOfString:@"findBy" withString:@""];
	selectorName = [selectorName stringByReplacingOccurrencesOfString:@"findAllBy" withString:@""];
	selectorName = [selectorName stringByReplacingOccurrencesOfString:@":" withString:@""];
	return [selectorName componentsSeparatedByString:@"And"];
}

+(NSString *) queryStringFromDictionary:(NSDictionary *)dictionary {
	NSString *queryString = @"?";
	for (NSString *parameterName in [[dictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]) {
		queryString = [queryString stringByAppendingFormat:@"%@=%@&", [parameterName lowercaseString], [dictionary objectForKey:parameterName]];	
	}
	return [queryString substringToIndex:[queryString length] - 1];	
}

static id dynamicFindBy(id self, SEL selector, id firstParamValue, ...) {
	NSArray *params = [self parameterNamesInSelector:selector];
	NSMutableDictionary *paramsAndValues = [NSMutableDictionary dictionary];
	id eachObject;
	va_list argumentList;
	if (firstParamValue) {
		int i = 0;
		[paramsAndValues setObject:firstParamValue forKey:[params objectAtIndex:i]];
		va_start(argumentList, firstParamValue);
		while (eachObject = va_arg(argumentList, id)) {
			[paramsAndValues setObject:eachObject forKey:[params objectAtIndex:++i]];	
		}
		va_end(argumentList);
	}
	NSString *resourceIdentifier = [self queryStringFromDictionary:paramsAndValues];
	return [self findById:resourceIdentifier];
}


static id dynamicFindAllBy(id self, SEL selector, id firstParamValue, ...) {
	NSArray *params = [self parameterNamesInSelector:selector];
	NSMutableDictionary *paramsAndValues = [NSMutableDictionary dictionary];
	id eachObject;
	va_list argumentList;
	if (firstParamValue) {
		int i = 0;
		[paramsAndValues setObject:firstParamValue forKey:[params objectAtIndex:i]];
		va_start(argumentList, firstParamValue);
		while (eachObject = va_arg(argumentList, id)) {
			[paramsAndValues setObject:eachObject forKey:[params objectAtIndex:++i]];	
		}
		va_end(argumentList);
	}
	NSString *resourceIdentifier = [self queryStringFromDictionary:paramsAndValues];
	return [self findAllAtUrl:[self fullResourcePathForIdentifier:resourceIdentifier]];
}

+ (BOOL)resolveClassMethod:(SEL)selector {
	Class metaClass = objc_getMetaClass([NSStringFromClass([self class]) UTF8String]);
	NSRange typeOfRequest = [NSStringFromSelector(selector) rangeOfString:@"findBy"];
	if (typeOfRequest.length > 0) {
		class_addMethod(metaClass, selector, (IMP)dynamicFindBy, "v@:@");
	}else {
		class_addMethod(metaClass, selector, (IMP)dynamicFindAllBy, "v@:@");
	}
	return TRUE;
}

@end
