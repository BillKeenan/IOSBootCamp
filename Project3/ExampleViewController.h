//
//  ExampleViewController.h
//  Project3
//
//  Created by william keenan on 2013-01-25.
//  Copyright (c) 2013 BigMojo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExampleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (weak, nonatomic) IBOutlet UITextField *myLabel;

- (IBAction)MyButtonTouchUp:(id)sender;
@end
