//
//  SinglePoint.m
//  Visualizer
//
//  Created by Ben Heebner on 10/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SinglePoint.h"


@implementation SinglePoint

@synthesize latitude;
@synthesize longitude;
@synthesize elevation;

/**
 * Inializer for the Single Point class that takes in a latitude and longitude 
 * @param lat Latitude of the Point
 * @param lon Longitude of the Point
 */
-(id)initWithLatLong:(double)lat Longitude:(double)lon
{
	latitude = lat;
	longitude = lon;
	return self;
}

/**
 * This method is an abstract method.  It is intended that subclasses of this class implement this method.
 */
- (void)drawPoint:(CALayer *)layer inContext:(CGContextRef)ctx withMapBounds:(MapBounds *)mapBounds
{ // Do nothing, subclasses should implement this method  
}

@end
