//
//  SecondViewController.m
//  RazeTweet
//
//  Created by Felipe on 10/13/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import <Twitter/Twitter.h>

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

@end

@implementation ProfileViewController

- (void)loadProfile
{
    // Store The url for the profile call (we are getting the results in JSON format)
    NSURL *feedURL = [NSURL URLWithString:@"http://api.twitter.com/1/users/show.json"];
    
    // Get the shared instance of the app delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Set the username label to the user's screen name
    self.usernameLabel.text = appDelegate.userAccount.username;
    
    // Create an NSDictionary for the twitter request parameters. We specify we want to get 30 tweets though this can be changed to what you like
    NSDictionary *parameters = @{@"screen_name" : appDelegate.userAccount.username};
    
    // Create a new TWRequest, use the GET request method, pass in our parameters and the URL
    TWRequest *twitterFeed = [[TWRequest alloc] initWithURL:feedURL
                                                 parameters:parameters
                                              requestMethod:TWRequestMethodGET];
    
    // Set the twitter request's user account to the one we downloaded inside our app delegate
    //twitterFeed.account = appDelegate.userAccount;
    
    // Enable the network activity indicator to inform the user we're downloading tweets
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    sharedApplication.networkActivityIndicatorVisible = YES;
    
    // Perform the twitter request
    [twitterFeed performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!error)
        {
            // If no errors were found then parse the JSON into a foundation object
            NSError *jsonError = nil;
            
            id feedData = [NSJSONSerialization JSONObjectWithData:responseData
                                                          options:0
                                                            error:&jsonError];
            
            if (!jsonError)
            {
                NSDictionary *profileDictionary = (NSDictionary *)feedData;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.descriptionLabel.text = profileDictionary[@"description"];
                    self.favoritesLabel.text = [profileDictionary [@"favourites_count"] stringValue];
                    self.followersLabel.text = [profileDictionary[@"followers_count"] stringValue];
                    self.followingLabel.text = [profileDictionary[@"friends_count"] stringValue];
                    self.tweetsLabel.text = [profileDictionary[@"statuses_count"] stringValue];
                });
            }
            else
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    // In case we had an error parsing JSON then show the user an alert view with the error's description
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[jsonError localizedDescription]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                });
            }
        }
        else
        {
           dispatch_sync(dispatch_get_main_queue(), ^{
               // In case we couldn't perform the twitter request successfuly then show the user an alert view with the error's description
               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                   message:[error localizedDescription]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
               [alertView show];
           });
        }
        
        // Stop the network activity indicator since we're done downloading data
        sharedApplication.networkActivityIndicatorVisible = NO;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadProfile];
}

@end
