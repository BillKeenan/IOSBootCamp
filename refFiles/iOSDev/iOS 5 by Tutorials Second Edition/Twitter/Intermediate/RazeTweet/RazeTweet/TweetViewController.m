//
//  FirstViewController.m
//  RazeTweet
//
//  Created by Felipe on 10/13/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "AppDelegate.h" 
#import "TweetViewController.h"
#import <Twitter/Twitter.h>

@interface TweetViewController ()

@property (assign) BOOL isAttached;
@property (weak, nonatomic) IBOutlet UILabel *attachedLabel;
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

- (IBAction)attachTapped:(id)sender;
- (IBAction)tweetTapped:(id)sender;

@end

@implementation TweetViewController

- (IBAction)attachTapped
{
    // If the image is already attached then un-attach it, empty the label and change our boolean to NO, otherwise set the attached label's text and our boolean to YES.
    if (_isAttached)
    {
        self.attachedLabel.text = @"";
        
        _isAttached = NO;
    }
    else
    {
        self.attachedLabel.text = @"Attached";
        
        _isAttached = YES;
    }
}

- (void)dismissKeyboard
{
    // Dismiss the keyboard if visible when the user has tapped the view.
    if (self.statusTextField.isFirstResponder)
    {
        [self.statusTextField resignFirstResponder];
    }
}

- (IBAction)tweetTapped
{
    self.successLabel.text = @"";
    
    // Store The url for the mentions call (we are getting the results in JSON format)
    NSURL *feedURL;
    
    // If the user selected to attach the image then use the update_with_media call, otherwise use the regular update call.
    if (_isAttached)
    {
        feedURL = [NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"];
    }
    else
    {
        feedURL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
    }
    
    // Dictionary with the call's parameters
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.statusTextField.text, @"status", @"true", @"wrap_links", nil];
    
    // Create a new TWRequest, use the GET request method, pass in our parameters and the URL
    TWRequest *twitterFeed = [[TWRequest alloc] initWithURL:feedURL
                                                 parameters:parameters
                                              requestMethod:TWRequestMethodPOST];
    
    // If the user has selected to attach an image then add it to our request
    if (_isAttached)
    {
        [twitterFeed addMultiPartData:UIImagePNGRepresentation([UIImage imageNamed:@"TweetImage.png"]) withName:@"media" type:@"image/png"];
        [twitterFeed addMultiPartData:[self.statusTextField.text dataUsingEncoding:NSUTF8StringEncoding] withName:@"status" type:@"text/plain"];
    }
    
    // Get the shared instance of the app delegate
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    // Set the twitter request's user account to the one we downloaded inside our app delegate
    twitterFeed.account = appDelegate.userAccount;
    
    // Enable the network activity indicator to inform the user we're downloading tweets
    UIApplication *sharedApplication = [UIApplication sharedApplication];
    sharedApplication.networkActivityIndicatorVisible = YES;
    
    // Set our _isAttached BOOL toNO and attachedLabel to an empty string.
    _isAttached = NO;
    
    self.attachedLabel.text = @"";
    
    // Perform the twitter request
    [twitterFeed performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (!error)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.successLabel.text = @"Tweeted Successfully";
                
                self.statusTextField.text = @"";
            });
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                // In case we couldn't perform the twitter request successfully then show the user an alert view with the error's description
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize our _isAttached BOOL to NO.
    _isAttached = NO;
    
    // Create a tap gesture recognizer so he user can dismiss the keyboard by tapping anywhere in the view.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapRecognizer];
}

@end
