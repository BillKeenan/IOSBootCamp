//
//  WordCount.h
//  TrueTopic
//
//  Created by Marin Todorov on 01/10/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordCount : NSObject

@property (strong) NSString* word;
@property int count;

+(WordCount*)wordWithString:(NSString*)str;

@end