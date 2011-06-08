//
//  UploaderView.h
//  iHackerPro
//
//  Created by H4CK3R on 09/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JPImagePickerController.h"
#import <UIKit/UIKit.h>


@interface UploaderView : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, JPImagePickerControllerDataSource, JPImagePickerControllerDelegate> {
	IBOutlet UIBarButtonItem *cameraButton;
	IBOutlet UIBarButtonItem *uploadButton;
	IBOutlet UIImageView *imageView;

	IBOutlet UIBarButtonItem *uploadHistoryButton;

	NSString *returnString;
}
-(void)checkHistory;

-(void)show;
-(void)hide;

-(IBAction)pick;
-(IBAction)upload;
-(IBAction)uploadHistory;
-(IBAction)close;

-(void)beginUpload;


@end
