//
//  Trilaterator.h
//  Visualizer
//


#import <Cocoa/Cocoa.h>
#import "AccessPoint.h"
#import "GeoCircle.h"
#import "GeoCircleIntersection.h"

#define intersectionRadiusVariationInMeters 6

/**
 * This class contains static methods for trilaterating a point for a given AccessPoint
 */
@interface Trilaterator : NSObject {

}

+ (GeoCircleIntersection *)determineSignalSampleIntersectionPoints: (SignalSample *)firstSample secondSample:(SignalSample *)secondSample;
+ (GeoCircle *)trilaterate:(AccessPoint *)accessPoint;

@end
