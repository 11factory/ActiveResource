#import <Foundation/Foundation.h>
#import "ActiveResource.h"

@interface MultipleTypeResource : ActiveResource {

}
@property(nonatomic, retain)NSNumber *intNSNumberProperty;
@property(nonatomic, retain)NSNumber *floatNSNumberProperty;
@property(nonatomic, retain)NSNumber *boolNSNumberProperty;
@property(nonatomic, retain)NSDate *dateProperty;
@property(nonatomic, assign)int intProperty;
@property(nonatomic, assign)float floatProperty;
@property(nonatomic, assign)bool boolProperty;

@end
