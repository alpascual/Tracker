//
//  EventViewController.h
//  Tracker
//
//  Created by Albert Pascual on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MapViewController.h"
#import "TrackingManager.h"

@interface EventViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *hashtag;
@property (nonatomic, strong) TrackingManager *trackingManager; 
@property (nonatomic, strong) NSTimer *startTimer;

@end
