/**
 *  MapView.h
 *  Visualizer
 *
 *  The class manages the WebView that contains the Google Map.  This class can be used to 
 *  manipulate the map, as well as get information from the map
 */

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "MapBounds.h"

/**
 * The String that defines the constant used for the MapMoveStart Notification
 */
extern NSString * const MapMoveStartNotification;

/**
 * The String that defines the constant used for the MapMoveEnd Notification
 */
extern NSString * const MapMoveEndNotification;

/**
 * The String that defines the constant used for the MapLoaded Notification
 */
extern NSString * const MapLoadedNotification;

/**
 *  MapView.h
 *  Visualizer
 *
 *  The class manages the WebView that contains the Google Map.  This class can be used to 
 *  manipulate the map, as well as get information from the map
 */
@interface MapView : NSObject {
	IBOutlet WebView *mapView;	/**< WebView object that holds the Google Map Object */
	MapBounds *currentBounds; /**< Instance of the MapBounds class that holds the curent bounds of the map window */
}

@property (nonatomic, retain)MapBounds *currentBounds;

#pragma mark -
#pragma mark Methods called by Javascript
- (void)mapMoveStart;
- (void)mapMoveEnd;

#pragma mark -
#pragma mark WebFrameLoadDelegate Methods
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame;
- (void)webView:(WebView *)sender windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject;

#pragma mark -
#pragma mark WindowScriptObject Methods
+ (BOOL)isSelectorExcludedFromWebScript:(SEL)selector;
+ (NSString *) webScriptNameForSelector:(SEL)sel;

#pragma mark -
#pragma mark Map Commands
- (void)sendCommandToMap:(NSString *)command;
- (void)mapMultiplePoints:(NSMutableArray *)pts;

#pragma mark -
#pragma mark Map Metadata Methods
- (int)getMapZoomLevel;
- (void)setMapType:(NSString *)mapType;
- (double)getNorthEastLatitude;
- (double)getNorthEastLongitude;
- (double)getSouthWestLatitude;
- (double)getSouthWestLongitude;

- (double)getLesserLatitude;
- (double)getGreaterLatitude;
- (double)getLesserLongitude;
- (double)getGreaterLongitude;

- (double)getLatitudeSpan;
- (double)getLongitudeSpan;
@end
