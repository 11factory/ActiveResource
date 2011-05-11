#import "JSONResponse.h"


@implementation JSONResponse

- (NSArray *) matchForPattern:(NSString *)pattern onString:(NSString *)stringToInspect  {
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
																		   options:NSRegularExpressionCaseInsensitive
																			 error:nil];
	return [regex matchesInString:stringToInspect
									  options:0
										range:NSMakeRange(0, [stringToInspect length])];
}

-(NSDictionary *) keyValuesForString:(NSString *)string {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	for (NSTextCheckingResult *match in [self matchForPattern:@"\"@?(.+?)\"\\s?:\\s?\"(.+?)\"" onString:string]) {
		NSString *key = [string substringWithRange:[match rangeAtIndex:1]];
		NSString *value = [string substringWithRange:[match rangeAtIndex:2]];
		[dictionary setObject:value forKey:key];
	}
	return dictionary;
}

-(NSDictionary *) getAsKeyValues {
	return [self keyValuesForString:self.responseContent];
}

-(NSArray *) getAsArrayOfkeyValues {
	NSMutableArray *itemsFound = [NSMutableArray array];
	if ([self.responseContent length] > 1) {
		NSString *stringToInspect = [self.responseContent substringFromIndex:1];
		for (NSTextCheckingResult *match in [self matchForPattern:@"\\{(.+?)\\}" onString:stringToInspect]) {
			NSString *elementAsString = [stringToInspect substringWithRange:[match rangeAtIndex:1]];
			[itemsFound addObject:[self keyValuesForString:elementAsString]];
		}
	}
	return itemsFound;
}

@end
