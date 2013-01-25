//
//  TouchesExampleViewController.h
//  TouchesExample
//
//  Created by James Eberhardt on 11-03-25.
//  Copyright 2011 Echo Mobile Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shape.h"

@interface TouchesExampleViewController : UIViewController {
    Shape *_ball;
    NSMutableArray *_touches;
}

@property (nonatomic, strong) Shape *ball;
@property (nonatomic, strong) NSMutableArray *touches;

@end
