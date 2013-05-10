//
//  MapBounds.m
//  Visualizer
//


#import "MapBounds.h"
#import "Grid.h"

@implementation MapBounds

@synthesize northeastLatitude;
@synthesize northeastLongitude;
@synthesize southwestLatitude;
@synthesize southwestLongitude;
@synthesize currentZoomLevel;
@synthesize mapWidth;
@synthesize mapHeight;


/**
 * Between the top and bottom of the map, this method returns the latitude that is closer to the equator
 * @return Laitude that is closer to the equator as a float
 */
- (double)getLesserLatitude
{
	if(northeastLatitude <= southwestLatitude)
	{
		return northeastLatitude;
	}
	return southwestLatitude;
}

/**
 * Between the top and bottom of the map, this method returns the latitude that is further from the equator
 * @return Laitude that is furthest from the equator as a float
 */
- (double)getGreaterLatitude
{
	if(northeastLatitude >= southwestLatitude)
	{
		return northeastLatitude;
	}
	return southwestLatitude;
}

/**
 * Between the left-side and right-side of the map, this method returns the longitude that is closer to the prime meridian
 * @return Longitude that is closet to the prime meridian as a float
 */
- (double)getLesserLongitude
{
	if(fabs(northeastLongitude) <= fabs(southwestLongitude))
	{
		return northeastLongitude;
	}
	return southwestLongitude;
}

/**
 * Between the left-side and right-side of the map, this method returns the longitude that is further from the prime meridian
 * @return Longitude that is further from the prime meridian as a float
 */
- (double)getGreaterLongitude
{
	if(fabs(northeastLongitude) >= fabs(southwestLongitude))
	{
		return northeastLongitude;
	}
	return southwestLongitude;
}

/**
 * Retrieves the distance, in degrees from the top to the bottom of the map
 * @return The distance in degrees from the top the bottom of the map
 */
- (double)getLongitudeSpan
{
	double retVal = fabs(northeastLongitude - southwestLongitude);
	return retVal;
}

/**
 * Retrieves the distance, in degrees from the left to the right of the map
 * @return The distance in degrees from the left to the right of the map
 */
- (double)getLatitudeSpan
{
	double retVal = fabs(northeastLatitude - southwestLatitude);
	return retVal;
}

/**
 * Determines if the input latitude and longitude is contained within the current map bounds area
 * @param latitude Input latitude to see if it's within the latitude span of the current map bounds
 * @param lng Input longitude to see if it's within the longitude of the current map bounds
 * @return A boolean indicating whether or not the input lat/long combo is within the current map bounds
 */
- (BOOL)isWithinMapBounds:(double)latitude longitude:(double)lng
{
	double absLat = fabs(latitude);
	double absLng = fabs(lng);
	
	if(absLat >= fabs([self getLesserLatitude]) &&
	   absLat <= fabs([self getGreaterLatitude]) &&
	   absLng >= fabs([self getLesserLongitude]) &&
	   absLng <= fabs([self getGreaterLongitude]))
	{
		return YES;
	}	
	return NO;
}

/**
 * Determines if the input longitude is within the map bounds of the current map view longitude span
 * @param longitude Input longitude to determine if it's within the longitude map bounds
 * @return A boolean indicating if the input longitude is within the current map bounds
 */
- (BOOL)isLongitudeWithinMapBounds:(double)longitude
{
	double absLong = fabs(longitude);
	
	if(absLong >= fabs([self getLesserLongitude]) &&
	   absLong <= fabs([self getGreaterLongitude]))
	{
		return YES;
	}
	return NO;
}

/**
 * Determines if the input latitude is within the map bounds of the current map view latitude span
 * @param latitude Input latitude to determine if it's within the latitude map bounds
 * @return A boolean indicating if the input latitude is within the current map bounds
 */
