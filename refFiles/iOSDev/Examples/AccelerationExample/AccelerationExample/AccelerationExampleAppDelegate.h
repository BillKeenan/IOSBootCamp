//
//  AccelerationExampleAppDelegate.h
//  AccelerationExample
//
//  Created by James Eberhardt on 11-03-25.
//  Copyright 2011 Echo Mobile Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shape.h"

@interface AccelerationExampleAppDelegate : NSObject <UIApplicationDelegate, UIAccelerometerDelegate> {
    Shape *ball;
}

@property (nonatomic) float accelX;
@property (nonatomic) float accelY;
@property (nonatomic) float previousAccelY;
@property (nonatomic, retain) Shape *ball;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property(nonatomic, assign) CGPoint delta;
@property(nonatomic, assign) CGPoint location;

@end
