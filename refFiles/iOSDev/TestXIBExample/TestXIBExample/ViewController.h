//
//  ViewController.h
//  TestXIBExample
//
//  Created by James Eberhardt on 2012-11-03.
//  Copyright (c) 2012 Echo Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
- (IBAction)myButtonClick:(id)sender;

@end
