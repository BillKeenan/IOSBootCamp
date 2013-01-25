
#import "DetailViewController.h"

@implementation DetailViewController

@synthesize navigationBar;
@synthesize textField;
@synthesize delegate;
@synthesize sectionName;
@synthesize indexInSection;
@synthesize name;
@synthesize value;

- (void)dealloc
{
	[sectionName release];
	[name release];
	[value release];
	[super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.navigationBar.topItem.title = self.name;
	self.textField.text = [self.value description];

	[self.textField becomeFirstResponder];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.navigationBar = nil;
	self.textField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (IBAction)cancel:(id)sender
{
	[self.delegate detailViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender
{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	NSNumber *newValue = [formatter numberFromString:self.textField.text];
	[formatter release];

	if (newValue != nil)
		self.value = newValue;
	else
		self.value = [NSNumber numberWithInt:0];

	[self.delegate detailViewControllerDidClose:self];
}

@end
