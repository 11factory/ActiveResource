//
//  RootViewController.h
//  iContinue
//
//  Created by Laurent Cobos on 08/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
}
-(IBAction)refresh:(id)sender;
@property(nonatomic, retain)NSArray *builds;
@property(nonatomic, retain)IBOutlet UIBarButtonItem *refreshButton;
@end
