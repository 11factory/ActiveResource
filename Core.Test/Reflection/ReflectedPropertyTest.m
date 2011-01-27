#import "ReflectedPropertyTest.h"
#import "ReflectedProperty.h"
#import "MultipleTypeResource.h"

@implementation ReflectedPropertyTest
MultipleTypeResource *fixture;

-(void)setUp {
	fixture = [[MultipleTypeResource alloc] init];
}

- (void) setValueFromString:(NSString *)rawValue forPropertyNamed:(NSString *)propertyName {
	ReflectedProperty *property = [[ReflectedProperty alloc] initWithPropertyName:propertyName onInstance:fixture];
	[property setValueFromString:rawValue];
}

- (void) testSupportNSNumberTypes {
	[self setValueFromString:@"4" forPropertyNamed:@"intNSNumberProperty"];
	[self setValueFromString:@"4.5" forPropertyNamed:@"floatNSNumberProperty"];
	[self setValueFromString:@"true" forPropertyNamed:@"boolNSNumberProperty"];
	STAssertEquals((int)[fixture.intNSNumberProperty intValue], 4, nil);	
	STAssertEquals((float)[fixture.floatNSNumberProperty floatValue], 4.5f, nil);	
	STAssertEquals((bool)[fixture.boolNSNumberProperty boolValue], (bool)true, nil);	
}

- (void) testSupportNSDateTypes {
	[self setValueFromString:@"1970-01-01T01:00:10Z" forPropertyNamed:@"dateProperty"];
	STAssertEqualObjects([fixture.dateProperty descriptionWithLocale:[NSLocale currentLocale]], [[NSDate dateWithTimeIntervalSince1970:10] descriptionWithLocale:[NSLocale currentLocale]], nil);	
}

- (void) testSupportPrimitiveTypes {
	[self setValueFromString:@"4" forPropertyNamed:@"intProperty"];
	[self setValueFromString:@"4.5" forPropertyNamed:@"floatProperty"];
	[self setValueFromString:@"true" forPropertyNamed:@"boolProperty"];	
	STAssertEquals((int)fixture.intProperty, 4, nil);	
	STAssertEquals((float)fixture.floatProperty, 4.5f, nil);	
	STAssertEquals((bool)fixture.boolProperty, (bool)true, nil);		
}
@end
