//
//  FacebookFeedViewController.m
//  iSocial
//
//  Created by Felipe on 9/3/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "FacebookFeedViewController.h"
#import "AppDelegate.h"
#import "CommentViewController.h"
#import "FacebookCell.h"
#import "MessageCell.h"
#import "PhotoCell.h"
#import "WebViewController.h"

// foo
@interface FacebookFeedViewController ()
@property (strong, atomic) NSArray *feedArray;
@property (strong, atomic) NSMutableDictionary *imagesDictionary;
@end

@implementation FacebookFeedViewController

- (NSString *)feedString
{
    return @"https://graph.facebook.com/me/home";
}

- (NSString *)titleString
{
    return @"Feed";
}

- (void)didReceiveMemoryWarning
{
    if ([self.view window] == nil)
    {
        _feedArray = nil;
        _imagesDictionary = nil;
    }
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl =
    [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(refreshFacebookFeed)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.title = [self titleString];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshFacebookFeed)
                                                 name:AccountFacebookAccountAccessGranted object:nil];
    
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.facebookAccount)
    {
        [self refreshFacebookFeed];
    }
    else
    {
        AppDelegate *appDelegate =
        [[UIApplication sharedApplication] delegate];
        [appDelegate getFacebookAccount];
    }
}
- (void)refreshFacebookFeed
{
    // 1
    SLRequest *request = [SLRequest
                          requestForServiceType:SLServiceTypeFacebook
                          requestMethod:SLRequestMethodGET
                          URL:[NSURL URLWithString:[self feedString]]
                          parameters:@{ @"limit" : @"30" }];
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    request.account = appDelegate.facebookAccount;
    
    // 2
    [request performRequestWithHandler:^(NSData *responseData,
                                         NSHTTPURLResponse *urlResponse, NSError *error) {
        [self.refreshControl endRefreshing];
        
        if (error)
        {
            // 3
            AppDelegate *appDelegate = (AppDelegate *)
            [[UIApplication sharedApplication] delegate];
            
            [appDelegate presentErrorWithMessage:
             [NSString stringWithFormat:
              @"There was an error reading your Facebook feed. %@",
              [error localizedDescription]]];
        }
        else
        {
            // 4
            NSError *jsonError;
            NSDictionary *responseJSON = [NSJSONSerialization
                                          JSONObjectWithData:responseData
                                          options:NSJSONReadingAllowFragments
                                          error:&jsonError];
            
            if (jsonError)
            {
                // 5
                AppDelegate *appDelegate = (AppDelegate *)
                [[UIApplication sharedApplication] delegate];
                
                [appDelegate presentErrorWithMessage:
                 [NSString stringWithFormat:
                  @"There was an error reading your Facebook feed. %@",
                  [error localizedDescription]]];
            }
            else
            {
                // 6
                NSMutableArray *cleanFeedArray =
                [NSMutableArray array];
                
                for (NSDictionary *item in responseJSON[@"data"])
                {
                    if ([item[@"type"] isEqualToString:@"status"] ||
                        [item[@"type"] isEqualToString:@"link"] ||
                        [item[@"type"] isEqualToString:@"photo"] ||
                        [item[@"type"] isEqualToString:@"video"])
                    {
                        if ([item[@"type"] isEqualToString:@"status"])
                        {
                            if (!item[@"message"])
                            {
                                continue;
                            }
                        }
                        
                        [cleanFeedArray addObject:item];
                    }
                }
                
                // 7
                self.feedArray =
                [NSArray arrayWithArray:cleanFeedArray];
                self.imagesDictionary =
                [NSMutableDictionary dictionary];
                
                // 8
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForCellAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.feedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1
    FacebookCell *cell;
    cell.userImageView.image = nil;
    
    // 2
    NSDictionary *currentItem = [self.feedArray
                                 objectAtIndex:indexPath.row];
    NSDictionary *currentUser = currentItem[@"from"];
    NSString *currentUserID = currentUser[@"id"];
    
    // 3
    if ([currentItem[@"type"] isEqualToString:@"status"])
    {
        // 1
        MessageCell *messageCell = [tableView
                                    dequeueReusableCellWithIdentifier:@"MessageCell"];
        
        messageCell.usernameLabel.text =
        currentItem[@"from"][@"name"];
        messageCell.messageLabel.text = currentItem[@"message"];
        
        // 2
        CGFloat messageLabelHeight = [self
                                      heightForString:currentItem[@"message"]
                                      withFont:[UIFont systemFontOfSize:15.0f]
                                      constrainedtoSize:CGSizeMake(670, 500)];
        
        messageCell.messageLabel.frame =
        CGRectMake(messageCell.messageLabel.frame.origin.x,
                   messageCell.messageLabel.frame.origin.y,
                   670, messageLabelHeight);
        
        // 3
        NSArray *toArray = currentItem[@"to"][@"data"];
        
        if (toArray.count > 0)
        {
            messageCell.toLabel.hidden = NO;
            messageCell.toLabel.text =
            [self toLabelStringFromArray:toArray];
            messageCell.toLabel.frame =
            CGRectMake(messageCell.toLabel.frame.origin.x,
                       messageCell.messageLabel.frame.origin.y +
                       messageCell.messageLabel.frame.size.height + 5,
                       messageCell.toLabel.frame.size.width,
                       [self heightForString:messageCell.toLabel.text
                                    withFont:[UIFont systemFontOfSize:15.0f]
                           constrainedtoSize:CGSizeMake(670, 500)]);
        }
        else
        {
            messageCell.toLabel.hidden = YES;
        }
        
        // 4
        int commentCount =
        ((NSArray *)currentItem[@"comments"][@"data"]).count;
        
        if (commentCount > 0)
        {
            messageCell.accessoryType =
            UITableViewCellAccessoryDisclosureIndicator;
            messageCell.selectionStyle =
            UITableViewCellSelectionStyleBlue;
            messageCell.userInteractionEnabled = YES;
        }
        else
        {
            messageCell.accessoryType =
            UITableViewCellAccessoryNone;
            messageCell.selectionStyle =
            UITableViewCellSelectionStyleNone;
            messageCell.userInteractionEnabled = NO;
        }
        
        // 5
        cell = messageCell;

    }
    // 4
    else if ([currentItem[@"type"] isEqualToString:@"link"])
    {
        MessageCell *messageCell = [tableView
                                    dequeueReusableCellWithIdentifier:@"MessageCell"];
        
        messageCell.usernameLabel.text =
        currentItem[@"from"][@"name"];
        messageCell.messageLabel.text = currentItem[@"name"];
        
        CGFloat descriptionLabelHeight = [self
                                          heightForString:currentItem[@"name"]
                                          withFont:[UIFont systemFontOfSize:15.0f]
                                          constrainedtoSize:CGSizeMake(670, 500)];
        
        messageCell.messageLabel.frame =
        CGRectMake(messageCell.messageLabel.frame.origin.x,
                   messageCell.messageLabel.frame.origin.y,
                   670, descriptionLabelHeight);
        
        if (currentItem[@"message"])
        {
            messageCell.toLabel.hidden = NO;
            messageCell.toLabel.text = currentItem[@"message"];
            messageCell.toLabel.frame =
            CGRectMake(messageCell.toLabel.frame.origin.x,
                       messageCell.messageLabel.frame.origin.y +
                       messageCell.messageLabel.frame.size.height + 5,
                       messageCell.toLabel.frame.size.width,
                       [self heightForString:messageCell.toLabel.text
                                    withFont:[UIFont italicSystemFontOfSize:15.0f]
                           constrainedtoSize:CGSizeMake(670, 500)]);
        }
        else
        {
            messageCell.toLabel.hidden = YES;
        }
        
        messageCell.accessoryType =
        UITableViewCellAccessoryDisclosureIndicator;
        messageCell.selectionStyle =          
        UITableViewCellSelectionStyleBlue;
        messageCell.userInteractionEnabled = YES;
        
        cell = messageCell;

    }
    // 5
    else if ([currentItem[@"type"] isEqualToString:@"photo"] ||
             [currentItem[@"type"] isEqualToString:@"video"])
    {
        PhotoCell *photoCell = [tableView
                                dequeueReusableCellWithIdentifier:@"PhotoCell"];
        
        photoCell.usernameLabel.text =
        currentItem[@"from"][@"name"];
        photoCell.messageLabel.text = currentItem[@"name"];
        
        CGFloat descriptionLabelHeight =
        [self heightForString:currentItem[@"name"]
                     withFont:[UIFont systemFontOfSize:15.0f]
            constrainedtoSize:CGSizeMake(597, 500)];
        
        photoCell.messageLabel.frame =
        CGRectMake(photoCell.messageLabel.frame.origin.x,
                   photoCell.messageLabel.frame.origin.y,
                   597, descriptionLabelHeight);
        
        photoCell.accessoryType =
        UITableViewCellAccessoryDisclosureIndicator;
        photoCell.selectionStyle =
        UITableViewCellSelectionStyleBlue;
        photoCell.userInteractionEnabled = YES;
        
        dispatch_async(dispatch_get_global_queue(
                                                 DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *pictureURL = currentItem[@"picture"];
            
            NSURL *imageURL = [NSURL URLWithString:pictureURL];
            
            __block NSData *imageData;
            
            dispatch_sync(dispatch_get_global_queue(
                                                    DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                imageData =
                [NSData dataWithContentsOfURL:imageURL];
                
                UIImage *pictureImage =
                [UIImage imageWithData:imageData];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    photoCell.pictureImageView.image =
                    pictureImage;
                });
            });
        });
        
        cell = photoCell;

    }
    
    // 6
    if (self.imagesDictionary[currentUserID])
    {
        cell.userImageView.image =
        self.imagesDictionary[currentUserID];
    }
    else
    {
        
        // 7
        dispatch_async(dispatch_get_global_queue(
                                                 DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString *pictureURL = [NSString
                                    stringWithFormat:@"%@/%@/picture?type=small",
                                    @"https://graph.facebook.com",
                                    currentUser[@"id"]];
            
            NSURL *imageURL = [NSURL URLWithString:pictureURL];
            
            __block NSData *imageData;
            
            // 8
            dispatch_sync(dispatch_get_global_queue(
                                                    DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                imageData =
                [NSData dataWithContentsOfURL:imageURL];
                
                [self.imagesDictionary setObject:
                 [UIImage imageWithData:imageData]
                                          forKey:currentUserID];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    cell.userImageView.image = 
                    self.imagesDictionary[currentUserID];
                });
            });
        });
    }
    
    return cell;
}


