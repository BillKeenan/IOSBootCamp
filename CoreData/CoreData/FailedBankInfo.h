//
//  FailedBankInfo.h
//  CoreData
//
//  Created by william keenan on 2013-01-26.
//  Copyright (c) 2013 BigMojo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FailedbankDetails.h"

@interface FailedBankInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) FailedBankDetails *details;

@end
