/**
 *  SignalMagnitudeMap.h
 *  Visualizer
 *
 *  This class is responsible for drawing network points as a Signal Magnitude map
 */

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "SignalMagnitudeMapLayer.h"
#import "MapBounds.h"
#import "NetworkReading.h"

@interface SignalMagnitudeMap : NSObject {
	NSMutableArray *smMapSubLayers; /**< Array that holds the layers for correct layering */
	CGColorRef colorArray[9]; /**< Array that holds the color used for different layers */
	MapBounds *currentMapBounds; /**< The current bounds of the map */ 
	CALayer *mainSigMagMapLayer; /**< Layer that contains all sub layers */
}

@property (nonatomic, retain)CALayer *mainSigMagMapLayer;
@property (nonatomic, retain)MapBounds *currentMapBounds;

- (id)initWithMapBounds:(MapBounds *)mapBnds;
- (void)getMapBounds:(NSNotification *)note;
- (SignalMagnitudeMapLayer *)getSubLayerIndexForPlot:(NetworkReading *)reading;
- (void)addPlotsToMap:(NSArray *)plots;
- (void)removePlotsFromMap:(NSArray *)plots;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
- (void)clearMap;

@end
