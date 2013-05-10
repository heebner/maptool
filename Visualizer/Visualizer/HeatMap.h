/**
 *  HeatMap.h
 *  Visualizer
 *
 *  This class is responsible for drawing network points as a heat map
 */

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "MapBounds.h"

#import "HeatMapLayer.h"


@interface HeatMap : NSObject {
	NSMutableArray *heatMapSubLayers; /**< Array that holds the layers for correct layering */
	CGColorRef colorArray[9]; /**< Array that holds the color used for different layers */
	MapBounds *currentMapBounds; /**< The current bounds of the map */ 
	CALayer *mainHeatMapLayer; /**< Layer that contains all sub layers */

}

@property (nonatomic, retain)CALayer *mainHeatMapLayer;
@property (nonatomic, retain)MapBounds *currentMapBounds;

- (id)initWithMapBounds:(MapBounds *)mapBnds;
- (void)getMapBounds:(NSNotification *)note;
- (HeatMapLayer *)getSubLayerIndexForPlot:(NetworkReading *)reading;
- (void)addPlotsToMap:(NSArray *)plots;
- (void)removePlotsFromMap:(NSArray *)plots;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
- (void)clearMap;
@end
