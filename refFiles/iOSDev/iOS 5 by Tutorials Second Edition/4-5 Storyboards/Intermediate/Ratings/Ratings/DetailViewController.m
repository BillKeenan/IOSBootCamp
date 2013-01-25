//
//  DetailViewController.m
//  Ratings
//
//  Created by Matthijs Hollemans.
//  Copyright 2011-12 Razeware LLC. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DetailViewController.h"

@implementation DetailViewController
{
	UIPopoverController *_masterPopoverController;
	UIPopoverController *_menuPopoverController;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ShowPopover"])
	{
		// This is the iOS 5 solution for preventing the Menu button from
		// showing more than one popover at a time.
		if (_menuPopoverController != nil && _menuPopoverController.popoverVisible)
			[_menuPopoverController dismissPopoverAnimated:NO];

		_menuPopoverController = ((UIStoryboardPopoverSegue *)segue).popoverController;
		_menuPopoverController.delegate = self;
	}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (_menuPopoverController != nil && _menuPopoverController.popoverVisible)
	{
		[_menuPopoverController dismissPopoverAnimated:YES];
		_menuPopoverController = nil;
	}
}

/*
// This also prevents more than one instance of the popover being open at 
// a time, but it only works on iOS 6.
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
	if ([identifier isEqualToString:@"ShowPopover"] && _menuPopoverController != nil && _menuPopoverController.popoverVisible)
		return NO;
	else
		return YES;
}
*/

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)splitViewController
	willHideViewController:(UIViewController *)viewController
	withBarButtonItem:(UIBarButtonItem *)barButtonItem
	forPopoverController:(UIPopoverController *)popoverController
{
	barButtonItem.title = @"Master";
	NSMutableArray *items = [[self.toolbar items] mutableCopy];
	[items insertObject:barButtonItem atIndex:0];
	[self.toolbar setItems:items animated:YES];
	_masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController
	willShowViewController:(UIViewController *)viewController
	invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	NSMutableArray *items = [[self.toolbar items] mutableCopy];
	[items removeObject:barButtonItem];
	[self.toolbar setItems:items animated:YES];
	_masterPopoverController = nil;
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
	_menuPopoverController.delegate = nil;
	_menuPopoverController = nil;
}

@end
