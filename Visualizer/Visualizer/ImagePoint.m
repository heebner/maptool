//
//  ImagePoint.m
//  Visualizer
//
//  Created by Ben Heebner on 10/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ImagePoint.h"


@implementation ImagePoint

/**
 * Initializer for the ImagePoint class that takes in an image, latitude, and longitude
 * @param image Image to display when this point is visible
 * @param lat Latitude to plot the image at
 * @param lon Longitude to plot the image at
 */
- (id)initWithData:(NSData *)imageData Latitude:(double)lat Longitude:(double)lon
{
	if(self = [super initWithLatLong:lat Longitude:lon])
	{
        imageToDraw = [self nsImageToCGImageRef:imageData];
        CGImageRetain(imageToDraw);
	}
	
	return self;
}

/**
 * Initializer for the ImagePoint class that takes in an image, latitude, and longitude
 * @param image Image to display when this point is visible
 * @param lat Latitude to plot the image at
 * @param lon Longitude to plot the image at
 * @param elev Elevation to plot the image at
 */
- (id)initWithData:(NSData *)imageData Latitude:(double)lat Longitude:(double)lon Elevation:(double)elev
{
	if(self = [self initWithData:imageData Latitude:lat Longitude:lon])
	{
		elevation = elev;
	}
	
	return self;
}

/**
 * Converts an input image to a CGImageRef struct
 * @param image Instance of the NSImage to convert
 * @return A CGImageRef to that is the input NSImage
 */
- (CGImageRef)nsImageToCGImageRef:(NSData*)image
{
    //NSData * imageData = [image TIFFRepresentation];
    CGImageRef imageRef = nil;
    if(image) {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)image,  NULL);
        imageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
        [(id)imageRef autorelease];
        CFRelease(imageSource);
    }

    return imageRef;
}

/**
 * Draws a point at the lat/long for this instance on the input layer and context
 * @param layer The layer to draw the point onto
 * @param ctx The context in which to draw the layer
 * @param mapBounds The current bounds of the map on the display
 */
- (void)drawPoint:(CALayer *)layer inContext:(CGContextRef)ctx withMapBounds:(MapBounds *)mapBounds
{
	double convertedLatitude = [mapBounds convertLatitudeToPoint:latitude];
	double convertedLongitude = [mapBounds convertLongitudeToPoint:longitude];
	
	// Account for the width of the pin "PNG"
	convertedLongitude -= 17.5;
	
	CGRect rect = CGRectMake(convertedLongitude, 
							 convertedLatitude, 
							 35, 
							 30);
	
	
	CGContextDrawImage(ctx, rect, imageToDraw);
}

-(void)dealloc;
{
    CFRelease(imageToDraw);
    [super dealloc];
}

@end
