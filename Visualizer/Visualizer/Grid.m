/*
 *  Grid.m
 *  Visualizer
 *
 *  This class is the "model" for drawing the grid on the map WebView control.
 *  
 */

#import "Grid.h"
#import <QuartzCore/QuartzCore.h>
#import "MapView.h"
#import "Constants.h"

/**
 * The int that defines the number of meeters in one degree latitude or longitude
 */
float const MetersInOneDegree = 111133.0;

@implementation Grid

@synthesize color;
@synthesize currentMapType;

- (id) init
{
	self = [super init];
		
	[self updateFromPreferences:nil];
	
	CFMakeCollectable(normalColor);
	CFMakeCollectable(satelliteColor);
	
	// Currently set to black
	color = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 0.7);
	CFMakeCollectable(color);
	zoomLevel = 17;
	shouldDrawGrid = YES;
	
	// Initialize as arary used to determin the number of gridlines at each zoom level.  Take the current zoom level and substract 10 to get the
	// correct number of gridlines for a given zoom level.
	gridlineIntervals[0] = 10000; // Distance between gridlines at zoom level 10 in meters
	gridlineIntervals[1] = 10000; // Distance between gridlines at zoom level 11 in meters
	gridlineIntervals[2] = 2000;  // Distance between gridlines at zoom level 12 in meters
	gridlineIntervals[3] = 1000;  // Distance between gridlines at zoom level 13 in meters
	gridlineIntervals[4] = 1000;  // Distance between gridlines at zoom level 14 in meters
	gridlineIntervals[5] = 200;   // Distance between gridlines at zoom level 15 in meters
	gridlineIntervals[6] = 100;   // Distance between gridlines at zoom level 16 in meters
	gridlineIntervals[7] = 100;   // Distance between gridlines at zoom level 17 in meters
	gridlineIntervals[8] = 50;    // Distance between gridlines at zoom level 18 in meters
	gridlineIntervals[9] = 10;    // Distance between gridlines at zoom level 19 in meters
	
	// Register for notifications we care about
	// Let's figure out when the map is done moving, we'll most likely have to redraw the grid
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(mapMoveEnded:) 
			   name:MapMoveEndNotification 
			 object:nil];
	[nc addObserver:self
		   selector:@selector(mapLoaded:) 
			   name:MapLoadedNotification
			 object:nil];
	[nc addObserver:self
		   selector:@selector(updateFromPreferences:)
			   name:PreferencesUpdatedNotification 
			 object:nil];
	
	return self;
}

#pragma mark -
#pragma mark Received Notifications
/**
 * Method that is invokes when the Notification Center raises the 'MapMoveEndedNotification'.  This method will rescale/redraw
 * the map based on the new bounds of the map view
 * @param note The Notification object associated will the Notification
 */
- (void)mapMoveEnded:(NSNotification *)note
{
	MapView *map = [note object];
	currentMapBounds = [map currentBounds];
}

/**
 * Method that is invoked when the map is loaded. 
 * @param note Object associated with the notification
 */
- (void)mapLoaded:(NSNotification *)note
{
	MapView *map = [note object];
	currentMapBounds = [map currentBounds];
}

/**
 * This method reads in the preferences and applies the ones applicable to the grid to the view
 * @param note The notification used to tell the Grid instance to read in the preferences
 */
