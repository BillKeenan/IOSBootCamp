//
//  AppDelegate.m
//  DetectingEnvironments
//
//  Created by James Eberhardt on 2012-11-09.
//  Copyright (c) 2012 Echo Mobile. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // NOTE: Be sure you are targetting the correct device in the SCHEME, otherwise this app will always try and run in the iPad simulator instead of allowing you to choose the iPhone simulator from the iOS Simulator Device Settings.
    
    // Detect if iPad or iPhone
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        NSLog(@"User Interface Type = iPad");
    } else {
        NSLog(@"User Interface Type = iPhone or iPod");
    }
    
    NSLog(@"The current model is: %@", [[UIDevice currentDevice] model] );
    
    // Detect if the app is running in the simulator
    BOOL isSimulator = ([[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location != NSNotFound);
    NSLog(@"The device is running in the simulator: %d", isSimulator);
    
    // Detect if the screen is a retina display
    BOOL isRetina = ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                     ([UIScreen mainScreen].scale == 2.0));
    NSLog(@"The device has a retina display: %d", isRetina);
    
    // Detect an iPhone device with the larger screen size
    BOOL isLargerScreen = (([UIScreen mainScreen].bounds.size.height == 568.0) && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone));
    NSLog(@"The device has a larger screen: %d", isLargerScreen);
    
    // Detect if the device has a camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"The device does have a camera.");
    } else {
        NSLog(@"The device does NOT have a camera.");
    }
    
    // Detect the current locale / language of the device
    NSLog(@"The current locale of the device is %@", [[NSLocale currentLocale] localeIdentifier]);
    NSLog(@"The users' preferred language is %@", [[NSLocale preferredLanguages] objectAtIndex:0]);
    
    // Print a localized string;
    NSLog(@"Localized string: %@", NSLocalizedString(@"Greeting", @""));
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
