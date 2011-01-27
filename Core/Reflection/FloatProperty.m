#import "FloatProperty.h"


@implementation FloatProperty

-(id)convertedValueForRawValue:(NSString *)valueToConvert {
	float newValue = [valueToConvert floatValue];
	unsigned int addr = (unsigned int)&newValue;
	return *(float**)addr;
}

@end
