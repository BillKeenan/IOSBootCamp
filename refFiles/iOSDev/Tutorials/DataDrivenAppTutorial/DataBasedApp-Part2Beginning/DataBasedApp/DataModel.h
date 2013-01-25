//
//  DataModel.h
//  DataBasedApp
//
//  Created by James Eberhardt on 12-03-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic, strong) NSArray *cities;

+(DataModel*)getInstance;

@end
