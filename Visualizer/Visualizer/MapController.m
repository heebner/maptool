//
//  MapController.m
//  Visualizer
//
//  Created by Ben Heebner on 10/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Quartz/Quartz.h>
#import "AppController.h"
#import "MapController.h"
#import "JavascriptWrapper.h"
#import "HeatMap.h"

/**
 * The String that defines the constant used for the AddHeatMapPlot Notification
 */
NSString * const AddHeatMapPlotNotification = @"AddHeatMapPlotNotification";

/**
 * The String that defines the constant used for the RemoveHeatMapPlotNotification Notification
 */
NSString * const RemoveHeatMapPlotNotification = @"RemoveHeatMapPlotNotification";

/**
 * The String that defines the constant used for the AddSigMagMapPlotNotification Notification
 */
NSString * const AddSigMagMapPlotNotification = @"AddSigMapPlotNotification";

/**
 * The String that defines the constant used for the RemoveSigMagMapPlotNotification Notification
 */
NSString * const RemoveSigMagMapPlotNotification  = @"RemoveSigMagNotification";

/**
 * The string that defines teh constant used for the RedrawLayers Notification
 */
NSString * const RedrawLayersNotification = @"RedrawLayersNotification";

@implementation MapController

@synthesize zoomSlider;

- (id)init
{
	self = [super init];
    // Register for Notifications we care about
	// We want to know when the map starts to move to we can hide the Network View (plots, grid)
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self 
		   selector:@selector(mapMoveStarted:) 
			   name:MapMoveStartNotification 
			 object:nil];
	
	// We want to know when the map stopped moving to we can unhide the Network View
	[nc addObserver:self
		   selector:@selector(mapMoveEnded:) 
			   name:MapMoveEndNotification 
			 object:nil];
	
	
	// We want to know when the map is enabled so we can enable the Grid Checkbox
	[nc addObserver:self
		   selector:@selector(mapLoaded:) 
			   name:MapLoadedNotification
			 object:nil];
	
	// Initialize the single map dictionary
	singlePointMaps = [[NSMutableDictionary alloc] init];
	
	return self;
}

- (void)awakeFromNib
{
	[map init];
	
	//Hide the scale related stuff until the grid is on
	[scaleLabel setHidden:YES];
	[scaleTextLabel setHidden:YES];
	
	//Rotate the Longitude Labels
	[southwestLonLabel setFrameCenterRotation:90.0];
	[northeastLonLabel setFrameCenterRotation:-90.0];
}

/**
 * Method that updates the Lat/Long labels on the main display to show teh current corners of the map view 
 */
- (void)updateMapLabels
{
	NSString *swLong = [[NSString alloc] initWithFormat:@"%f", [[map currentBounds] southwestLongitude]];
	[southwestLonLabel setStringValue:swLong];
	
	NSString *swLat = [[NSString alloc] initWithFormat:@"%f", [[map currentBounds] southwestLatitude]];
	[southwestLatLabel setStringValue:swLat];
	
	NSString *neLong = [[NSString alloc] initWithFormat:@"%f", [[map currentBounds] northeastLongitude]];
	[northeastLonLabel setStringValue:neLong];
	
	NSString *neLat = [[NSString alloc] initWithFormat:@"%f", [[map currentBounds] northeastLatitude]];
	[northeastLatLabel setStringValue:neLat];
	
	NSString *scale = [[NSString alloc] initWithFormat:@"%i meters", [networkView currentGridScale]];
	[scaleLabel setStringValue:scale];
	
	[swLong release];
	[swLat release];
	[neLong release];
	[neLat release];
	[scale release];
}

/**
 * Updates the border that surrounds the map and the text that appears in the border with the input colors
 * @param borderColor The color to change the border around the map to
 * @param textColor The color to change the text in the map border to
 */
- (void)updateColorsForBorderAndText:(NSColor *)borderColor textcolor:(NSColor *)textColor
{
	[mapBorder setFillColor:borderColor];
	[southwestLonLabel setTextColor:textColor];
	[southwestLatLabel setTextColor:textColor];
	[northeastLonLabel setTextColor:textColor];
	[northeastLatLabel setTextColor:textColor];
	[scaleLabel setTextColor:textColor];
	[scaleTextLabel setTextColor:textColor];
}

/**
 * Method that is invoked whenever the zoom silder on the HMI changes it's value
 * @param sender The zoom slider
 */
- (IBAction)sliderValueChanged:(id)sender
{
	NSLog(@"Zoom Level: %d", [zoomSlider intValue]);
	[self setZoomLevel:[zoomSlider intValue]];
}

