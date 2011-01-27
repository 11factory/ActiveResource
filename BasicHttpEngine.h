#import <Foundation/Foundation.h>
#import "HttpResponse.h"
#import "HttpEngine.h"

extern NSString * const BeginNetworkActivity;
extern NSString * const EndNetworkActivity;

@interface BasicHttpEngine : NSObject<HttpEngine> {

}
+(BasicHttpEngine *)newInstance;
-(HttpResponse *) responseFromUrl:(NSString *)url;
@end
