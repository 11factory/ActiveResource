#import "ReflectedInstance.h"
#import "ReflectedProperty.h"
#import <objc/runtime.h> 
#import <objc/message.h>

@implementation ReflectedInstance
@synthesize targetInstance;

+(id) forClass:(Class)targetClass {
	ReflectedInstance *reflectedInstance = [[[ReflectedInstance alloc] initWithTargetClass:targetClass] autorelease];
	return reflectedInstance;
}

-(ReflectedInstance *) initWithTargetClass:(Class) targetClass {
	return [self initWithInstance:[[[targetClass alloc] init] autorelease]];
}

+(ReflectedInstance *) withInstance:(id) instance {
	ReflectedInstance *reflectedInstance = [[[ReflectedInstance alloc] initWithInstance:instance] autorelease];
	return reflectedInstance;
}

-(ReflectedInstance *) initWithInstance:(id) instance {
	self.targetInstance = instance;
	return self;
}

-(void) injectValue:(NSString *)rawValue intoPropertyNamed:(NSString *)propertyName {
	ReflectedProperty *property = [[ReflectedProperty alloc] initWithPropertyName:propertyName onInstance:self.targetInstance];
	[property setValueFromString:rawValue];
	[property release];
}

-(NSString *) stringWithCString:(const char*)cstring {
	return [NSString stringWithCString:cstring encoding:NSUTF8StringEncoding];
}

- (NSDictionary *) asDictionary {
	NSMutableDictionary *objectAsKeyValues = [NSMutableDictionary dictionary];
	unsigned int propertiesCount;
    objc_property_t *properties = class_copyPropertyList([self.targetInstance class], &propertiesCount);
    for(int i = 0; i < propertiesCount; i++) {
        const char *propName = property_getName(properties[i]);
		id value = [self.targetInstance valueForKey:[self stringWithCString:propName]];
		if (value == nil)
			continue;
		[objectAsKeyValues setObject:[NSString stringWithFormat:@"%@", value] forKey:[self stringWithCString:propName]];
    }
    free(properties);
	return objectAsKeyValues;
}

@end
