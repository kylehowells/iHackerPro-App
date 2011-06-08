//
//  KHSettingsPage.h
//  iHackerPro
//
//  Created by H4CK3R on 16/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatternView.h"
#import "GradientButton.h"
#import "GradientView.h"


@interface KHSettingsPage : UIViewController <UIActionSheetDelegate> {
	IBOutlet GradientView *contentView;
	IBOutlet GradientButton *backButton;
	IBOutlet UISwitch *iconsOnOff;
	IBOutlet UISwitch *historyOnOff;

	IBOutlet GradientButton *resetButton;
}

-(IBAction)iconsChanged;
-(IBAction)historyChanged;

-(IBAction)reset;
-(IBAction)close;

@end
