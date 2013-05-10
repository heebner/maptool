//
//  Circle.m
//  WiFi Tracker
//

#import "GeoCircle.h"


@implementation GeoCircle

@synthesize center;
@synthesize radius;


- (id)initWithLatitudeLongitudeAndRadius: (double)theLatitude longitude:(double)theLongitude radius:(double)theRadius {
	if (self = [super init]) {
		GeoLocation *theCenter = [[GeoLocation alloc] initWithLatitudeAndLongitude: theLatitude longitude: theLongitude];
		[self setCenter: theCenter];
		[theCenter release];
		radius = theRadius;
	}
	
	return self;	
}

- (id)initWithCenterAndRadius: (GeoLocation *)theCenter radius:(double)theRadius {
	if (self = [super init]) {
		[self setCenter: theCenter];
		[self setRadius: theRadius];
	}
	
	return self;
}

+ (id)geoCircleWithLatitudeLongitudeAndRadius: (double)theLatitude longitude:(double)theLongitude radius:(double)theRadius {
	GeoCircle *geoCircle = [[[GeoCircle alloc] initWithLatitudeLongitudeAndRadius: theLatitude
																		longitude: theLongitude
																		   radius: theRadius] autorelease];
	return geoCircle;
}

+ (id)geoCircleWithCenterAndRadius: (GeoLocation *)theCenter radius:(double)theRadius {
	GeoCircle *geoCircle = [[[GeoCircle alloc] initWithCenterAndRadius: theCenter radius: theRadius] autorelease];
	return geoCircle;
}


- (BOOL)containsLocation: (GeoLocation *)location {
	return ([location distanceToLocationInMeters: center] <= radius);
}

- (GeoCircleIntersection *)intersectionWithCircle: (GeoCircle *)otherGeoCircle {
	double x1 = center.locationLongitude;
	double x2 = otherGeoCircle.center.locationLongitude;
	double y1 = center.locationLatitude;
	double y2 = otherGeoCircle.center.locationLatitude;
	
	double xDistanceInMeters = [center longitudinalDistanceToLocationInMeters: otherGeoCircle.center];
	double yDistanceInMeters = [center latitudinalDistanceToLocationInMeters: otherGeoCircle.center];
	
	double d = [center distanceToLocationInMeters: otherGeoCircle.center];
	
	// These radii are in meters
	double r1 = radius;
	double r2 = otherGeoCircle.radius;
	
	// The first terms here are in degrees, the second and third are in meters.
	// We will convert all of them to degrees (below) before adding or subtracting them.
	// We need them in meters to perform the circle calculations,
	// because one degree longitude != one degree latitude, unless you're at the equator.
	double xFirstTerm = ((x2 + x1) / 2.0);
	double xSecondTermInMeters = (xDistanceInMeters * (pow(r1, 2.0) - pow(r2, 2.0))) / (2.0 * pow(d, 2.0));
	double xThirdTermInMeters = (yDistanceInMeters / (2.0 * pow(d, 2.0))) * (sqrt((pow(r1 + r2, 2.0) - pow(d, 2.0)) * (pow(d, 2.0) - (pow(r2 - r1, 2.0)))));
	
	double yFirstTerm = ((y2 + y1) / 2.0);		
	double ySecondTermInMeters = (yDistanceInMeters * (pow(r1, 2.0) - pow(r2, 2.0))) / (2.0 * pow(d, 2.0));
	double yThirdTermInMeters = (xDistanceInMeters / (2.0 * pow(d, 2.0))) * (sqrt((pow(r1 + r2, 2.0) - pow(d, 2.0)) * (pow(d, 2.0) - (pow(r2 - r1, 2.0)))));
	
	double xSecondTerm = [GeoLocation convertMetersToDegreesLongitudeDelta: xSecondTermInMeters degreesLatitude: ((y1 + y2) / 2)];
	double xThirdTerm = [GeoLocation convertMetersToDegreesLongitudeDelta: xThirdTermInMeters degreesLatitude: ((y1 + y2) / 2)];
	double ySecondTerm = [GeoLocation convertMetersToDegreesLatitudeDelta: ySecondTermInMeters];
	double yThirdTerm = [GeoLocation convertMetersToDegreesLatitudeDelta: yThirdTermInMeters];	
	
	GeoLocation *intersectionPoint1 = [[GeoLocation alloc] initWithLatitudeAndLongitude: (yFirstTerm + ySecondTerm - yThirdTerm)
																			  longitude: (xFirstTerm + xSecondTerm + xThirdTerm)];
	GeoLocation *intersectionPoint2 = [[GeoLocation alloc] initWithLatitudeAndLongitude: (yFirstTerm + ySecondTerm + yThirdTerm)
																			  longitude: (xFirstTerm + xSecondTerm - xThirdTerm)];
	
	GeoCircleIntersection *intersection = [GeoCircleIntersection geoCircleIntersectionWithIntersectionPoints: intersectionPoint1
																							   intersection2: intersectionPoint2];
	
	[intersectionPoint1 release];
	[intersectionPoint2 release];
	
	return intersection;
}

- (GeoLocation *)trilaterateWithCircles: (GeoCircle *)firstGeoCircle secondGeoCircle:(GeoCircle *)secondGeoCircle {
	GeoCircleIntersection *firstIntersection = [self intersectionWithCircle: firstGeoCircle];
	GeoCircleIntersection *secondIntersection = [self intersectionWithCircle: secondGeoCircle];
	GeoCircleIntersection *thirdIntersection = [firstGeoCircle intersectionWithCircle: secondGeoCircle];
	
	NSArray *intersectionPoints = [[NSArray alloc] initWithObjects: firstIntersection.intersectionPoint1,
								   firstIntersection.intersectionPoint2,
								   secondIntersection.intersectionPoint1,
								   secondIntersection.intersectionPoint2,
								   thirdIntersection.intersectionPoint1,
								   thirdIntersection.intersectionPoint2,
								   nil];
	
	// Default the trilaterated location to an invalid one
	GeoLocation *trilateratedLocation = nil;
	
	for (int i = 0; i < [intersectionPoints count]; i++) {
		for (int j = i; j < [intersectionPoints count]; j++) {
			GeoCircle *intersectionCircle = [[GeoCircle alloc] initWithCenterAndRadius: [intersectionPoints objectAtIndex: i]
																				radius: intersectionRadiusVariationInMeters];
			GeoLocation *intersectionPoint = [intersectionPoints objectAtIndex: j];			
			
			if ([intersectionCircle containsLocation: intersectionPoint]) 
			{
				trilateratedLocation = [GeoLocation geoLocationWithLatitudeAndLongitude:intersectionCircle.center.locationLatitude longitude:intersectionCircle.center.locationLongitude];
			}
			
			[intersectionCircle release];
		}
	}
	
	[intersectionPoints release];
	
	// If we found no location, create an invalid one
	if (trilateratedLocation == nil) {
		trilateratedLocation = [GeoLocation geoLocationWithLatitudeAndLongitude: NAN longitude: NAN];
	}
	
	return trilateratedLocation;
}


- (void)dealloc {
	[center release];
	
	[super dealloc];
}


@end
