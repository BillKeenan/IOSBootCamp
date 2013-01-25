//
//  MainViewController.m
//  SettingsPanelExample
//
//  Created by James Eberhardt on 11-10-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIView *mainView = [[UIView alloc] init];
    self.view = mainView;
    
}

-(void) doNothing:(id)sender{

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UISlider appearance] setMinimumTrackTintColor:[UIColor redColor]];
    
    UISlider *tmpSlider = [[UISlider alloc] initWithFrame: CGRectMake(170., 200., 125., 50.)];
    [self.view addSubview:tmpSlider];
    
    UIButton *tmpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tmpButton.frame = CGRectMake(25., 25., 150., 50.);
    [tmpButton setTitle:@"Send iMessage" forState:UIControlStateNormal];
    [tmpButton addTarget:self action:@selector(doNothing:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tmpButton];
    
    
    UIButton *tmpButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tmpButton2.frame = CGRectMake(25., 250., 150., 50.);
    [tmpButton2 setTitle:@"Send iMessage" forState:UIControlStateNormal];
    [tmpButton2 addTarget:self action:@selector(doNothing:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:tmpButton2];
    
}


@end
