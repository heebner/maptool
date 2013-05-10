/**
 *  HeatMapLayer.h
 *  Visualizer
 *
 *  This class is responsible for drawing a subset of points as a heat map with a single color
 */

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import "MapBounds.h"
#import "NetworkReading.h"


@interface HeatMapLayer : NSObject {
	CGColorRef color; /**< The color of the plots for this heat map layer */
	NSMutableArray *plots; /**< Points to plot on the layer */
}

- (id)initWithColor:(CGColorRef)plotColor;

- (void)addPlot:(NetworkReading *)reading;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx withMapBounds:(MapBounds *)mapBounds;
- (void)removePlot:(NetworkReading *)reading;
- (void)clearPlots;

@end
