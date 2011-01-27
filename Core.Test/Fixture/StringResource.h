#import <Foundation/Foundation.h>
#import "ActiveResource.h"

@interface StringResource : ActiveResource {

}
@property(nonatomic, retain)NSString *value;
@property(nonatomic, retain)NSString *otherValue;
@end
