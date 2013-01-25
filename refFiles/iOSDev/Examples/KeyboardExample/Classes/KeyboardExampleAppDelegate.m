//
//  KeyboardExampleAppDelegate.m
//  KeyboardExample
//
//  Created by James Eberhardt on 10-02-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "KeyboardExampleAppDelegate.h"
#import "KeyboardExampleViewController.h"

@implementation KeyboardExampleAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(keyboardWillHide:) 
												 name:UIKeyboardWillHideNotification 
											   object:nil];    
	
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

- (void)keyboardWillShow:(NSNotification *)note {
	NSLog(@"keyboardWillShow");
}

- (void)keyboardWillHide:(NSNotification *)note {
	NSLog(@"keyboardWillHide");
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
