//
//  ViewController.m
//  SimpleTweet
//
//  Created by Felipe on 10/13/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import <Twitter/Twitter.h>
#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSString *imageString;
@property (strong, nonatomic) NSString *urlString;

@property (weak, nonatomic) IBOutlet UILabel *button1Label;
@property (weak, nonatomic) IBOutlet UILabel *button2Label;
@property (weak, nonatomic) IBOutlet UILabel *button3Label;
@property (weak, nonatomic) IBOutlet UILabel *button4Label;

- (IBAction)button1Tapped:(id)sender;
- (IBAction)button2Tapped:(id)sender;
- (IBAction)button3Tapped:(id)sender;
- (IBAction)button4Tapped:(id)sender;
- (IBAction)tweetTapped:(id)sender;

@end

@implementation ViewController

#pragma mark - IBActions

- (IBAction)button1Tapped:(id)sender
{
    [self clearLabels];
    self.imageString = @"CheatSheetButton.png";
    self.urlString = @"http://www.raywenderlich.com/4872/objective-c-cheat-sheet-and-quick-reference";
    self.button1Label.textColor = [UIColor redColor];
}

- (IBAction)button2Tapped:(id)sender
{
    [self clearLabels];
    self.imageString = @"HorizontalTablesButton.png";
    self.urlString = @"http://www.raywenderlich.com/4723/how-to-make-an-interface-with-horizontal-tables-like-the- pulse-news-app-part-2";
    self.button2Label.textColor = [UIColor redColor];
}

- (IBAction)button3Tapped:(id)sender
{
    [self clearLabels];
    self.imageString = @"PathfindingButton.png";
    self.urlString = @"http://www.raywenderlich.com/4946/introduction-to-a-pathfinding";
    self.button3Label.textColor = [UIColor redColor];
}
- (IBAction)button4Tapped:(id)sender
{
    [self clearLabels];
    self.imageString = @"UIKitButton.png";
    self.urlString = @"http://www.raywenderlich.com/4817/how-to-integrate-cocos2d-and-uikit";
    self.button4Label.textColor = [UIColor redColor];
}

- (IBAction)tweetTapped:(id)sender
{
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet =
        [[TWTweetComposeViewController alloc] init];
        [tweetSheet setInitialText: @"Tweeting from iOS 5 By Tutorials! :)"];
        
        if (self.imageString)
        {
            [tweetSheet addImage:[UIImage imageNamed:self.imageString]];
        }
        if (self.urlString)
        {
            [tweetSheet addURL:[NSURL URLWithString:self.urlString]];
        }
        
        [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark - Private Methods

- (void)clearLabels
{
    self.button1Label.textColor = [UIColor whiteColor];
    self.button2Label.textColor = [UIColor whiteColor];
    self.button3Label.textColor = [UIColor whiteColor];
    self.button4Label.textColor = [UIColor whiteColor];
}

@end
