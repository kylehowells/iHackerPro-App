//
//  iHackerProViewController.h
//  iHackerPro
//
//  Created by H4CK3R on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <UIKit/UIKit.h>
#import "UploaderView.h"
#import "MBProgressHUD.h"


@interface iHackerProViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate> {
	UploaderView *uploaderView;
	MBProgressHUD *progressHud;

	IBOutlet UIWebView *webView;
	IBOutlet UIBarButtonItem *plusButton;
	IBOutlet UIBarButtonItem *loadButton;
	IBOutlet UIBarButtonItem *backButton;
	IBOutlet UIBarButtonItem *forwardButton;

	NSURLRequest *lastRequest;

	UIImage *stopImage;
	UIImage *reloadImage;

	NSString *selectedImageURL;
	NSString *selectedLinkURL;

	BOOL pageLoading;
}

-(IBAction)loadPressed;

-(IBAction)homePressed;
-(IBAction)morePressed;


@end
