//
//  KeyboardExampleAppDelegate.h
//  KeyboardExample
//
//  Created by James Eberhardt on 10-02-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KeyboardExampleViewController;

@interface KeyboardExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    KeyboardExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet KeyboardExampleViewController *viewController;

@end

