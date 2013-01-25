//
//  BAAnnotation.m
//  BeerAdvisor
//
//  Created by Marin Todorov on 05/10/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "BAAnnotation.h"

@implementation BAAnnotation

-(id)initWithCoordinate:(CLLocationCoordinate2D)c
{
    if (self = [super init]) {
        self.coordinate = c;
    }
    return self;
}

@end
