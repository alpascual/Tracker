//
//  AppDelegate.m
//  Tracker
//
//  Created by Albert Pascual on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize trackingManager = _trackingManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.trackingManager = [[TrackingManager alloc] init];
    [self.trackingManager startUpTracking];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.viewController.trackingManager = self.trackingManager;
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

//http://stackoverflow.com/questions/4656214/iphone-backgrounding-to-poll-for-events
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    UIApplication*    app = [UIApplication sharedApplication];
    NSLog(@"\n\nBackground called!\n\n");
    
    if ( self.trackingManager == nil )
    {
        self.trackingManager = [[TrackingManager alloc] init];
        [self.trackingManager startUpTracking];
    }
    
    // it's better to move "dispatch_block_t expirationHandler"
    // into your headerfile and initialize the code somewhere else
    // i.e. 
    // - (void)applicationDidFinishLaunching:(UIApplication *)application {
    //
    // expirationHandler = ^{ ... } }
    // because your app may crash if you initialize expirationHandler twice.
    __block UIBackgroundTaskIdentifier bgTask; //Create a task object
    dispatch_block_t expirationHandler;
    expirationHandler = ^{
        
        [app endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
        
        
        bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];
    };
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:expirationHandler];
    
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // inform others to stop tasks, if you like
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyApplicationEntersBackground" object:self];
        
        // write the code here
        while ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground)
        {
            //NSLog(@"backgroundTimeRemaining: %f", [[UIApplication sharedApplication] backgroundTimeRemaining]);
            
            
            //[UIApplication sharedApplication].applicationIconBadgeNumber = self.trackingManager.offlineFeatureLayer.addedFeaturesArray.count;
            
            //NSLog(@"Feature collected: %d", self.trackingManager.offlineFeatureLayer.addedFeaturesArray.count);
            
            
            [NSThread sleepForTimeInterval:10.0];                            
        }   
        
        NSLog(@"\n\n endBackgroundTask going to be calledback \n\n");
    }); 
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}



- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
