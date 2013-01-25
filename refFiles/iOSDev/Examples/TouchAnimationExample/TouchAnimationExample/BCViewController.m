//
//  BCViewController.m
//  TouchAnimationExample
//
//  Created by James Eberhardt on 12-04-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BCViewController.h"

@interface BCViewController ()

@end

@implementation BCViewController

@synthesize ball;

- (void)loadView{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.ball = [[Shape alloc] initWithFrame:CGRectMake(100., 100., 75., 75.)];
    [self.view addSubview:ball];

}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	NSLog(@"touchesBegan");
    self.ball.alpha = 1.;
    self.view.userInteractionEnabled = FALSE;
    [UIView animateWithDuration:2.0
                          delay:0.0 
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.ball.center = [[touches anyObject] locationInView:self.view];
                     }
                     completion:^(BOOL finished) {
                         self.view.userInteractionEnabled = TRUE;
                     }
     ];
    [UIView animateWithDuration:0.5
                          delay:.75 
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         self.ball.alpha = 0.;
                     }
                     completion:^(BOOL finished) {
                     }
     ];    
}

@end
