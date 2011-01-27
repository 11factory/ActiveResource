#import "BoolProperty.h"


@implementation BoolProperty

-(id)convertedValueForRawValue:(NSString *)valueToConvert {
	bool newValue = [valueToConvert boolValue];
	unsigned int addr = (unsigned int)&newValue;
	return *(bool**)addr;
}

@end
