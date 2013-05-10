/**
 *  SinglePoint.h
 *  Visualizer
 *
 *  The class is the base class for single point plots, it should be subclassed
 */

#import <Cocoa/Cocoa.h>
#import "MapBounds.h"


@interface SinglePoint : NSObject {

	double latitude; /**< Latitude of the point */
	double longitude; /**< Longitude of the point */
	double elevation; /**< Elevtion of the point */
}

@property (nonatomic)double latitude;
@property (nonatomic)double longitude;
@property (nonatomic)double elevation;

-(id)initWithLatLong:(double)lat Longitude:(double)lon;
- (void)drawPoint:(CALayer *)layer inContext:(CGContextRef)ctx withMapBounds:(MapBounds *)mapBounds;

@end
