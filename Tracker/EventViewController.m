//
//  EventViewController.m
//  Tracker
//
//  Created by Albert Pascual on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventViewController.h"

@implementation EventViewController

@synthesize hashtag = _hashtag;
@synthesize trackingManager = _trackingManager;

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
    
    NSUserDefaults *myPrefs = [NSUserDefaults standardUserDefaults]; 
    if ( [myPrefs objectForKey:@"hashtag"] != nil)
    {
        self.hashtag.text = [myPrefs objectForKey:@"hashtag"];
    }

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

- (IBAction)pressedNext:(id)sender {
    
    if ( self.hashtag.text.length > 0 ) {
        NSUserDefaults *myPrefs = [NSUserDefaults standardUserDefaults]; 
        [myPrefs setObject:self.hashtag.text forKey:@"hashtag"];
        [myPrefs synchronize];
        
        MapViewController *map = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
        map.trackingManager = self.trackingManager;
        [self presentModalViewController:map animated:YES];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Hashtag"
                                                        message:@"Please enter the twitter hashtag and click next"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

@end
