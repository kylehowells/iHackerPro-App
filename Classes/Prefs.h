//
//  Prefs.h
//  iHackerPro
//
//  Created by H4CK3R on 15/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://mugunthkumar.com
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>

@interface Prefs : NSObject {
	NSUserDefaults *defaults;

	int _fileUploadHistory;
}

@property (assign) BOOL iconsOn;
@property (assign) BOOL historyOn;

@property (assign) int fileUploadHistory;

+ (Prefs*) sharedInstance;
-(void)resetDefaults;

-(UIImage *)imageForNumber:(int)i;
-(NSString *)URLForNumber:(int)i;

-(void)saveImageData:(NSData*)image withURL:(NSString*)name;

-(void)setIconNumbers:(int)l;

@end
