//
//  TouchesExampleViewController.m
//  TouchesExample
//
//  Created by James Eberhardt on 11-03-25.
//  Copyright 2011 Echo Mobile Inc. All rights reserved.
//

#import "TouchesExampleViewController.h"

@implementation TouchesExampleViewController

@synthesize myBallsArray = _myBallsArray;

@synthesize myTouchesArray = _myTouchesArray;

#pragma mark - View lifecycle

-(void)loadView{
    self.view = [[UIView alloc]init];
    self.view.backgroundColor = [UIColor greenColor];
    self.view.multipleTouchEnabled = TRUE;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myBallsArray = [[NSMutableArray alloc] init];
    self.myTouchesArray = [[NSMutableArray alloc] init];
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSLog(@"touchesBegan: %d", [touches count]);
    
    for (UITouch *touch in touches){
        // Move relative to the original touch point
        Shape *tempBall = [[Shape alloc] initWithFrame:CGRectMake(0., 0., 75., 75.)];
        [self.view addSubview:tempBall];
        tempBall.center = [touch locationInView:self.view];

        // Add the touch to the array;
        [self.myTouchesArray addObject:touch];
        
        // Add the ball to the array;
        [self.myBallsArray addObject:tempBall];
        
    }
    
    
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{	
    for (UITouch *touch in touches){
        NSLog(@"Touch: %@", touch);
        if ([self.myTouchesArray indexOfObject:touch] != NSNotFound){
            Shape *tempBall = [self.myBallsArray objectAtIndex:[self.myTouchesArray indexOfObject:touch]];
            tempBall.center = [touch locationInView:self.view];            
        }
    }
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{	
    for (UITouch *touch in touches){
        
        int touchIndex = [self.myTouchesArray indexOfObject:touch];
        
        if (touchIndex != NSNotFound){
            [[self.myBallsArray objectAtIndex:touchIndex] removeFromSuperview];
            [self.myBallsArray removeObjectAtIndex:touchIndex];
            [self.myTouchesArray removeObjectAtIndex:touchIndex];
        }
    }
}

@end
