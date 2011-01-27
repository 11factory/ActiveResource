#import <Foundation/Foundation.h>


@interface HttpResponse : NSObject {

}
@property(nonatomic, retain)NSString *responseContent;
@property(nonatomic, retain)NSString *mimeType;

+(id) responseWithContent:(NSString *)content ofType:(NSString *)mime;

-(id) initWithContent:(NSString *)content ofType:(NSString *)mime;
-(NSArray *) getAsArrayOfkeyValues;
-(NSDictionary *) getAsKeyValues;
@end
