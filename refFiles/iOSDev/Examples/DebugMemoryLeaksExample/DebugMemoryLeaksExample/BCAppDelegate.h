//
//  BCAppDelegate.h
//  DebugMemoryLeaksExample
//
//  Created by James Eberhardt on 12-04-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCViewController;

@interface BCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BCViewController *viewController;

@end
