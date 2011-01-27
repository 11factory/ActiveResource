#import "ReflectedInstanceTest.h"
#import "ReflectedInstance.h"
#import "StringResource.h"
#import "MultipleTypeResource.h"

ReflectedInstance *reflection;
StringResource *reflectedInstance;

@implementation ReflectedInstanceTest

-(void) setUp {
	reflectedInstance = [StringResource new];
	reflection = [ReflectedInstance withInstance:reflectedInstance];
}

-(void) testCanInjectAValueIntoAProperty {
	[reflection injectValue:@"foo" intoPropertyNamed:@"value"];
	STAssertEqualObjects(((StringResource *)(reflection.targetInstance)).value, @"foo", nil);
}

-(void) testCanGetAllPropertiesAsKeyValues {
	reflectedInstance.value = @"bar";
	NSDictionary *expectedProperties = [NSDictionary dictionaryWithObjectsAndKeys:@"bar", @"value", nil];
	STAssertEqualObjects([reflection asDictionary], expectedProperties, nil);
}

-(void) testCanGetAllPropertiesAsKeyValuesForAllBasicTypesProperties {
	MultipleTypeResource *multipleTypeResource = [MultipleTypeResource new];
	multipleTypeResource.intNSNumberProperty = [NSNumber numberWithInt:3];
	multipleTypeResource.floatProperty = 3.2f;
	multipleTypeResource.intProperty = 5;
	multipleTypeResource.boolProperty = true;
	reflection = [ReflectedInstance withInstance:multipleTypeResource];
	NSDictionary *expectedProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										@"3", @"intNSNumberProperty",
										@"3.2", @"floatProperty",
										@"1", @"boolProperty",
										@"5", @"intProperty", nil];
	STAssertEqualObjects([reflection asDictionary], expectedProperties, nil);
}
@end
