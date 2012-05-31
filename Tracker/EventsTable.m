//
//  EventsTable.m
//  Tracker
//
//  Created by Albert Pascual on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventsTable.h"

@implementation EventsTable

@synthesize eventArray = _eventArray;
@synthesize delegate = _delegate;
@synthesize tableView = _tableView;

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
    
    // TODO get events here
    //http://tracker.alsandbox.us/api/EventList
    
    NSString *myRequestString = @"http://tracker.alsandbox.us/api/EventList";
    NSLog(@"Request string %@", myRequestString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:myRequestString]];    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *JsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"My Json %@", JsonString);
    
    NSError *error = nil;
    NSArray *theArray = [NSDictionary dictionaryWithJSONString:JsonString error:&error];
    if ( theArray == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Inernet"
                                                        message:@"No internet detected to download other users positions."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    self.eventArray = [[NSMutableArray alloc] initWithCapacity:theArray.count];
    
    for(int i=0; i < theArray.count; i++)
    {     
        NSString *tempEvent = [theArray objectAtIndex:i];
        NSLog(@"Event: %@", tempEvent);
        [self.eventArray addObject:tempEvent];
    }
    
    [self.tableView reloadData];
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

- (IBAction)changeTable:(id)sender {
    [self.delegate wantToDismissTable];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ( self.eventArray != nil )
        return self.eventArray.count;
    
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    NSUInteger row = [indexPath row]; 
    
    cell.textLabel.text = [self.eventArray objectAtIndex:row];
    cell.backgroundColor = [UIColor blueColor];
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://twomindsinteractive.com/wp-content/uploads/2011/11/twitter-logo.jpg"]]];
    
    /*TweetUserInfo *anObject = [self.peopleArray objectAtIndex:row];
    
    cell.textLabel.text = anObject.userName;
    
    cell.detailTextLabel.numberOfLines = 4;
    
    cell.detailTextLabel.text = anObject.lastTweet;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    cell.backgroundColor = [UIColor blueColor];
    
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:anObject.imageUrl]]];*/
    
    /*UIImage *backImage = [UIImage imageNamed:@"UITableSelection.png"];
     UIImageView *imageView = [[UIImageView alloc] initWithImage:backImage];    
     cell.backgroundView = imageView;*/
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{   
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row]; 
    NSString *eventSelected = [self.eventArray objectAtIndex:row];
    NSUserDefaults *myPrefs = [NSUserDefaults standardUserDefaults]; 
    [myPrefs setObject:eventSelected forKey:@"hashtag"];
    [myPrefs synchronize];
    
    [self.delegate eventSelected];
   
}

@end
