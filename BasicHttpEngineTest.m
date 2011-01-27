#import "BasicHttpEngineTest.h"
#import "BasicHttpEngine.h"
#import "HttpRequestStubEngine.h"
#import "JSONResponse.h"

@implementation BasicHttpEngineTest
bool beginEventFired; 
bool endEventFired;
HttpRequestStubEngine *engine;

- (void) setUp {
	engine = [[HttpRequestStubEngine alloc] init];
}

- (void) testCanGetDataFromUrl {    
	[engine stubUrl:@"http://somewhere/" toAnswer:@"foo"];
	STAssertEqualObjects([engine responseFromUrl:@"http://somewhere/"].responseContent, @"foo", nil);
}

-(void) testBeforeRequestAndAferRequestNotificationsOnGetRequest {
	beginEventFired = FALSE;
	endEventFired = FALSE;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBeginNetworkActivity) name:@"BeginNetworkActivity" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEndNetworkActivity) name:@"EndNetworkActivity" object:nil];
	[engine stubUrl:@"http://somewhere/" toAnswer:@"foo"];
	[engine responseFromUrl:@"http://somewhere/"];
	STAssertTrue(beginEventFired, nil);
	STAssertTrue(endEventFired, nil);
}

-(void) testCanForceResponseType {
	[engine stubUrl:@"foo" toAnswer:@"bar" ofMimeType:@"plain/text"];
	STAssertEqualObjects([[engine responseFromUrl:@"foo" withForcedMimeType:@"application/json"] class], [JSONResponse class], nil);
}

-(void) testBeforeRequestAndAferRequestNotificationsOnPostRequest {
	beginEventFired = FALSE;
	endEventFired = FALSE;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBeginNetworkActivity) name:@"BeginNetworkActivity" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEndNetworkActivity) name:@"EndNetworkActivity" object:nil];
	[engine expectPostOnUrl:@"foo.com" withContent:@"bar" ofMimeType:@"my mime"];
	[engine postOnUrl:@"foo.com" withContent:@"bar" withMimeType:@"my mime"];
	STAssertTrue(beginEventFired, nil);
	STAssertTrue(endEventFired, nil);
}

-(void) onBeginNetworkActivity {
	beginEventFired = TRUE;
}

-(void) onEndNetworkActivity {
	endEventFired = TRUE;
}

@end
