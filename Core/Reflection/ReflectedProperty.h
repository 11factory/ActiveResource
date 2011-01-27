#import <Foundation/Foundation.h>

@interface ReflectedProperty : NSObject {

}
- (id) initWithPropertyName:(NSString *)propertyName onInstance:(id)instance;
-(void) setValueFromString:(id)rawValue;
-(NSString *)getPropertyTypeEncodingForPropertyName:(NSString *)propertyName onInstance:(id)instance;
-(id)convertedValueForRawValue:(NSString *)valueToConvert;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) id holdingInstance;
@property(nonatomic, retain) ReflectedProperty *targetProperty;
@property(nonatomic, retain)NSDictionary *propertyMapping;
@end
