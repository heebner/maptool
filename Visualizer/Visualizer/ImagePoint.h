/**
 *  ImagePoint.h
 *  Visualizer
 *
 *  The class plots an image at a specified latitude and longitude.  This class inherits from SinglePoint
 */

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "SinglePoint.h"


@interface ImagePoint : SinglePoint {
	CGImageRef imageToDraw; /**< The image to draw at the lat/long */
}

- (CGImageRef)nsImageToCGImageRef:(NSData*)image;
- (id)initWithData:(NSData *)image Latitude:(double)lat Longitude:(double)lon;
- (id)initWithData:(NSData *)image Latitude:(double)lat Longitude:(double)lon Elevation:(double)elev;


@end
