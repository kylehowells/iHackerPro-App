//
//  KHStatusBar.h
//  iHackerPro
//
//  Created by H4CK3R on 11/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar ( http://mugunthkumar.com )
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>

@interface KHStatusBar : UIWindow {
@private
	UILabel *_statusLabel;	// Text label to display informations
	UIActivityIndicatorView *_indicator;	// The indicator
	UIProgressView *_progressView;

	float _uploadProgress;
}

@property (nonatomic, assign) float uploadProgress;


+ (KHStatusBar*) sharedInstance;

-(void)showWithStatusMessage:(NSString*)msg;
-(void)showWithProgress:(float)t;
-(void)showIndicator;
-(void)show;
-(void)hide;


@end
