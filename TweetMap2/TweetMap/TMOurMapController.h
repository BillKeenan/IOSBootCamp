//
//  TMOurMapController.h
//  TweetMap
//
//  Created by Michael Reyder on 13-01-27.
//  Copyright (c) 2013 Michael Reyder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface TMOurMapController : UIViewController <MKMapViewDelegate> {
    MKMapView *mapView;
}

@end
