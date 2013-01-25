//
//  EMAppDelegate.m
//  DownloadedImageExample
//
//  Created by James Eberhardt on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMAppDelegate.h"
#import "RootViewController.h"

@implementation EMAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Remember, the window in the appDelegate needs one, and only one rootViewController
    self.window.rootViewController = [[RootViewController alloc] init];
    
    return YES;
}

@end
