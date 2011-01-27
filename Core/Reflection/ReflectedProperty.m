#import "ReflectedProperty.h"
#import <objc/runtime.h> 
#import <objc/message.h>
#import "NSDateProperty.h"
#import "IntProperty.h"
#import "FloatProperty.h"
#import "BoolProperty.h"
#import "DefaultProperty.h"

@implementation ReflectedProperty
@synthesize name, holdingInstance;
@synthesize targetProperty, propertyMapping;

- (id) initWithPropertyName:(NSString *)propertyName onInstance:(id)instance {
	self.name = propertyName;
	self.holdingInstance = instance;
	propertyMapping = [NSDictionary dictionaryWithObjectsAndKeys:
					   [NSDateProperty class], @"@\"NSDate\"",
					   [IntProperty class], @"i",
					   [FloatProperty class], @"f",
					   [BoolProperty class], @"B",nil];
	NSString *propertyTypeEncoding = [self getPropertyTypeEncodingForPropertyName:propertyName onInstance:instance];
	self.targetProperty = [[[[propertyMapping objectForKey:propertyTypeEncoding] alloc] init] autorelease];
	if (self.targetProperty == nil)
		self.targetProperty = [[[DefaultProperty alloc] init] autorelease];
	return self;
}

-(NSString *)getPropertyTypeEncodingForPropertyName:(NSString *)propertyName onInstance:(id)instance {
	Ivar targetPropertyType = object_getInstanceVariable(instance, [propertyName UTF8String], NULL);
	const char *propertyTypeEncoding = ivar_getTypeEncoding(targetPropertyType);
	return propertyTypeEncoding ? [NSString stringWithCString:propertyTypeEncoding encoding:NSUTF8StringEncoding] : @"";
}

-(void) setValueFromString:(id)rawValue {
	id convertedValue = [self.targetProperty convertedValueForRawValue:rawValue];
	object_setInstanceVariable(self.holdingInstance, [self.name UTF8String], convertedValue);
}

-(id)convertedValueForRawValue:(NSString *)valueToConvert {
	@throw [[NSException alloc] initWithName:@"Not implemented" reason:@"This is an abstract method" userInfo:nil];
}
@end
