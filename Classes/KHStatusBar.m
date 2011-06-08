//
//	KHStatusBar.m
//	iHackerPro
//
//	Created by H4CK3R on 11/03/2011.
//	Copyright 2011 __MyCompanyName__. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar ( http://mugunthkumar.com )
//	Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "KHStatusBar.h"

@interface KHStatusBar ()
-(void)customInit;
@end


static KHStatusBar *_instance;
@implementation KHStatusBar

@synthesize uploadProgress;

+ (KHStatusBar*)sharedInstance{
	@synchronized(self) {
		if (_instance == nil) {
			_instance = [[super allocWithZone:NULL] init];
			[_instance customInit];
		}
	}
	return _instance;
}
-(void)customInit{
	// Place the window on the correct level & position
	self.opaque = NO;
	self.backgroundColor = [UIColor blackColor];
//	self.layer.borderColor = [UIColor grayColor];
//	self.layer.borderWidth = 1;
	self.windowLevel = UIWindowLevelStatusBar + 1.0f;
	self.frame = [UIApplication sharedApplication].statusBarFrame;
	// Create an image view with an image to make it look like the standard grey status bar
	//UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:_instance.frame];
	//backgroundImageView.image = [[UIImage imageNamed:@"statusbar_background.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
	//[_instance addSubview:backgroundImageView];
	//[backgroundImageView release];

	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	_indicator.frame = (CGRect){.origin.x = 5.0f, .origin.y = 3.0f, .size.width = self.frame.size.height - 6, .size.height = self.frame.size.height - 6};
	_indicator.hidesWhenStopped = YES;
	[self addSubview:_indicator];

	_statusLabel = [[UILabel alloc] initWithFrame:(CGRect){.origin.x = self.frame.size.height, .origin.y = 0.0f, .size.width = 200.0f, .size.height = self.frame.size.height}];
	_statusLabel.backgroundColor = [UIColor clearColor];
	_statusLabel.textColor = [UIColor whiteColor];
	_statusLabel.font = [UIFont boldSystemFontOfSize:10.0f];
	[self addSubview:_statusLabel];

	_progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	_progressView.frame = CGRectMake(0, 0,[UIApplication sharedApplication].statusBarFrame.size.width*0.75, [UIApplication sharedApplication].statusBarFrame.size.height*0.75);
	_progressView.center = CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.6);
	_progressView.progress = 0.0f;
	[self addSubview:_progressView];

	_indicator.center = CGPointMake((_progressView.frame.origin.x)*0.5, (self.frame.size.height)*0.5);

	UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
	bottomBar.backgroundColor = [UIColor grayColor];
	[self addSubview:bottomBar];
	[bottomBar release];

	self.userInteractionEnabled = NO;
}


-(void)showWithStatusMessage:(NSString*)msg {
	if (!msg) return;
	_statusLabel.text = msg;
	[_indicator startAnimating];
	self.hidden = NO;
}
-(void)showWithProgress:(float)t{
	_progressView.progress = t;
	self.hidden = NO;
}
-(void)showIndicator{
	if (![_indicator isAnimating]){
		[_indicator startAnimating];
	}
}

-(void)show {
	_statusLabel.hidden = NO;
	[_indicator startAnimating];
	self.hidden = NO;
}

-(void)hide {
	_statusLabel.hidden = YES;
	[_indicator stopAnimating];
	self.hidden = YES;
}


-(void)setUploadProgress:(float)l{
	_progressView.progress = l;
}
-(float)uploadProgress{
	return _uploadProgress;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{
	return [[self sharedInstance]retain];	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{
	return self;	
}

- (unsigned)retainCount
{
	return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
	//do nothing
}

- (id)autorelease
{
	return self;	
}

@end
