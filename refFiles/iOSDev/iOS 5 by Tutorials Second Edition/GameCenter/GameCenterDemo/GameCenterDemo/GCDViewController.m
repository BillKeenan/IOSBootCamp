//
//  GCDViewController.m
//  GameCenterDemo
//
//  Created by Marin Todorov on 29/09/2012.
//  Copyright (c) 2012 Underplot ltd. All rights reserved.
//

#import "GCDViewController.h"
#import <GameKit/GameKit.h>

@interface GCDViewController ()
{
    IBOutlet UIImageView* photoView;
    IBOutlet UILabel* nameLabel;
}
-(IBAction)achieveRightNow;
@end

@implementation GCDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([GKLocalPlayer localPlayer].authenticated == NO) { //1
        [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *controller, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^(void) { //3
                nameLabel.text = [GKLocalPlayer localPlayer].alias; //4
                //show the user photo
                [self loadPlayerPhoto];
                
                //show logged notification
                [self showMessage:@"User authenticated successfuly"];
            });
        }];
    }
}

-(void)loadPlayerPhoto
{
    [[GKLocalPlayer localPlayer] loadPhotoForSize: GKPhotoSizeNormal
                            withCompletionHandler:^(UIImage *photo, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (error==nil) {
                photoView.image = photo; //show photo notification later
                [self showMessage:@"Photo downloaded"];
        } else {
            nameLabel.text = @"No player photo"; }
        });
    }];
}

//add inside the implementation
-(void)showMessage:(NSString*)msg {
    [GKNotificationBanner showBannerWithTitle:@"GameKit message"
                                      message:msg
                            completionHandler:^{}];
}

-(IBAction)achieveRightNow
{
    GKAchievement* achievement= [[GKAchievement alloc]
                                 initWithIdentifier: @"com.razeware.writinggamecenterapichapter"];
    achievement.percentComplete= 100;
    achievement.showsCompletionBanner = YES;
    
    [achievement reportAchievementWithCompletionHandler:^(NSError *error){NSLog(@"error: %@", error);}];
}

@end
