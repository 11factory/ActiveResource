#import "NSDateProperty.h"


@implementation NSDateProperty

-(id)convertedValueForRawValue:(NSString *)valueToConvert {
	id convertedValue = valueToConvert;
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	convertedValue = [dateFormatter dateFromString:valueToConvert];	
	return [convertedValue retain];
}
@end
