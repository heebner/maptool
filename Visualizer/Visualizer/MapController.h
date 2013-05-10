/*
 *  MapController.h
 *  Visualizer
 *
 *  The class manages the Map WebView as was as any drawing being done on top of the map
 *  This class also manages the lat/long labels that surround the map.
 */

#import <Cocoa/Cocoa.h>
#import "MapView.h"
#import "NetworkView.h"
#import "HeatMap.h"
#import "SignalMagnitudeMap.h"
#import "SinglePointMap.h"
#import "SinglePoint.h"


/**
 MapController.h
 Visualizer

 The MapController is responsible for managing the map, and the area that surrounds the map.  The list of 
 responsibilities:
 <ul>
 <li>Handling user manipulation of the map</li>
 <li>Updating the NE and SW Longitude and Latitude text fields that surround the map</li>
 <li>Drawing visualizations on top of the map (Heat Map, Signal Magnitude, Trilateration)</li>
 <li>Drawing elements on the map such as the Grid or items from a KML Feed</li>
 </ul>
 The MapController holds references to an instance of NetworkView and MapView.  See the documentation for those classes to 
 determine their responsibilities.
 */
@interface MapController : NSObject {
	IBOutlet NetworkView *networkView; /**< NSView that lays on top of the WebView Map */
	IBOutlet MapView *map; /**< View that holds the WebView and sits underneath the network view */
	
	// Fields used to provide meta data for the user about the map
	IBOutlet NSTextField *southwestLatLabel; /**< Label for the southwest latitude */
	IBOutlet NSTextField *southwestLonLabel; /**< Label for the southwest longitude */
	IBOutlet NSTextField *northeastLatLabel; /**< Label for the northeast latitude */
	IBOutlet NSTextField *northeastLonLabel; /**< Label for the northeast longitude */
	IBOutlet NSTextField *scaleTextLabel; /**< Label that holds the text to the scale */
	IBOutlet NSTextField *scaleLabel; /**< Label for displaying the map scale */
	IBOutlet NSBox *mapBorder; /**< View that is the border for the map */
    IBOutlet NSSlider *zoomSlider; /**< Slides used to control the zoom of the map */

	HeatMap *heatMap; /**< Heat Map instance for all heat map plots */
	SignalMagnitudeMap *sigMagMap; /**< Signal Magnitude map for all Signal Magnitude plots*/
	NSMutableDictionary *singlePointMaps; /**< Collection of Single Point Maps indexed by the a name that described what's on the map */
}

@property(nonatomic, retain)IBOutlet NSSlider *zoomSlider;
- (IBAction)sliderValueChanged:(id)sender;

- (void)redrawMap;

- (void)mapMoveStarted:(NSNotification *)note;
- (void)mapMoveEnded:(NSNotification *)note;
- (void)mapLoaded:(NSNotification *)note;
- (void)updateMapLabels;
- (void)updateColorsForBorderAndText:(NSColor *)borderColor textcolor:(NSColor *)textColor;

- (void)addPointsToHeatMap:(NSArray *)points;
- (void)removePointsFromHeatMap:(NSArray *)points;
- (void)addPointsToSignalMagnitudeMap:(NSArray *)points;
- (void)removePointsFromSignalMagnitudeMap:(NSArray *)points;
- (void)addSinglePoint:(SinglePoint *)pt forMap:(NSString *)mapName;
- (void)removeSinglePoint:(SinglePoint *)pt forMap:(NSString *)mapName;
- (void)showSinglePointMapForName:(NSString *)mapName;
- (void)hideSinglePointMapForName:(NSString *)mapName;
- (void)clearMap;

- (void)shouldDrawGrid:(BOOL)shouldDrawFlag;
- (void)setZoomLevel:(NSInteger)zoomLevel;
- (void)changeMapType:(NSString *)mapType;
- (int)currentGridScale;
- (void)addPointToMap:(double)lat longitude:(double)lon;
- (void)centerMap:(SinglePoint *)coordinates;

@end
