//
//  DWFViewController.m
//  DrawWithFire
//
//  Created by Marin Todorov on 05/10/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "DWFViewController.h"

@interface DWFViewController ()

@end

@implementation DWFViewController

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [fireView setEmitterPositionFromTouch: [touches anyObject]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [fireView setEmitterPositionFromTouch: [touches anyObject]];
    [fireView setIsEmitting:YES];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [fireView setIsEmitting:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [fireView setIsEmitting:NO];
}

@end
