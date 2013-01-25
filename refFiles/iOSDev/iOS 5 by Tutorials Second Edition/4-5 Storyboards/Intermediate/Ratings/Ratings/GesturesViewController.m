//
//  GesturesViewController.h
//  Ratings
//
//  Created by Matthijs Hollemans.
//  Copyright 2011-2012 Razeware LLC. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "GesturesViewController.h"
#import "RankingViewController.h"
#import "Player.h"

@interface GesturesViewController ()

@end

@implementation GesturesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		return YES;

	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"BestPlayers"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		RankingViewController *rankingViewController = [navigationController viewControllers][0];
		rankingViewController.rankedPlayers = [self playersWithRating:5];
		rankingViewController.title = @"Best Players";
		rankingViewController.requiredRating = 5;
	}
	else if ([segue.identifier isEqualToString:@"WorstPlayers"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		RankingViewController *rankingViewController = [navigationController viewControllers][0];
		rankingViewController.rankedPlayers = [self playersWithRating:1];
		rankingViewController.title = @"Worst Players";
		rankingViewController.requiredRating = 1;
	}
}

- (NSMutableArray *)playersWithRating:(int)rating
{
	NSMutableArray *rankedPlayers = [NSMutableArray arrayWithCapacity:[self.players count]];
	
	for (Player *player in self.players)
	{
		if (player.rating == rating)
			[rankedPlayers addObject:player];
	}
	
	return rankedPlayers;
}

@end
