/*
 *  MapView.m
 *  Visualizer
 *
 *  The class manages the WebView that contains the Google Map.  This class can be used to 
 *  manipulate the map, as well as get information from the map
 */

#import "MapView.h"
#import "JavascriptWrapper.h"
#import "NetworkReading.h"
#import "Constants.h"


/**
 * The String that defines the constant used for the MapMoveStart Notification
 */
NSString * const MapMoveStartNotification = @"MapMoveStart";
/**
 * The String that defines the constant used for the MapMoveEnd Notification
 */
NSString * const MapMoveEndNotification = @"MapMoveEnd";

/**
 * The String that defines the constant used for the MapLoadedNotification
 */
NSString * const MapLoadedNotification = @"MapLoaded";


@implementation MapView

@synthesize currentBounds;

- (id)init
{
	self = [super init];
    NSString *urlToLoad;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if([defaults boolForKey:PrefCenterOnFirstNetwork] == NO)
	{
		NSInteger startingLat = [defaults integerForKey:PrefStartingLatitude];
		NSInteger startingLong = [defaults integerForKey:PrefStartingLongitude];
		NSInteger zoom = [defaults integerForKey:PrefMapZoom];
		urlToLoad = [[NSString alloc] initWithFormat:@"http://www.oxfordhaus.com/map.html?lat=%l&lon=%l&zoom=%l", 
							   startingLat, startingLong, zoom];
	}
	else 
	{
		urlToLoad = [[NSString alloc] initWithString:@"http://www.heebnerd.com/maps/index.html"];
	}
	NSURL *mapFileURL = [NSURL URLWithString:urlToLoad];
	NSURLRequest *request = [NSURLRequest requestWithURL:mapFileURL];
	[[mapView mainFrame] loadRequest:request];
	[[[mapView mainFrame] frameView] setAllowsScrolling:NO];
	[mapView setNeedsDisplay:YES]; 
    
    [urlToLoad release];

	return self;
}


#pragma mark -
#pragma mark Methods called by Javascript

/**
 * Invoked when the user starts to move the map.  This method is invoked by Javacsript on the page that contains the 
 * map control
 */
- (void)mapMoveStart
{
	NSLog(@"Map moving started.");
	// Let's let the notification center know the map has started moving
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:MapMoveStartNotification object:self];
}


/**
 * Invoked when the user is finished moving the map.  This method is invoked by Javacsript on the page that contains the 
 * map control
 */
- (void)mapMoveEnd
{
	NSLog(@"Map moving ended.");
	
	currentBounds.northeastLatitude = [self getNorthEastLatitude];
	currentBounds.northeastLongitude = [self getNorthEastLongitude];
	currentBounds.southwestLatitude = [self getSouthWestLatitude];
	currentBounds.southwestLongitude = [self getSouthWestLongitude];
	currentBounds.currentZoomLevel = [self getMapZoomLevel];
	currentBounds.mapWidth = mapView.bounds.size.width;
	currentBounds.mapHeight = mapView.bounds.size.height;

	NSLog(@"New Map Bounds. Zoom Level:%i;  NELat:%f; NELong:%f; SWLat:%f; SWLong:%f", currentBounds.currentZoomLevel, currentBounds.northeastLatitude, 
		currentBounds.northeastLongitude, currentBounds.southwestLatitude, currentBounds.southwestLongitude);
	
	// Let's let the notification center know the map has ended moving
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:MapMoveEndNotification object:self];
	
	NSLog(@"Posting is done.");
}

/**
 * This method is called when Javacript tries to invoke a method in Objectice-C through the WebView.
 * This method is responsible for determining with methods can and cannot be called from Javascript
 * @param selector The pointer to a method in the class
 * @return A flag indicating if the method can be called 'NO' if it can be called (it's shouldn't be excluded)
 *			'YES' is can cannot be called (it shoudl be excluded)
 */
+ (BOOL)isSelectorExcludedFromWebScript:(SEL)selector
{
	if(selector == @selector(mapMoveEnd))
	{
		return NO;
	}
	else if(selector == @selector(mapMoveStart))
	{
		return NO;
	}
	return YES;
}

