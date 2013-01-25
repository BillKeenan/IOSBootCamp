//
//  CityInformationViewController.m
//  DataBasedApp
//
//  Created by James Eberhardt on 12-03-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CityInformationViewController.h"

@implementation CityInformationViewController

@synthesize data;
@synthesize cityImage;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.data = [DataModel getInstance];
    
    self.title = [(City*)[self.data.cities objectAtIndex:self.data.selectedCity] name];
    
    self.cityImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[(City*)[self.data.cities objectAtIndex:self.data.selectedCity] imageURL]]]];
    
}

- (void)viewDidUnload
{
    [self setCityImage:nil];
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
