//
//  City.h
//  DataBasedApp
//
//  Created by James Eberhardt on 12-03-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface City : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic) CLLocationCoordinate2D location;

@end
