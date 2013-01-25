//
//  TableViewController.h
//  DataBasedApp
//
//  Created by James Eberhardt on 12-03-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityInformationViewController.h"
#import "DataModel.h"
#import "City.h"

@interface TableViewController : UITableViewController

@property (nonatomic, strong) DataModel *data;

@end
