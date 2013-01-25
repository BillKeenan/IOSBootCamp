//
//  NotificationExampleAppDelegate.h
//  NotificationExample
//
//  Created by James Eberhardt on 10-02-12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotificationExampleViewController;

@interface NotificationExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    NotificationExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet NotificationExampleViewController *viewController;

-(void)someExampleEvent;

@end

