//
//  GCTurnBasedMatchHelper.h
//  spinningyarn
//
//  Created by Ray Wenderlich on 10/23/12.
//  Copyright (c) 2012 Jake Gundersen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GCTurnBasedMatchHelperDelegate
- (void)enterNewGame:(GKTurnBasedMatch *)match;
- (void)layoutMatch:(GKTurnBasedMatch *)match;
- (void)takeTurn:(GKTurnBasedMatch *)match;
- (void)recieveEndGame:(GKTurnBasedMatch *)match;
- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match;
@end

@interface GCTurnBasedMatchHelper : NSObject <GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate> {
    BOOL userAuthenticated;
    UIViewController *presentingViewController;
}

@property (strong) GKTurnBasedMatch * currentMatch;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, assign) id <GCTurnBasedMatchHelperDelegate> delegate;

+ (GCTurnBasedMatchHelper *)sharedInstance;
-(void)authenticateLocalUserFromViewController:(UIViewController *)authenticationPresentingViewController;
- (void)findMatchWithMinPlayers:(int)minPlayers
                     maxPlayers:(int)maxPlayers
                 viewController:(UIViewController *)viewController;

@end
