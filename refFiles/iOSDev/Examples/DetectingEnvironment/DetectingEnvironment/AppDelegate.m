//
//  AppDelegate.m
//  DetectingEnvironment
//
//  Created by James Eberhardt on 2012-11-01.
//  Copyright (c) 2012 Echo Mobile. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
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

@end
