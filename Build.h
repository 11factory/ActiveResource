//
//  Build.h
//  iContinue
//
//  Created by Laurent Cobos on 08/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveResource.h"

@interface Build : ActiveResource {

}
@property(nonatomic, retain)NSString *name;
@property(nonatomic, retain)NSNumber *didSucceed;
@end