/**
 * This method is called when the 'isSelectorExcludedFromWebScript' method return 'NO'.  This
 * allows the mapping of a method name to account for special characters that would otherwise
 * throw off Javascript such as colons ':' and dollar signs '$'
 *
 * Currently the only method called from Javacscript is the 'redrawMaps' which takes no parameters.
 * Therefore there is no need to implement this method, but we're leaving in case we have to at a 
 * later time.
 */
+ (NSString *) webScriptNameForSelector:(SEL)sel
{
	// Currently the only method called from Javacscript is the 'redrawMaps' which takes no parameters.
	// Therefore there is no need to implement this method, but we're leaving in case we have to at a 
	// later time.
	return nil;
}

#pragma mark -
#pragma mark Map Commands
/**
 * This method can put multiple points on google map. It is assumed that the array contains
 * 'NetworkReadings' objects
 * @param pts A instance of the NSMutableArray containing NetworkReading objects
 */
- (void)mapMultiplePoints:(NSMutableArray *)pts
{
	for(int index = 0; index < [pts count]; index++)
	{
		NetworkReading *reading = [pts objectAtIndex:index];
		// Create the command to set a marker using the Javascript wrapper class
		NSString *cmd = [JavascriptWrapper createMarker:[reading latitude] longitude:[reading longitude]];
		[self sendCommandToMap:cmd];
	}
}

/**
 * Sends Javascript commands to the google map
 * @param command The string command to send to the google map
 */
- (void)sendCommandToMap:(NSString *)command
{
	// Get the window script object so we can send Javascript commands through
	id map = [mapView windowScriptObject];
	NSLog(@"Excuting command: %@", command);
	[map evaluateWebScript:command];
}

#pragma mark -
#pragma mark WebFrameLoadDelegate Methods

/**
 * Fires when the WebView is finished loading the last URL given to it to load. This is a method
 * implemented from the WebFramLoadDelegate
 * @param sender TThe class that invokes this message, this will be the WebView references but this MapView
 * @param frame Frame that finished loading
 */
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	NSLog(@"WebView is loaded");
	currentBounds = [[MapBounds alloc] init];
	currentBounds.northeastLatitude = [self getNorthEastLatitude];
	currentBounds.northeastLongitude = [self getNorthEastLongitude];
	currentBounds.southwestLatitude = [self getSouthWestLatitude];
	currentBounds.southwestLongitude = [self getSouthWestLongitude];
	currentBounds.currentZoomLevel = [self getMapZoomLevel];
	currentBounds.mapWidth = mapView.bounds.size.width;
	currentBounds.mapHeight = mapView.bounds.size.height;
	
	NSLog(@"New Map Bounds. Zoom Level:%i;  NELat:%f; NELong:%f; SWLat:%f; SWLong:%f", currentBounds.currentZoomLevel, currentBounds.northeastLatitude, 
		  currentBounds.northeastLongitude, currentBounds.southwestLatitude, currentBounds.southwestLongitude);
	
	// Let's let the notification center know the map is loaded
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:MapLoadedNotification object:self];
	
	// Let's let the notification center know the map has ended moving
	[nc postNotificationName:MapMoveEndNotification object:self];
	
}

/**
 * Invoked when a frame’s scripting object for a page is available. This method is invoked before 
 * the page is actually loaded.
 * @param sender The class that invokes this message, this will be the WebView references but this MapView
 * @param windowScriptObject The window object in the scripting environment
 */
- (void)webView:(WebView *)sender windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject
{
	NSLog(@"Window Script Object Available");
	// We're setting the 'MapView' key in Javascript to map to ourselves so the Javascript can
	// call methods on us
	[windowScriptObject setValue:self forKey:@"MapView"];
}

#pragma mark -
#pragma mark Map Metadata Methods

/**
 * Method sets the map type for the main map view. The input string is used to determine what type fo map to display
 * @param mapType String used ot determine what type of map to view. Input values are 'Normal', 'Satellite', and 'Hybrid'
 */
