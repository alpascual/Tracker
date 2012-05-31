//
//  TweetsTablesView.m
//  Tracker
//
//  Created by Albert Pascual on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweetsTablesView.h"

@implementation TweetsTablesView

@synthesize delegate = _delegate;
@synthesize tableView = _tableView;
@synthesize peopleArray = _peopleArray;
@synthesize segmentChange = _segmentChange;
@synthesize utilTimer = _utilTimer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView reloadData];
    
    UISwipeGestureRecognizer *sw = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFromD:)];
    [self.view addGestureRecognizer:sw];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)changePage:(id)sender {
    // Send event
   
    [self.delegate wantToDismiss];
    
}

-(void) wantToDismissTable {
    [self dismissModalViewControllerAnimated:YES];
    
    self.segmentChange.selectedSegmentIndex = 0;
}

- (IBAction)showTable:(id)sender {
    
    EventsTable *event = [[EventsTable alloc] initWithNibName:@"EventsTable" bundle:nil]; 
    event.delegate = self;
    [self presentModalViewController:event animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ( self.peopleArray != nil )
        return self.peopleArray.count;
    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    NSUInteger row = [indexPath row]; 
    
    TweetUserInfo *anObject = [self.peopleArray objectAtIndex:row];
    
    cell.textLabel.text = anObject.userName;
    
    cell.detailTextLabel.numberOfLines = 4;
    
    cell.detailTextLabel.text = anObject.lastTweet;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    //cell.backgroundColor = [UIColor blueColor];
    
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:anObject.imageUrl]]];
    
    /*UIImage *backImage = [UIImage imageNamed:@"UITableSelection.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backImage];    
    cell.backgroundView = imageView;*/
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{   
    return 90;
}

-(void) eventSelected
{
    [self dismissModalViewControllerAnimated:YES];
    
    self.utilTimer = [NSTimer scheduledTimerWithTimeInterval:(0.3) target:self selector:@selector(timerToRefreshFunc:) userInfo:nil repeats:NO];
}

- (void)timerToRefreshFunc:(NSTimer *)timer {
    [self.delegate eventChanged];
    self.utilTimer = nil;
}



@end
