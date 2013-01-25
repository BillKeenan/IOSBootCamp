//
//  DataModel.m
//  DataBasedApp
//
//  Created by James Eberhardt on 12-03-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@synthesize cities;

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
        self.cities = [NSArray arrayWithObjects:
                       @"Toronto", 
                       @"Ottawa",
                       @"Québec",
                       @"Vancouver",
                       @"Winnipeg",
                       @"Calgary",
                       @"Halifax",
                       @"Charlottetown",
                       @"St. John",
                       @"St. John's",
                       @"Whitehorse",
                       @"Yellowknife",
                       @"Iqaluit",
                       nil];        
    }
    
    return self;
}

@end
