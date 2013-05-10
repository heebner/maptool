//
//  CircleIntersection.h
//  WiFi Tracker
//

#import "GeoLocation.h"
#import <Foundation/Foundation.h>

typedef enum GeoCircleIntersectionTypes {
	DoNotIntersect,
	IntersectAtOnePoint,
	IntersectAtTwoPoints
} GeoCircleIntersectionType;

/**
 * \brief This class represents the two points where two geo-circles intersect.
 *
 * Use the "valid" property of the intersection points to determine their validity (latitude or longitude = nan is invalid).
 * If the circles intersect at one point, then both points may actually have the same intersection (latitude & longitude).
 * Use the "intersectionType" property to determine if the two circles do not intersect, intersect at one point, or intersect at two points.
 */
@interface GeoCircleIntersection : NSObject {
	/// This is the first of the two potential intersection points
	GeoLocation *intersectionPoint1;
	
	/// This is the second of the two potential intersection points
	GeoLocation *intersectionPoint2;
	
	/// This property returns the intersection type (circles do not intersect, they intersect at one point, or they intersect at two points)
	GeoCircleIntersectionType intersectionType;
}

@property (nonatomic, retain) GeoLocation *intersectionPoint1;
@property (nonatomic, retain) GeoLocation *intersectionPoint2;
@property (nonatomic, readonly) GeoCircleIntersectionType intersectionType;

/**
 * This method initializes the circle intersection with two intersection points.
 * @param intersection1 The first intersection point of the two circles (a GeoLocation object)
 * @param intersection2 The second intersection point of the two circles (a GeoLocation object)
 * @return The initialized GeoCircleIntersection object
 */
- (id)initWithIntersectionPoints: (GeoLocation *)intersection1 intersection2:(GeoLocation *)intersection2;

/**
 * This convenience constructor creates a circle intersection (autoreleased) with two intersection points.
 * @param intersection1 The first intersection point of the two circles (a GeoLocation object)
 * @param intersection2 The second intersection point of the two circles (a GeoLocation object)
 * @return The initialized GeoCircleIntersection object
 */
+ (id)geoCircleIntersectionWithIntersectionPoints: (GeoLocation *)intersection1 intersection2:(GeoLocation *)intersection2;


@end
