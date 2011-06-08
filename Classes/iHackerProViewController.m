//
//	iHackerProViewController.m
//	iHackerPro
//
//	Created by H4CK3R on 08/03/2011.
//	Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iHackerProViewController.h"
#import "UIWebViewAdditions.h"
#import "KHSettingsPage.h"
#import "Prefs.h"


//-------(Private Methods)-------------------------------------------------------
@interface iHackerProViewController ()
- (void)stopSelection:(NSNotification*)notification;
- (void)contextualMenuAction:(NSNotification*)notification;
- (void)openContextualMenuAt:(CGPoint)pt;

-(void)UnreadPms;
-(void)saveImageURL:(NSString*)url;
@end
//-------(Private Methods)-------------------------------------------------------


@implementation iHackerProViewController



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	uploaderView = [[UploaderView alloc] initWithNibName:@"UploaderView" bundle:nil];
	[self.view addSubview:uploaderView.view];
	uploaderView.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);

	progressHud = [[MBProgressHUD alloc] initWithView:self.view];
	progressHud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Tick.png"]] autorelease];
	progressHud.opacity = 0.8;
	[self.view addSubview:progressHud];
	[progressHud hide:NO];
	progressHud.userInteractionEnabled = NO;

	backButton.enabled = NO;
	forwardButton.enabled = NO;

	stopImage = [[UIImage imageNamed:@"icon_delete.png"] retain];
	reloadImage = [[UIImage imageNamed:@"icon_circle.png"] retain];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://hacker-pro.com/forum/index.php?theme=10"]];
    [request setValue:@"iHackerPro_App" forHTTPHeaderField:@"User-Agent"];
	[webView loadRequest:request];


	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextualMenuAction:) name:@"TapAndHoldNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSelection:) name:@"TapAndHoldShortNotification" object:nil];
}

- (void)stopSelection:(NSNotification*)notification{
	[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)contextualMenuAction:(NSNotification*)notification{
	CGPoint pt;
	NSDictionary *coord = [notification object];
	pt.x = [[coord objectForKey:@"x"] floatValue];
	pt.y = [[coord objectForKey:@"y"] floatValue];

	// convert point from window to view coordinate system
	pt = [webView convertPoint:pt fromView:nil];

	// convert point from view to HTML coordinate system
	CGPoint offset  = [webView scrollOffset];
	CGSize viewSize = [webView frame].size;
	CGSize windowSize = [webView windowSize];

	CGFloat f = windowSize.width / viewSize.width;
	pt.x = pt.x * f + offset.x;
	pt.y = pt.y * f + offset.y;

	//CGPointY = pt.y;
	//CGPointX = pt.x;

	[self openContextualMenuAt:pt];
}
- (void)openContextualMenuAt:(CGPoint)pt{
	// Load the JavaScript code from the Resources and inject it into the web page
	NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"js"];
	NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	[webView stringByEvaluatingJavaScriptFromString:jsCode];

	// get the Tags at the touch location
	NSString *tags = [webView stringByEvaluatingJavaScriptFromString:
					  [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];

	NSString *tagsHREF = [webView stringByEvaluatingJavaScriptFromString:
						  [NSString stringWithFormat:@"MyAppGetLinkHREFAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];

	NSString *tagsSRC = [webView stringByEvaluatingJavaScriptFromString:
						 [NSString stringWithFormat:@"MyAppGetLinkSRCAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];



	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

	selectedLinkURL = @"";
	selectedImageURL = @"";

	// If an image was touched, add image-related buttons.
	if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
		selectedImageURL = tagsSRC;

		if (sheet.title == nil) {
			sheet.title = tagsSRC;
		}

		[sheet addButtonWithTitle:@"Save Image"];
		[sheet addButtonWithTitle:@"Copy Image"];
	}
	// If a link is pressed add image buttons.
	if ([tags rangeOfString:@",A,"].location != NSNotFound){
		selectedLinkURL = tagsHREF;

		sheet.title = tagsHREF;
		[sheet addButtonWithTitle:@"Open"];
		[sheet addButtonWithTitle:@"Copy"];
	}

	if (sheet.numberOfButtons > 0) {
		[sheet addButtonWithTitle:@"Cancel"];
		sheet.cancelButtonIndex = (sheet.numberOfButtons-1);
		[sheet showInView:webView];
	}
	[selectedLinkURL retain];
	[selectedImageURL retain];
	[sheet release];
}



-(IBAction)homePressed{
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://hacker-pro.com/forum/index.php"]]];
}
-(IBAction)morePressed{
	UIActionSheet *options = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Settings", @"Image Uploader", nil];
	options.actionSheetStyle = UIActionSheetStyleAutomatic;
	options.cancelButtonIndex = (options.numberOfButtons-1);
	[options showFromBarButtonItem:plusButton animated:YES];
	[options release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Cancel"]) {
		NSLog(@"Cancel");
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Settings"]) {
		NSLog(@"Open Settings");
		KHSettingsPage *settingsPage = [[KHSettingsPage alloc] initWithNibName:@"KHSettingsPage" bundle:nil];
		//settingsPage.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		[self presentModalViewController:settingsPage animated:YES];
		[settingsPage release];
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Image Uploader"]){
		NSLog(@"Open Uploader");
		[uploaderView show];
	}

	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Open"]){
		[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:selectedLinkURL]]];
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Copy"]){
		[[UIPasteboard generalPasteboard] setString:selectedLinkURL];
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Copy Image"]){
		[[UIPasteboard generalPasteboard] setString:selectedImageURL];
	}
	else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save Image"]){
		NSOperationQueue *queue = [NSOperationQueue new];
		NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveImageURL:) object:selectedImageURL];
		[queue addOperation:operation];
		[operation release];
	}
}

