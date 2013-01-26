//
//  MasterViewController.h
//  CoreData
//
//  Created by william keenan on 2013-01-26.
//  Copyright (c) 2013 BigMojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController

@property (nonatomic,strong) NSArray * failedBankInfos;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
