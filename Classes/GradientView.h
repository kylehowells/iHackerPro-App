//
//  CoolWhiteView.h
//  Pong
//
//  Created by H4CK3R on 03/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"


@interface GradientView : UIView {
	UIColor *colorStart;
	UIColor *colorEnd;
}

-(void)setGradientFrom:(UIColor*)startColor to:(UIColor*)endColor;


@end
