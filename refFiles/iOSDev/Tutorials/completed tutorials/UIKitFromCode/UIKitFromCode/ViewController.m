//
//  ViewController.m
//  UIButtonFromCode
//
//  Created by James Eberhardt on 2012-11-03.
//  Copyright (c) 2012 Echo Mobile. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myButton.frame = CGRectMake(50., 50., 100., 50.);
    [myButton setTitle:@"Click me" forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myButton];
    
    self.myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50., 150., 150., 50.)];
    self.myLabel.text = @"Hello";
    [self.view addSubview:self.myLabel];
}

-(void)buttonClick:(id)sender{
	NSLog(@"The button was clicked: %@", sender);
    self.myLabel.text = @"Goodbye";
}

@end
