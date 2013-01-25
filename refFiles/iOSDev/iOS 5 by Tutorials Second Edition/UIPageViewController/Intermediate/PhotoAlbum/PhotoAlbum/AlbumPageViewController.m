//
//  AlbumPageViewController.m
//  PhotoAlbum
//
//  Created by Felipe on 10/15/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "AlbumPageViewController.h"

@interface AlbumPageViewController()

@property (nonatomic, strong) NSMutableArray *pictureViews;

@end

@implementation AlbumPageViewController

@synthesize index = _index;

- (void)setPictureAtIndex:(NSUInteger)index inFrame:(CGRect)frameForPicture
{
    UIImageView *picture = self.pictureViews[index];
    
    CGFloat scale;
    
    if (picture.image.size.width > picture.image.size.height)
    {
        scale = picture.image.size.height / picture.image.size.width;
        
        picture.frame = CGRectMake(0, 0, (frameForPicture.size.width * 0.80), (frameForPicture.size.width * 0.80) * scale);
        picture.center = CGPointMake(frameForPicture.origin.x + (frameForPicture.size.width * 0.5), frameForPicture.origin.y + (frameForPicture.size.height * 0.5));
    }
    else
    {
        scale = picture.image.size.width / picture.image.size.height;
        
        picture.frame = CGRectMake(0, 0, (frameForPicture.size.height * 0.80) * scale, (frameForPicture.size.height * 0.80));
        picture.center = CGPointMake(frameForPicture.origin.x + (frameForPicture.size.width * 0.5), frameForPicture.origin.y + (frameForPicture.size.height * 0.5));
    }
    
    [self.view addSubview:picture];
}

- (void)layoutPicturesAnimated:(BOOL)animated withDuration:(NSTimeInterval)duration forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (animated)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationDelay:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    }
    
    CGRect orientationFrame;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
            orientationFrame = CGRectMake(0, 0, 768, 1024);
        }
        else
        {
            orientationFrame = CGRectMake(0, 0, 512, 768);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        {
            orientationFrame = CGRectMake(0, 0, 320, 480);
        }
        else
        {
            orientationFrame = CGRectMake(0, 0, 480, 320);
        }
    }
    
    if (self.picturesArray.count > 0)
    {
        if (self.picturesArray.count == 1)
        {
            [self setPictureAtIndex:0 inFrame:orientationFrame];
        }
        else if (self.picturesArray.count == 2)
        {
            CGRect frameOne;
            CGRect frameTwo;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && UIInterfaceOrientationIsLandscape(interfaceOrientation))
            {
                frameOne = CGRectMake(0, 0, orientationFrame.size.width * 0.5, orientationFrame.size.height);
                frameTwo = CGRectMake(orientationFrame.size.width * 0.5, 0, orientationFrame.size.width * 0.5, orientationFrame.size.height);
                
                [self setPictureAtIndex:0 inFrame:frameOne];
                [self setPictureAtIndex:1 inFrame:frameTwo];
            }
            else
            {
                frameOne = CGRectMake(0, 0, orientationFrame.size.width, orientationFrame.size.height * 0.5);
                frameTwo = CGRectMake(0, orientationFrame.size.height * 0.5, orientationFrame.size.width, orientationFrame.size.height * 0.5);
                
                [self setPictureAtIndex:0 inFrame:frameOne];
                [self setPictureAtIndex:1 inFrame:frameTwo];
            }
        }
        else
        {
            CGRect frameOne;
            CGRect frameTwo;
            CGRect frameThree;
            CGRect frameFour;
            
            frameOne = CGRectMake(0, 0, orientationFrame.size.width * 0.5, orientationFrame.size.height * 0.5);
            frameTwo = CGRectMake(orientationFrame.size.width * 0.5, 0, orientationFrame.size.width * 0.5, orientationFrame.size.height * 0.5);
            frameThree = CGRectMake(0, orientationFrame.size.height * 0.5, orientationFrame.size.width * 0.5, orientationFrame.size.height * 0.5);
            frameFour = CGRectMake(orientationFrame.size.width * 0.5, orientationFrame.size.height * 0.5, orientationFrame.size.width * 0.5, orientationFrame.size.height * 0.5);
            
            [self setPictureAtIndex:0 inFrame:frameOne];
            [self setPictureAtIndex:1 inFrame:frameTwo];
            [self setPictureAtIndex:2 inFrame:frameThree];
            
            if (self.picturesArray.count == 4)
            {
                [self setPictureAtIndex:3 inFrame:frameFour];
            }
        }
    }
    
    if (animated)
    {
        [UIView commitAnimations];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (NSString *pictureName in self.picturesArray)
    {
        if (!self.pictureViews)
        {
            self.pictureViews = [NSMutableArray array];
        }
        
        UIImageView *picture = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pictureName]];
        [self.pictureViews addObject:picture];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self layoutPicturesAnimated:NO withDuration:0 forInterfaceOrientation:self.interfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutPicturesAnimated:YES withDuration:duration forInterfaceOrientation:toInterfaceOrientation];
}

@end
