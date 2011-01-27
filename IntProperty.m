#import "IntProperty.h"


@implementation IntProperty

-(id)convertedValueForRawValue:(NSString *)valueToConvert {
	return [valueToConvert intValue];
}

@end
