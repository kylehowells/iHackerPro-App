//
//  UploaderView.m
//  iHackerPro
//
//  Created by H4CK3R on 09/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIImageResizing.h"
#import "UploaderView.h"
#import "KHStatusBar.h"
#import "Prefs.h"

@interface UploaderView()
-(void)showButtons;
-(void)hideButtons;
@end


@implementation UploaderView


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	[self checkHistory];
	uploadButton.enabled = NO;

	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == NO && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
		cameraButton.enabled = NO;
	}
}
-(void)checkHistory{
	if ([Prefs sharedInstance].fileUploadHistory >= 0) {
		uploadHistoryButton.enabled = YES;
	}
	else {
		uploadHistoryButton.enabled = NO;
	}
}


-(void)show{
	self.view.userInteractionEnabled = YES;
	self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);

	[UIView beginAnimations:@"SlideDown" context:nil];
	self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];

	[self checkHistory];
}
-(void)hide{
	self.view.userInteractionEnabled = NO;
	self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

	[UIView beginAnimations:@"SlideDown" context:nil];
	self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
	[UIView commitAnimations];
}


-(IBAction)pick{
	UIActionSheet *options = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		[options addButtonWithTitle:@"Camera"];
		options.tag = 1;
	}
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		[options addButtonWithTitle:@"Photo Library"];
	}

	[options addButtonWithTitle:@"Cancel"];
	options.cancelButtonIndex = (options.numberOfButtons-1);
	[options showInView:self.view];
	[options release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (actionSheet.numberOfButtons == 3) {
		if (buttonIndex == 0) {
			NSLog(@"Camera Selected");
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.sourceType = UIImagePickerControllerSourceTypeCamera;
			[self presentModalViewController:picker animated:YES];
			[picker release];
		}
		else if (buttonIndex == 1){
			NSLog(@"Photo Library Pressed");
			UIImagePickerController *picker = [[UIImagePickerController alloc] init];
			picker.delegate = self;
			picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[self presentModalViewController:picker animated:YES];
			[picker release];
		}
	}
	else if (actionSheet.numberOfButtons == 2) {
		if (buttonIndex == 0) {
			if (actionSheet.tag == 1) {
				NSLog(@"Camera Pressed");
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.delegate = self;
				picker.sourceType = UIImagePickerControllerSourceTypeCamera;
				[self presentModalViewController:picker animated:YES];
				[picker release];
			}
			else {
				NSLog(@"Photo Library Pressed");
				UIImagePickerController *picker = [[UIImagePickerController alloc] init];
				picker.delegate = self;
				picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
				[self presentModalViewController:picker animated:YES];
				[picker release];
			}
		}
	}
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
	imageView.image = image;
	uploadButton.enabled = YES;
	[picker.parentViewController dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[picker.parentViewController dismissModalViewControllerAnimated:YES];
}


-(IBAction)upload{
	/*NSOperationQueue *queue = [NSOperationQueue new];
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(beginUpload) object:nil];
	[queue addOperation:operation];
	[operation release];*/
	[self beginUpload];
}
-(void)beginUpload{
	//Running in the background.
	if (imageView.image == nil) {
		UIAlertView *failed = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select an image" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[failed show];
		[failed release];
		return;
	}
	else {
		[self hideButtons];
		NSData *imageData = UIImageJPEGRepresentation(imageView.image, 90);
		NSString *urlString = @"http://hacker-pro.com/upload/img/upload.php";

		NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
		[request setURL:[NSURL URLWithString:urlString]];
		[request setHTTPMethod:@"POST"];

		NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
		NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
		[request addValue:contentType forHTTPHeaderField:@"Content-Type"];

		NSMutableData *body = [NSMutableData data];
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[NSData dataWithData:imageData]];
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[request setHTTPBody:body];

		returnString = @"";
		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		[connection start];
		[connection release];
		[[KHStatusBar sharedInstance] showWithProgress:0.0f];
	}
}



