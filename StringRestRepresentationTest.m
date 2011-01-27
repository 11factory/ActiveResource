#import "StringRestRepresentationTest.h"
#import "StringRestRepresentation.h"

@implementation StringRestRepresentationTest

-(void) testCanConvertStringToRestRepresentation {
	STAssertEqualObjects([@"FooBar" stringInRestResourceFormat], @"foo_bar", nil);
}

@end
