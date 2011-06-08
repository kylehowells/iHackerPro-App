//
//  UIWebViewAdditions.m
//  iHackerPro
//
//  Created by H4CK3R on 13/03/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIWebViewAdditions.h"


@implementation UIWebView (UIWebViewAdditions)

- (CGSize)windowSize
{
	CGSize size;
	size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
	size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
	return size;
}

- (CGPoint)scrollOffset
{
	CGPoint pt;
	pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
	pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
	return pt;
}

@end
