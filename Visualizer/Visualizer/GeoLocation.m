//
//  IntersectionPoint.m
//  WiFi Tracker
//


#import "GeoLocation.h"


@implementation GeoLocation

@synthesize locationLongitude;
@synthesize locationLatitude;


- (id)initWithLatitudeAndLongitude: (double)latitude longitude:(double)longitude {
	if (self = [super init]) 
	{
		locationLatitude = latitude;
		locationLongitude = longitude;
	}
	
	return self;
}


+ (id)geoLocationWithLatitudeAndLongitude: (double)latitude longitude:(double)longitude {
	GeoLocation *geoLocation = [[[GeoLocation alloc] initWithLatitudeAndLongitude: latitude longitude: longitude] autorelease];
	return geoLocation;
}



- (BOOL) isValid {
	// If either the latitude or longitude values are "not a number", then the intersection point is not valid.
	if (isnan(locationLatitude) || isnan(locationLongitude)) {
		isValid = FALSE;
	}
	else {
		isValid = TRUE;
	}
	
	return isValid;
}

- (double)latitudinalDistanceToLocationInMeters: (GeoLocation *)otherLocation 
{
	double latitudinalDistanceInMeters = [GeoLocation convertDegreesLatitudeDeltaToMeters: (otherLocation.locationLatitude - locationLatitude)];
	
	return latitudinalDistanceInMeters;
}

- (double)longitudinalDistanceToLocationInMeters: (GeoLocation *)otherLocation 
{
	double longitudinalDistanceInMeters = [GeoLocation convertDegreesLongitudeDeltaToMeters: (otherLocation.locationLongitude - locationLongitude)
																			degreesLatitude: ((locationLatitude	+ otherLocation.locationLatitude) / 2.0)];
	
	return longitudinalDistanceInMeters;
}


- (double)distanceToLocationInMeters: (GeoLocation *)otherLocation {
	double latitudinalDistanceInMeters = [self latitudinalDistanceToLocationInMeters: otherLocation];
	double longitudinalDistanceInMeters = [self longitudinalDistanceToLocationInMeters: otherLocation];
	
	double distanceInMeters = sqrt(pow(latitudinalDistanceInMeters, 2) + pow(longitudinalDistanceInMeters, 2));
	
	return distanceInMeters;
}


+ (double)convertMetersToDegreesLatitudeDelta: (double) meters {
	return (meters * metersPerLatitudeDegree);
}

+ (double)convertMetersToDegreesLongitudeDelta: (double) meters degreesLatitude:(double)degreesLatitude {
	// degrees longitude is a function of latitude
	double metersPerLongitudeDegree = 1.0 / ((M_PI * earthEquatorialRadiusInMeters / 180.0) * cos(M_PI * degreesLatitude / 180.0));
	return (meters * metersPerLongitudeDegree);
}

+ (double)convertDegreesLatitudeDeltaToMeters: (double) degreesLatitudeDelta {
	return (degreesLatitudeDelta / metersPerLatitudeDegree);
}

+ (double)convertDegreesLongitudeDeltaToMeters: (double) degreesLongitudeDelta degreesLatitude:(double)degreesLatitude {
	// degrees longitude is a function of latitude
	double metersPerLongitudeDegree = 1.0 / ((M_PI * earthEquatorialRadiusInMeters / 180.0) * cos(M_PI * degreesLatitude / 180.0));
	return (degreesLongitudeDelta / metersPerLongitudeDegree);
}


@end
