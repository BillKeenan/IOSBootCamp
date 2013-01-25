//
//  AppDelegate.h
//  RazeTweet
//
//  Created by Felipe on 10/13/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) NSMutableDictionary *profileImages;
@property (strong, nonatomic) ACAccount *userAccount;
@property (strong, nonatomic) UIWindow *window;

@end
