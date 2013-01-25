//
//  Player.h
//  Ratings
//
//  Created by James Eberhardt on 2012-11-04.
//  Copyright (c) 2012 Echo Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property (nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *game;
@property (nonatomic, assign) int rating;

@end
