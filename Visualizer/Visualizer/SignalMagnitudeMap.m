//
//  SignalMagnitudeMap.m
//  Visualizer
//
//  Created by Ben Heebner on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SignalMagnitudeMap.h"
#import "MapView.h"
#import "PreferenceController.h"

/**
 * The alpha level for plots on the map
 */
double const PlotAlphaLevel = 0.75;

@implementation SignalMagnitudeMap

@synthesize mainSigMagMapLayer;
@synthesize currentMapBounds;

/**
 * Initializes this class with a set of plots.
 * @param mapBnds The current map bounds
 */
- (id)initWithMapBounds:(MapBounds *)mapBnds
{
	self = [super init];
	// purple
	colorArray[8] = CGColorCreateGenericRGB(0.196, 0.110, 0.439, 0.75);
	// pink
	colorArray[7] = CGColorCreateGenericRGB(0.922, 0.082, 0.376, 0.75);
	// red
	colorArray[6] = CGColorCreateGenericRGB(0.824, 0.086, 0.098, 0.75);
	// orange
	colorArray[5] = CGColorCreateGenericRGB(0.863, 0.325, 0.086, 0.75);
	// gold
	colorArray[4] = CGColorCreateGenericRGB(0.996, 0.667, 0.208, 0.75);
	// green
	colorArray[3] = CGColorCreateGenericRGB(0.294, 0.498, 0.094, 0.75);
	// blue green
	colorArray[2] = CGColorCreateGenericRGB(0.196, 0.714, 0.439, 0.75);
	// blue
	colorArray[1] = CGColorCreateGenericRGB(0.141, 0.235, 0.820, 0.75);
	// light blue
	colorArray[0] = CGColorCreateGenericRGB(0.392, 0.537, 0.980, 0.75);
	
	smMapSubLayers = [[NSMutableArray alloc] init];
	mainSigMagMapLayer = [CALayer layer];
    [self setCurrentMapBounds:mapBnds];
	
	for(int index = 0; index < 9; index++)
	{
		CALayer *layer = [CALayer layer];
		[layer setZPosition:index];
		CGColorRef tempColor = colorArray[index];
		SignalMagnitudeMapLayer *newSigMagMapLayer = [[SignalMagnitudeMapLayer alloc] initWithColor:tempColor];
		[layer setDelegate:newSigMagMapLayer];
		[smMapSubLayers addObject:newSigMagMapLayer];
		[mainSigMagMapLayer addSublayer:layer];
        [newSigMagMapLayer release];
	}
	
	
	// Register for notifications we care about
	// Let's figure out when the map is done moving, we'll most likely have to redraw the grid
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(getMapBounds:) 
			   name:MapMoveEndNotification 
			 object:nil];
	
	return self;
}

/**
 * Method the is invoked when the map is finished being manipulated by the user (scoll, pan or zoom)
 * @param note Notification object associated with the mapMoveEndNotification
 */
- (void)getMapBounds:(NSNotification *)note
{
	MapView *map = [note object];
	currentMapBounds = [map currentBounds];
}

/**
 * This method sorts the input plot and returns which sublayer the plot belong on
 * @param reading The plots to sort onto the sublayers
 */
- (SignalMagnitudeMapLayer *)getSubLayerIndexForPlot:(NetworkReading *)reading
{
	SignalMagnitudeMapLayer *returnVal;
	
	// purple
	if (reading.signalStrength > -60) 
	{
		returnVal = [smMapSubLayers objectAtIndex:8];
	}
	// pink
	else if (reading.signalStrength > -66) 
	{
		returnVal = [smMapSubLayers objectAtIndex:7];
	}
	// red
	else if (reading.signalStrength > -71) 
	{
		returnVal = [smMapSubLayers objectAtIndex:6];
	}
	// orange
	else if (reading.signalStrength > -74) 
	{
		returnVal = [smMapSubLayers objectAtIndex:5];	
	}
	// gold
	else if (reading.signalStrength > -77) 
	{
		returnVal = [smMapSubLayers objectAtIndex:4];
	}
	// green
	else if (reading.signalStrength > -80) 
	{
		returnVal = [smMapSubLayers objectAtIndex:3];
	}
	// blue green
	else if (reading.signalStrength > -84) 
	{
		returnVal = [smMapSubLayers objectAtIndex:2];
	}
	// blue
	else if (reading.signalStrength > -90) 
	{
		returnVal = [smMapSubLayers objectAtIndex:1];
	}
	// light blue
	else 
	{
		returnVal = [smMapSubLayers objectAtIndex:0];
	}
	return returnVal;
}

/**
 * Adds input plots to map on the Heat Map
 * @param plots Plots to add to the heat map
 */
- (void)addPlotsToMap:(NSArray *)plots
{
	for(NetworkReading *reading in plots)
	{
		if([reading isChecked] == YES)
		{
			[[self getSubLayerIndexForPlot:reading] addPlot:reading];
		}
	}
}

/**
 * Removes input plots from the Heat Map
 * @param plots Plots to remove from the 
 */
- (void)removePlotsFromMap:(NSArray *)plots
{
	for(NetworkReading *reading in plots)
	{
		[[self getSubLayerIndexForPlot:reading] removePlot:reading];
	}
    
}

/**
 * This method draws the input network readings as a heat map on the input layer with the input context
 * @param layer The layer to draw the heat map on
 * @param ctx The context in which to draw the heat map
 */
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	for(SignalMagnitudeMapLayer *smLayer in smMapSubLayers)
	{
		[smLayer drawLayer:layer inContext:ctx withMapBounds:currentMapBounds];
	}
}

/**
 * Clears the map of all plots
 */
- (void)clearMap
{
	for(SignalMagnitudeMapLayer *smLayer in smMapSubLayers)
	{
		[smLayer clearPlots];
	}
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (void)dealloc
{
	[smMapSubLayers release];
	CFRelease(colorArray);
	[currentMapBounds release]; 
	[mainSigMagMapLayer release];
	[super dealloc];
}

@end
