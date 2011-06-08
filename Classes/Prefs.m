//
//  Prefs.m
//  iHackerPro
//
//  Created by H4CK3R on 15/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (| http://mugunthkumar.com |)
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import "JPImagePickerController.h"
#import "UIImageResizing.h"
#import "Prefs.h"

#define iHP_PRE_RUN @"PreRun"
#define iHP_UPLOAD_HISTORY @"Upload_History"
#define iHP_ICON_NUMBERS @"icon_numbers"
#define iHP_ICONS_ON @"icons_on"
#define iHP_HISTORY_ON @"history_on"


@interface Prefs()
-(void)checkDefaults;

-(NSString *)documentsDirectory;
@end


static Prefs *_instance;
@implementation Prefs

@synthesize fileUploadHistory = _fileUploadHistory, iconsOn, historyOn;

+ (Prefs*)sharedInstance
{
	@synchronized(self) {
		if (_instance == nil) {
			_instance = [[super allocWithZone:NULL] init];
			[_instance checkDefaults];
			// Allocate/initialize any member variables of the singleton class her
			// example
			//_instance.member = @"";
		}
	}
	return _instance;
}
-(void)resetDefaults{
	NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"iHackerPro/UploadHistory/"];
	NSError *error = nil;

	for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error]) {
		[[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:&error];
	}

	[defaults setBool:YES forKey:iHP_PRE_RUN];
	[defaults setBool:YES forKey:iHP_ICONS_ON];
	[defaults setInteger:0 forKey:iHP_ICON_NUMBERS];
	[defaults setBool:YES forKey:iHP_HISTORY_ON];
	[defaults setInteger:-1 forKey:iHP_UPLOAD_HISTORY];
	[defaults synchronize];
}


-(UIImage *)imageForNumber:(int)i{
	NSString *imagePath = [[[self documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"iHackerPro/UploadHistory/"]] stringByAppendingFormat:@"/%d", i];
	NSLog(@"%@", imagePath);
	return [UIImage imageWithContentsOfFile:imagePath];
}
-(NSString *)URLForNumber:(int)i{
	NSString *imagePath = [[[self documentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"iHackerPro/UploadHistory/"]] stringByAppendingFormat:@"/%d-URL", i];

	return [NSString stringWithContentsOfFile:imagePath encoding:NSASCIIStringEncoding error:nil];
}



-(void)checkDefaults{
	static BOOL preRun = NO;
	if (!preRun) {
		defaults = [NSUserDefaults standardUserDefaults];
		if (![defaults boolForKey:iHP_PRE_RUN]) {
			NSLog(@"Defaults being set");

			[defaults setBool:YES forKey:iHP_ICONS_ON];
			[defaults setInteger:0 forKey:iHP_ICON_NUMBERS];
			[defaults setBool:YES forKey:iHP_HISTORY_ON];

			[defaults setInteger:-1 forKey:iHP_UPLOAD_HISTORY];
			[defaults synchronize];

			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"iHackerPro/UploadHistory"];

			if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
				[[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:nil];
		}
		self.fileUploadHistory = [defaults integerForKey:iHP_UPLOAD_HISTORY];
		NSLog(@"Check Defaults called: %d",self.fileUploadHistory);
		preRun = YES;
	}
}
-(NSString *)documentsDirectory{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	return documentsDirectory;
}

-(void)saveImageData:(NSData*)image withURL:(NSString*)name{
	if (image != nil){
		self.fileUploadHistory = (self.fileUploadHistory+1);

		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"iHackerPro/UploadHistory/%d", self.fileUploadHistory]];
		[image writeToFile:path atomically:YES];

		NSData *data = [name dataUsingEncoding:NSASCIIStringEncoding];
		[data writeToFile:[path stringByAppendingString:@"-URL"] atomically:YES];
	}
}


-(void)setIconNumbers:(int)l{
	[defaults setInteger:l forKey:iHP_ICON_NUMBERS];
}

-(void)setIconsOn:(BOOL)onOff{
	if (onOff != self.iconsOn) {
		[defaults setBool:onOff forKey:iHP_ICONS_ON];
		if (!onOff) {
			[defaults setInteger:[[UIApplication sharedApplication] applicationIconBadgeNumber] forKey:iHP_ICON_NUMBERS];
			[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
		}
		else {
			[UIApplication sharedApplication].applicationIconBadgeNumber = [defaults integerForKey:iHP_ICON_NUMBERS];
		}

		[defaults synchronize];
	}
}
-(BOOL)iconsOn{
	return [defaults boolForKey:iHP_ICONS_ON];
}

-(void)setHistoryOn:(BOOL)onOff{
	[defaults setBool:onOff forKey:iHP_HISTORY_ON];
	[defaults synchronize];
}
-(BOOL)historyOn{
	return [defaults boolForKey:iHP_HISTORY_ON];
}


// self.fileUploadHistory setter method
-(void)setFileUploadHistory:(int)l{
	_fileUploadHistory = l;
	[defaults setInteger:_fileUploadHistory forKey:iHP_UPLOAD_HISTORY];
	[defaults synchronize];
}
// self.fileUploadHistory getter method
-(int)fileUploadHistory{
	return _fileUploadHistory;
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
