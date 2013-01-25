//
//  CityInformationViewController.m
//  DataBasedApp
//
//  Created by James Eberhardt on 12-03-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CityInformationViewController.h"
#import "MapViewController.h"

@implementation CityInformationViewController

@synthesize data;
@synthesize cityImage;

-(void)loadView{
    self.view = [[UIView alloc] init];
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
    self.view.backgroundColor = [UIColor redColor];
    
    self.data = [DataModel getInstance];
    
    self.title = [(City*)[self.data.cities objectAtIndex:self.data.selectedCity] name];
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(mapButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = mapButton;
    
    self.cityImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[(City*)[self.data.cities objectAtIndex:self.data.selectedCity] imageURL]]]];
    
}

-(void)mapButtonAction:(id)sender{
    
    MapViewController *mapViewController =[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    [self.navigationController pushViewController:mapViewController animated:YES];
    
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
