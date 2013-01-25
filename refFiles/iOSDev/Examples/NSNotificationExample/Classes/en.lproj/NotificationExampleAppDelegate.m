//
//  NotificationExampleAppDelegate.m
//  NotificationExample
//
//  Created by James Eberhardt on 10-02-12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "NotificationExampleAppDelegate.h"
#import "NotificationExampleViewController.h"

@implementation NotificationExampleAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	[[NSNotificationCenter defaultCenter] 
        postNotificationName:@"testNotification" 
        object:self];
}

-(void)someExampleEvent{
	NSLog(@"getting some event");
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
