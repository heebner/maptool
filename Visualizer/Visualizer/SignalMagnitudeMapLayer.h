/**
 *  SignalMagnitudeMapLayer.h
 *  Visualizer
 *
 *  This class is responsible for drawing a subset of points as a Signanl Magnitude map with a single color
 */


#import <Cocoa/Cocoa.h>
#import "NetworkReading.h"
#import "MapBounds.h"


@interface SignalMagnitudeMapLayer : NSObject {
	CGColorRef color; /**< The color of the plots for this heat map layer */
	NSMutableArray *plots; /**< Points to plot on the layer */
}

- (id)initWithColor:(CGColorRef)plotColor;

- (void)addPlot:(NetworkReading *)reading;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx withMapBounds:(MapBounds *)mapBounds;
- (void)removePlot:(NetworkReading *)reading;
- (void)clearPlots;

@end
