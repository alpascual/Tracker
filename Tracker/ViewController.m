//
//  ViewController.m
//  Tracker
//
//  Created by Albert Pascual on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize nextButton = _nextButton;
@synthesize twitterUser = _twitterUser;
@synthesize trackingManager = _trackingManager;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Load the name if exist
    NSUserDefaults *myPrefs = [NSUserDefaults standardUserDefaults]; 
    if ( [myPrefs objectForKey:@"twitteruser"] != nil)
    {
        self.twitterUser.text = [myPrefs objectForKey:@"twitteruser"];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)pressedNext:(id)sender {
    
    if ( self.twitterUser.text.length > 0 ) {
        NSUserDefaults *myPrefs = [NSUserDefaults standardUserDefaults]; 
        [myPrefs setObject:self.twitterUser.text forKey:@"twitteruser"];
        [myPrefs synchronize];
        
//        EventViewController *event = [[EventViewController alloc] initWithNibName:@"EventViewController" bundle:nil];
//        event.trackingManager = self.trackingManager;
//        [self presentModalViewController:event animated:YES];
        
        HitchhikerViewController *hitch = [[HitchhikerViewController alloc] initWithNibName:@"HitchhikerViewController" bundle:nil];
        hitch.trackingManager = self.trackingManager;
        [self presentModalViewController:hitch animated:YES];
        
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Twitter Name"
                                                        message:@"Please enter the twitter name and click next"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}

@end
