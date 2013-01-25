//
//  MapKitExampleViewController.h
//  MapKitExample
//
//  Created by James Eberhardt on 10-02-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapKitExampleViewController : UIViewController <MKMapViewDelegate> {
	MKMapView *mapView;
}

-(void)addPin:(CLLocationCoordinate2D)location;

@end

