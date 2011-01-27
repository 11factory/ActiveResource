#import "HttpResponseTest.h"
#import "HttpResponse.h"
#import "JSONResponse.h"

@implementation HttpResponseTest

-(void)testJSONResponseIsSupported {
	STAssertEqualObjects([[HttpResponse responseWithContent:@"foo" ofType:@"application/json"] class], [JSONResponse class], nil);
}

-(void)testThrowNotImplementedWhenMimeIsNotSupported {
	bool execptionThrown = false;
	@try {
		[HttpResponse responseWithContent:@"foo" ofType:@"application/html"];
	}
	@catch (NSException * e) {
		execptionThrown = true;
		STAssertEqualObjects([e description], @"Mime type 'application/html' is not supported", nil);
	}
	@finally {
		STAssertTrue(execptionThrown, nil);
	}
}

@end
