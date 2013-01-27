//
//  TMViewController.m
//  TweetMap
//
//  Created by Michael Reyder on 13-01-27.
//  Copyright (c) 2013 Michael Reyder. All rights reserved.
//

#import "TMViewController.h"
#import "TMOurMapController.h"

@interface TMViewController ()

@end

@implementation TMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToMap:(id)sender {
    TMOurMapController *ourMap = [[TMOurMapController alloc] init];
    [self.navigationController pushViewController:ourMap animated:true];
}
@end
