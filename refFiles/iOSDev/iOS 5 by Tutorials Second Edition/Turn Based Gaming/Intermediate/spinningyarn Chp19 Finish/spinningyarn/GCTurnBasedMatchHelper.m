//
//  GCTurnBasedMatchHelper.m
//  spinningyarn
//
//  Created by Jake Gundersen on 10/18/12.
//  Copyright (c) 2012 Jake Gundersen. All rights reserved.
//

#import "GCTurnBasedMatchHelper.h"

@implementation GCTurnBasedMatchHelper

#pragma mark Initialization

+ (GCTurnBasedMatchHelper *) sharedInstance {
    static GCTurnBasedMatchHelper *sharedHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHelper = [[GCTurnBasedMatchHelper alloc] init];
    });
    
    return sharedHelper;
}

-(id)init {
    if ((self = [super init])) {
        _gameCenterAvailable = [self isGameCenterAvailable];
        if (_gameCenterAvailable) {
#if !defined(__IPHONE_6_0)
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
#endif
        } else {
            NSLog(@"Game Center is not available, this game requires game center");
        }
    }
    return self;
}


-(void)authenticationChanged {
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        userAuthenticated = YES;
        NSLog(@"Authentication changed: player authenticated.");
    } else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        userAuthenticated = NO;
        NSLog(@"Authentication changed: player not authenticated");
    }
}

-(void)deleteAllMatches {
    [GKTurnBasedMatch loadMatchesWithCompletionHandler:
     ^(NSArray *matches, NSError *error){
         for (GKTurnBasedMatch *match in matches) {
             NSLog(@"%@", match.matchID);
             
#if !defined(__IPHONE_6_0) || __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
             [match removeWithCompletionHandler:^(NSError *error) {
                 NSLog(@"%@", error);
             }];
#else
             [match participantQuitOutOfTurnWithOutcome:GKTurnBasedMatchOutcomeTied withCompletionHandler:^(NSError *error) {
                 NSLog(@"%@", error);
                 [match removeWithCompletionHandler:^(NSError *error) {
                     NSLog(@"%@", error);
                 }];
             }];
#endif
         }
     }];
}

#pragma mark User functions
-(void)authenticateLocalUserFromViewController:(UIViewController *)authenticationPresentingViewController {
    if (!_gameCenterAvailable) return;
    
    NSLog(@"Authenticating local user . . .");
    presentingViewController = authenticationPresentingViewController;
    
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
#if defined(__IPHONE_6_0)
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (viewController) {
            [authenticationPresentingViewController presentViewController:viewController animated:YES completion:^{
                userAuthenticated = YES;
                //1
                GKTurnBasedEventHandler *ev = [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
                ev.delegate = self;
                //[self deleteAllMatches];
            }];
        } else if (localPlayer.authenticated) {
            userAuthenticated = YES;
            //2
            GKTurnBasedEventHandler *ev = [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
            ev.delegate = self;
            //[self deleteAllMatches];
        } else {
            userAuthenticated = NO;
            NSLog(@"Error with Game Center %@", error);
        }
    };
    
    
#else
    if (localPlayer.authenticated == NO ) {
        [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
            //3
            GKTurnBasedEventHandler *ev = [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
            ev.delegate = self;
        }];
    } else {
        NSLog(@"Already authenticated");
        //4
        GKTurnBasedEventHandler *ev = [GKTurnBasedEventHandler sharedTurnBasedEventHandler];
        ev.delegate = self;
        
    }
#endif
}




-(BOOL)isGameCenterAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    // check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    return (gcClass && osVersionSupported);
}

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers viewController: (UIViewController *)viewController {
    
    if (!_gameCenterAvailable) return;
    presentingViewController = viewController;
    
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    request.minPlayers = minPlayers;
    request.maxPlayers = maxPlayers;
    GKTurnBasedMatchmakerViewController *mmvc = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    mmvc.turnBasedMatchmakerDelegate = self;
    mmvc.showExistingMatches = YES;
    
    [presentingViewController presentViewController:mmvc animated:YES completion:nil];
}

