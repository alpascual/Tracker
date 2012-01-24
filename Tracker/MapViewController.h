//
//  MapViewController.h
//  Tracker
//
//  Created by Albert Pascual on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "TrackingManager.h"
#import "MyAnnotation.h"
#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"
#import "TweetsTablesView.h"
#import "TweetUserInfo.h"

@interface MapViewController : UIViewController <TweetEvents, MKMapViewDelegate>

@property (nonatomic, strong) TrackingManager *trackingManager; 
@property (nonatomic, strong) IBOutlet MKMapView* mapView;
@property (nonatomic, strong) NSTimer *timerToRefresh;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, strong) IBOutlet UIPageControl *pages;
@property (nonatomic, strong) TweetsTablesView *tweetView;
@property (nonatomic, strong) NSMutableArray *pointsToDisplay;

- (NSArray *) twitterRequest:(NSString *)hashTag;
- (void)getLastTweet:(NSString *)username:(TweetUserInfo *) userTweet;
- (void) addArrayToMap:(NSArray *)allPeople;
- (void) addStateToMap:(CLLocationCoordinate2D)location : (NSString*)twitterName;
+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;


@end
