//
//  SinglePointMap.m
//  Visualizer
//
//  Created by Ben Heebner on 10/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SinglePointMap.h"
#import "MapView.h"


@implementation SinglePointMap

@synthesize mainPointMapLayer;
@synthesize currentMapBounds;

/**
 * Initializes this class with a set of plots.
 * @param mapBnds The current map bounds
 */
- (id)initWithMapBounds:(MapBounds *)mapBnds
{
	self = [super init];
    mainPointMapLayer = [CALayer layer];
	[mainPointMapLayer setDelegate:self];
    [self setCurrentMapBounds:mapBnds];
	plots = [[NSMutableArray alloc] init];
	
	// Register for notifications we care about
	// Let's figure out when the map is done moving, we'll most likely have to redraw the grid
	//NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	//[nc addObserver:self
	//	   selector:@selector(getMapBounds:) 
//			   name:MapMoveEndNotification 
//			 object:nil];
	
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
 * Adds the input plot to the map
 * @param plot Plot to add to the map
 */
- (void)addPlotToMap:(SinglePoint *)plot
{
    // If we have plots, when we should register interest
    // for when the map bounds changes
    if([plots count] == 0) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(getMapBounds:) 
                   name:MapMoveEndNotification 
                 object:nil];
    }
	[plots addObject:plot];
}

/**
 * Removes the input plot from the map
 * @param plot Plot to remove from the map
 */
- (void)removePlotFromMap:(SinglePoint *)plot
{
	[plots removeObject:plot];
    if([plots count] == 0) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self];
    }
}

/**
 * This method draws the input network readings as a single map on the input layer with the input context
 * @param layer The layer to draw the single point map on
 * @param ctx The context in which to draw the single point map
 */
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	for(SinglePoint *pt in plots)
	{
		[pt drawPoint:layer inContext:ctx withMapBounds:currentMapBounds];
	}
}

/**
 * Return the number of plots on the layer
 * @return The number of plots on the layer
 */
- (NSInteger)numberOfPlotsOnLayer
{
	return [plots count];
}

/**
 * Clears the map of all plots
 */
- (void)clearMap
{
	[plots removeAllObjects];
}

/**
 */
- (void)deregister {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
}

- (void)dealloc
{
	[currentMapBounds release];
	[mainPointMapLayer release];
	[plots release];
	[super dealloc];
}

@end
