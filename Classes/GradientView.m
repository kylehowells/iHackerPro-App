//
//	CoolWhiteView.m
//	Pong
//
//	Created by H4CK3R on 03/02/2011.
//	Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GradientView.h"


@implementation GradientView

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		colorStart = [[UIColor alloc] initWithRed:255/255 green:255/255 blue:255/255 alpha:1.0];
		colorEnd = [[UIColor alloc] initWithRed:200/255 green:200/255 blue:255/255 alpha:1.0];
	}
	return self;
}

-(void)setGradientFrom:(UIColor*)startColor to:(UIColor*)endColor{
	[colorStart release];
	[colorEnd release];
	colorStart = nil;
	colorEnd = nil;

	colorStart = [startColor retain];
	colorEnd = [endColor retain];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	// Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorRef whiteColor = colorStart.CGColor;
	CGColorRef lightGrayColor = colorEnd.CGColor;
	CGRect paperRect = self.bounds;
	drawLinearGradient(context, paperRect, whiteColor, lightGrayColor);
}


- (void)dealloc {
	[colorStart release];
	[colorEnd release];
	[super dealloc];
}


@end
