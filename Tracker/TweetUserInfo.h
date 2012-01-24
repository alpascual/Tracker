//
//  TweetUserInfo.h
//  Tracker
//
//  Created by Albert Pascual on 1/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetUserInfo : NSObject

@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *lastTweet;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic) BOOL bInAppUser;
@property (nonatomic) double X;
@property (nonatomic) double Y;

@end
