//
//  ViewController.h
//  spinningyarn
//
//  Created by Jake Gundersen on 10/8/12.
//  Copyright (c) 2012 Jake Gundersen. All rights reserved.
//

#import <UIKit/UIKit.h>
// foo
#import "GCTurnBasedMatchHelper.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *textInputField;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;
@property (weak, nonatomic) IBOutlet UIView *textInputView;
@property (weak, nonatomic) IBOutlet UITextView *mainTextController;

- (IBAction)presentGCTurnViewController:(id)sender;
- (IBAction)updateCount:(id)sender;

@end
