//
//  ViewController.m
//  Navigation
//
//  Created by william keenan on 2013-01-26.
//  Copyright (c) 2013 BigMojo. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title=@"Menu";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button:(id)sender {
    SecondViewController *tmpView = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:tmpView animated:true];
}
@end
