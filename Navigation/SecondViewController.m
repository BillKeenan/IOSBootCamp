//
//  SecondViewController.m
//  Navigation
//
//  Created by william keenan on 2013-01-26.
//  Copyright (c) 2013 BigMojo. All rights reserved.
//

#import "SecondViewController.h"
#import "TableViewController.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.title=@"monkeys";
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

- (IBAction)openTable:(id)sender {
    TableViewController *tmpTabl = [[TableViewController alloc] init];
    [self.navigationController pushViewController:tmpTabl animated:true];
}
@end
