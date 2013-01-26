//
//  SavingUserPreferencesAppDelegate.m
//  SavingUserPreferences
//
//  Created by James Eberhardt on 29/11/08.
//  Copyright Echo Mobile Inc. 2008. All rights reserved.
//

#import "SavingUserPreferencesAppDelegate.h"

@implementation SavingUserPreferencesAppDelegate

@synthesize window = _window, selectedColourLabel = _selectedColourLabel;
@synthesize redButton = _redButton, blueButton = _blueButton;
@synthesize prefs = _prefs;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    self.mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50., 50., 0., 0.)];
                     
    [self.mySwitch addTarget:self action:@selector(switchSwitched:) forControlEvents:UIControlEventValueChanged];
    
    [self.window addSubview:self.mySwitch];
    
	self.prefs = [NSUserDefaults standardUserDefaults];
	// Check to see what was stored in the user prefs, and update the label with that colour.
	if ([self.prefs stringForKey:@"selectedColour"] == nil) {
        // Key does not exist, do nothing.
    } else {
		NSLog(@"The prefs is set.");
		self.selectedColourLabel.text = [self.prefs stringForKey:@"selectedColour"];
        self.mySwitch.on = [self.prefs boolForKey:@"myKey"];
	}
	
    // Override point for customization after application launch
    [self.window makeKeyAndVisible];
}

-(IBAction) selectRed:(id)sender
{
	NSLog(@"Selecting the red.");
	[self.prefs setObject:@"red" forKey:@"selectedColour"];
	[self.prefs synchronize];
	self.selectedColourLabel.text = [self.prefs stringForKey:@"selectedColour"];
}

-(IBAction) selectBlue:(id)sender
{
	NSLog(@"Selecting the blue.");
	[self.prefs setObject:@"blue" forKey:@"selectedColour"];
	[self.prefs synchronize];
	self.selectedColourLabel.text = [self.prefs stringForKey:@"selectedColour"];
}

-(IBAction) clearPrefs:(id)sender {
	// clear all of the user preferences
	[self.prefs removeObjectForKey:@"selectedColour"];
	[self.prefs synchronize];
	self.selectedColourLabel.text = @"Not Selected";
}

- (IBAction)switchChanged:(id)sender {
}

- (IBAction)switchSwitched:(UISwitch*)sender {
    //NSLog(@"%@",sender);
    UISwitch *here = (UISwitch *)sender;
    NSLog(@"test %d",here.on);
    [self.prefs setBool:here.on  forKey:@"myKey"];
    [self.prefs synchronize];
}
@end
