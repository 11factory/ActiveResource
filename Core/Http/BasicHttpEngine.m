#import "BasicHttpEngine.h"
#import "JSONResponse.h"

NSString * const BeginNetworkActivity = @"BeginNetworkActivity";
NSString * const EndNetworkActivity = @"EndNetworkActivity";

@implementation BasicHttpEngine

+(BasicHttpEngine *)newInstance {
	return [[[BasicHttpEngine alloc] init] autorelease];
}

-(HttpResponse *) doGetFromUrl:(NSString *)url withForcedMimeType:(NSString *)mimeType {
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	NSURLResponse *urlResponse = nil;
	NSData *responseAsString = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:nil];
	NSString *content = [[[NSString alloc] initWithData:responseAsString encoding:NSUTF8StringEncoding] autorelease];	
	NSString *mimeTypeToUse = mimeType ? mimeType : [urlResponse MIMEType];
	return [HttpResponse responseWithContent:content ofType:mimeTypeToUse];
}

-(void) doPostOnUrl:(NSString *)url withContent:(NSString *)content withMimeType:(NSString *)mimeType {
	NSMutableURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	[request setHTTPMethod:@"POST"];
	NSData *bodyData = [ NSData dataWithBytes: [content UTF8String ] length: [content length ] ];
	[request setHTTPBody:bodyData];
	[request setValue:mimeType forHTTPHeaderField:@"Content-Type"];
	[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

-(HttpResponse *) responseFromUrl:(NSString *)url {
	return [self responseFromUrl:url withForcedMimeType:nil];
}

-(HttpResponse *) responseFromUrl:(NSString *)url withForcedMimeType:(NSString *)forcedMimeType {
	[[NSNotificationCenter defaultCenter] postNotificationName:BeginNetworkActivity object:self];	
	HttpResponse *response = [self doGetFromUrl:url withForcedMimeType:forcedMimeType];
	NSLog(@"BasicHttpEngine - For url : '%@'\nResponse --> %@", url, response.responseContent);
	[[NSNotificationCenter defaultCenter] postNotificationName:EndNetworkActivity object:self];	
	return response;	
}

-(void) postOnUrl:(NSString *)url withContent:(NSString *)content withMimeType:(NSString *)mimeType {
	[[NSNotificationCenter defaultCenter] postNotificationName:BeginNetworkActivity object:self];	
	[self doPostOnUrl:url withContent:content withMimeType:mimeType];
	NSLog(@"BasicHttpEngine - For url : '%@'\nPost --> %@", url, content);
	[[NSNotificationCenter defaultCenter] postNotificationName:EndNetworkActivity object:self];	
}

@end
