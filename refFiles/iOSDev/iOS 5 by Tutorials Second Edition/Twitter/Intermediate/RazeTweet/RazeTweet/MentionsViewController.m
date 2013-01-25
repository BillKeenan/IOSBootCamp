//
//  MentionsViewController.m
//  RazeTweet
//
//  Created by Felipe on 10/13/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "AppDelegate.h"
#import "MentionsViewController.h"
#import "TweetCell.h"
#import <Twitter/Twitter.h>

@interface MentionsViewController ()

@property (strong, nonatomic) NSArray *tweetsArray;

@end

@implementation MentionsViewController

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)getFeed
{
    // Store The url for the home timeline (we are getting the results in JSON format)
    NSURL *feedURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/mentions.json"];
    
    // Create an NSDictionary for the twitter request parameters. We specify we want to get 30 tweets though this can be changed to what you like
    NSDictionary *parameters = @{@"count" : @"30"};
    
    // Create a new TWRequest, use the GET request method, pass in our parameters and the URL
    TWRequest *twitterFeed = [[TWRequest alloc] initWithURL:feedURL
                                                 parameters:parameters
                                              requestMethod:TWRequestMethodGET];
    
    // Get the shared instance of the app delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Set the twitter request's user account to the one we downloaded inside our app delegate
    twitterFeed.account = appDelegate.userAccount;
    
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
                // If no errors were found during the JSON parsing then update our feed table
                [self updateFeed:feedData];
            }
            else
            {
                // In case we had an error parsing JSON then show the user an alert view with the error's description
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[jsonError localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
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

- (void)updateFeed:(id)feedData
{
    // We receive the NSArray of tweets and store it in our local tweets array
    self.tweetsArray = (NSArray *)feedData;
    
    // Update the number of rows in the table view
    [self.tableView numberOfRowsInSection:self.tweetsArray.count];
    
    // Reload the table view's data
    [self.tableView reloadData];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self getFeed];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a reusable cell if available or create a new one if necessary
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    // Get the dictionary for the current tweet as well as the user
    NSDictionary *currentTweet = self.tweetsArray[indexPath.row];
    NSDictionary *currentUser = currentTweet[@"user"];
    
    // Set the user name and tweet labels, use the default cell image until we load ours
    cell.usernameLabel.text = currentUser[@"name"];
    cell.tweetLabel.text = currentTweet[@"text"];
    cell.userImage.image = [UIImage imageNamed:@"ProfileImage_Default.png"];
    
    // Get an instance to the app delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *userName = cell.usernameLabel.text;
    
    // If the current user's image is inside our app delegate's profile image dictionary then get it, otherwise download the image
    if ([appDelegate.profileImages objectForKey:userName])
    {
        cell.userImage.image = appDelegate.profileImages[userName];
    }
    else
    {
        // Get a concurrent queue form the system
        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        // Perform an asynchronous operation using our concurrent queue in order to get the user's image from the web
        dispatch_async(concurrentQueue, ^{
            // Store the image link into an NSURL object
            NSURL *imageURL = [NSURL URLWithString:currentUser[@"profile_image_url"]];
            
            // create an NSData object to store our image's data
            __block NSData *imageData;
            
            // Download the image synchronously using our queue variable created earlier
            dispatch_sync(concurrentQueue, ^{
                imageData = [NSData dataWithContentsOfURL:imageURL];
                
                // After we download the image we store it in the app delegate's profile images dictionary with the username as the key
                [appDelegate.profileImages setObject:[UIImage imageWithData:imageData] forKey:userName];
            });
            
            // Update the cell's user image on the main thread, all UI operations must be performed on the main thread!!!
            dispatch_sync(dispatch_get_main_queue(), ^{
                cell.userImage.image = appDelegate.profileImages[userName];
            });
        });
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweetsArray.count;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Become the first responder so we can receive be notified when // a shake occurs.
    [self becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // Resign the first responder when we are not visible anymore.
    [self resignFirstResponder];
    
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If we've already retrieved a user account then
    // get the user's feed, otherwise just register for the
    // TwitterAccountAcquiredNotification.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.userAccount)
    {
        [self getFeed];
    }
    
    // Register ourselves to listen for the
    // TwitterAccountAcquiredNotification after the view is loaded
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getFeed)
                                                 name:@"TwitterAccountAcquiredNotification"
                                               object:nil];
}

@end