#import <Foundation/Foundation.h>


@interface ReflectedInstance : NSObject {

}
+(ReflectedInstance *) forClass:(Class) targetClass;
+(ReflectedInstance *) withInstance:(id) instance;
-(ReflectedInstance *) initWithTargetClass:(Class) targetClass;
-(ReflectedInstance *) initWithInstance:(id) instance;
-(void) injectValue:(NSString *)rawValue intoPropertyNamed:(NSString *)propertyName;
-(NSDictionary *) asDictionary;
@property(nonatomic, retain)id targetInstance;
@end
