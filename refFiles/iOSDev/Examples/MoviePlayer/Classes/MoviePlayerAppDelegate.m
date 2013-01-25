//
//  MoviePlayerAppDelegate.m
//  MoviePlayer
//
//  Created by James Eberhardt on 10-11-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MoviePlayerAppDelegate.h"

@implementation MoviePlayerAppDelegate

@synthesize window, moviePlayer;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    [window makeKeyAndVisible];
	
	NSString *resourceString = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"testvideo.mp4"];
	NSString *expandedResourceString = [resourceString stringByExpandingTildeInPath];
	NSURL *tmpURL = [NSURL fileURLWithPath:expandedResourceString];
	MPMoviePlayerController *tmpMoviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:tmpURL];
	self.moviePlayer = tmpMoviePlayer;
	[tmpMoviePlayer release];
	self.moviePlayer.view.frame = CGRectMake(0.,0.,320., 350.);
	[self.window addSubview:self.moviePlayer.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    
	[self.moviePlayer play];
    
    return YES;
}

-(void) playerPlaybackDidFinish:(NSNotification*) notificationObject{
    [(MPMoviePlayerController*)notificationObject.object view].hidden = TRUE;    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [self.moviePlayer release];
    [super dealloc];
}


@end
