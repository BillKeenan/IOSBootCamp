//
//  TouchesExampleAppDelegate.h
//  TouchesExample
//
//  Created by James Eberhardt on 11-03-25.
//  Copyright 2011 Echo Mobile Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchesExampleViewController.h"

@class TouchesExampleViewController;

@interface TouchesExampleAppDelegate : NSObject <UIApplicationDelegate> {
    TouchesExampleViewController *_viewController;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) TouchesExampleViewController *viewController;

@end
