//
//  NotificationExampleViewController.m
//  NotificationExample
//
//  Created by James Eberhardt on 10-02-12.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "NotificationExampleViewController.h"
#import "NotificationExampleAppDelegate.h"

@implementation NotificationExampleViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	NotificationExampleAppDelegate *appDelegate = (NotificationExampleAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate someExampleEvent];
	
    [super viewDidLoad];
	[[NSNotificationCenter defaultCenter] 
	 addObserver:self 
	 selector:@selector(receiveNotification:) 
	 name:@"testNotification" 
	 object:nil
	 ];
}

- (void)receiveNotification:(id)obj{
	NSLog(@"Got a notification:%@", obj);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"testNotification" object:nil];
}


- (void)dealloc {
    [super dealloc];
}

@end
