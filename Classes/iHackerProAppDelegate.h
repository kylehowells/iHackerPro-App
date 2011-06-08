//
//  iHackerProAppDelegate.h
//  iHackerPro
//
//  Created by H4CK3R on 08/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHWindow.h"

@class iHackerProViewController;

@interface iHackerProAppDelegate : NSObject <UIApplicationDelegate> {
    KHWindow *window;
    iHackerProViewController *viewController;
}

@property (nonatomic, retain) IBOutlet KHWindow *window;
@property (nonatomic, retain) IBOutlet iHackerProViewController *viewController;

@end

