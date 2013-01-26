//
//  ExampleViewController.m
//  Project3
//
//  Created by william keenan on 2013-01-25.
//  Copyright (c) 2013 BigMojo. All rights reserved.
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
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(100.,50.,100.,50.)];
    newLabel.text=@"hi";
    newLabel.textColor=[UIColor colorWithRed:0xff/255.0 green:0 blue:0 alpha:1.0];
    [self.view addSubview:newLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)MyButtonTouchUp:(id)sender {
    NSLog(@"Button-%@", sender);
    self.myLabel.text=@"here";
}
@end
