//
//  IntersectionPoint.h
//  WiFi Tracker
//


#import <Foundation/Foundation.h>


#define earthEquatorialRadiusInMeters 6378137
#define earthPolarRadiusInMeters 6356752.3
#define earthAverageRadiusInMeters ((earthEquatorialRadiusInMeters + earthPolarRadiusInMeters) / 2)
#define metersPerLatitudeDegree (1.0 / ((M_PI * earthAverageRadiusInMeters) / 180))


/**
 * \brief This is a class that represents a geographic location (i.e. a location on the surface of the earth).
 *
 * This class wraps a CLLocationCoordinate2D struct (which contains a latitude and longitude).
 * It provides an "isValid" property, which is FALSE when the location's latitude or longitude is not a number (NaN).
 * It also provides a distance method to determine the distance between this location and another location.
 */
@interface GeoLocation : NSObject {
	/// The location
	double locationLatitude; /**< The latitude location of the GeoLocation instance */
	double locationLongitude; /**< The longitude location of the Geolocation instance */
	
	/// A validity flag (set to false if either location.latitude or location.longitude is set to "not a number" [NaN])
	BOOL isValid;
}

@property (nonatomic, readonly) double locationLongitude;
@property (nonatomic, readonly) double locationLatitude;
@property (nonatomic, readonly) BOOL isValid;

/**
 * This method initializes the intersection point with a latitude and longitude.
 * @param latitude The latitude of the intersection point (double)
 * @param longitude The longitude of the intersection point (double)
 * @return The initialized IntersectionPoint object
 */
- (id)initWithLatitudeAndLongitude: (double)latitude longitude:(double)longitude;

/**
 * This convenience constructor creates an intersection point (autoreleased) with a latitude and longitude.
 * @param latitude The latitude of the intersection point (double)
 * @param longitude The longitude of the intersection point (double)
 * @return The initialized IntersectionPoint object 
 */
+ (id)geoLocationWithLatitudeAndLongitude: (double)latitude longitude:(double)longitude;


/**
 * This method determines the distance (in meters) between this location and another location on the earth.
 * @param otherLocation The other location
 * @return A double value representing the distance between the two locations, in meters
 */
- (double)distanceToLocationInMeters: (GeoLocation *)otherLocation;

/**
 * This method determines the latitudinal distance (in meters) between this location and another location on the earth.
 * @param otherLocation The other location
 * @return A double value representing the latitudinal distance between the two locations, in meters
 */
- (double)latitudinalDistanceToLocationInMeters: (GeoLocation *)otherLocation;

/**
 * This method determines the longitudinal distance (in meters) between this location and another location on the earth.
 * @param otherLocation The other location
 * @return A double value representing the longitudinal distance between the two locations, in meters
 */
- (double)longitudinalDistanceToLocationInMeters: (GeoLocation *)otherLocation;


/**
 * This utility method converts meters to the equivalent number of degrees latitude (delta) distance.
 * @param meters The meters value to convert
 * @return The distance in degrees latitude
 */
+ (double)convertMetersToDegreesLatitudeDelta: (double) meters;

/**
 * This utility method converts meters to the equivalent number of degrees longitude (delta) distance.
 * The number of meters in one degree longitude is a function of the location's latitude.
 * @param meters The meters value to convert
 * @param degreesLatitude The location of the point in degrees latitude on Earth
 * @return The distance in degrees longitude
 */
+ (double)convertMetersToDegreesLongitudeDelta: (double) meters degreesLatitude:(double)degreesLatitude;

/**
 * This utility method converts a (delta) number of degrees latitude distance to the equivalent number of meters.
 * @param degreesLatitudeDelta The distance in degrees latitude to convert
 * @return The distance in meters
 */
+ (double)convertDegreesLatitudeDeltaToMeters: (double) degreesLatitudeDelta;

/**
 * This utility method converts a (delta) number of degrees longitude distance to the equivalent number of meters.
 * The number of meters in one degree longitude is a function of the location's latitude.
 * @param degreesLongitudeDelta The distance in degrees longitude to convert
 * @param degreesLatitude The location of the point in degrees latitude on Earth
 * @return The distance in meters
 */
+ (double)convertDegreesLongitudeDeltaToMeters: (double)degreesLongitudeDelta degreesLatitude:(double)degreesLatitude;


@end
