//
//  HitchhikerViewController.h
//  TrackerHitchhiker
//
//  Created by Albert Pascual on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"

@interface HitchhikerViewController : UIViewController

@property (nonatomic, strong) TrackingManager *trackingManager;

- (void) sendToMap:(NSString*)hashTag;

@end
