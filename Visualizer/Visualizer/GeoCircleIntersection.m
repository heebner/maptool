//
//  CircleIntersection.m
//  WiFi Tracker
//


#import "GeoCircleIntersection.h"


@implementation GeoCircleIntersection

@synthesize intersectionPoint1;
@synthesize intersectionPoint2;


- (id)initWithIntersectionPoints: (GeoLocation *)intersection1 intersection2:(GeoLocation *)intersection2 {
	if (self = [super init]) {
		[self setIntersectionPoint1: intersection1];
		[self setIntersectionPoint2: intersection2];
	}
	
	return self;
}

+ (id)geoCircleIntersectionWithIntersectionPoints: (GeoLocation *)intersection1 intersection2:(GeoLocation *)intersection2 {
	GeoCircleIntersection *geoCircleIntersection = [[[GeoCircleIntersection alloc] initWithIntersectionPoints: intersection1
																								intersection2: intersection2] autorelease];
	return geoCircleIntersection;
}


- (GeoCircleIntersectionType)intersectionType {
	// If both intersection points are not valid (latitude or longitude = nan), then the circles do not intersect.
	if (!(intersectionPoint1.isValid) || !(intersectionPoint2.isValid)) {
		intersectionType = DoNotIntersect;
	}
	// If only one of the intersection points is valid, and the other is invalid,
	// or the intersection points have the same latitude and longitude, then the circles intersect at one point.
	else if ((!(intersectionPoint1.isValid) && intersectionPoint2.isValid) || 
			 (intersectionPoint1.isValid && !(intersectionPoint2.isValid)) ||
			 (intersectionPoint1.locationLatitude == intersectionPoint2.locationLatitude &&
			  intersectionPoint1.locationLongitude == intersectionPoint2.locationLongitude)) {
		intersectionType = IntersectAtOnePoint;
	}
	else {
		intersectionType = IntersectAtTwoPoints;
	}
	
	return intersectionType;
}


- (void)dealloc {
	[intersectionPoint1 release];
	[intersectionPoint2 release];
	
	[super dealloc];
}


@end
