//
//  KHSettingsPage.m
//  iHackerPro
//
//  Created by H4CK3R on 16/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KHSettingsPage.h"
#import "Prefs.h"


@interface KHSettingsPage ()
-(void)checkButtons;
@end


@implementation KHSettingsPage

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	[backButton useWhiteStyle];
	[resetButton useRedDeleteStyle];

	[contentView setGradientFrom:[UIColor colorWithRed:210.0/225.0 green:210.0/225.0 blue:210.0/225.0 alpha:1.0] to:[UIColor colorWithRed:120.0/225.0 green:120.0/225.0 blue:120.0/225.0 alpha:1.0]];
	contentView.layer.cornerRadius = 20;
	contentView.clipsToBounds = YES;
	contentView.alpha = 0.95;

	[self checkButtons];
}
-(void)checkButtons{
	iconsOnOff.on = [Prefs sharedInstance].iconsOn;
	historyOnOff.on = [Prefs sharedInstance].historyOn;
}


-(IBAction)iconsChanged{
	[Prefs sharedInstance].iconsOn = iconsOnOff.on;
}
-(IBAction)historyChanged{
	[Prefs sharedInstance].historyOn = historyOnOff.on;
}

-(IBAction)reset{
	UIActionSheet *comfirm = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Reset" otherButtonTitles:nil];
	comfirm.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[comfirm showInView:self.view];
	[comfirm release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Reset"]) {
		[[Prefs sharedInstance] resetDefaults];
		[self checkButtons];
	}
}

-(IBAction)close{
	[self.parentViewController dismissModalViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
