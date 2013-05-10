/*
 *  MapBounds.h
 *  Visualizer
 *
 *  This class represents the bounds of hte current map window.  This classe is also responsible for
 *  performing calculations based on the map bounds
 */

#import <Cocoa/Cocoa.h>

#define earthEquatorialRadiusInMeters 6378137
#define earthPolarRadiusInMeters 6356752.3
#define earthAverageRadiusInMeters ((earthEquatorialRadiusInMeters + earthPolarRadiusInMeters) / 2)
#define metersPerLatitudeDegree (1.0 / ((M_PI * earthAverageRadiusInMeters) / 180))

/**
 *  MapBounds.h
 *  Visualizer
 *
 *  This class represents the bounds of hte current map window.  This classe is also responsible for
 *  performing calculations based on the map bounds
 */
@interface MapBounds : NSObject {
	double northeastLatitude; /**< The northeast latitude of the current map bounds */
	double northeastLongitude; /**< The northeast longitude of the current map bounds */
	double southwestLatitude; /**< The southweat latitude of the current map bounds */
	double southwestLongitude; /**< The southwest longitude of the current map bounds */
	int currentZoomLevel; /**< The current zoom level of the map */
	float mapWidth; /**< This is the MapView Window Width */
	float mapHeight; /**< This is the MapView Window Height */
}

@property (nonatomic)double northeastLatitude;
@property (nonatomic)double northeastLongitude;
@property (nonatomic)double southwestLatitude;
@property (nonatomic)double southwestLongitude;
@property (nonatomic)int currentZoomLevel;
@property (nonatomic)float mapWidth;
@property (nonatomic)float mapHeight;

- (double)getLesserLatitude;
- (double)getGreaterLatitude;
- (double)getLesserLongitude;
- (double)getGreaterLongitude;
- (double)getLongitudeSpan;
- (double)getLatitudeSpan;
- (BOOL)isWithinMapBounds:(double)latitude longitude:(double)lng;
- (BOOL)isLongitudeWithinMapBounds:(double)longitude;
- (BOOL)isLatitudeWithinMapBounds:(double)latitude;
- (double)metersPerPoint;
- (double)pointsPerMeter;
- (double)convertLatitudeToPoint:(double)latitude;
- (double)convertLongitudeToPoint:(double)longitude;

+ (double)convertMetersToDegreesLatitudeDelta: (double) meters;
+ (double)convertMetersToDegreesLongitudeDelta: (double) meters degreesLatitude:(double)degreesLatitude;
+ (double)convertDegreesLatitudeDeltaToMeters: (double) degreesLatitudeDelta;
+ (double)convertDegreesLongitudeDeltaToMeters: (double)degreesLongitudeDelta degreesLatitude:(double)degreesLatitude;


@end