- (NSString *)toLabelStringFromArray:(NSArray *)toArray
{
    NSMutableString *toString =
    [NSMutableString stringWithString:@"To: "];
    
    for (int i = 0; i < toArray.count; i++)
    {
        [toString appendString:toArray[i][@"name"]];
        
        if (i < (toArray.count - 1))
        {
            [toString appendString:@", "];
        }
    }
    
    return [NSString stringWithString:toString];
}

- (CGFloat)heightForString:(NSString *)theString withFont:(UIFont *)font constrainedtoSize:(CGSize)constrainSize
{
    CGSize stringHeight = [theString sizeWithFont:font
                                constrainedToSize:constrainSize];
    
    return stringHeight.height;
}


- (CGFloat)heightForCellAtIndex:(NSUInteger)index
{
    // 1
    NSDictionary *feedItem = self.feedArray[index];
    
    CGFloat cellHeight = 0.0;
    
    // 2
    if ([feedItem[@"type"] isEqualToString:@"status"])
    {
        cellHeight = 50;
        
        NSString *facebookText = feedItem[@"message"];
        
        CGSize messageLabelHeight = [facebookText
                                     sizeWithFont:[UIFont systemFontOfSize:15.0f]
                                     constrainedToSize:CGSizeMake(670, 500)];
        
        cellHeight += messageLabelHeight.height < 20 ? 20.0 :
        messageLabelHeight.height;
        
        NSArray *toArray = feedItem[@"to"][@"data"];
        
        if (toArray.count > 0)
        {
            NSString *toString =
            [self toLabelStringFromArray:toArray];
            
            CGSize toLabelHeight = [toString
                                    sizeWithFont:[UIFont italicSystemFontOfSize:15.0f]
                                    constrainedToSize:CGSizeMake(670, 500)];
            cellHeight += toLabelHeight.height < 20.0 ? 20.0 :
            toLabelHeight.height;
        }
    }
    // 3
    else if ([feedItem[@"type"] isEqualToString:@"link"])
    {
        cellHeight = 50;
        
        NSString *descriptionText = feedItem[@"name"];
        
        CGSize descriptionLabelHeight = [descriptionText
                                         sizeWithFont:[UIFont systemFontOfSize:15.0f]
                                         constrainedToSize:CGSizeMake(670, 500)];
        
        cellHeight += descriptionLabelHeight.height < 20 ? 20.0 :
        descriptionLabelHeight.height;
        
        if (feedItem[@"message"])
        {
            NSString *messageString = feedItem[@"message"];
            
            CGSize messageLabelHeight = [messageString
                                         sizeWithFont:[UIFont italicSystemFontOfSize:15.0f]
                                         constrainedToSize:CGSizeMake(670, 500)];
            cellHeight += messageLabelHeight.height < 20.0 ?
            20.0 : messageLabelHeight.height;
        }
    }
    // 4
    else if ([feedItem[@"type"] isEqualToString:@"photo"] ||
             [feedItem[@"type"] isEqualToString:@"video"])
    {
        cellHeight = 50;
        
        NSString *descriptionText = feedItem[@"name"];
        
        CGSize descriptionLabelHeight = [descriptionText
                                         sizeWithFont:[UIFont systemFontOfSize:15.0f]
                                         constrainedToSize:CGSizeMake(670, 500)];
        
        cellHeight += descriptionLabelHeight.height < 20 ? 20.0 : 
        descriptionLabelHeight.height;
        
        cellHeight = cellHeight < 110 ? 110 : cellHeight;
    }
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1
    NSDictionary *selectedItem = self.feedArray[indexPath.row];
    
    // 2
    if ([selectedItem[@"type"] isEqualToString:@"status"])
    {
        NSDictionary *itemComments = selectedItem[@"comments"];
        
        int commentCount =
        ((NSArray *)itemComments[@"data"]).count;
        
        if (commentCount > 0)
        {
            CommentViewController *commentViewController =
            [self.storyboard
             instantiateViewControllerWithIdentifier:
             CommentViewControllerIdentifier];
            commentViewController.commentsArray =
            itemComments[@"data"];
            [self.navigationController
             pushViewController:commentViewController
             animated:YES];
        }
    }
    // 3
    else if ([selectedItem[@"type"] isEqualToString:@"link"] ||
             [selectedItem[@"type"] isEqualToString:@"photo"] ||
             [selectedItem[@"type"] isEqualToString:@"video"])
    {
        NSString *urlString = selectedItem[@"link"];
        
        WebViewController *webViewController = [self.storyboard
                                                instantiateViewControllerWithIdentifier:
                                                WebViewControllerIdentifier];
        webViewController.initialURLString = urlString;
        
        [self presentViewController:webViewController
                           animated:YES completion:nil];
    }
    
    // 4
    [self.tableView deselectRowAtIndexPath:indexPath 
                                  animated:YES];
}


@end
