//
//  MyAnnotation.m
//  Geography Tutor
//
//  Created by Al Pascual on 12/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize coordinate;


- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
	coordinate = newCoordinate;
}

- (void) setTitle:(NSString*)newString
{
	title = newString;
}

- (void) setTweet:(NSString*)newTweet
{
    tweet = newTweet;       
}

- (NSString *)title {
	return title;
}

- (NSString *)subtitle{
	return subtitle;
}

@end
