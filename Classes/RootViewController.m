//
//  RootViewController.m
//  iContinue
//
//  Created by Laurent Cobos on 08/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "Build.h"

@implementation RootViewController
@synthesize builds, refreshButton;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"iContinue";
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBeginNetworkActivityEvent) name:@"BeginNetworkActivity" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEndNetworkActivityEvent) name:@"EndNetworkActivity" object:nil];	
	self.refreshButton.target = self;
	self.refreshButton.action = @selector(refresh:);	
	[self refresh:self];
}

-(void) enableRefreshButton {
	self.refreshButton.enabled = TRUE;	
}

-(void) disableRefreshButton {
	self.refreshButton.enabled = FALSE;	
}

-(void) onBeginNetworkActivityEvent {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
	[self performSelectorOnMainThread:@selector(disableRefreshButton) withObject:nil waitUntilDone:false];
}

-(void) onEndNetworkActivityEvent {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
	[self performSelectorOnMainThread:@selector(enableRefreshButton) withObject:nil waitUntilDone:false];
}

-(void)reloadTableView {
	[self.tableView reloadData];
}

-(IBAction)refresh:(id)sender {
	Build.site = @"http://continuousbuildwrapper.appspot.com/resources/";
	[Build findAllAndCallback:[[^(NSArray *buildsFound) {
		self.builds = buildsFound;
		[self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:false];
	} copy] autorelease]];
}
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.builds.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	Build *build = [self.builds objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@ is %@", build.name, build.didSucceed ? @"OK" : @"KO"];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

