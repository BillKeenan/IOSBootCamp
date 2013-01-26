//
//  SavingUserPreferencesAppDelegate.h
//  SavingUserPreferences
//
//  Created by James Eberhardt on 29/11/08.
//  Copyright Echo Mobile Inc. 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavingUserPreferencesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *_window;
	UILabel *_selectedColourLabel;
	UIButton *_redButton;
	UIButton *_blueButton;
    	UISwitch *_mySwitch;
	NSUserDefaults *_prefs;

}
- (IBAction)switchSwitched:(UISwitch*)sender;

@property (nonatomic, strong) IBOutlet UISwitch *mySwitch;

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UILabel *selectedColourLabel;
@property (nonatomic, strong) IBOutlet UIButton *redButton;
@property (nonatomic, strong) IBOutlet UIButton *blueButton;
@property (nonatomic, strong) NSUserDefaults *prefs;

-(IBAction) selectRed:(id)sender;
-(IBAction) selectBlue:(id)sender;
-(IBAction) clearPrefs:(id)sender;


@end

