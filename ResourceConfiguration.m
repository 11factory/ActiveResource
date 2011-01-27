#import "ResourceConfiguration.h"
#import "StringRestRepresentation.h"

@implementation ResourceConfiguration
@synthesize resourceClass, representation;

+(id)newInstanceForClass:(Class) configuratedClass {
	ResourceConfiguration *configuration = [[[ResourceConfiguration alloc] init] autorelease];
	configuration.resourceClass = configuratedClass;
	configuration.elementName = nil;
	return configuration;
}

-(void) setSite:(NSString *)resourceSite {
	site = resourceSite;
}

-(void) setElementName:(NSString *)resourceElementName {
	currentElementName = resourceElementName;
}

-(NSString *) site {
	return [site retain];
}

-(NSString *) elementName {
	if (currentElementName == nil) {
		currentElementName = [[[self.resourceClass description] stringInRestResourceFormat] retain];
	}
	return [currentElementName stringByAppendingString:@"s"];	
}

-(NSString *)resourceBaseUrl {
	return [site stringByAppendingString:[self elementName]]; 
}


@end
