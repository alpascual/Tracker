//
//  MapViewController.m
//  Tracker
//
//  Created by Albert Pascual on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

@synthesize trackingManager = _trackingManager;
@synthesize mapView = _mapView;
@synthesize timerToRefresh = _timerToRefresh;
@synthesize activity = _activity;
@synthesize pages = _pages;
@synthesize tweetView = _tweetView;
@synthesize pointsToDisplay = _pointsToDisplay;

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
    
    self.mapView.mapType = MKMapTypeStandard;
		
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
	
	region.center.latitude = 40.105085;
	region.center.longitude = -99.005237;
	region.span.latitudeDelta = 36;
	region.span.longitudeDelta = 36;	
	
	[self.mapView setRegion:region];
    self.mapView.showsUserLocation = YES;
    
    self.pointsToDisplay = [[NSMutableArray alloc] init];
    
    
    // Start the timer fast to download and display
    self.timerToRefresh = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(timerToRefreshFunc:) userInfo:nil repeats:NO];
}

- (void)timerToRefreshFunc:(NSTimer *)timer 
{
    [self.timerToRefresh invalidate];
    self.timerToRefresh = nil;
    
    if ( self.activity.isAnimating == NO )
        [self.activity startAnimating];
 
    NSUserDefaults *myPrefs = [NSUserDefaults standardUserDefaults];     
    NSString *hashtag = [myPrefs objectForKey:@"hashtag"];
    

    // TOOD Make a request to the Json part
    NSString *myRequestString = [[NSString alloc] initWithFormat:@"http://tracker.alsandbox.us/api/Json?sHashTag=%@", hashtag];
    NSLog(@"Request string %@", myRequestString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:myRequestString]];    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *JsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"My Json %@", JsonString);
    
    // TODO Parse Json and put it in the map
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
    
    [self.pointsToDisplay removeAllObjects];
    
    for(int i=0; i < theArray.count; i++)
    {
        TweetUserInfo *user = [[TweetUserInfo alloc] init];
        NSDictionary *oneObject = [theArray objectAtIndex:i];
        user.userName = [oneObject objectForKey:@"TwitterName"];
        user.X = [[oneObject objectForKey:@"X"] doubleValue];
        user.Y = [[oneObject objectForKey:@"Y"] doubleValue];
        user.bInAppUser = YES;
        [self getLastTweet:user.userName:user];
        
        NSLog(@"Last Tweet %@ and Image %@", user.lastTweet, user.imageUrl);
        
        [self.pointsToDisplay addObject:user];
    }
           
    
    //Request a search in Twitter with GeoLocation and put it in the map
    //http://search.twitter.com/search.json?q=mavp12&geocode=Lat,Long,15mi
    NSArray *twitterKeys = [self twitterRequest:hashtag];
    NSLog(@"Twitter %@", twitterKeys);
    for (int u=0; u < twitterKeys.count; u++) {
        NSDictionary *allItems = [twitterKeys objectAtIndex:u];
        NSLog(@"all Items %@", allItems);
        
        TweetUserInfo *tUser = [[TweetUserInfo alloc] init];
        tUser.userName = [allItems objectForKey:@"from_user"];
        tUser.imageUrl = [allItems objectForKey:@"profile_image_url"];
        tUser.lastTweet = [allItems objectForKey:@"text"];
        tUser.X = self.trackingManager.lastLocation.coordinate.latitude;
        tUser.Y = self.trackingManager.lastLocation.coordinate.longitude;
        tUser.bInAppUser = NO;
        
        [self.pointsToDisplay addObject:tUser];
    }
    
    [self addArrayToMap:self.pointsToDisplay];
    
    [self.activity stopAnimating];
    // Reschedule
    self.timerToRefresh = [NSTimer scheduledTimerWithTimeInterval:(120.0) target:self selector:@selector(timerToRefreshFunc:) userInfo:nil repeats:NO];
}
         
