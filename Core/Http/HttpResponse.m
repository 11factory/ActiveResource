#import "HttpResponse.h"
#import "JSONResponse.h"

@implementation HttpResponse
@synthesize responseContent, mimeType;

+(id) responseWithContent:(NSString *)content ofType:(NSString *)mime {
	if ([mime isEqualToString:@"application/json"]) {
		JSONResponse *jsonResponse = [[[JSONResponse alloc]init] autorelease];
		jsonResponse.responseContent = content;
		jsonResponse.mimeType = mime;
		return jsonResponse;
	} else {
		@throw [[[NSException alloc] initWithName:@"Not implemented" reason:[NSString stringWithFormat:@"Mime type '%@' is not supported", mime] userInfo:nil] autorelease];
	}

	return [[[self alloc] initWithContent:content ofType:mime] autorelease];
}

-(id) initWithContent:(NSString *)content ofType:(NSString *)mime {
	self.responseContent = content;
	self.mimeType = mime;
	return self;
}

-(NSArray *) getAsArrayOfkeyValues {
	return nil;
}

-(NSDictionary *) getAsKeyValues {
	return nil;
}
@end
