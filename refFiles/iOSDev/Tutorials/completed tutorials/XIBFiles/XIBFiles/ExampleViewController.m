//
//  ExampleViewController.m
//  XIBFiles
//
//  Created by James Eberhardt on 2012-11-03.
//  Copyright (c) 2012 Echo Mobile. All rights reserved.
//

#import "ExampleViewController.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myButtonClick:(id)sender {
    NSLog(@"The button was clicked:%@", sender);
    self.myLabel.text = @"Goodbye";
}
@end
