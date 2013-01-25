//
//  ViewController.m
//  spinningyarn
//
//  Created by Jake Gundersen on 10/8/12.
//  Copyright (c) 2012 Jake Gundersen. All rights reserved.
//

#import "ViewController.h"
#import "GCTurnBasedMatchHelper.h"
#import "GCCustomGUI.h"

@interface ViewController() <UITextFieldDelegate, GCTurnBasedMatchHelperDelegate, UIAlertViewDelegate >

@property (weak, nonatomic) GCCustomGUI *altGUI;

@end

@implementation ViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textInputField.delegate = self;
    [[GCTurnBasedMatchHelper sharedInstance] authenticateLocalUserFromViewController:self];
    [GCTurnBasedMatchHelper sharedInstance].delegate = self;
	
    self.textInputField.enabled = NO;
    self.statusLabel.text = @"Welcome. Press Game Center to get started.";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 210; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    int textFieldMovement = movement * 0.75;
    self.textInputView.frame = CGRectOffset(self.textInputView.frame, 0, movement);
    self.mainTextController.frame = CGRectMake(self.mainTextController.frame.origin.x, self.self.mainTextController.frame.origin.y, self.mainTextController.frame.size.width, self.mainTextController.frame.size.height + textFieldMovement);
    [UIView commitAnimations];
    
}

- (IBAction)updateCount:(id)sender {
    UITextField *tf = (UITextField *)sender;
    int len = [tf.text length];
    int remain = 250 - len;
    self.characterCountLabel.text = [NSString stringWithFormat:@"%d", remain];
    if (remain < 0) {
        self.characterCountLabel.textColor = [UIColor redColor];
    } else {
        self.characterCountLabel.textColor = [UIColor blackColor];
    }
}

- (IBAction)sendTurn:(id)sender {
    GKTurnBasedMatch *currentMatch = [[GCTurnBasedMatchHelper sharedInstance] currentMatch];
    
    NSString *newStoryString;
    if ([self.textInputField.text length] > 250) {
        newStoryString = [self.textInputField.text substringToIndex:249];
    } else {
        newStoryString = self.textInputField.text;
    }
    
    NSString *sendString = [NSString stringWithFormat:@"%@ %@", self.mainTextController.text, newStoryString];
    
    NSData *data = [sendString dataUsingEncoding:NSUTF8StringEncoding ];
    
    self.mainTextController.text = sendString;
    
    NSUInteger currentIndex = [currentMatch.participants indexOfObject:currentMatch.currentParticipant];
    
    NSMutableArray *nextParticipants = [NSMutableArray array];
    for (int i = 0; i < [currentMatch.participants count]; i++) {
        int indx = (i + currentIndex + 1) % [currentMatch.participants count];
        GKTurnBasedParticipant *participant = [currentMatch.participants objectAtIndex:indx];
        //1
        if (participant.matchOutcome == GKTurnBasedMatchOutcomeNone) {
            [nextParticipants addObject:participant];
        }
        
    }
    
    if ([data length] > 3800) {
        for (GKTurnBasedParticipant *part in currentMatch.participants) {
            part.matchOutcome = GKTurnBasedMatchOutcomeTied;
        }
        [currentMatch endMatchInTurnWithMatchData:data completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
            }
        }];
        self.statusLabel.text = @"Game has ended";
    } else {
        [currentMatch endTurnWithNextParticipants:nextParticipants turnTimeout:36000 matchData:data completionHandler: ^(NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                self.statusLabel.text = @"Oops, there was a problem. Try that again.";
            } else {
                self.statusLabel.text = @"Your turn is over.";
                self.textInputField.enabled = NO;
            }
            
        }];
    }

    
    NSLog(@"Send Turn, %@, %@", data, nextParticipants);
    self.textInputField.text = @"";
    self.characterCountLabel.text = @"250";
    self.characterCountLabel.textColor = [UIColor blackColor];

}

- (IBAction)presentGCTurnViewController:(id)sender {
    [[GCTurnBasedMatchHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:12 viewController:self];
}

-(void)enterNewGame:(GKTurnBasedMatch *)match {
    NSLog(@"Entering new game...");
    int playerNum = [match.participants indexOfObject:match.currentParticipant] + 1;
    self.statusLabel.text = [NSString stringWithFormat:@"Player %d's Turn (that's you)", playerNum];
    self.textInputField.enabled = YES;
    self.mainTextController.text = @"Once upon a time";
}

-(void)takeTurn:(GKTurnBasedMatch *)match {
    NSLog(@"Taking turn for existing game...");
    int playerNum = [match.participants indexOfObject:match.currentParticipant] + 1;
    
    NSString *statusString = [NSString stringWithFormat:@"Player %d's Turn (that's you)", playerNum];
    
    self.statusLabel.text = statusString;
    self.textInputField.enabled = YES;
    
    if ([match.matchData bytes]) {
        NSString *storySoFar = [NSString stringWithUTF8String:[match.matchData bytes]];
        self.mainTextController.text = storySoFar;
    }
    [self checkForEnding:match.matchData];
}


-(void)layoutMatch:(GKTurnBasedMatch *)match {
    
    NSLog(@"Viewing match where it's not our turn...");
    NSString *statusString;
    
    if (match.status == GKTurnBasedMatchStatusEnded) {
        statusString = @"Match Ended";
    } else {
        int playerNum = [match.participants indexOfObject:match.currentParticipant] + 1;
        statusString = [NSString stringWithFormat:@"Player %d's Turn", playerNum];
    }
    
    self.statusLabel.text = statusString;
    self.textInputField.enabled = NO;
    NSString *storySoFar = [NSString stringWithUTF8String:[match.matchData bytes]];
    self.mainTextController.text = storySoFar;
    [self checkForEnding:match.matchData];
}

-(void)sendNotice:(NSString *)notice forMatch: (GKTurnBasedMatch *)match {
    if ([self.altGUI isVisible]) {
        [self.altGUI reloadTableView];
    } else {
        [GCTurnBasedMatchHelper sharedInstance].alternateMatch =
        match;
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Another game needs your attention!" message:notice delegate:self cancelButtonTitle:@"Sweet!" otherButtonTitles:@"Let's see it!", @"All my Matches", nil];
        av.delegate = self;
        [av show];
    }
}

-(void)checkForEnding:(NSData *)matchData {
    if ([matchData length]) {
        self.statusLabel.text = [NSString stringWithFormat:@"%@, only about %d letter left", self.statusLabel.text, 4000 - [matchData length]];
    }
}
-(void)recieveEndGame:(GKTurnBasedMatch *)match {
    [self layoutMatch:match];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //1
    if ([segue.identifier isEqualToString:@"PresentCustomGUI"]) {
        //2
        UINavigationController *nc = (UINavigationController *)segue.destinationViewController;
        //3
        GCCustomGUI *cg = (GCCustomGUI *)nc.viewControllers[0];
        //4
        cg.vc = self;
        self.altGUI = cg;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [[GCTurnBasedMatchHelper sharedInstance] setCurrentMatch:[GCTurnBasedMatchHelper sharedInstance].alternateMatch];
            
            if ([[GCTurnBasedMatchHelper sharedInstance].currentMatch.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
                
                [self takeTurn:[GCTurnBasedMatchHelper sharedInstance].currentMatch];
            } else {
                [self layoutMatch:[GCTurnBasedMatchHelper sharedInstance].currentMatch];
            }
            break;
        case 2:
            [self performSegueWithIdentifier:@"PresentCustomGUI" sender:nil];
            break;
        default:
            break;
    }
}


@end
