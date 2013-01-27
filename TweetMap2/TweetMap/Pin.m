//
//  Pin.m
//  TweetMap
//
//  Created by Michael Reyder on 13-01-27.
//  Copyright (c) 2013 Michael Reyder. All rights reserved.
//

#import "Pin.h"

@implementation MapPin

@synthesize coordinate, title, subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c withTitle:(NSString*)t withSubTitle:(NSString *)s {
	coordinate=c;
	title = t;
	subtitle = s;
	return self;
}

@end