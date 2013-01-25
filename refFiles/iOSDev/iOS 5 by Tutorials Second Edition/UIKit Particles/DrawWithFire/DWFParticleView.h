//
//  DWFParticleView.h
//  DrawWithFire
//
//  Created by Marin Todorov on 05/10/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWFParticleView : UIView
-(void)setEmitterPositionFromTouch: (UITouch*)t;
-(void)setIsEmitting:(BOOL)isEmitting;
@end
