//
//  ClickableImageView.m
//  Visualizer
//
//  Created by Ben Heebner on 11/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ClickableImageView.h"


@implementation ClickableImageView

@synthesize delegate;

/**
 * Invoked when the user mouses down on the image.  This method determines if the delegate of this instance
 * has a mouseDown:sender: method.  If it does, it will be called.
 * @param event The event details
 */
- (void) mouseDown:(NSEvent *)event
{
	if([delegate respondsToSelector:@selector(mouseDown:sender:)] == YES) {
		[delegate mouseDown:event sender:self];
	}
}

/**
 * Invoked when the user mouses up on the image.  This method determines if the delegate of this instance
 * has a mouseUp:sender: method.  If it does, it will be called.
 * @param event The event details
 */
- (void)mouseUp:(NSEvent *)event
{
	if([delegate respondsToSelector:@selector(mouseUp:sender:)] == YES) {
		[delegate mouseUp:event sender:self];
	}
}

@end