- (void)getLastTweet:(NSString *)username:(TweetUserInfo *) userTweet {
    
    //https://api.twitter.com/1/statuses/user_timeline.json?screen_name=alpascual&count=1
      
    NSString *myStringRequest = [[NSString alloc] initWithFormat:@"https://api.twitter.com/1/statuses/user_timeline.json?screen_name=%@&count=1", username];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:myStringRequest]]; 
    NSLog(@"Last Tweet Request %@", myStringRequest);
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *JsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    // TODO Parse Json and put it in the map
    NSError *error = nil;
    NSArray *theArray = [NSDictionary dictionaryWithJSONString:JsonString error:&error];
    NSLog(@"response Dictionary %@", theArray);
    
    NSDictionary *theDictionary = [theArray objectAtIndex:0];
    userTweet.lastTweet = [theDictionary objectForKey:@"text"];
    userTweet.imageUrl = [[theDictionary objectForKey:@"user"] objectForKey:@"profile_image_url"];
    
    //user ->
    //profile_image_url

}


- (NSArray *) twitterRequest:(NSString *)hashTag {
    if ( self.trackingManager.lastLocation != nil) {
        
        // TOOD Make a request to the Json part
        NSString *myRequestString = [[NSString alloc] initWithFormat:@"http://search.twitter.com/search.json?q=%@&geocode=%f,%f,25mi", hashTag, self.trackingManager.lastLocation.coordinate.latitude, self.trackingManager.lastLocation.coordinate.longitude];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:myRequestString]]; 
        NSLog(@"My Twitter Request %@", myRequestString);
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSString *JsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        
        // TODO Parse Json and put it in the map
        NSError *error = nil;
        NSDictionary *theDictionary = [NSDictionary dictionaryWithJSONString:JsonString error:&error];
        NSLog(@"Twitter Response %@", theDictionary);
        
        NSArray *aResults = [theDictionary objectForKey:@"results"];
        
        return aResults;
    }
    return nil;
}

- (void) addArrayToMap:(NSArray *)allPeople
{
    for(int i=0; i < allPeople.count; i++)
    {
        TweetUserInfo *user = [allPeople objectAtIndex:i];
        CLLocationCoordinate2D loc;
        loc.longitude = user.X;
        loc.latitude = user.Y;
        
        [self addStateToMap:loc:user.userName];
    }
}

- (void) addStateToMap:(CLLocationCoordinate2D)location : (NSString*)twitterName
{	
	MyAnnotation *addAnnotation = [[MyAnnotation alloc] init];
	
	[addAnnotation setCoordinate:location];
	[addAnnotation setTitle:twitterName];
    
	
	[self.mapView addAnnotation:addAnnotation];
	
}

- (void) hidePrevious
{    
	//NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:[self.mapView.annotations count]+1];
    
	for (id annotation in self.mapView.annotations)
	{
		[[self.mapView viewForAnnotation:annotation] setHidden:YES];        
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

- (IBAction)changePage:(id)sender {
 
    self.tweetView = [[TweetsTablesView alloc] initWithNibName:@"TweetsTablesView" bundle:nil];
    self.tweetView.delegate = self;
    self.tweetView.peopleArray = self.pointsToDisplay;
    self.tweetView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentModalViewController:self.tweetView animated:YES];
}

-(void) wantToDismiss
{
    [self dismissModalViewControllerAnimated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[MyAnnotation class]])   // for City of San Francisco
    {
        static NSString* SFAnnotationIdentifier = @"MyAnnotation";
        MKPinAnnotationView* pinView =
        (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
        if (!pinView)
        {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:SFAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            
            UIImage *flagImage = [UIImage imageNamed:@"flag.png"];
            
            CGRect resizeRect;
            
            resizeRect.size = flagImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [flagImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image = resizedImage;
            annotationView.opaque = NO;
            
            //MyAnnotation *customAnnot = annotation;
            
            /*UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:customAnnot.imageUrl]]];*/
            
           // UIImageView *imageView = [[UIImageView alloc] initWithImage:image];    
            
            //annotationView.leftCalloutAccessoryView = imageView;
                        
            return annotationView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

@end
