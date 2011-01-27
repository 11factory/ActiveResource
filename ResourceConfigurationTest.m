#import "ResourceConfigurationTest.h"
#import "ResourceConfiguration.h"

@implementation ResourceConfigurationTest

ResourceConfiguration *configuration;

-(void) setUp {
	configuration = [ResourceConfiguration newInstanceForClass:[self class]];
	configuration.site = @"http://foo.com/";
}

-(void) testDefaultResourceName {   
	STAssertEqualObjects(configuration.elementName, @"resource_configuration_tests", nil);
}

-(void) testCanOverrideDefaultResourceName {
	configuration.elementName = @"fooBar";
	STAssertEqualObjects(configuration.elementName, @"fooBars", nil);
}

-(void) testCanGetResourceUrl {
	configuration.elementName = @"resource_name";
	STAssertEqualObjects([configuration resourceBaseUrl], @"http://foo.com/resource_names", nil);
}

@end
