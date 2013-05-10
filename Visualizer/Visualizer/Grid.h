/*
 *  Grid.h
 *  Visualizer
 *
 *  This class is the "model" for drawing the grid on the map WebView control.
 *  
 */

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "MapBounds.h"

extern float const MetersInOneDegree; /**< The int that defines the number of meeters in one degree latitude or longitude */

/**
 *  Grid.h
 *  Visualizer
 *
 *  This class is the "model" for drawing the grid on the map WebView control.
 *  
 */
@interface Grid : NSObject {
	__strong CGColorRef color; /**< The color of the grid on the display */
	__strong CGColorRef normalColor; /**< The normal color of the grid */
	__strong CGColorRef satelliteColor; /**< The satellite grid color */	
	NSColor *normalMapGridColor; /**< Color of the grid when the map is in Normal mode */
	NSColor *satelliteMapGridcolor; /**< Color of the grid when the map is in Satellite or Hybrid mode */
	int zoomLevel; /**< The current soomlevel displayed by the map */
	BOOL shouldDrawGrid; /**< Flag used to determine if the flag should be drawn */
	MapBounds *currentMapBounds; /**< The current bounds of the map */ 
	int gridlineIntervals[10]; /**< Arry used to store the interval of the gridlines.  Used to draw the grid at differnt zoom levels */
	NSString *currentMapType;
}

/**
 * Gets and Sets the Color of the grid lines
 */
@property(nonatomic)CGColorRef color;
@property(nonatomic, retain)NSString *currentMapType;

- (int)currentMapScale;

#pragma mark -
#pragma mark Methods
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;

- (double)determineStartingLatitude;
- (double)determineStartingLongitude;

#pragma mark -
#pragma mark Received Notifications
- (void)mapMoveEnded:(NSNotification *)note;
- (void)mapLoaded:(NSNotification *)note;
- (void)updateFromPreferences:(NSNotification *)note;

#pragma mark -
#pragma mark Properties

/**
 * Gets the Color of the grid
 * @return Color of the grid to be drawn
 */
- (CGColorRef)color;

/**
 * Gets the Zoom Level of the Grid
 */
- (int)zoomLevel;
- (void)setZoomLevel:(int)zmLvl;

/**
 * Gets a flag as to whether of not the grid shoud lbe drawn
 */
- (BOOL)shouldDrawGrid;
- (void)setShouldDrawGrid:(BOOL)drawFlag;

@end
