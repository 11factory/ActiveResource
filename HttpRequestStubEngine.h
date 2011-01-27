#import <Foundation/Foundation.h>
#import "BasicHttpEngine.h"

@interface HttpRequestStubEngine : BasicHttpEngine {

}
@property(nonatomic, retain)NSMutableDictionary *urlResponseMapping;
@property(nonatomic, retain)NSMutableArray *requestExpectations;
@property(nonatomic, assign)bool expectationsMeets;
@property(nonatomic, retain)NSDictionary *lastFailedExpectation;
@property(nonatomic, retain)NSDictionary *lastReceivedRequest;
-(void) stubUrl:(NSString *)url toAnswer:(NSString *)response;
-(void) stubUrl:(NSString *)url toAnswer:(NSString *)response ofMimeType:(NSString *)mime;
-(void) expectPostOnUrl:(NSString *)url withContent:(NSString *)content ofMimeType:(NSString *)mime;	
-(void) verify;
@end
