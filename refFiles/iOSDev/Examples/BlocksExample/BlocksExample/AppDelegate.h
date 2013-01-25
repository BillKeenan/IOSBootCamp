//
//  AppDelegate.h
//  BlocksExample
//
//  Created by James Eberhardt on 2012-11-06.
//  Copyright (c) 2012 Echo Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) int (^multiply)(int,int);

@end
