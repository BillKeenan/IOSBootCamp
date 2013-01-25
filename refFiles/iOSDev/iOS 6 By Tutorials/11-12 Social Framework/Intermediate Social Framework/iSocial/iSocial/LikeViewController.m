//
//  LikeViewController.m
//  iSocial
//
//  Created by Felipe on 9/3/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "LikeViewController.h"

@interface LikeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong) NSString * userID;
@property (assign) BOOL userLikesPhoto;

- (IBAction)likeTapped;

@end

@implementation LikeViewController

#pragma mark - IBActions

- (void)didReceiveMemoryWarning
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if ([self.view window] == nil)
    {
        _coverImageView = nil;
        _infoLabel = nil;
        _likeButton = nil;
    }
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *imageURL = [NSURL URLWithString:PhotoURL];
        
        __block NSData *imageData;
        
        dispatch_sync(dispatch_get_global_queue(
                                                DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.coverImageView.image =
                [UIImage imageWithData:imageData];
            });
        });
    });
    
    SLRequest *request = [SLRequest
                          requestForServiceType:SLServiceTypeFacebook
                          requestMethod:SLRequestMethodGET
                          URL:[NSURL URLWithString:@"https://graph.facebook.com/me"]
                          parameters:nil];
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    request.account = appDelegate.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error)
        {
            AppDelegate *appDelegate = (AppDelegate *)
            [[UIApplication sharedApplication] delegate];
            
            [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error getting the user's ID. %@", [error localizedDescription]]];
        }
        else
        {
            NSError *jsonError;
            NSDictionary *responseJSON = [NSJSONSerialization
                                          JSONObjectWithData:responseData
                                          options:NSJSONReadingAllowFragments
                                          error:&jsonError];
            
            if (jsonError)
            {
                AppDelegate *appDelegate = (AppDelegate *)
                [[UIApplication sharedApplication] delegate];
                
                [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There wasn an error reading the user's ID. %@", [error localizedDescription]]];
            }
            else
            {
                self.userID = responseJSON[@"id"];
            }
        }
    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePhotoStatus)
                                                 name:AccountFacebookAccountAccessGranted object:nil];
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.facebookAccount)
    {
        [self updatePhotoStatus];
    }
    else
    {
        self.likeButton.enabled = NO;
        
        AppDelegate *appDelegate =
        [[UIApplication sharedApplication] delegate];
        [appDelegate getFacebookAccount];
    }
}

- (void)updatePhotoStatus
{
    // 1
    SLRequest *request = [SLRequest
                          requestForServiceType:SLServiceTypeFacebook
                          requestMethod:SLRequestMethodGET
                          URL:[NSURL URLWithString:PhotoGraphURL]
                          parameters:nil];
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    request.account = appDelegate.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error)
        {
            // 2
            AppDelegate *appDelegate = (AppDelegate *)
            [[UIApplication sharedApplication] delegate];
            
            [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error getting the status of the photo's likes. %@", [error localizedDescription]]];
        }
        else
        {
            // 3
            NSError *jsonError;
            NSDictionary *responseJSON = [NSJSONSerialization
                                          JSONObjectWithData:responseData
                                          options:NSJSONReadingAllowFragments
                                          error:&jsonError];
            
            if (jsonError)
            {
                // 4
                AppDelegate *appDelegate = (AppDelegate *)
                [[UIApplication sharedApplication] delegate];
                
                [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error reading the photo's status. %@", [error localizedDescription]]];
            }
            else
            {
                // 5
                NSString *userID = self.userID;
                NSArray *likes = responseJSON[@"data"];
                
                for (NSDictionary *user in likes)
                {
                    if ([user[@"id"] isEqualToString:userID])
                    {
                        self.userLikesPhoto = YES;
                        
                        break;
                    }
                }
                
                // 6
                self.likeButton.enabled = YES;
                
                if (self.userLikesPhoto)
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.infoLabel.text =
                        @"You have already liked this picture";
                        [self.likeButton setTitle:
                         @"Unlike This Photo"
                                         forState:UIControlStateNormal];
                    });
                }
                else
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        self.infoLabel.text = @"You haven't liked the picture. Tap the button to like it";
                        [self.likeButton setTitle:@"Like This Photo" forState:UIControlStateNormal];
                    });
                }
            }
        }
    }];
}


- (IBAction)likeTapped
{
    self.likeButton.enabled = NO;
    
    if (self.userLikesPhoto)
    {
        SLRequest *request = [SLRequest
                              requestForServiceType:SLServiceTypeFacebook
                              requestMethod:SLRequestMethodDELETE
                              URL:[NSURL URLWithString:PhotoGraphURL]
                              parameters:nil];
        
        AppDelegate *appDelegate =
        [[UIApplication sharedApplication] delegate];
        request.account = appDelegate.facebookAccount;
        
        [request performRequestWithHandler:
         ^(NSData *responseData, NSHTTPURLResponse *urlResponse,
           NSError *error) {
             dispatch_sync(dispatch_get_main_queue(), ^{
                 self.likeButton.enabled = YES;
             });
             
             if (error)
             {
                 AppDelegate *appDelegate = (AppDelegate *)
                 [[UIApplication sharedApplication] delegate];
                 
                 [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error unliking the photo. %@", [error localizedDescription]]];
             }
             else
             {
                 NSError *jsonError;
                 id responseJSON = [NSJSONSerialization
                                    JSONObjectWithData:responseData
                                    options:NSJSONReadingAllowFragments
                                    error:&jsonError];
                 
                 if (jsonError)
                 {
                     AppDelegate *appDelegate = (AppDelegate *)
                     [[UIApplication sharedApplication] delegate];
                     
                     [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error unliking the photo. %@", [error localizedDescription]]];
                 }
                 else
                 {
                     if ([responseJSON intValue] == 1)
                     {
                         self.userLikesPhoto = NO;
                         
                         dispatch_sync(dispatch_get_main_queue(), ^{
                             self.infoLabel.text = @"You haven't liked the picture. Tap the button to like it";
                             [self.likeButton setTitle:@"Like This Photo" forState:UIControlStateNormal];
                         });
                     }
                 }
             }
         }];
    }
    else
    {
        SLRequest *request = [SLRequest
                              requestForServiceType:SLServiceTypeFacebook
                              requestMethod:SLRequestMethodPOST
                              URL:[NSURL URLWithString:PhotoGraphURL]
                              parameters:nil];
        
        AppDelegate *appDelegate =
        [[UIApplication sharedApplication] delegate];
        request.account = appDelegate.facebookAccount;
        
        [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.likeButton.enabled = YES;
            });
            
            if (error)
            {
                AppDelegate *appDelegate = (AppDelegate *)
                [[UIApplication sharedApplication] delegate];
                
                [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error liking the photo. %@", [error localizedDescription]]];
            }
            else
            {
                NSError *jsonError;
                id responseJSON = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                
                if (jsonError)
                {
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    
                    [appDelegate presentErrorWithMessage:[NSString stringWithFormat:@"There was an error liking the photo. %@", [error localizedDescription]]];
                }
                else
                {
                    if ([responseJSON intValue] == 1)
                    {
                        self.userLikesPhoto = YES;
                        
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            self.infoLabel.text = @"You have already liked this picture";
                            [self.likeButton setTitle:@"Unlike This Photo" forState:UIControlStateNormal];
                        });
                    }
                }
            }
        }];
    }
}

@end
