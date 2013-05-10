/*
 *  JavascriptWrapper.m
 *  Visualizer
 *
 *   This class builds the Javascript command that can be interprets by the google map that is loaded into the WebView
 */


#import "JavascriptWrapper.h"


@implementation JavascriptWrapper

/**
 * Returns a string Javacsript command that will set the map center to the input latitude and longitude, with the input zoom value.
 * @param latValue Latitude of the center point
 * @param lonValue Longitude of the center point
 * @param zoomValue Zoom value to set the map to
 * @return A string that is a Javacsript command that can be used to set the google map to the input center and zoom level
 */
+ (NSString *)setCenter:(double)latValue 
			  longitude:(double)lonValue
			  zoomLevel:(int)zoomValue
{	
	NSString *point = [self createGLatLong:latValue longitude:lonValue];
	
	return [[[NSString alloc] initWithFormat:@"map.setCenter(%@, %d)",
			point, zoomValue] autorelease];
}

/**
 * Return a string Javascript command to zoom the map in one level centered on the current center
 * @return A string Javascript command to zoom the map in
 */
+(NSString *)zoomIn
{
	return [[[NSString alloc] initWithString:@"map.zoomIn()"] autorelease];
}

/**
 * Return a string Javascript command to zoom the map out one level centered on the current center
 * @return A string Javascript command to zoom the map out
 */
+(NSString *)zoomOut
{
	return [[[NSString alloc] initWithString:@"map.zoomOut()"] autorelease];
}

/**
 * Return a string Javascript command set the zoom to a new level, based on the input zoom level.
 * @param zoomLevel The level of zoom to set the map to
 * @return A string Javascript command to set the zoom level to the input zoom level
 */
+ (NSString *)setZoom:(NSInteger)zoomLevel
{
	return [[[NSString alloc] initWithFormat:@"map.setZoom(%d)", zoomLevel] autorelease];
}

/**
 * Return a string Javascript command to map a point on the map
 * @param latValue Latitude of the point to map
 * @param lonValue Longitude of the point to map
 * @return A string Javascript command to map a point based on the input params
 */
+ (NSString *)createMarker:(double)latValue 
				 longitude:(double)lonValue
{
	NSString *point = [self createGLatLong:latValue longitude:lonValue];
	
	return [[[NSString alloc] initWithFormat:@"map.addOverlay(new GMarker(%@))", point] autorelease];
}

/**
 * Return a Javascript command to make a new GLatLng Javascript structure
 * @param latValue Latitude used to construct the GLatLng structure
 * @param lonValue Longitude used to contsruct the GLatLng structure
 * @return A string Javascript command to createa GLatLng structure
 */
+ (NSString *)createGLatLong:(double)latValue longitude:(double)lonValue
{
	return [[[NSString alloc] initWithFormat:@"new GLatLng(%f, %f)", latValue, lonValue] autorelease];
}

/**
 * Returns a Javascript command that can be used to retrieve the north east latitude of a map
 * @return A string Javascript command to retrieve th north east latitude of a map
 */
+ (NSString *)northEastLatitude
{
	return [[[NSString alloc] initWithString:@"map.getBounds().getNorthEast().lat()"] autorelease];
}

/**
 * Returns a Javascript command that can be used to retrieve the north east longitude of a map
 * @return A string Javascript command to retrieve th north east longitude of a map
 */
+ (NSString *)northEastLongitude
{
	return [[[NSString alloc] initWithString:@"map.getBounds().getNorthEast().lng()"] autorelease];
}

/**
 * Returns a Javascript command that can be used to retrieve the southwest latitude of a map
 * @return A string Javascript command to retrieve th southwest latitude of a map
 */
+ (NSString *)southWestLatitude
{
	return [[[NSString alloc] initWithString:@"map.getBounds().getSouthWest().lat()"] autorelease];
}

/**
 * Returns a Javascript command that can be used to retrieve the southwest longitude of a map
 * @return A string Javascript command to retrieve th southwest longitude of a map
 */
+ (NSString *)southWestLongitude
{
	return [[[NSString alloc] initWithString:@"map.getBounds().getSouthWest().lng()"] autorelease];
}

/**
 * Returns a Javascript command that can be used to retrieve the current zoom level of the map
 * @return A string Javascript command to retrieve the map zoomlevel
 */
+ (NSString *)getZoom
{
	return [[[NSString alloc] initWithString:@"map.getZoom()"] autorelease];
}

/**
 * Returns a Javascript command that can be used change the map type to 'Normal'.
 * @return A string Javascript command to change the map type to 'Normal'
 */
+ (NSString *)getNormalMapTypeCommand
{
	return [[[NSString alloc] initWithString:@"map.setMapType(G_NORMAL_MAP)"] autorelease];
}

/**
 * Returns a Javascript command that can be used change the map type to 'Satellite'.
 * @return A string Javascript command to change the map type to 'Satellite'
 */
+ (NSString *)getSatelliteMapTypeCommand
{
	return [[[NSString alloc] initWithString:@"map.setMapType(G_SATELLITE_MAP)"] autorelease];
}

/**
 * Returns a Javascript command that can be used change the map type to 'Hybrid'.
 * @return A string Javascript command to change the map type to 'Hybrid'
 */
+ (NSString *)getHybridMapTypeCommand
{
	return [[[NSString alloc] initWithString:@"map.setMapType(G_HYBRID_MAP)"] autorelease];
}


@end