-(IBAction)loadPressed{
	if (pageLoading) {
		[webView stopLoading];
	}
	else {
		[webView reload];
	}
}
- (BOOL)webView:(UIWebView *)sender shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([request.URL.scheme isEqualToString:@"mailto"]) {
		// make sure this device is setup to send email
		if ([MFMailComposeViewController canSendMail]) {
			// create mail composer object
			MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
			// style the mail view to match your app
			[[mailer navigationBar] setTintColor:[UIColor blackColor]];
			// make this view the delegate
			mailer.mailComposeDelegate = self;
			// set recipient
			[mailer setToRecipients:[NSArray arrayWithObject:request.URL.resourceSpecifier]];
			// generate message body
			NSString *body = @"";
			// add to users signature
			[mailer setMessageBody:body isHTML:NO];
			// present user with composer screen
			[self presentModalViewController:mailer animated:YES];
			// release composer object
			[mailer release];
		} else {
			NSLog(@"Can't Send Mail Through Mail App");
			// alert to user there is no email support
		}
		// don't load url in this webview
		return NO;
	}

	return YES;
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	[controller.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void)webViewDidStartLoad:(UIWebView *)_webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	pageLoading = YES;
	loadButton.image = stopImage;

	forwardButton.enabled = [webView canGoForward];
	backButton.enabled = [webView canGoBack];
}
-(void)webView:(UIWebView *)_webView didFailLoadWithError:(NSError *)error{
	if ([error code] != -999) {
		MBProgressHUD *failed = [[MBProgressHUD alloc] initWithView:self.view];
		failed.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Remove.png"]] autorelease];
		failed.mode = MBProgressHUDModeCustomView;
		failed.labelText = @"Error";
		failed.detailsLabelText = @"Failed to load web page";
		failed.removeFromSuperViewOnHide = YES;
		[self.view addSubview:failed];

		[failed show:YES];
		[failed performSelector:@selector(hide:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.0];
		[failed release];
	}

	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	pageLoading = NO;
	loadButton.image = reloadImage;

	forwardButton.enabled = [webView canGoForward];
	backButton.enabled = [webView canGoBack];
}
-(void)webViewDidFinishLoad:(UIWebView *)_webView{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self UnreadPms];
	pageLoading = NO;
	loadButton.image = reloadImage;

	forwardButton.enabled = [webView canGoForward];
	backButton.enabled = [webView canGoBack];
}

-(void)UnreadPms{
	NSString *pms = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('tabmessages').innerText"];
	if ([Prefs sharedInstance].iconsOn) {
		[UIApplication sharedApplication].applicationIconBadgeNumber = [pms intValue];
	}
	else {
		[[Prefs sharedInstance] setIconNumbers:[pms intValue]];
	}
}

-(void)saveImageURL:(NSString*)url{
	[self performSelectorOnMainThread:@selector(showStartSaveAlert) withObject:nil waitUntilDone:YES];
	UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]], nil, nil, nil);
	[self performSelectorOnMainThread:@selector(showFinishedSaveAlert) withObject:nil waitUntilDone:YES];
}


-(void)showStartSaveAlert{
	progressHud.mode = MBProgressHUDModeIndeterminate;
	progressHud.labelText = @"Saving Image...";
	[progressHud show:YES];
}
-(void)hideSaveAlert:(UIAlertView*)alertView{
	[alertView dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)showFinishedSaveAlert{
	// Set custom view mode
	progressHud.mode = MBProgressHUDModeCustomView;
	progressHud.labelText = @"Completed";
	[progressHud performSelector:@selector(hide:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5];
}


- (void)didReceiveMemoryWarning {
	//Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	//Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[progressHud release];
	[stopImage release];
	[reloadImage release];
	[uploaderView release];
	[super dealloc];
}

@end