//------------------------- Connection Delegate Methods --------------------------------------------------------------------

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
	float float1 = totalBytesWritten;
	float float2 = totalBytesExpectedToWrite;
	[KHStatusBar sharedInstance].uploadProgress = (float1/float2);
	NSLog(@"\n\nTotal Bytes Written: %.2f\nTotal Bytes Expected To Write: %.2f", float1, float2);

	if (float2-float1 < 0.12)
		[[KHStatusBar sharedInstance] performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	NSString *tempString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	returnString = [NSString stringWithFormat:@"%@%@", returnString, tempString];
	[tempString release];
	[returnString retain];
	NSLog(@"Delgate test return data");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	UIAlertView *failed = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error upload failed." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[failed show];
	UIImage *theImage = [UIImage imageNamed:@"Black_Alert.png"];
	theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	CGSize theSize = [failed frame].size;
	UIGraphicsBeginImageContext(theSize);
	[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];
	theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[[failed layer] setContents:(id)[theImage CGImage]];
	[failed release];

	[self showButtons];
	[[KHStatusBar sharedInstance] hide];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	if ([returnString length] > 4) {
		if ([Prefs sharedInstance].historyOn)
			[[Prefs sharedInstance] saveImageData:[imageView.image thumbnailData] withURL:returnString];
		[[UIPasteboard generalPasteboard] setString:returnString];

		UIAlertView *uploaded = [[UIAlertView alloc] initWithTitle:@"Image Uploaded" message:[NSString stringWithFormat:@"File Uploaded Successfully!\nLink has been copied to pasteboard"]  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[uploaded show];
		UIImage *theImage = [UIImage imageNamed:@"Black_Alert.png"];
		theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		CGSize theSize = [uploaded frame].size;
		UIGraphicsBeginImageContext(theSize);
		[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];
		theImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[[uploaded layer] setContents:(id)[theImage CGImage]];
		[uploaded release];

		imageView.image = nil;
		[self showButtons];
		uploadButton.enabled = NO;
	}
	else {
		UIAlertView *failed = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error failed to connect to server" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[failed show];
		UIImage *theImage = [UIImage imageNamed:@"Black_Alert.png"];
		theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
		CGSize theSize = [failed frame].size;
		UIGraphicsBeginImageContext(theSize);
		[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];
		theImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[[failed layer] setContents:(id)[theImage CGImage]];
		[failed release];

		[self showButtons];
	}
	NSLog(@"%d",[returnString retainCount]);
	/*for (int l = 0;[returnString retainCount] > 1; l++) {
		[returnString release];
		NSLog(@"returnString Released");
	}*/
	[[KHStatusBar sharedInstance] hide];
}

//------------------------- Connection Delegate Methods --------------------------------------------------------------------
////////////////////////////////////////////////////////////////////



- (NSInteger)numberOfImagesInImagePicker:(JPImagePickerController *)picker{
	return ([[Prefs sharedInstance] fileUploadHistory] + 1);
}
- (UIImage *)imagePicker:(JPImagePickerController *)picker thumbnailForImageNumber:(NSInteger)imageNumber{
	NSLog(@"%i",imageNumber);
	return [[Prefs sharedInstance] imageForNumber:imageNumber];
}
-(UIImage*)imagePicker:(JPImagePickerController *)picker imageForImageNumber:(NSInteger)imageNumber{
	return [[Prefs sharedInstance] imageForNumber:imageNumber];
}

/////////////////////////////

- (void)imagePickerDidCancel:(JPImagePickerController *)picker{
	[self dismissModalViewControllerAnimated:YES];
	NSLog(@"Canceled Upload History");
}

- (void)imagePicker:(JPImagePickerController *)picker didFinishPickingWithImageNumber:(NSInteger)imageNumber{
	[self dismissModalViewControllerAnimated:YES];
	[[UIPasteboard generalPasteboard] setString:[[Prefs sharedInstance] URLForNumber:imageNumber]];

	UIAlertView *uploaded = [[UIAlertView alloc] initWithTitle:@"URL Copied" message:[NSString stringWithFormat:@"Link for previously uploaded image copied to pasteboard."]  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[uploaded show];
	UIImage *theImage = [UIImage imageNamed:@"Black_Alert.png"];
	theImage = [theImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	CGSize theSize = [uploaded frame].size;
	UIGraphicsBeginImageContext(theSize);
	[theImage drawInRect:CGRectMake(0, 0, theSize.width, theSize.height)];
	theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	[[uploaded layer] setContents:(id)[theImage CGImage]];
	[uploaded release];
}



////////////////////////////////////////////////////////////////////
-(IBAction)uploadHistory{
	JPImagePickerController *imagePickerController = [[JPImagePickerController alloc] init];

	imagePickerController.delegate = self;
	imagePickerController.dataSource = self;
	imagePickerController.imagePickerTitle = @"Upload History";

	[self presentModalViewController:imagePickerController animated:YES];
	[imagePickerController release];
}

-(IBAction)close{
	[self hide];
}
////////////////////////////////////////////////////////////////////


-(void)hideButtons{
	cameraButton.enabled = NO;
	uploadButton.enabled = NO;
}
-(void)showButtons{
	uploadButton.enabled = YES;
	cameraButton.enabled = YES;
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
