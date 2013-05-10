/*
 *  NetworkView.m
 *  Visualizer
 *
 *  The NetworkView class is a subclass of NSView.  This view's job is to maintain the network and grid layers
 */


#import "NetworkView.h"
#import <QuartzCore/QuartzCore.h>
#import "PreferenceController.h"
#import "Constants.h"

#define MARGIN (0)

@implementation NetworkView

#pragma mark -
#pragma mark Methods

/**
 * Overriden method from the NSView.  This method initializes the class member attributes
 */
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
	grid = [[Grid alloc] init];
	networkLayers = [[NSMutableArray alloc] init];
    //gridLayer = [[CALayer alloc] init];
    networkPlotLayer = [[CALayer alloc] init];
	
	// Register for notifications we care about
	// Let's figure out when the map is done moving, we'll most likely have to redraw the grid
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(mapMoveEnded:) 
			   name:MapMoveEndNotification 
			 object:nil];
	[nc addObserver:self
		   selector:@selector(updateFromPreferences:)
			   name:PreferencesUpdatedNotification 
			 object:nil];
	
    return self;
}

/**
 * Gets the current grid scale in meters
 * @return The length of one grid box in meters
 */
- (int)currentGridScale
{
	return [grid currentMapScale];
}

/**
 * Since we're using layers to draw the network plots and the grid, we don't do anything in this method
 * but we may in the future
 */
- (void)redrawLayers
{
	// Take off the Grid layer and put it back on the end, that way it'll always be on top
	[gridLayer removeFromSuperlayer];
	[[self layer] addSublayer:gridLayer];
	
	// Redraw the grid based on the new map bounds
	[gridLayer setNeedsDisplay];
	
	// Redraw the network layers based on the new map bounds
	for(CALayer *layer in [[self layer] sublayers])
	{
		[layer setNeedsDisplay];
	}
}


/**
 * Method that is invokes when the Notification Center raises the 'MapMoveEndedNotification'.  This method will rescale/redraw
 * the map based on the new bounds of the map view
 * @param note The Notification object associated will the Notification
 */
- (void)mapMoveEnded:(NSNotification *)note
{	
	[self redrawLayers];
}

- (void)alphaLevelChanged:(NSNotification *)note
{
	[self redrawLayers];
}

/**
 * Adds the grid layer on top of the map
 */
- (void)addGrid
{
	gridLayer = [CALayer layer];
	CGRect b = [[self layer] bounds];
	b = CGRectInset(b, MARGIN, MARGIN);
	[gridLayer setAnchorPoint:CGPointMake(0, 0)];
	[gridLayer setFrame:b];
	[gridLayer setBorderColor:[grid color]];
	[gridLayer setBorderWidth:3.0];
	[gridLayer setDelegate:grid];
	[[self layer] addSublayer:gridLayer];
	[gridLayer display];
}

- (void)addLayer:(CALayer *)layerToAdd
{
    [[self layer] addSublayer:layerToAdd];
}

- (void)updateFromPreferences:(NSNotification *)note
{
	[self redrawLayers];
}

#pragma mark -
#pragma mark Properties

/**
 * Gets the zoom level of the grid
 */
- (int)zoomLevel{
	return [grid zoomLevel];
}

/**
 * Sets the zoom level of the grid
 * @param zmLvl The zoom level to set the grid to, typically this corresponds to the map zoom level
 */
- (void)setZoomLevel:(int)zmLvl{
	[grid setZoomLevel:zmLvl];
	[gridLayer setNeedsDisplay];
}

/**
 * Gets a flag indicating if the grid should be drawn
 */
- (BOOL)shouldDrawGrid{
	return [grid shouldDrawGrid];
}

/**
 * Sets the flag as to whether or not to draw the grid
 * @param drawFlag 'YES' to draw the grid, 'NO' to hide it
 */
- (void)setShouldDrawGrid:(BOOL)drawFlag{
	if(drawFlag == YES)
	{
		if(gridLayer != nil)
		{
			gridLayer.hidden = NO;
		}
		else
		{
			[self addGrid];
		}
	}
	else
	{
		gridLayer.hidden = YES;
	}
	[grid setShouldDrawGrid:drawFlag];
}

/**
 * This method sets the color of the grid lines to the input color
 * @param mapType The type of map the map is changing to
 */
- (void)setMapType:(NSString *)mapType
{
	grid.currentMapType = mapType;
	[gridLayer setNeedsDisplay];
}

- (void)dealloc
{
	[grid release];
	[gridLayer release];
	[networkPlotLayer release];
	[networkLayers release];
	[super dealloc];
}

@end
