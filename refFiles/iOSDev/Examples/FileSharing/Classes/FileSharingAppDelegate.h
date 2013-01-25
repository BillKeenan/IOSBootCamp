//
//  FileSharingAppDelegate.h
//  FileSharing
//
//  Created by James Eberhardt on 10-09-16.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FileSharingViewController;

@interface FileSharingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FileSharingViewController *viewController;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet FileSharingViewController *viewController;

@end

