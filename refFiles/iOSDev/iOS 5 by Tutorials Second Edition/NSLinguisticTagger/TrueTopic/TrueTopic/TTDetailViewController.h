//
//  TTDetailViewController.h
//  TrueTopic
//
//  Created by Marin Todorov on 01/10/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
