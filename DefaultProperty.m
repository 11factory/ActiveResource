#import "DefaultProperty.h"


@implementation DefaultProperty

-(id)convertedValueForRawValue:(NSString *)valueToConvert {
	return [valueToConvert retain];
}
@end
