
#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, DetailViewControllerDelegate>
{
	// Instance variables for outlets
	UITableView *tableView;
	UISegmentedControl *segmentedControl;

	// Private instance variables
	NSDictionary *namesDictionary;
	NSMutableDictionary *valuesDictionary;
	NSArray *sortedSectionNames;

	// For the "sorted by value" screen
	BOOL sortedByName;
	NSArray *sortedNames;
	NSArray *sortedValues;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)sortChanged:(UISegmentedControl *)sender;

@end