#pragma mark -
#pragma mark Received Notifications

/**
 * Method that is invoked when the map starts to move.  The AppController will hide the Network View because ew're not going
 * to try and redraw the view as the map moves at this point
 * @param note Object associated with the notification
 */
- (void)mapMoveStarted:(NSNotification *)note
{
	[[networkView layer] setHidden:YES];
}

/**
 * Method that is invoked when the map starts to move.  The AppController will show the Network View because we're not going
 * to try and redraw the view as the map moves at this point, so we want to display the grid and plots once the map is done moving
 * @param note Object associated with the notification
 */
- (void)mapMoveEnded:(NSNotification *)note
{
	[self updateMapLabels];
    [self redrawMap];
	[[networkView layer] setHidden:NO];
}

/**
 * Method that is invoked when the map is loaded.  We can't show the grid until the map is loaded, so we
 * won't allow the user to turn it on until the map is loaded
 * @param note Object associated with the notification
 */
- (void)mapLoaded:(NSNotification *)note
{
	[self updateMapLabels];
}


/**
 * Method used to determine is the grid should be drawn or not
 * @param shouldDrawFlag Flag used to determine if the grid should be drawn. YES if the grid should be drawn.
 */
- (void)shouldDrawGrid:(BOOL)shouldDrawFlag
{
	[networkView setShouldDrawGrid:shouldDrawFlag];
	[scaleLabel setHidden:!shouldDrawFlag];
	[scaleTextLabel setHidden:!shouldDrawFlag];
}

/**
 * Sets the zoom level of the map
 * @param zoomLevel The level to set the map zoom to
 */
- (void)setZoomLevel:(NSInteger)zoomLevel
{
	[map sendCommandToMap:[JavascriptWrapper setZoom:zoomLevel]];
}

/**
 * Changes the type of map this is displayed.  Use 'Normal' for a regular vector maps (no ground images).  'Satellite' for ground images. 'Hybrid' for
 * labeled streets and road on top of ground images.
 * @param mapType The string used to determine what time of map the map should change to
 */
- (void)changeMapType:(NSString *)mapType
{
	// Set the map type on the map
	[map setMapType:mapType];
	[networkView setMapType:mapType];
}

/**
 * This method adds points to the current Signal Magnitude Map
 * @param points The points to add to the Signal Magintude map
 */
- (void)addPointsToSignalMagnitudeMap:(NSArray *)points
{
	if(sigMagMap == nil)
	{
		sigMagMap = [[SignalMagnitudeMap alloc] initWithMapBounds:[map currentBounds]];	
		[sigMagMap addPlotsToMap:points];
		CALayer *newLayer = [CALayer layer];
		[newLayer setDelegate:sigMagMap];
		
		CGRect b = [[networkView layer] bounds];
		[newLayer setFrame:b];
		[[networkView layer] addSublayer:newLayer];
		[newLayer display];
	}
	else
	{
		[sigMagMap addPlotsToMap:points];
		[self redrawMap];
	}
}

/**
 * Removes in the input points from the Signal Magnitude Map
 * @param points Points to remove from the Signal Magnitude Map
 */
- (void)removePointsFromSignalMagnitudeMap:(NSArray *)points
{
	[sigMagMap removePlotsFromMap:points];
	[self redrawMap];
}

/**
 * This method adds points to the current Heat Map
 * @param points The points to add to the heat map
 */
- (void)addPointsToHeatMap:(NSArray *)points
{
	if(heatMap == nil)
	{
		heatMap = [[HeatMap alloc] initWithMapBounds:[map currentBounds]];	
		[heatMap addPlotsToMap:points];
		CALayer *newLayer = [CALayer layer];
		[newLayer setDelegate:heatMap];
		
		CGRect b = [[networkView layer] bounds];
		[newLayer setFrame:b];
		[[networkView layer] addSublayer:newLayer];
		[newLayer display];
	}
	else
	{
		[heatMap addPlotsToMap:points];
		[self redrawMap];
	}
}

/**
 * Removes in the input points from the Heat Map
 * @param points Points to remove from the Heat Map
 */
- (void)removePointsFromHeatMap:(NSArray *)points
{
	[heatMap removePlotsFromMap:points];
	[self redrawMap];
}

/**
 * Adds a single point to the map
 * @param pt Point to add to the map
 * @param mapName The map to add the point to. If the map doesn't exist yet it will be created and then the point will be added to it
 */
