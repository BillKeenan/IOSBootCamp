//
//  FollowUsViewController.m
//  RazeTweet
//
//  Created by Felipe on 10/13/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "AppDelegate.h"
#import "FollowUsViewController.h" 
#import <Twitter/Twitter.h>

#define kAccountToFollow @"airjordan12345"

@interface FollowUsViewController ()

@property (assign) BOOL isFollowing;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (IBAction)followTapped;

@end

@implementation FollowUsViewController

- (void)checkFollowing
{
    // Store The url for the home timeline (we are getting the results in JSON format)
    NSURL *feedURL = [NSURL URLWithString:@"http://api.twitter.com/1/friendships/exists.json"];
    
    // Get the shared instance of the app delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Create an NSDictionary for the twitter request parameters. We specify the users to check for.
    NSDictionary *parameters = @{@"screen_name_a" : appDelegate.userAccount.username,
                                 @"screen_name_b" : kAccountToFollow};
    
    // Create a new TWRequest, use the GET request method, pass in our parameters and the URL
    TWRequest *twitterFeed = [[TWRequest alloc] initWithURL:feedURL
                                                 parameters:parameters
                                              requestMethod:TWRequestMethodGET];
    
    // Set the twitter request's user account to the one we downloaded inside our app delegate
    twitterFeed.account = appDelegate.userAccount;
    
    // Enable the network activity indicator to inform the user we're downloading tweets
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    sharedApplication.networkActivityIndicatorVisible = YES;
    
    // Perform the twitter request
    [twitterFeed performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!error)
        {
            NSString *responseString = [[NSString alloc]  initWithBytes:[responseData bytes]
                                                                 length:[responseData length]
                                                               encoding:NSUTF8StringEncoding];
            
            // Set the label's text depending on whether we're already a follower or not.
            if ([responseString isEqualToString:@"true"])
            {
                self.textLabel.text = @"Unfollow Felipe On Twitter";
                
                _isFollowing = YES;
            }
            else
            {
                self.textLabel.text = @"Follow Felipe On Twitter";
                
                _isFollowing = NO;
            }
        }
        else
        {
            // In case we couldn't perform the twitter request successfuly then show the user an alert view with the error's description
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
        // Stop the network activity indicator since we're done downloading data
        sharedApplication.networkActivityIndicatorVisible = NO;
    }];
}

- (IBAction)followTapped
{
    // Store The url for the follow calls (we are getting the results in JSON format)
    NSURL *feedURL;
    
    // Use the proper URL depending on whether we're already a follower or not.
    if (_isFollowing)
    {
        feedURL = [NSURL URLWithString:@"http://api.twitter.com/1/friendships/destroy.json"];
    }
    else
    {
        feedURL = [NSURL URLWithString:@"http://api.twitter.com/1/friendships/create.json"];
    }
    
    // Get the shared instance of the app delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Create an NSDictionary for the twitter request parameters. We specify the users to check for.
    NSDictionary *parameters = @{@"follow" : @"true", @"screen_name" : kAccountToFollow};
    
    // Create a new TWRequest, use the GET request method, pass in our parameters and the URL
    TWRequest *twitterFeed = [[TWRequest alloc] initWithURL:feedURL
                                                 parameters:parameters
                                              requestMethod:TWRequestMethodPOST];
    
    // Set the twitter request's user account to the one we downloaded inside our app delegate
    twitterFeed.account = appDelegate.userAccount;
    
    // Enable the network activity indicator to inform the user we're downloading tweets
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    sharedApplication.networkActivityIndicatorVisible = YES;
    
    // Perform the twitter request
    [twitterFeed performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!error)
        {
            // Change the label and the boolean to indicate we are following or no longer following the account.
            if (!_isFollowing)
            {
                self.textLabel.text = @"Unfollow Felipe On Twitter";
                
                _isFollowing = YES;
            }
            else
            {
                self.textLabel.text = @"Follow Felipe On Twitter";
                
                _isFollowing = NO;
            }
        }
        else
        {
            // In case we couldn't perform the twitter request successfuly then show the user an alert view with the error's description
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
        // Stop the network activity indicator since we're done downloading data
        sharedApplication.networkActivityIndicatorVisible = NO;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkFollowing];
}

@end