#pragma mark GKTurnBasedMatchmakerViewControllerDelegate
-(void)turnBasedMatchmakerViewController: (GKTurnBasedMatchmakerViewController *)viewController didFindMatch:(GKTurnBasedMatch *)match {
    
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    self.currentMatch = match;
    
    NSMutableArray *stillPlaying = [NSMutableArray array];
    for (GKTurnBasedParticipant *p in match.participants) {
        if (p.matchOutcome == GKTurnBasedMatchOutcomeNone) {
            [stillPlaying addObject:p];
        }
    }
 
    if ([stillPlaying count] < 2 && [match.participants count] >= 2) {
        //There's only one player left
       
        for (GKTurnBasedParticipant *part in stillPlaying) {
            part.matchOutcome = GKTurnBasedMatchOutcomeTied;
        }

        [match endMatchInTurnWithMatchData:match.matchData completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"Error Ending Match %@", error);
            }
      
            [self.delegate layoutMatch:match];
        }];
        
    }
    
    GKTurnBasedParticipant *firstParticipant = [match.participants objectAtIndex:0];
    if (firstParticipant.lastTurnDate == NULL) {
        //It's a new game
        [self.delegate enterNewGame:match];
    } else {
        if ([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            //It's your turn
            [self.delegate takeTurn:match];
        } else {
            //Someone else's turn
            [self.delegate layoutMatch:match];
        }
    }


}

-(void)turnBasedMatchmakerViewControllerWasCancelled: (GKTurnBasedMatchmakerViewController *)viewController {
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"has cancelled");
}

-(void)turnBasedMatchmakerViewController: (GKTurnBasedMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"Error finding match: %@", error.localizedDescription);
}

-(void)turnBasedMatchmakerViewController: (GKTurnBasedMatchmakerViewController *)viewController playerQuitForMatch:(GKTurnBasedMatch *)match {
    NSUInteger currentIndex = [match.participants indexOfObject:match.currentParticipant];
    GKTurnBasedParticipant *part;
    
    NSMutableArray *nextParticipants = [NSMutableArray array];
    for (int i = 0; i < [match.participants count]; i++) {
        part = [match.participants objectAtIndex:(currentIndex + 1 + i) % match.participants.count];
        if (part.matchOutcome == GKTurnBasedMatchOutcomeNone) {
            [nextParticipants addObject:part];
        }
    }
    
    [match participantQuitInTurnWithOutcome:GKTurnBasedMatchOutcomeQuit nextParticipants:nextParticipants turnTimeout:600 matchData:match.matchData completionHandler:nil];
    
    NSLog(@"playerquitforMatch, %@, %@", match, match.currentParticipant);
}

#pragma mark GKTurnBasedEventHandlerDelegate

-(void)handleInviteFromGameCenter:(NSArray *)playersToInvite {
    [presentingViewController dismissViewControllerAnimated:YES completion:nil];
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    
    request.playersToInvite = playersToInvite;
    request.maxPlayers = 12;
    request.minPlayers = 2;
    
    GKTurnBasedMatchmakerViewController *viewController = [[GKTurnBasedMatchmakerViewController alloc] initWithMatchRequest:request];
    
    viewController.showExistingMatches = NO;
    viewController.turnBasedMatchmakerDelegate = self;
    [presentingViewController presentViewController:viewController animated:YES completion:nil];
}


-(void)handleTurnEventForMatch:(GKTurnBasedMatch *)match didBecomeActive:(BOOL)didBecomeActive {
    NSLog(@"Turn has happened");
    if ([match.matchID isEqualToString:self.currentMatch.matchID]) {
        if ([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's the current match and it's our turn now
            self.currentMatch = match;
            [self.delegate takeTurn:match];
        } else {
            // it's the current match, but it's someone else's turn
            self.currentMatch = match;
            [self.delegate layoutMatch:match];
        }
    } else {
        if ([match.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
            // it's not the current match and it's our turn now
            [self.delegate sendNotice:@"It's your turn for another match" forMatch:match];
        } else {
            // it's the not current match, and it's someone else's
            // turn
        }
    }
}

-(void)handleMatchEnded:(GKTurnBasedMatch *)match {
    if ([match.matchID isEqualToString:self.currentMatch.matchID]) {
        [self.delegate recieveEndGame:match];
    } else {
        [self.delegate sendNotice:@"Another Game Ended!" forMatch:match];
    }

}


@end
