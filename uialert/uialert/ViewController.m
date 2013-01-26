//
//  ViewController.m
//  uialert
//
//  Created by william keenan on 2013-01-26.
//  Copyright (c) 2013 BigMojo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()


@end

@implementation ViewController

UIAlertView *alert;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    alert = [[UIAlertView alloc] initWithTitle:@"titile" message:@"message" delegate:self cancelButtonTitle:@"tests" otherButtonTitles:@"monkeys",@"anotherbuggon",@"monkeys",@"anotherbuggon",@"monkeys", nil];
    
    
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"pressed %i",buttonIndex);
    NSString *title = [alert buttonTitleAtIndex:buttonIndex];
    NSLog(@"pressed %@",title);
    
    
    alert = [[UIAlertView alloc] initWithTitle:@"titile" message:@"message" delegate:self cancelButtonTitle:@"tests" otherButtonTitles:@"Totall new button", nil];
    
    NSInteger thisIndex = [alert addButtonWithTitle:@"last button"];
    NSLog(@"Last button %i",thisIndex);
    
    [alert show];
}

@end
