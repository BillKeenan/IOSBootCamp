//
//  EMAppDelegate.m
//  SettingsPanelExample
//
//  Created by James Eberhardt on 11-10-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EMAppDelegate.h"
#import "MainViewController.h"

@implementation EMAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Set the application defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary 
                                 dictionaryWithObjects: [NSArray arrayWithObjects:@"YES", @"YES", @"james", nil]
                                 forKeys: [NSArray arrayWithObjects:@"setting1", @"setting2", @"login", nil]];
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[MainViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    return YES
}

@end
