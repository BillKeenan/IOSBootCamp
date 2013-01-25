//
//  EMAppDelegate.m
//  UIAppearanceExample
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
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:255./255. green:145./255. blue:135./255. alpha:1.0]];
    
    [[UISlider appearanceWhenContainedIn:[UINavigationController class], nil] setMinimumTrackTintColor:[UIColor blueColor]];
    [[UISlider appearanceWhenContainedIn:[MainViewController class], nil] setMinimumTrackTintColor:[UIColor yellowColor]];
    
    [[UIButton appearance] setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [[UIButton appearance] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    
    self.window.rootViewController = [[UINavigationController alloc] init];
    [(UINavigationController*)self.window.rootViewController pushViewController:[[MainViewController alloc] init] animated:FALSE];
    
    //self.window.rootViewController = [[MainViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
