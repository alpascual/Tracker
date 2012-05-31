//
//  EventsTable.h
//  Tracker
//
//  Created by Albert Pascual on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CJSONDeserializer.h"
#import "NSDictionary_JSONExtensions.h"
//#import "MapViewController.h"

@protocol TweetTable <NSObject>

-(void) wantToDismissTable;
-(void) eventSelected;

@end

@interface EventsTable : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *eventArray;
@property (strong, nonatomic) id <TweetTable> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