- (BOOL)isLatitudeWithinMapBounds:(double)latitude
{
	double absLat = fabs(latitude);
	
	if(absLat >= fabs([self getLesserLatitude]) &&
		absLat <= fabs([self getGreaterLatitude]))
	{
		return YES;
	}
	return NO;
}

/**
 * Returns the number of meters per point on the map view
 * @return Double value of the number of meters per point on the map view
 */
- (double)metersPerPoint
{
	double metersInSpan = [self getLatitudeSpan] * MetersInOneDegree;
	double retVal = metersInSpan / mapHeight;
	return retVal;
}

/**
 * Returns the numebr of points per meter on the map view
 * @return Double value of the number of points per meter on the map view
 */
- (double)pointsPerMeter
{
	double metersInSpan = [self getLatitudeSpan] * MetersInOneDegree;
	double retVal = mapHeight / metersInSpan;
	return retVal;
}


/**
 * Converts a latitude to the correct position on the map that is currently in view on the HMI.
 * @param latitude Latitude to convert to a point value
 * @return The floating point value point that corresponds to the input latitude
 */
- (double)convertLatitudeToPoint:(double)latitude
{
	double numerator = latitude - [self southwestLatitude];
	double denominator = [self getLatitudeSpan];
	double divisionResult = numerator/denominator;
	double retVal = divisionResult * mapHeight;
	return retVal;
}

/**
 * Converts a longitude to the correct position on the map that is currently in view on the HMI
 * @param longitude Longitude to convert to a point value
 * @return The floating point value point that corresponds to the input longitude
 */
- (double)convertLongitudeToPoint:(double)longitude
{

	double numerator = longitude - [self southwestLongitude];
	double denominator = [self getLongitudeSpan];
	double divisionResult = numerator/denominator;
	double retVal = divisionResult * mapWidth;
	return retVal;
}

/**
 * This utility method converts meters to the equivalent number of degrees latitude (delta) distance.
 * @param meters The meters value to convert
 * @return The distance in degrees latitude
 */
+ (double)convertMetersToDegreesLatitudeDelta: (double) meters {
	return (meters * metersPerLatitudeDegree);
}

/**
 * This utility method converts meters to the equivalent number of degrees longitude (delta) distance.
 * The number of meters in one degree longitude is a function of the location's latitude.
 * @param meters The meters value to convert
 * @param degreesLatitude The location of the point in degrees latitude on Earth
 * @return The distance in degrees longitude
 */
+ (double)convertMetersToDegreesLongitudeDelta: (double) meters degreesLatitude:(double)degreesLatitude {
	// degrees longitude is a function of latitude
	double metersPerLongitudeDegree = 1.0 / ((M_PI * earthEquatorialRadiusInMeters / 180.0) * cos(M_PI * degreesLatitude / 180.0));
	return (meters * metersPerLongitudeDegree);
}

/**
 * This utility method converts a (delta) number of degrees latitude distance to the equivalent number of meters.
 * @param degreesLatitudeDelta The distance in degrees latitude to convert
 * @return The distance in meters
 */
+ (double)convertDegreesLatitudeDeltaToMeters: (double) degreesLatitudeDelta {
	return (degreesLatitudeDelta / metersPerLatitudeDegree);
}

/**
 * This utility method converts a (delta) number of degrees longitude distance to the equivalent number of meters.
 * The number of meters in one degree longitude is a function of the location's latitude.
 * @param degreesLongitudeDelta The distance in degrees longitude to convert
 * @param degreesLatitude The location of the point in degrees latitude on Earth
 * @return The distance in meters
 */
+ (double)convertDegreesLongitudeDeltaToMeters: (double) degreesLongitudeDelta degreesLatitude:(double)degreesLatitude {
	// degrees longitude is a function of latitude
	double metersPerLongitudeDegree = 1.0 / ((M_PI * earthEquatorialRadiusInMeters / 180.0) * cos(M_PI * degreesLatitude / 180.0));
	return (degreesLongitudeDelta / metersPerLongitudeDegree);
}



@end
