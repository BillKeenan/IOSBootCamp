//
//  MapKitExampleAppDelegate.h
//  MapKitExample
//
//  Created by James Eberhardt on 10-02-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class MapKitExampleViewController;

@interface MapKitExampleAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    UIWindow *window;
    MapKitExampleViewController *viewController;
	CLLocationManager *locationManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MapKitExampleViewController *viewController;

@end

