/**
 *  SinglePoint.h
 *  Visualizer
 *
 *  The class is responsible for drawing single points on the map.
 */

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "SinglePoint.h"
#import "MapBounds.h"


@interface SinglePointMap : NSObject {
	MapBounds *currentMapBounds; /**< The current bounds of the map */ 
	CALayer *mainPointMapLayer; /**< Layer that contains all sub layers */
	NSMutableArray *plots; /**< Points to plot on the layer */
}

@property (nonatomic, retain)CALayer *mainPointMapLayer; 
@property (nonatomic, retain)MapBounds *currentMapBounds;

- (id)initWithMapBounds:(MapBounds *)mapBnds;
- (void)getMapBounds:(NSNotification *)note;
- (void)addPlotToMap:(SinglePoint *)plot;
- (void)removePlotFromMap:(SinglePoint *)plot;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
- (NSInteger)numberOfPlotsOnLayer;
- (void)clearMap;
- (void)deregister;

@end
