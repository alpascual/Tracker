//
//  TweetsTablesView.h
//  Tracker
//
//  Created by Albert Pascual on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetUserInfo.h"

@protocol TweetEvents <NSObject>

-(void) wantToDismiss;

@end

@interface TweetsTablesView : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) id <TweetEvents> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *peopleArray;

@end

