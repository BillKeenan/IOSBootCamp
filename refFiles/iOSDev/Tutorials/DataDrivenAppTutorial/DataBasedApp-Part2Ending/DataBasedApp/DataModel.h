//
//  DataModel.h
//  DataBasedApp
//
//  Created by James Eberhardt on 12-03-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@interface DataModel : NSObject

@property (nonatomic, strong) NSMutableArray *cities;
@property (nonatomic) NSInteger selectedCity;

+(DataModel*)getInstance;

@end
