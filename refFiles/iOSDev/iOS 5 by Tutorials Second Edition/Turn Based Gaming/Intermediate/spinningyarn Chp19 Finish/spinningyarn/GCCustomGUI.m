//
//  GCCustomGUI.m
//  spinningyarn
//
//  Created by Jake Gundersen on 10/18/12.
//  Copyright (c) 2012 Jake Gundersen. All rights reserved.
//

#import "GCCustomGUI.h"
#import <GameKit/GameKit.h>
#import "MatchCell.h"

@interface GCCustomGUI () <MatchCellDelegate>

@end

@implementation GCCustomGUI  {
    NSArray *allMyMatches;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = 220;
    //2
    self.tableView.editing = NO;
    //3
    UIBarButtonItem *plus = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewMatch)];
    
    self.navigationItem.rightBarButtonItem = plus;
    //4
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = cancel;
    
    [self reloadTableView];
}

-(void)reloadTableView {
    // 1
    [GKTurnBasedMatch loadMatchesWithCompletionHandler: ^(NSArray *matches, NSError *error) {
        // 2
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            // 3
            NSMutableArray *myMatches = [NSMutableArray array];
            NSMutableArray *otherMatches = [NSMutableArray array];
            NSMutableArray *endedMatches = [NSMutableArray array];
            // 4
            for (GKTurnBasedMatch *m in matches) {
                GKTurnBasedMatchOutcome myOutcome;
                for (GKTurnBasedParticipant *par in m.participants) {
                    if ([par.playerID isEqualToString: [GKLocalPlayer localPlayer].playerID]) {
                        myOutcome = par.matchOutcome;
                    }
                }
                // 5
                if (m.status != GKTurnBasedMatchStatusEnded && myOutcome != GKTurnBasedMatchOutcomeQuit) {
                    if ([m.currentParticipant.playerID isEqualToString:[GKLocalPlayer localPlayer].playerID]) {
                        [myMatches addObject:m];
                    } else {
                        [otherMatches addObject:m];
                    }
                } else {
                    [endedMatches addObject:m];
                }
            }
            // 6
            allMyMatches = [[NSArray alloc] initWithObjects:myMatches, otherMatches,endedMatches, nil];
            NSLog(@"Matches: %@", allMyMatches);
            [self.tableView reloadData];
        }
    }];
}

-(void)cancel {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)addNewMatch {
    GKMatchRequest *request = [[GKMatchRequest alloc] init];
    
    request.maxPlayers = 12;
    request.minPlayers = 2;
    
    [GKTurnBasedMatch findMatchForRequest:request withCompletionHandler:^(GKTurnBasedMatch *match, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription );
        } else {
            NSLog(@"match found!");
            [self.vc dismissViewControllerAnimated:YES completion:nil];
            [[GCTurnBasedMatchHelper sharedInstance] turnBasedMatchmakerViewController:nil didFindMatch:match];

        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"My Turn";
    } else if (section == 1) {
        return @"Their Turn";
    } else {
        return @"Game Ended";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[allMyMatches objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1
    MatchCell *cell = (MatchCell *)[tableView dequeueReusableCellWithIdentifier:@"MatchCell"];
    //2
    GKTurnBasedMatch *match = [[allMyMatches objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.match = match;
    
    cell.delegate = self;
    //3
    if ([match.matchData length] > 0) {
        //4
        NSString *storyString = [NSString stringWithUTF8String:[match.matchData bytes]];
        cell.storyText.text = storyString;
        //5
        int days = -floor([match.creationDate timeIntervalSinceNow] / (60 * 60 * 24));
        cell.statusLabel.text = [NSString stringWithFormat:@"Story started %d days ago and is about %d words",days, [storyString length] / 5];
    }
    
    if (indexPath.section == 2) {
        [cell.quitButton setTitle:@"Remove" forState:UIControlStateNormal];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)loadAMatch:(GKTurnBasedMatch *)match {
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    [[GCTurnBasedMatchHelper sharedInstance] turnBasedMatchmakerViewController:nil didFindMatch:match];
}

- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}


@end
