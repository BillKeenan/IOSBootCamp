//
//  MapKitExampleAppDelegate.m
//  MapKitExample
//
//  Created by James Eberhardt on 10-02-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MapKitExampleAppDelegate.h"
#import "MapKitExampleViewController.h"

@implementation MapKitExampleAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self; // Tells the location manager to send updates to this object
    locationManager.distanceFilter = 5;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
//    [locationManager startMonitoringSignificantLocationChanges];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"Got new location update\n");
    
	NSLog(@"latitude %+.3f, longitude %+.6f\n",
		   newLocation.coordinate.latitude,
		   newLocation.coordinate.longitude);
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
