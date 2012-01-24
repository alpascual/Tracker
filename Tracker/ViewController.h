//
//  ViewController.h
//  Tracker
//
//  Created by Albert Pascual on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventViewController.h"
#import "TrackingManager.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *twitterUser;
@property (nonatomic, strong) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) TrackingManager *trackingManager; 

@end
