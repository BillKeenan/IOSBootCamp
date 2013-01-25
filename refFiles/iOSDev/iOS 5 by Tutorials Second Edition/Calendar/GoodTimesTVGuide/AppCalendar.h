//
//  AppCalendar.h
//  GoodTimesTVGuide
//
//  Created by Marin Todorov on 06/10/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

#define kAppCalendarTitle @"Good Times TV Guide"

@interface AppCalendar : NSObject

+(EKEventStore*)eventStore;
+(EKCalendar*)calendar;
+(EKCalendar*)createAppCalendar;

@end