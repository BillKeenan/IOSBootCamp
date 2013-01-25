//
//  AccelerationExampleAppDelegate.m
//  AccelerationExample
//
//  Created by James Eberhardt on 11-03-25.
//  Copyright 2011 Echo Mobile Inc. All rights reserved.
//

#import "AccelerationExampleAppDelegate.h"
#import "AccelerometerSimulation.h" 

#define kFilteringFactor 0.8
#define CAP(val, max) (val < -max ? -max : (val > max ? max : val))

@implementation AccelerationExampleAppDelegate
@synthesize ball;
@synthesize delta, location;
@synthesize accelX, accelY, previousAccelY;
@synthesize window=_window;

#define kFilteringFactor 0.1

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ball = [[[Shape alloc] initWithFrame:CGRectMake(100.0, 100.0, 75.0, 75.0)] autorelease];
	[self.window addSubview:ball];
    
	UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
	accelerometer.updateInterval = 0.05;
	accelerometer.delegate = self;
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

static inline BOOL bounce(float* val, float* delta, float min, float max) {
#define FLIP(val, c) (c - (val - c))
    if (*val < min || *val > max) {
        *delta = -(*delta * 0.25);
        float loc = *val < min ? min : max;
        *val = FLIP(*val, loc);
        return YES;
    } 
    return NO;
}


-(void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration;
{
	
	//NSLog(@"Accleration X: %f", acceleration.x);
	//NSLog(@"Accleration Y: %f", acceleration.y);
	//NSLog(@"Accleration Z: %f", acceleration.z);
    
    // low pass filter on X
    self.accelX = (acceleration.x * kFilteringFactor) + (self.accelX * (1.0 - kFilteringFactor));
    
    // simplified high pass filter on Y
    self.previousAccelY = (acceleration.y * kFilteringFactor) + (previousAccelY * (1.0 - kFilteringFactor));
    self.accelY = acceleration.y - self.previousAccelY;

    // Calculate the relative distance the ball has moved
	CGPoint _delta = CGPointMake(self.delta.x + self.accelX,
								self.delta.y - self.accelY);
    
    // Calculate the absolute position in the view of the ball
	CGPoint _location = CGPointMake(self.location.x + _delta.x, self.location.y + _delta.y);
    
    // Determine if the ball has reached an edge of the view, and if so, then 'bounce'
	bounce(&_location.x, &_delta.x, ball.frame.size.width / 2, self.window.bounds.size.width - ball.frame.size.width / 2);
    bounce(&_location.y, &_delta.y, ball.frame.size.width / 2, self.window.bounds.size.height - ball.frame.size.height / 2);

	self.delta = _delta;
	self.location = _location;
	self.ball.center = self.location;
    
}

@end
