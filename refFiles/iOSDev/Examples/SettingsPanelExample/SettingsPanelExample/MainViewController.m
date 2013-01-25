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
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:) 
     name:UIApplicationDidBecomeActiveNotification 
     object:nil
     ];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UIView *mainView = [[UIView alloc] init];
    self.view = mainView;
    
    UILabel *setting1 = [[UILabel alloc] initWithFrame:CGRectMake(25., 25., 200., 50.)];
    setting1.text = [defaults stringForKey:@"setting1"];
    setting1.tag = 1;
    [self.view addSubview:setting1];
    
    UILabel *setting2 = [[UILabel alloc] initWithFrame:CGRectMake(25., 75., 200., 50.)];
    setting2.text = [defaults stringForKey:@"setting2"];
    setting1.tag = 2;
    [self.view addSubview:setting2];
    
    UILabel *login = [[UILabel alloc] initWithFrame:CGRectMake(25., 125., 200., 50.)];
    login.text = [defaults stringForKey:@"login"];
    setting1.tag = 3;
    [self.view addSubview:login];
}

-(void) applicationWillEnterForeground:(NSNotification*)notification{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UILabel *setting1 = (UILabel*)[self.view viewWithTag:1];
    setting1.text = [defaults stringForKey:@"setting1"];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
