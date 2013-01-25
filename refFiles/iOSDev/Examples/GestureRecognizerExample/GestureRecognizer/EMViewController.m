//
//  EMViewController.m
//  GestureRecognizer
//
//  Created by James Eberhardt on 12-01-28.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EMViewController.h"

@implementation EMViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // A double tap recognizer
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTapGesture];
    
    // A pan gesture
    UIPanGestureRecognizer *panGesture =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer: panGesture];
    
    // A pinch gesture
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self.view addGestureRecognizer:pinchGesture];
        
    // Long press gesture
    UILongPressGestureRecognizer *longpressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    longpressGesture.minimumPressDuration = 3;
    [self.view addGestureRecognizer:longpressGesture];
    
}

- (void)handleDoubleTapGesture:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"Double tap 2");
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    NSLog(@"Pan");
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)gestureRecognizer {
    NSLog(@"Pinch:%f", gestureRecognizer.scale);
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    NSLog(@"Long press: %f", gestureRecognizer.minimumPressDuration);
}

- (void)viewDidUnload
{
    for (UIGestureRecognizer *gestureRecognizer in self.view.gestureRecognizers){
        [self.view removeGestureRecognizer:gestureRecognizer];
    }
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
