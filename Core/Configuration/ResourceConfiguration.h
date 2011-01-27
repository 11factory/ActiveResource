#import <Foundation/Foundation.h>

@interface ResourceConfiguration : NSObject {
	NSString *currentElementName;
	NSString *site;
}
@property(nonatomic, retain)Class resourceClass;

-(void)setSite:(NSString *)resourceSite;
-(void)setElementName:(NSString *)resourceElementName;
-(NSString *)site;
-(NSString *)elementName;
+(id)newInstanceForClass:(Class) configuratedClass;
-(NSString *)resourceBaseUrl;
@property(nonatomic, retain)NSString *representation;
@end
