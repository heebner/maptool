//
//  ClickableImageView.h
//  Visualizer
//
//  Created by Ben Heebner on 11/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * The Clickable image view is a subclass of NSImageView that responds to mouse events on an image.  In order
 * to be notified of mouse events set the "delegate" member on this instance to the object that will handle
 * the mouse events
 */
@interface ClickableImageView : NSImageView 
{
	IBOutlet id delegate; /**< The delegate that will handle the mouse events */
}
 /**
  * Gets and Sets the delegate for this instance of the ClickableImageView
  */
@property (readwrite, retain)id delegate;

@end
