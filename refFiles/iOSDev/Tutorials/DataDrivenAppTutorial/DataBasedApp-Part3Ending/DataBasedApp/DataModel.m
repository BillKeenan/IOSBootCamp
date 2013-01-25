//
//  DataModel.m
//  DataBasedApp
//
//  Created by James Eberhardt on 12-03-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@synthesize cities, selectedCity;

static DataModel* _instance;

+(DataModel*)getInstance{
    if (_instance == NULL){
        _instance = [DataModel alloc];
		[_instance init];
    }
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        City *toronto = [[City alloc] init];
        toronto.name = @"Toronto";
        toronto.province = @"Ontario";
        toronto.thumbnail = @"toronto_thumb.png";
        toronto.imageURL = @"http://www.eberhardt.ca/ocad/toronto.png";
        
        CLLocationCoordinate2D tmpLocation;
        tmpLocation.latitude = 43.649553;
        tmpLocation.longitude = -79.389181;        
        toronto.location = tmpLocation;
        
        self.cities = [NSArray arrayWithObjects:toronto, toronto,
                       toronto,
                       toronto,
                       toronto,
                       toronto,
                       toronto,
                       toronto,
                       toronto,
                       toronto,
                       toronto,
                       toronto,
                       toronto,
                       toronto,toronto,
                       toronto,
                       toronto,
                       toronto,
                       nil];
        
        self.selectedCity = 0;
    }
    
    return self;
}

@end
