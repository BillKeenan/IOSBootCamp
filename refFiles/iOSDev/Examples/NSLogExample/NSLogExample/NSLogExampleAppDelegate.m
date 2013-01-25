//
//  NSLogExampleAppDelegate.m
//  NSLogExample
//
//  Created by James Eberhardt on 11-03-24.
//  Copyright 2011 Echo Mobile Inc. All rights reserved.
//

#import "NSLogExampleAppDelegate.h"
#import "CustomObject.h"

@implementation NSLogExampleAppDelegate


@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	// A simple log statement.
	NSLog(@"Hello world.");
	
	// How to display a number.
	int a = 5;
	//NSLog(a);	// This is not valid, and causes an error.
	NSLog(@"The value of a is: %d", a);
	
	// How to display a string, and a string with a comment.
	NSString *first_name = @"James";
	NSLog(@"First name: %@", first_name);

	// Combining objects, strings and number together into one trace statement.
    NSLog(@"First name: %@, the number: %d", first_name, a);	
    
	// How to display the description of an object.
	NSLog(@"This is: %@", self);
	
	// Displaying a custom string for an object.
	CustomObject *newCustomObject = [[CustomObject alloc] init];
	NSLog(@"The custom object is: %@", newCustomObject);    
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
