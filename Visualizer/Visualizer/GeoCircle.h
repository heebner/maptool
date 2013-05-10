//
//  Circle.h
//  WiFi Tracker
//

#import "GeoLocation.h"
#import "GeoCircleIntersection.h"
#import <Foundation/Foundation.h>


#define intersectionRadiusVariationInMeters 6


/**
 * \brief This is a class that represents a simple circle (center point and radius) on the surface of the earth.
 *
 * This class contains utility (class-level) methods to convert between latitude degrees, longitude degrees, and meters.
 * It also contains a method to determine where two GeoCircle objects intersect on the surface of the earth.
 */
@interface GeoCircle : NSObject {
	/// The center of the circle
	GeoLocation *center;
	
	/// The radius of the circle, in meters
	double radius;
}

@property (nonatomic, retain) GeoLocation *center;
@property (nonatomic) double radius;

/**
 * This method initializes the circle with a latitude, longitude, and radius.
 * @param theLatitude The latitude of center of the circle (double)
 * @param theLongitude The longitude of center of the circle (double)
 * @param theRadius The radius of the circle as a double value (the unit for the radius is meters)
 * @return The initialized Circle object
 */
- (id)initWithLatitudeLongitudeAndRadius: (double)theLatitude longitude:(double)theLongitude radius:(double)theRadius;

/**
 * This method initializes the circle with a center and radius.
 * @param theCenter The center location of the circle (a GeoLocation object)
 * @param theRadius The radius of the circle as a double value  (the unit for the radius is meters)
 * @return The initialized Circle object
 */
- (id)initWithCenterAndRadius: (GeoLocation *)theCenter radius:(double)theRadius;

/**
 * This convenience constructor creates a circle (autoreleased) with a latitude, longitude, and radius.
 * @param theLatitude The latitude of center of the circle (double)
 * @param theLongitude The longitude of center of the circle (double)
 * @param theRadius The radius of the circle as a double value (the unit for the radius is meters)
 * @return The initialized Circle object
 */
+ (id)geoCircleWithLatitudeLongitudeAndRadius: (double)theLatitude longitude:(double)theLongitude radius:(double)theRadius;

/**
 * This convenience constructor creates a circle (autoreleased) with a center and radius.
 * @param theCenter The center location of the circle (a GeoLocation object)
 * @param theRadius The radius of the circle as a double value  (the unit for the radius is meters)
 * @return The initialized Circle object
 */
+ (id)geoCircleWithCenterAndRadius: (GeoLocation *)theCenter radius:(double)theRadius;


/**
 * This method determines if the circle contains a given location.
 * @param location The location
 * @return A Boolean value indicating whether or not the circle contains the supplied location
 */
- (BOOL)containsLocation: (GeoLocation *)location;

/**
 * This method determines the intersection of this circle with another circle (passed in as an argument).
 * @param otherGeoCircle The other circle to perform the intersection calculation with
 * @returns A GeoCircleIntersection object that represents the intersection of the two circles.
 */
- (GeoCircleIntersection *)intersectionWithCircle: (GeoCircle *)otherGeoCircle;

/**
 * This method determines the single intersection point between this circle and two other circles (passed in as arguments).
 * @param firstGeoCircle The first circle to perform the trilateration algorithm with
 * @param secondGeoCircle The second circle to perform the trilateration algorithm with
 * @returns A GeoLocation object that represents the intersection of the three circles.
 */
- (GeoLocation *)trilaterateWithCircles: (GeoCircle *)firstGeoCircle secondGeoCircle:(GeoCircle *)secondGeoCircle;


@end