- (void)addSinglePoint:(SinglePoint *)pt forMap:(NSString *)mapName
{
    if([singlePointMaps objectForKey:mapName] == nil)
	{
		SinglePointMap *spm = [[SinglePointMap alloc] initWithMapBounds:[map currentBounds]];
		[spm addPlotToMap:pt];
		//CALayer *newLayer = [CALayer layer];
        
        //[newLayer setDelegate:spm];
        CGRect b = [[networkView layer] bounds];
        [[spm mainPointMapLayer] setFrame:b];
        [[networkView layer] addSublayer:[spm mainPointMapLayer]];
        [[spm mainPointMapLayer] display];
        [singlePointMaps setObject:spm forKey:mapName];
        
        [spm release];
        
	}
	else
	{
		SinglePointMap *spm = [singlePointMaps objectForKey:mapName];
		[spm addPlotToMap:pt];
		[self redrawMap];
	}
}

/**
 * Removes the input plot from the map
 * @param pt Point to remove from the map
 * @param mapName The name of the map to remove the point from.  If it's the last point on the map, the map is removed as well
 */
- (void)removeSinglePoint:(SinglePoint *)pt forMap:(NSString *)mapName
{
	SinglePointMap *spm = [singlePointMaps objectForKey:mapName];
	[spm removePlotFromMap:pt];
	if([spm numberOfPlotsOnLayer] == 0)
	{
         
		[[spm mainPointMapLayer] removeFromSuperlayer];
		[singlePointMaps removeObjectForKey:mapName];
	}
	[self redrawMap];
}

/**
 * Hides the single point map for the input name
 * @param mapName The name of the SinglePoint map to hide
 */
- (void)showSinglePointMapForName:(NSString *)mapName {
    SinglePointMap *spm = [singlePointMaps objectForKey:mapName];
    [[spm mainPointMapLayer] setHidden:NO];
    [self redrawMap];
}

/**
 * Shows the single point map for the input name
 * @param mapName The name of the SinglePoint map to show
 */
- (void)hideSinglePointMapForName:(NSString *)mapName {
    SinglePointMap *spm = [singlePointMaps objectForKey:mapName];
    [[spm mainPointMapLayer] setHidden:YES];
    [self redrawMap];
}

/**
 * Clears the map of all plots
 */
- (void)clearMap
{
	if(heatMap != nil)
	{
		[heatMap clearMap];
	}
	
	if(sigMagMap != nil)
	{
		[sigMagMap clearMap];
	}
	
	for(SinglePointMap *spm in [singlePointMaps allValues])
	{
		[spm clearMap];
	}
}

/**
 * This method tells the network view to redraw itself
 */
- (void)redrawMap
{
	SinglePointMap *trilaterationLayer = nil;
    NSArray *allMaps = [singlePointMaps allValues];
	// We do this because we want the single point maps on top of all other plots
	for(SinglePointMap *spm in allMaps)
	{
		[[spm mainPointMapLayer] removeFromSuperlayer];
		if([[[singlePointMaps allKeysForObject:spm] objectAtIndex:0] isEqualToString:TrilateratedPointMapName] == YES)
		{
			trilaterationLayer = spm;
		}
		else
		{
			[[networkView layer] addSublayer:[spm mainPointMapLayer]];
		}
	}
	if(trilaterationLayer != nil)
	{
		[[networkView layer] addSublayer:[trilaterationLayer mainPointMapLayer]];
	}
	[networkView redrawLayers];
}

/**
 * Gets the current grid scale in meters
 * @return The length of one grid box in meters
 */
- (int)currentGridScale
{
	return [networkView currentGridScale];
}

/**
 * This method uses Javascript to add a marker on the map 
 * @param lat The latitude of the point to create a marker at
 * @param lon The longitude of the point to create a marker at
 */
- (void)addPointToMap:(double)lat longitude:(double)lon
{
	[map sendCommandToMap:[JavascriptWrapper createMarker:lat longitude:lon]];
}

/**
 * This method centers the map using the input lat/long and the current zoom level
 * @param coordinates The instance of the SinglePoint class that contains the data to center the map on
 */
- (void)centerMap:(SinglePoint *)coordinates
{
	[map sendCommandToMap:[JavascriptWrapper setCenter:coordinates.latitude longitude:coordinates.longitude zoomLevel:[networkView zoomLevel]]];
}

- (void)dealloc
{
	[heatMap release];
	[sigMagMap release];
	[singlePointMaps release];
    [zoomSlider release];
	[super dealloc];
}

@end
