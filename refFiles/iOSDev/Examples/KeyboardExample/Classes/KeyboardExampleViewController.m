//
//  KeyboardExampleViewController.m
//  KeyboardExample
//
//  Created by James Eberhardt on 10-02-05.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "KeyboardExampleViewController.h"

@implementation KeyboardExampleViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	UIView *contentView = [[UIView alloc] initWithFrame:screenRect];

	testTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 350, 190, 30)];
	testTextField.borderStyle = UITextBorderStyleRoundedRect;
	testTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	testTextField.returnKeyType = UIReturnKeyNext;
	testTextField.placeholder = @"<enter text>";
	testTextField.delegate = self;
	
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[doneButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
	[doneButton setTitle:@"Done" forState:0];
	doneButton.frame = CGRectMake(250, 50, 50, 30);
	
	[contentView addSubview:doneButton];
	[contentView addSubview:testTextField];
    [contentView setBackgroundColor:[UIColor redColor]];
	
	self.view = contentView;
	
	[contentView release];
    contentView = nil;
    [contentView setBackgroundColor:[UIColor greenColor]];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(IBAction)hideKeyboard:(id)button{
	[testTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Did start editing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Did end editing: %@", textField.text);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
    NSLog(@"textFieldShouldReturn");
	return FALSE;
}


- (void)dealloc {
    [super dealloc];
}

@end
