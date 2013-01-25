//
//  MapPin.m
//  City Sonic
//
//  Created by James Eberhardt on 17/06/09.
//  Copyright 2009 Echo Mobile Inc. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

@synthesize coordinate, title, subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c withTitle:(NSString*)t withSubTitle:(NSString *)s {
	coordinate=c;
	title = t;
	subtitle = s;
	return self;
}

-(void)dealloc{
	[title release];
	[subtitle release];
	[super dealloc];
}
@end