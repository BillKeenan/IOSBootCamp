//
//  RootViewController.m
//  PhotoAlbum
//
//  Created by Felipe on 10/15/12.
//  Copyright (c) 2012 Felipe Laso Marsetti. All rights reserved.
//

#import "AlbumPageViewController.h"
#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize pageViewController = _pageViewController;

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // 1
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && UIInterfaceOrientationIsLandscape(orientation))
    {
        // 2
        AlbumPageViewController *currentViewController = self.pageViewController.viewControllers[0];
        NSArray *viewControllers = nil;
        
        NSUInteger indexOfCurrentViewController = currentViewController.index;
        
        // 3
        if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0)
        {
            UIViewController *nextViewController = [self pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
            viewControllers = @[currentViewController, nextViewController];
        }
        else
        {
            UIViewController *previousViewController = [self pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
            viewControllers = @[previousViewController, currentViewController];
        }
        
        // 4
        [self.pageViewController setViewControllers:viewControllers
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:NULL];
        
        return UIPageViewControllerSpineLocationMid;
    }
    
    // 5
    AlbumPageViewController *currentViewController = self.pageViewController.viewControllers[0];
    
    NSArray *viewControllers = @[currentViewController];
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:NULL];
    self.pageViewController.doubleSided = NO;
    
    return UIPageViewControllerSpineLocationMin;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    AlbumPageViewController *previousViewController = (AlbumPageViewController *)viewController;
    
    if (previousViewController.index == 0)
    {
        return nil;
    }
    
    AlbumPageViewController *albumPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPageViewController"];
    albumPageViewController.index = previousViewController.index - 1;
    
    NSRange picturesRange;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        NSUInteger startingIndex = ((albumPageViewController.index) * 4);
        
        picturesRange.location = startingIndex; picturesRange.length = 4;
        
        if ((picturesRange.location + picturesRange.length) >= self.picturesArray.count)
        {
            picturesRange.length = self.picturesArray.count - picturesRange.location - 1;
        }
    }
    else
    {
        NSUInteger startingIndex = ((albumPageViewController.index) * 2);
        
        picturesRange.location = startingIndex;
        picturesRange.length = 2;
        
        if ((picturesRange.location + picturesRange.length) >= self.picturesArray.count)
        {
            picturesRange.length = self.picturesArray.count - picturesRange.location - 1;
        }
    }
    
    albumPageViewController.picturesArray = [self.picturesArray subarrayWithRange:picturesRange];
    
    return albumPageViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    AlbumPageViewController *previousViewController = (AlbumPageViewController *)viewController;
    
    NSUInteger pagesCount;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        pagesCount = (NSUInteger)ceilf(self.picturesArray.count * 0.25);
    }
    else
    {
        pagesCount = (NSUInteger)ceilf(self.picturesArray.count * 0.5);
    }
    
    pagesCount--;
    
    if (previousViewController.index == pagesCount)
    {
        return nil;
    }
    
    AlbumPageViewController *albumPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPageViewController"];
    albumPageViewController.index = previousViewController.index + 1;
    
    NSRange picturesRange;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        NSUInteger startingIndex = ((albumPageViewController.index) * 4);
        
        picturesRange.location = startingIndex;
        picturesRange.length = 4;
        
        if ((picturesRange.location + picturesRange.length) >= self.picturesArray.count)
        {
            picturesRange.length = self.picturesArray.count - picturesRange.location - 1;
        }
    }
    else
    {
        NSUInteger startingIndex = ((albumPageViewController.index) * 2);
        picturesRange.location = startingIndex;
        picturesRange.length = 2;
        
        if ((picturesRange.location + picturesRange.length) >= self.picturesArray.count)
        {
            picturesRange.length = self.picturesArray.count - picturesRange.location - 1;
        }
    }
    
    albumPageViewController.picturesArray = [self.picturesArray subarrayWithRange:picturesRange];
    
    return albumPageViewController;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *picturesDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                                   pathForResource:@"Photos"
                                                                                   ofType:@"plist"]];
    self.picturesArray = picturesDictionary[@"PhotosArray"];
    
    NSDictionary *pageViewOptions = @{[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] : UIPageViewControllerOptionSpineLocationKey};
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:pageViewOptions];
    
    AlbumPageViewController *albumPageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumPageViewController"];
    albumPageViewController.index = 0;
    
    if (self.picturesArray.count > 0)
    {
        NSRange picturesRange;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            picturesRange.location = 0;
            
            if (self.picturesArray.count >= 4)
            {
                picturesRange.length = 4;
            }
            else
            {
                picturesRange.length = self.picturesArray.count;
            }
        }
        else
        {
            picturesRange.location = 0;
        }
    }
    
    [self.pageViewController setViewControllers:[NSArray arrayWithObject:albumPageViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    self.pageViewController.view.frame = self.view.bounds;
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    self.view.gestureRecognizers = self.pageViewController.view.gestureRecognizers;
    
    [self.pageViewController didMoveToParentViewController:self];
}

@end
