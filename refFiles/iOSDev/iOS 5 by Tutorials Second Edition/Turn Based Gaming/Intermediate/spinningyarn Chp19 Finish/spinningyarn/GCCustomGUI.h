//
//  GCCustomGUI.h
//  spinningyarn
//
//  Created by Jake Gundersen on 10/18/12.
//  Copyright (c) 2012 Jake Gundersen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "GCTurnBasedMatchHelper.h"

@interface GCCustomGUI : UITableViewController

@property (nonatomic, weak) ViewController * vc;

-(BOOL)isVisible;
-(void)reloadTableView;

@end
