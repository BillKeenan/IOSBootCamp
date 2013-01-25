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
    NSMutableArray *_ballsArray;
    NSMutableArray *_touchesArray;
}

@property (nonatomic, strong) NSMutableArray *myBallsArray;
@property (nonatomic, strong) NSMutableArray *myTouchesArray;

@end
