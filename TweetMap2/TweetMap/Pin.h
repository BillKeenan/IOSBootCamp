//
//  Pin.h
//  TweetMap
//
//  Created by Michael Reyder on 13-01-27.
//  Copyright (c) 2013 Michael Reyder. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapPin : NSObject <MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D) coordinate withTitle:(NSString*)t withSubTitle:(NSString *)s;

@end