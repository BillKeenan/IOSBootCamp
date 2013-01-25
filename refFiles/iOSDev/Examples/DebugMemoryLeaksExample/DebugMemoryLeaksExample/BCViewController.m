//
//  BCViewController.m
//  DebugMemoryLeaksExample
//
//  Created by James Eberhardt on 12-04-29.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//  

#import "BCViewController.h"

@interface BCViewController ()

@end

@implementation BCViewController

- (IBAction)buttonClick:(id)sender {
    NSLog(@"Creating a UIView object");
	UIView *newView = [UIView alloc];
//    [newView release];
    
    //newView.backgroundColor = [UIColor redColor];
    //[newView release];
}

-(BOOL)isValid:(int)numberToCheck{
    BOOL flag;
    if (numberToCheck > 0){
        flag = true;
    } else if (numberToCheck < 0){
        flag = false;
    }
    return flag;
}

@end