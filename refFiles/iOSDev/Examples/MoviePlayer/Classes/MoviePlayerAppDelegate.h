//
//  MoviePlayerAppDelegate.h
//  MoviePlayer
//
//  Created by James Eberhardt on 10-11-14.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface MoviePlayerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MPMoviePlayerController *moviePlayer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;

@end

