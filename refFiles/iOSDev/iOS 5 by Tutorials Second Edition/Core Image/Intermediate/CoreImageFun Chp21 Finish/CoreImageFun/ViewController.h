//
//  ViewController.h
//  CoreImageFun
//
//  Created by Jake Gundersen on 10/18/12.
//  Copyright (c) 2012 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *maskModeButton;
@property (weak, nonatomic) IBOutlet UILabel *filterTitle;

@property (weak, nonatomic) IBOutlet UISlider *amountSlider;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)amountSliderValueChanged:(id)sender;
- (IBAction)loadPhoto:(id)sender;
- (IBAction)savePhoto:(id)sender;
- (IBAction)maskModeOn:(id)sender;
- (IBAction)rotateFilter:(id)sender;
- (IBAction)autoEnhance:(id)sender;



@end
