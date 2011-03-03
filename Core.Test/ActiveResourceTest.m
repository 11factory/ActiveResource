#import "ActiveResourceTest.h"
#import "ActiveResource.h"
#import "StringResource.h"
#import "BasicHttpEngine.h"
#import "HttpRequestStubEngine.h"

@implementation ActiveResourceTest
HttpRequestStubEngine *httpEngine;

-(void) setUp {
	StringResource.site = @"http://foo.com/";
	httpEngine = [[HttpRequestStubEngine alloc] init];
	ActiveResource.httpEngine = httpEngine;
}

- (void) testCanFindAResource {
	[httpEngine stubUrl:@"http://foo.com/string_resources/2" toAnswer:@"{\"value\":\"Well done\"}" ofMimeType:@"application/json"];
	StringResource *resource = [StringResource findById:[NSNumber numberWithInt:2]];
	STAssertEqualObjects(resource.value, @"Well done", nil);
}

- (void) testCanFindAll {
	[httpEngine stubUrl:@"http://foo.com/string_resources" toAnswer:@"{\"popup\": [{\"value\":\"v1\"}, {\"value\":\"v2\"}]" ofMimeType:@"application/json"];
	NSArray *resources = [StringResource findAll];
	STAssertEqualObjects(((StringResource *)[resources objectAtIndex:0]).value, @"v1", nil);
	STAssertEqualObjects(((StringResource *)[resources objectAtIndex:1]).value, @"v2", nil);
}

-(void) testThereIsOneConfigurationByResourceType {
	STAssertFalse([[ActiveResource getConfiguration] isEqual:[StringResource getConfiguration]], nil);
}

-(void) testCanFindAllAsynchronously {
	__block bool didSucceed = false;
	[httpEngine stubUrl:@"http://foo.com/string_resources" toAnswer:@"{\"popup\": [{\"value\":\"v1\"}, {\"value\":\"v2\"}]" ofMimeType:@"application/json"];
	[StringResource findAllAndCallback:^(NSArray *resources) {
		didSucceed = true;
		STAssertEqualObjects(((StringResource *)[resources objectAtIndex:0]).value, @"v1", nil);
		STAssertEqualObjects(((StringResource *)[resources objectAtIndex:1]).value, @"v2", nil);		
	}];
	[self sleep:0.5];
	STAssertTrue(didSucceed, nil);
}

-(void) testCanFindAsynchronously {
	__block bool didSucceed = false;
	[httpEngine stubUrl:@"http://foo.com/string_resources/1" toAnswer:@"{\"value\":\"v1\"}" ofMimeType:@"application/json"];
	[StringResource findById:@"1" andCallback:^(id resource) {
		didSucceed = true;
		STAssertEqualObjects(((StringResource *)resource).value, @"v1", nil);
	}];
	[self sleep:0.5];
	STAssertTrue(didSucceed, nil);
}

-(void) testCanForceResourceRepresentation {
	StringResource.representation = @"application/json";
	[httpEngine stubUrl:@"http://foo.com/string_resources/2" toAnswer:@"{\"value\":\"Well done\"}" ofMimeType:@"plain/text"];
	StringResource *resource = [StringResource findById:[NSNumber numberWithInt:2]];
	STAssertEqualObjects(resource.value, @"Well done", nil);
}

-(void) testCanSaveAResource {
	StringResource.representation = @"application/json";
	[httpEngine expectPostOnUrl:@"http://foo.com/string_resources" withContent:@"{\"value\":\"foo\",\"otherValue\":\"bar\"}" ofMimeType:@"application/json"];	
	StringResource.representation = @"application/json";
	StringResource *resource = [StringResource new];
	resource.value = @"foo";
	resource.otherValue = @"bar";
	[resource save];
	[httpEngine verify];
}

-(void) testCanFindResourceByDynamicsCriterias {
	StringResource.representation = @"application/json";
	[httpEngine stubUrl:@"http://foo.com/string_resources/?o1=A&o2=B" toAnswer:@"{\"value\":\"good job\"}" ofMimeType:@"application/json"];
	StringResource *resource = [StringResource findByO1AndO2:@"A", @"B", nil];
	STAssertEqualObjects(resource.value, @"good job", nil);
}

-(void) testCanFindAllResourceByDynamicsCriterias {
	StringResource.representation = @"application/json";
	[httpEngine stubUrl:@"http://foo.com/string_resources/?o1=A&o2=B" toAnswer:@"[{\"value\":\"1\"},{\"value\":\"2\"}]" ofMimeType:@"application/json"];
	NSArray *resources = [StringResource findAllByO1AndO2:@"A", @"B", nil];
	STAssertEqualObjects(((StringResource *)[resources objectAtIndex:0]).value, @"1", nil);
	STAssertEqualObjects(((StringResource *)[resources objectAtIndex:1]).value, @"2", nil);		
}

-(void)sleep:(float)seconds {
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:seconds]];	
}
@end
