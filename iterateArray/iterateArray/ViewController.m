//
//  ViewController.m
//  iterateArray
//
//  Created by william keenan on 2013-01-25.
//  Copyright (c) 2013 BigMojo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *personOne = @"Ray";
    NSString *personTwo = @"Shawn";
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects: personOne, personTwo,nil];
    
    
    [array addObject:@"Waldo"];
    
    NSLog(@"%d items!", array.count);
    
    
    for (NSString *person in array) {
        NSLog(@"Person: %@", person);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
