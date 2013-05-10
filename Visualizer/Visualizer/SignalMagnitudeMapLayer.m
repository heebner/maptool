//
//  SignalMagnitudeMapLayer.m
//  Visualizer
//
//  Created by Ben Heebner on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SignalMagnitudeMapLayer.h"


@implementation SignalMagnitudeMapLayer

/**
 * Initializes this class with the input color.  This color is used to draw all points on this layer
 * @param plotColor Color used to plot all points for this layer
 */
-(id)initWithColor:(CGColorRef)plotColor
{
	self = [super init];
    color = plotColor;
	plots = [[NSMutableArray alloc] init];
	
	return self;
}

/**
 * This method draws the input network readings as a heat map on the input layer with the input context
 * @param layer The layer to draw the heat map on
 * @param ctx The context in which to draw the heat map
 * @param mapBounds Bounds of the current map view
 */
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx withMapBounds:(MapBounds *)mapBounds
{
	for(NetworkReading *reading in plots)
	{
		if([mapBounds isWithinMapBounds:reading.latitude longitude:reading.longitude] == YES && [reading isChecked] == YES)
		{			
			double plotWidthInDegrees = [MapBounds convertMetersToDegreesLongitudeDelta:[reading RSSIAsDistanceInMeters] degreesLatitude:reading.latitude];
			double plotHeightInDegrees = [MapBounds convertMetersToDegreesLatitudeDelta:[reading RSSIAsDistanceInMeters]];
            
			double convertedLatitude = [mapBounds convertLatitudeToPoint:(reading.latitude - plotHeightInDegrees)];
			double convertedLongitude = [mapBounds convertLongitudeToPoint:(reading.longitude - plotWidthInDegrees)];
			
			CGContextSetStrokeColorWithColor(ctx, color);
			CGContextSetLineWidth(ctx, 2.0);
			

			
			// Let's plot a network point at the converted coordinates, and use the 20 meters for the size of the circles
			CGRect rect = CGRectMake(convertedLongitude, 
									 convertedLatitude, 
									 ([reading RSSIAsDistanceInMeters] * 2) * [mapBounds pointsPerMeter], 
									 ([reading RSSIAsDistanceInMeters] * 2) *[mapBounds pointsPerMeter]);
			CGContextStrokeEllipseInRect(ctx, rect);
			if(reading.isSelected == YES)
			{
				CGColorRef highlightColor = CGColorCreateCopyWithAlpha(color, 0.05);
				CGContextSetFillColorWithColor(ctx, highlightColor);
				CGContextFillEllipseInRect(ctx, rect);
			}
			
		}
	}	
}

/**
 * Adds a plot to the collection of points to plot
 * @param reading Point to plot
 */
-(void)addPlot:(NetworkReading *)reading
{
	[plots addObject:reading];
}

/**
 * Removes the input plot from the set of plots that are drawn
 * @param reading Plot to remove from the sublayer
 */
- (void)removePlot:(NetworkReading *)reading
{
	[plots removeObject:reading];
}

/**
 * Removes all objects from the layer
 */
- (void)clearPlots
{
	[plots removeAllObjects];
}

- (void)dealloc
{
	CFRelease(color);
	[plots release];
	[super dealloc];
}

@end
