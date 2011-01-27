#import <Foundation/Foundation.h>
#import "HttpEngine.h"
#import "JSONResponse.h"
#import "ResourceConfiguration.h"

typedef void (^ArrayCallback)(NSArray *results);
typedef void (^SingleCallback)(id result);

@interface ActiveResource : NSObject {

}
+(void) setHttpEngine:(id<HttpEngine>)httpEngine;
+(id<HttpEngine>) httpEngine;
+(void) setSite:(NSString *)site;
+(void) setRepresentation:(NSString *)representation;
+(NSString *) getRepresentation;
+(void) setElementName:(NSString *)elementName;
+(ResourceConfiguration *)getConfiguration;
+(JSONResponse *) JSON;
+(id) findById:(id)identifier;
+(NSArray *) findAll;
+(void) findAllAndCallback:(ArrayCallback)callback;
+(void) findById:(id)identifier andCallback:(SingleCallback)callback;
-(void)save;
@end
