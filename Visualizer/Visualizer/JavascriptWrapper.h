/**
 *  JavascriptWrapper.h
 *  Visualizer
 *
 *  This class builds the Javascript command that can be interprets by the google map that is loaded into the WebView
 */

#import <Cocoa/Cocoa.h>


@interface JavascriptWrapper : NSObject {
	
}

+ (NSString *)setCenter:(double)latValue
			  longitude:(double)lonValue
			  zoomLevel:(int)zoomValue;

+ (NSString *)createMarker:(double)latValue 
				 longitude:(double)lonValue;


+ (NSString *)zoomIn;
+ (NSString *)zoomOut;

+ (NSString *)setZoom:(NSInteger)zoomLevel;
+ (NSString *)getZoom;

+ (NSString *)createGLatLong:(double)latValue longitude:(double)lonValue;

+ (NSString *)getNormalMapTypeCommand;
+ (NSString *)getSatelliteMapTypeCommand;
+ (NSString *)getHybridMapTypeCommand;

#pragma mark -
#pragma mark Map Bounds Methods

+ (NSString *)northEastLatitude;
+ (NSString *)northEastLongitude;
+ (NSString *)southWestLatitude;
+ (NSString *)southWestLongitude;

@end
