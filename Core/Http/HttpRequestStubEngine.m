#import "HttpRequestStubEngine.h"

@implementation HttpRequestStubEngine
@synthesize urlResponseMapping, requestExpectations, expectationsMeets, lastFailedExpectation, lastReceivedRequest;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.urlResponseMapping = [NSMutableDictionary dictionary];
		self.requestExpectations = [NSMutableArray array]; 
	}
	return self;
}

-(HttpResponse *) doGetFromUrl:(NSString *)url withForcedMimeType:(NSString *)forcedMimeType {
	NSString *mimeTypeToUse = nil;
	NSString *response = nil;
	NSDictionary *responseData = [self.urlResponseMapping objectForKey:url];
	if (responseData) {
		mimeTypeToUse = [responseData objectForKey:@"mime"];
		response = [responseData objectForKey:@"response"];
	}
	if (forcedMimeType)
		mimeTypeToUse = forcedMimeType;
	return [HttpResponse responseWithContent:response ofType:mimeTypeToUse];
}

-(void) doPostOnUrl:(NSString *)url withContent:(NSString *)content withMimeType:(NSString *)mimeType {
	self.lastReceivedRequest = [NSDictionary dictionaryWithObjectsAndKeys:url, @"url", content, @"content", mimeType, @"mime", nil]; 
	if ([self.requestExpectations count] == 0) {
		@throw [[NSException alloc] initWithName:@"Unexpected call" reason:[NSString stringWithFormat:@"Call on url '%@' was not expected", url] userInfo:nil];
	}
	NSDictionary *expectedRequest = [self.requestExpectations objectAtIndex:0];
	[self.requestExpectations removeObjectAtIndex:0];	
	self.expectationsMeets = [[expectedRequest objectForKey:@"url"] isEqualToString:url];
	self.expectationsMeets = self.expectationsMeets && [[expectedRequest objectForKey:@"content"] isEqualToString:content];
	self.expectationsMeets = self.expectationsMeets && [[expectedRequest objectForKey:@"mime"] isEqualToString:mimeType];
	self.lastFailedExpectation = self.expectationsMeets ? nil : expectedRequest;
}

-(void) stubUrl:(NSString *)url toAnswer:(NSString *)response {
	[self stubUrl:url toAnswer:response ofMimeType:@"application/json"];
}

-(void) stubUrl:(NSString *)url toAnswer:(NSString *)response ofMimeType:(NSString *)mime {
	NSDictionary *responseData = [NSDictionary dictionaryWithObjectsAndKeys:response, @"response", mime, @"mime", nil]; 
	[self.urlResponseMapping setObject:responseData forKey:url];
}

-(void) expectPostOnUrl:(NSString *)url withContent:(NSString *)content ofMimeType:(NSString *)mime {
	NSDictionary *expectedRequest = [NSDictionary dictionaryWithObjectsAndKeys:url, @"url", content, @"content", mime, @"mime", nil]; 
	self.lastFailedExpectation = expectedRequest;
	[self.requestExpectations addObject:expectedRequest];
}

-(void) verify {
	if (self.expectationsMeets == NO) {
		NSString *message = [NSString stringWithFormat:@"Call on url '%@' was expected", [self.lastFailedExpectation objectForKey:@"url"]];
		if (self.lastReceivedRequest) {
			message = [message stringByAppendingFormat:@"\nbut received url :'%@'\ncontent :'%@'\nmimeType:'%@", [self.lastReceivedRequest objectForKey:@"url"], [self.lastReceivedRequest objectForKey:@"content"], [self.lastReceivedRequest objectForKey:@"mime"]];	
		}
		@throw [[NSException alloc] initWithName:@"Unsatisfied expecations" reason:message userInfo:nil];
	}
}

@end
