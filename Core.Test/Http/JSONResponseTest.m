#import "JSONResponseTest.h"
#import "JSONResponse.h"

@implementation JSONResponseTest
JSONResponse *jsonResponse;

-(void)setUp {
	jsonResponse = [JSONResponse new];
}
- (void) testCanGetKeyValues {
    NSDictionary *expectedKeyValues = [NSDictionary dictionaryWithObjectsAndKeys:@"value of a", @"a", @"value of b", @"b", nil];
	jsonResponse.responseContent = @"{\"b\": \"value of b\", \"a\": \"value of a\"}\n";
	STAssertEqualObjects([jsonResponse getAsKeyValues], expectedKeyValues, nil);
}

- (void) testCanGetMultipleObjectsInKeyValues {
	NSDictionary *expectedObject1 = [NSDictionary dictionaryWithObjectsAndKeys:@"v1", @"a1", nil];
	NSDictionary *expectedObject2 = [NSDictionary dictionaryWithObjectsAndKeys:@"v2", @"a2", nil];
	NSArray *expectedObjects = [NSArray arrayWithObjects:expectedObject1, expectedObject2, nil];
	jsonResponse.responseContent = @"{\"foo\":[{\"@a1\": \"v1\"},{\"a2\":\"v2\"}]\n";
	STAssertEqualObjects([jsonResponse getAsArrayOfkeyValues], expectedObjects, nil);
}

- (void) testSupportEmptyJSON {
	jsonResponse.responseContent = @"";
	STAssertEqualObjects([jsonResponse getAsArrayOfkeyValues], [NSArray array], nil);
}

@end
