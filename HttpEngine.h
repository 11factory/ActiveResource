@class HttpResponse;

@protocol HttpEngine
-(HttpResponse *) responseFromUrl:(NSString *)url;
-(HttpResponse *) responseFromUrl:(NSString *)url withForcedMimeType:(NSString *)mimeType;
-(void) postOnUrl:(NSString *)url withContent:(NSString *)content withMimeType:(NSString *)mimeType;
@end