- (void)updateFromPreferences:(NSNotification *)note
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSColor *tempColor;
	NSData *temp = [defaults dataForKey:PrefNormalMapGridColor];
    if(temp != nil) {
	tempColor = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:PrefNormalMapGridColor]];
	normalColor = CGColorCreateGenericRGB([tempColor redComponent], 
										  [tempColor greenComponent],
										  [tempColor blueComponent], 
										  [tempColor alphaComponent]);
	}
    
    temp = [defaults dataForKey:PrefSatelliteMapGridColor];
    if(temp != nil) {
	tempColor = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:PrefSatelliteMapGridColor]];
	satelliteColor = CGColorCreateGenericRGB([tempColor redComponent], 
											 [tempColor greenComponent],
											 [tempColor blueComponent], 
											 [tempColor alphaComponent]);
    }
}
/**
 * This method draws a grid on the input context.  This grid will not be drawn if the
 * zoom level of the map is less than 9, or if the flag to draw the grid is set to 'NO'
 * @param layer Layer that will contain the grid
 * @param ctx The context in which the grid should be drawn
 */
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	CGRect b = [layer bounds];
	// Having a zoom level isn't possible because the slider control won't allow it,
	// but in initialization, sometimes this method gets called while the zoom level is 0
	if(zoomLevel > 9 && shouldDrawGrid == YES)
	{
		NSLog(@"Drawing Grid");
		// This saves off the current context so we can draw everything, then display it all at
		// once when we're done.
		CGContextSaveGState(ctx);
		float width =  b.size.width;
		float height = b.size.height;
		
		// Setup the context to drawn using the colro defined in the init method
		if([currentMapType isEqualToString:@"Normal"] == YES)
		{
			CGContextSetStrokeColorWithColor(ctx, normalColor);
		}
		else if([currentMapType isEqualToString:@"Satellite"] == YES)
		{
			CGContextSetStrokeColorWithColor(ctx, satelliteColor);
		}
		else // it's hybrid
		{
			CGContextSetStrokeColorWithColor(ctx, satelliteColor);
		}
		CGContextSetLineWidth(ctx, 1.0);
		
		// Determine the latitude at which we should draw the first latitude gridline
		double startingLatitude = [self determineStartingLatitude];
		// Convert the starting latitude to a drawing point
		double currentLatitudePoint = [currentMapBounds convertLatitudeToPoint:startingLatitude];;
		
		// Now determine the longitude at which we should draw the first longitude gridline
		double startingLongitude = [self determineStartingLongitude];
		// Convert the starting longitude to a drawing point
		double currentLongitudePoint = [currentMapBounds convertLongitudeToPoint:startingLongitude];
		
		// For the current zoom level, determine the number meters per drawing point, then multiply
		// by the numbers of meters between grdlines to determine the number of drawing points between
		// gridlines
		double pointsBetweenGridlines = gridlineIntervals[currentMapBounds.currentZoomLevel - 10] / [currentMapBounds metersPerPoint];
		
		
		

		// Draw the longitude grid lines
		do
		{
			CGContextMoveToPoint(ctx, currentLongitudePoint, 0.0);
			CGContextAddLineToPoint(ctx, currentLongitudePoint, height);
			currentLongitudePoint += pointsBetweenGridlines;
		}while(currentLongitudePoint <= width);

		// Draw the latitude grid lines
		do
		{
			CGContextMoveToPoint(ctx, 0.0, currentLatitudePoint);
			CGContextAddLineToPoint(ctx, width, currentLatitudePoint);
			currentLatitudePoint += pointsBetweenGridlines;
		}while(currentLatitudePoint <= height);
		
		CGContextStrokePath(ctx);
		// Restore the context to the display, hopefully a grid now appears
		CGContextRestoreGState(ctx);
	}
}

/**
 * Determines the start longitude to begin drawing longitude grid lines
 * @return The longitude value to draw the first gridline at
 */
