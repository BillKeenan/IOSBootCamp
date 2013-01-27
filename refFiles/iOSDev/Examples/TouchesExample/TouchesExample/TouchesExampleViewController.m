//
//  TouchesExampleViewController.m
//  TouchesExample
//
//  Created by James Eberhardt on 11-03-25.
//  Copyright 2011 Echo Mobile Inc. All rights reserved.
//

#import "TouchesExampleViewController.h"

@implementation TouchesExampleViewController

@synthesize ball = _ball;

#pragma mark - View lifecycle

-(void)loadView{
    self.view = [[UIView alloc]init];
    self.view.backgroundColor = [UIColor greenColor];
    self.view.multipleTouchEnabled = TRUE;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSLog(@"touchesBegan");
	// Move relative to the original touch point
    self.ball = [[Shape alloc] initWithFrame:CGRectMake(0., 0., 75., 75.)];
	self.ball.backgroundColor = [UIColor clearColor];
	[self.view addSubview:self.ball];
	self.ball.center = [[touches anyObject] locationInView:self.view];
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{	
	NSLog(@"touchesMoved: %d points", [touches count]);
	self.ball.center = [[touches anyObject] locationInView:self.view];
}

- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{	
	// Remove the ball
    [self.ball removeFromSuperview];
}

@end