- (void)setMapType:(NSString *)mapType
{
	id map = [mapView windowScriptObject];
	
	if([mapType isEqualToString:@"Normal"] == YES)
	{
		[map evaluateWebScript:[JavascriptWrapper getNormalMapTypeCommand]];
	}
	else if([mapType isEqualToString:@"Satellite"] == YES)
	{
		[map evaluateWebScript:[JavascriptWrapper getSatelliteMapTypeCommand]];
	}
	else if([mapType isEqualToString:@"Hybrid"] == YES)
	{
		[map evaluateWebScript:[JavascriptWrapper getHybridMapTypeCommand]];
	}
}

/**
 * Retrieves the current zoom level of the map
 * @return The zoom level of the map as an int
 */
- (int)getMapZoomLevel
{
	id map = [mapView windowScriptObject];
	return [[map evaluateWebScript:[JavascriptWrapper getZoom]] intValue];
}

/**
 * Retrieves the latitude of the northeast corner of the map
 * @return Latitude of the northeast corner of the map as a float
 */
- (double)getNorthEastLatitude
{
	id map = [mapView windowScriptObject];
	return [[map evaluateWebScript:[JavascriptWrapper northEastLatitude]] doubleValue];
}

/**
 * Retrieves the longitude of the northeast corner of the map
 * @return Longitude of the northeast corner of the map as a float
 */
- (double)getNorthEastLongitude
{
	id map = [mapView windowScriptObject];
	return [[map evaluateWebScript:[JavascriptWrapper northEastLongitude]] doubleValue];
}

/**
 * Retrieves the latitude of the southwest corner of the map
 * @return Latitude of the southwest corner of the map as a float
 */
- (double)getSouthWestLatitude
{
	id map = [mapView windowScriptObject];
	return [[map evaluateWebScript:[JavascriptWrapper southWestLatitude]] doubleValue];
}

/**
 * Retrieves the longitude of the southwest corner of the map
 * @return Longitude of the southwest corner of the map as a float
 */
- (double)getSouthWestLongitude
{
	id map = [mapView windowScriptObject];
	return [[map evaluateWebScript:[JavascriptWrapper southWestLongitude]] doubleValue];
}

/**
 * Between the top and bottom of the map, this method returns the latitude that is closer to the equator
 * @return Laitude that is closer to the equator as a float
 */
- (double)getLesserLatitude
{
	float lat1 = [self getNorthEastLatitude];
	float lat2 = [self getSouthWestLatitude];
	if(lat1 <= lat2)
	{
		return lat1;
	}
	return lat2;
}

/**
 * Between the top and bottom of the map, this method returns the latitude that is further from the equator
 * @return Laitude that is furthest from the equator as a float
 */
- (double)getGreaterLatitude
{
	float lat1 = [self getNorthEastLatitude];
	float lat2 = [self getSouthWestLatitude];
	if(lat2 >= lat1)
	{
		return lat2;
	}
	return lat1;
}

/**
 * Between the left-side and right-side of the map, this method returns the longitude that is closer to the prime meridian
 * @return Longitude that is closet to the prime meridian as a float
 */
- (double)getLesserLongitude
{
	float long1 = [self getNorthEastLongitude];
	float long2 = [self getSouthWestLongitude];
	if(long1 <= long2)
	{
		return long1;
	}
	return long2;
}

/**
 * Between the left-side and right-side of the map, this method returns the longitude that is further from the prime meridian
 * @return Longitude that is further from the prime meridian as a float
 */
- (double)getGreaterLongitude
{
	float long1 = [self getNorthEastLongitude];
	float long2 = [self getSouthWestLongitude];
	if(long2 >= long1)
	{
		return long2;
	}
	return long1;
}

/**
 * Retrieves the distance, in degrees from the top to the bottom of the map
 * @return The distance in degrees from the top the bottom of the map
 */
- (double)getLongitudeSpan
{
	float retVal = fabs([self getNorthEastLongitude] - [self getSouthWestLongitude]);
	return retVal;
}

/**
 * Retrieves the distance, in degrees from the left to the right of the map
 * @return The distance in degrees from the left to the right of the map
 */
- (double)getLatitudeSpan
{
	float retVal = fabs([self getNorthEastLatitude] - [self getSouthWestLatitude]);
	return retVal;
}

- (void)dealloc
{
	[currentBounds release];
	[super dealloc];
}

@end