- (double)determineStartingLongitude
{
	// This is the number of meters between gridlines
	int metersBetweenGridlines = gridlineIntervals[currentMapBounds.currentZoomLevel - 10];
	
	// We need to determine the first place to draw a longitude gridline
	// This is the closest whole longitude value that is to the 
	int wholeLongitude = floor(currentMapBounds.southwestLongitude);
	double decimalPieceOfLongitude = fabs(currentMapBounds.southwestLongitude - wholeLongitude);
	
	// This is the number of meters that we are from the closest whole longitude. We calculate
	// this by mulitplying the const of number of meters in a degree with the decimal portion of the 
	// southwest longitude map bounds, we floor it because we don't care about partial meters at this point
	int metersInDecimalPortion = floor(decimalPieceOfLongitude * MetersInOneDegree);
	
	// Now we need to find the closest meter that will be divisble by the grid increment based on zoom level
	// This value should be the first position inside the map bounds, which is why we do the second
	// calculation
	int metersFromDivisor = metersInDecimalPortion % metersBetweenGridlines;
	int firstMeterDivisorInView = metersInDecimalPortion + (metersBetweenGridlines - metersFromDivisor);
	
	// Now that we know the first meter position we want to draw a gridlines that, let's convert it back
	// to a longitude
	double startingDecimalPortion = firstMeterDivisorInView / MetersInOneDegree;
	
	// Put the decimal portion back with the whole longitude
	double startingLongitudeDegreeValue = startingDecimalPortion + wholeLongitude;
	
	return startingLongitudeDegreeValue;
}

/**
 * Determines the start latitude to begin drawing latitude grid lines
 * @return The latitude value to draw the first gridline at
 */
- (double)determineStartingLatitude
{
	// This is the number of meters between gridlines
	int metersBetweenGridlines = gridlineIntervals[currentMapBounds.currentZoomLevel - 10];
	
	// We need to determine the first place to draw a latitude gridline
	int wholeLatitude = floor(currentMapBounds.southwestLatitude);
	double decimalPieceOfLatitude = fabs(currentMapBounds.southwestLatitude - wholeLatitude);
	
	// This is the number of meters that we are from the closest whole latitude. We calculate
	// this by mulitplying the const of number of meters in a degree with the decimal portion of the 
	// southwest longitude map bounds, we floor it because we don't care about partial meters at this point
	int metersInDecimalPortion = floor(decimalPieceOfLatitude * MetersInOneDegree);
	
	// Now we need to find the closest meter that will be divisble by the grid increment based on zoom level
	// This value should be the first position inside the map bounds, which is why we do the second
	// calculation
	int metersFromDivisor = metersInDecimalPortion % metersBetweenGridlines;
	int firstMeterDivisorInView = metersInDecimalPortion + (metersBetweenGridlines - metersFromDivisor);
	
	// Now that we know the first meter position we want to draw a gridlines that, let's convert it back
	// to a latitude
	double startingDecimalPortion = firstMeterDivisorInView / MetersInOneDegree;
	
	// Put the decimal portion back with the whole latitude
	double startingLatitudeDegreeValue = startingDecimalPortion + wholeLatitude;
	
	return startingLatitudeDegreeValue;
}

/**
 * Gets the current scale of the grid in meters
 */
- (int)currentMapScale
{
	return gridlineIntervals[currentMapBounds.currentZoomLevel - 10];
}
 

#pragma mark -
#pragma mark Properties

/**
 * Gets the Color of the grid
 * @return Color of the grid to be drawn
 */
- (CGColorRef)color
{
	return color;
}

/**
 * Gets the Zoom Level of the Grid
 */
- (int)zoomLevel{
	return zoomLevel;
}

/**
 * Sets the zoom level of the grid
 * @param zmLvl The current zoom level of the map
 */
- (void)setZoomLevel:(int)zmLvl{
	zoomLevel = zmLvl;
}

/**
 * Gets a flag as to whether of not the grid shoudlbe drawn
 */
- (BOOL)shouldDrawGrid{
	return shouldDrawGrid;
}

/**
 * Sets a flag indicating if the grid shoudl be drwan or not
 * @param drawFlag Flag as to whether or not to draw the map
 */
- (void)setShouldDrawGrid:(BOOL)drawFlag{
	shouldDrawGrid = drawFlag;
}

- (void)dealloc
{
	CFRelease(color);
	CFRelease(normalColor);
	CFRelease(satelliteColor);
	[normalMapGridColor release];
	[satelliteMapGridcolor release];
	[currentMapBounds release];
	[currentMapType release];
	[super dealloc];
}

@end
