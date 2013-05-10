/**
 *  NetworkView.h
 *  Visualizer
 *
 *  The NetworkView class is a subclass of NSView.  This view's job is to maintain the network and grid layers
 */

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "Network.h"
#import "Grid.h"


@interface NetworkView : NSView {
	Grid *grid; /**< The instance of the Grid class that is responsible for drawing the grid */
	CALayer *gridLayer; /**< The CALayer that is used by the Grid instance to draw the grid onto. */
	CALayer *networkPlotLayer; /**< The layer that contains the network plots */
	NSMutableArray *networkLayers; /**< This is an array of CALayers, this is used to maintain each network plot layer */
}

#pragma mark -
#pragma mark Methods

- (void)addGrid;
- (void)mapMoveEnded:(NSNotification *)note;
- (int)currentGridScale;
- (void)redrawLayers;
- (void)addLayer:(CALayer *)layerToAdd;

#pragma mark -
#pragma mark Properties
- (int)zoomLevel;
- (void)setZoomLevel:(int)zmLvl;
- (BOOL)shouldDrawGrid;
- (void)setShouldDrawGrid:(BOOL)drawFlag;
- (void)setMapType:(NSString *)mapType;
- (void)updateFromPreferences:(NSNotification *)note;


@end
