//
//  CityInformationViewController.h
//  DataBasedApp
//
//  Created by James Eberhardt on 12-03-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import "City.h"

@interface CityInformationViewController : UIViewController

@property (nonatomic, strong) DataModel *data;
@property (weak, nonatomic) IBOutlet UIImageView *cityImage;

@end
