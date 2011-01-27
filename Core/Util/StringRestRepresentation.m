#import "StringRestRepresentation.h"


@implementation NSString (StringRestRepresentation)

- (bool) isAnUpperCaseCharacter: (unichar) character  {
  return character < 97;

}
-(id) stringInRestResourceFormat {
	NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
	for (int i = 0; i < [self length]; i++) {
		unichar currentCharacter = [self characterAtIndex:i];
		if ([self isAnUpperCaseCharacter:currentCharacter] && i > 0) {
			[result appendString:@"_"];
		}
		[result appendFormat:@"%c", currentCharacter];
	}
	return [result lowercaseString];
}

@end
