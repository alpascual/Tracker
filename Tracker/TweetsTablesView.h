//
//  TweetsTablesView.h
//  Tracker
//
//  Created by Albert Pascual on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetUserInfo.h"
#import "EventsTable.h"

@protocol TweetEvents <NSObject>

-(void) wantToDismiss;
-(void) eventChanged;

@end

@interface TweetsTablesView : UIViewController <UITableViewDataSource, UITableViewDelegate, TweetTable>

@property (strong, nonatomic) id <TweetEvents> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *peopleArray;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentChange;
@property (strong, nonatomic) NSTimer *utilTimer;

@end

