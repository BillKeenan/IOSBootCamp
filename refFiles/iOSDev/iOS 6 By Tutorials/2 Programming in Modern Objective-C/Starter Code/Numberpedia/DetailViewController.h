
#import <UIKit/UIKit.h>

@class DetailViewController;

@protocol DetailViewControllerDelegate <NSObject>

- (void)detailViewControllerDidCancel:(DetailViewController *)controller;
- (void)detailViewControllerDidClose:(DetailViewController *)controller;

@end

@interface DetailViewController : UIViewController
{
	UINavigationBar *navigationBar;
	UITextField *textField;

	id <DetailViewControllerDelegate> delegate;

	NSString *sectionName;
	NSUInteger indexInSection;
	NSString *name;
	NSNumber *value;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UITextField *textField;

@property (nonatomic, assign) id <DetailViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *sectionName;
@property (nonatomic, assign) NSUInteger indexInSection;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *value;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
