//
//  AnimationController.m
//  Visualizer
//
//  Created by Ben Heebner on 11/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AnimationController.h"
#import "AppController.h"

NSString * const PlayEnabledActive = @"PlayEnabledActive";
NSString * const PlayPressedActive = @"PlayPressedActive";
NSString * const PauseEnabledActive = @"PauseEnabledActive";
NSString * const PausePressedActive = @"PausePressedActive";
NSString * const BackwardEnabledActive = @"BackwardEnabledActive";
NSString * const BackwardPressedActive = @"BackwardPressedActive";
NSString * const BeginningEnabledActive = @"BeginningEnabledActive";
NSString * const BeginningPressedActive = @"BeginningPressedActive";
NSString * const EndEnabledActive = @"EndEnabledActive";
NSString * const EndPressedActive = @"EndPressedActive";
NSString * const ForwardEnabledActive = @"ForwardEnabledActive";
NSString * const ForwardPressedActive = @"ForwardPressedActive";
int const WindowBuffer = 4;

@implementation AnimationController

@synthesize animationDrawer;

- (id)init
{
	self = [super init];
    plots = [[NSMutableDictionary alloc] init];
	
	// Create an array of colors to use
	colors = [[NSMutableArray alloc] initWithCapacity:9];
	// purple
	[colors addObject:[CPColor colorWithComponentRed:0.196 green:0.110 blue:0.439 alpha:1.0]];
	// pink
	[colors addObject:[CPColor colorWithComponentRed:0.922 green:0.082 blue:0.376 alpha:1.0]];
	// red
	[colors addObject:[CPColor colorWithComponentRed:0.824 green:0.086 blue:0.098 alpha:1.0]];
	// orange
	[colors addObject:[CPColor colorWithComponentRed:0.863 green:0.325 blue:0.086 alpha:1.0]];
	// gold
	[colors addObject:[CPColor colorWithComponentRed:0.996 green:0.667 blue:0.208 alpha:1.0]];
	// green
	[colors addObject:[CPColor colorWithComponentRed:0.294 green:0.498 blue:0.094 alpha:1.0]];
	// blue green
	[colors addObject:[CPColor colorWithComponentRed:0.196 green:0.714 blue:0.439 alpha:1.0]];
	// blue
	[colors addObject:[CPColor colorWithComponentRed:0.141 green:0.235 blue:0.820 alpha:1.0]];
	// light blue
	[colors addObject:[CPColor colorWithComponentRed:0.392 green:0.537 blue:0.980 alpha:1.0]];
	
	
	// Let's build an array of images to use on for the controls
	imagesDictionary = [[NSMutableDictionary alloc] init];
	
	// Play button ">"
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PlayEnabledActiveLeopard" ofType:@"tiff"]];
	[imagesDictionary setObject:image forKey:PlayEnabledActive];
    [image release];
    
    // Pause Button "||"
    image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:
                                                     @"PauseEnabledActiveLeopard" ofType:@"tiff"]];
	[imagesDictionary setObject:image forKey:PauseEnabledActive];
    [image release];

    image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:
                                                     @"PausePressedActiveLeopard" ofType:@"tiff"]];
	[imagesDictionary setObject:image forKey:PausePressedActive];
    [image release];
	
	// Backward Button "<<"
    image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:
                                                     @"BackwardEnabledActiveLeopard" ofType:@"tiff"]];
	[imagesDictionary setObject:image forKey:BackwardEnabledActive];
    [image release];
    
    image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:
                                                     @"BackwardPressedActiveLeopard" ofType:@"tiff"]];
	[imagesDictionary setObject:image forKey:BackwardPressedActive];
    [image release];
	
	// Beginning Button "|<"
    image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:
                                                     @"BeginningEnabledActiveLeopard" ofType:@"tiff"]];
	[imagesDictionary setObject:image forKey:BeginningEnabledActive];
    [image release];
    
    image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: 
                                                     @"BeginningPressedActiveLeopard" ofType:@"tiff"]];
	[imagesDictionary setObject:image forKey:BeginningPressedActive];
    [image release];
	
	// End Button ">|"
    image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: 
                                                     @"EndEnabledActiveLeopard" ofType:@"tiff"]];
	[imagesDictionary setObject:image forKey:EndEnabledActive];
    [image release];
    
    image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: 
                                                     @"EndPressedActiveLeopard" ofType:@"tiff"]];
	[imagesDictionary setObject:image forKey:EndPressedActive];
    [image release];
	
	// Forward Button ">>"
    image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: 
                                                     @"ForwardEnabledActiveLeopard" ofType:@"tiff"]];
	[imagesDictionary setObject:image forKey:ForwardEnabledActive];
    [image release];
    
    image = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource: 
                                                     @"ForwardPressedActiveLeopard" ofType:@"tiff"]];
	[imagesDictionary setObject:image forKey:ForwardPressedActive];
    [image release];
	
	
	return self;
}

-(void)awakeFromNib
{
	[playPauseImageView setImage:[imagesDictionary objectForKey:PlayEnabledActive]];
	[forwardImageView setImage:[imagesDictionary objectForKey:ForwardEnabledActive]];
	[backwardImageView setImage:[imagesDictionary objectForKey:BackwardEnabledActive]];
	[endImageView setImage:[imagesDictionary objectForKey:EndEnabledActive]];
	[beginningImageView setImage:[imagesDictionary objectForKey:BeginningEnabledActive]];
	[self buildGraph];
}

#pragma mark -
#pragma mark Animation Methods



/**
 * Method that toggles the showing/hiding of the animation drawer along the bottom of the page
 * @param sender The button that was clicked to show/hide the properties drawer
 */
- (IBAction)toggleDrawer:(id)sender
{
	NSDrawerState state = [animationDrawer state];
	if(NSDrawerOpeningState == state || NSDrawerOpenState == state)
	{
		[animationDrawer close];
		[self resetMapAfterClosing];
	}
	else
	{ 
		[animationDrawer open];
		[self initializeMapAfterOpening];
	}
}

/**
 * This method restores the map on the main display to display the full contents of each checked network, instead
 * of the time based display that is used while in animation mode
 */
- (void)resetMapAfterClosing
{
	// Clears the map
	[mapController clearMap];
	
	// Re-plots the contents of each network depending on the flags checked for each type of visualization
	for(NetworkPlot *np in [plots allValues])
	{
		if([[np network] shouldPlotAsHeatMap] == YES)
		{
			[mapController addPointsToHeatMap:[[np network] readings]];
		}
		if([[np network] shouldPlotAsSigMagMap] == YES)
		{
			[mapController addPointsToSignalMagnitudeMap:[[np network] readings]];
		}
		if([[np network] shouldShowTrilateration] == YES)
		{
			[mapController addSinglePoint:[[np network] getTrilateratedPoint] forMap:TrilateratedPointMapName];
		}
	}
	
	// Set the map border and text back to their original colors
	[mapController updateColorsForBorderAndText:[NSColor colorWithDeviceRed:0.2980 green:0.2980 blue:0.2980 alpha:1.0]
									  textcolor:[NSColor colorWithDeviceRed:0.8471 green:0.8471 blue:0.8471 alpha:1.0]];
}

/**
 * Clears out the map, then adds only the points in view of the timeline slider
 */
- (void)initializeMapAfterOpening
{
	
	// Let's set the slider to 2, then we're going ot show what's in the current index plus/minus 2
	[timelineSlider setIntValue:[timelineSlider minValue] + WindowBuffer];
	
	// Set the map border and text to different colors to let the user know we're in animation mode
	[mapController updateColorsForBorderAndText:[NSColor colorWithDeviceRed:0.7020 green:0.7020 blue:0.7020 alpha:0.7020]
									  textcolor:[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:1.0]];

	[self update];

}

#pragma mark _
#pragma mark Methods for histogram Creation/Manipulation
/**
 * This method adds a network to the group of network currently available to animate. 
 * @param network The network to add
 */
- (void)addNetworkToAnimate:(Network *)network
{
	// We need to determine if the input network's earliest sample time is earlier than the graphs start time
	// and/or of the latest sample time is later than the graphs end time 
	BOOL startEndChanged = NO;
	
	if([plots count] == 0)
	{
		// This means the network passed in the first, so we can just set the graph start/end to whatever the 
		// input network's values are
		graphStart = [network earliestSampleDate];
		graphEnd = [network latestSampleDate];
		startEndChanged = YES;
	}
	else
	{
		if([graphStart earlierDate:[network earliestSampleDate]] != graphStart)
		{
			graphStart = [network earliestSampleDate];
			startEndChanged = YES;
		}
		if([graphEnd laterDate:[network latestSampleDate]] != graphEnd)
		{
			graphEnd = [network latestSampleDate];
			startEndChanged = YES;
		}
	}
	
	// Add and create 
	NetworkPlot *newPlot = [[NetworkPlot alloc] initWithNetwork:network];
	[plots setObject:newPlot forKey:[network BSSID]];
	
	if(startEndChanged == YES)
	{
		[self recalculateGraphData];
	}
	else
	{
		NSTimeInterval interval = ([graphEnd timeIntervalSinceDate:graphStart] / [timelineSlider maxValue]);
		[newPlot recalculatePlotsWithStartDate:graphStart interval:interval numberOfPlots:(int)([timelineSlider maxValue] + 1)];
	}
	
	NSDrawerState state = [animationDrawer state];
	if(NSDrawerOpeningState == state || NSDrawerOpenState == state)
	{
		[self update];
	}
	
	[self setGraphAxis];
	
	[newPlot release];
}

/**
 * This method removes the input network from the histogram and from being animated
 * @param network The network to remove
 */
- (void)removeNetwork:(Network *)network
{
	[plots removeObjectForKey:[network BSSID]];
	
	BOOL startEndChanged = NO;
	
	if([plots count] != 0)
	{
		if([graphStart earlierDate:[network earliestSampleDate]] == graphStart)
		{
			graphStart = [self findEarliestPlotStartDate];
			startEndChanged = YES;
		}
		if([graphEnd laterDate:[network latestSampleDate]] == graphEnd)
		{
			graphEnd = [self findLatestPlotEndDate];
			startEndChanged = YES;
		}
		
	}
	else
	{
		graphStart = nil;
		graphEnd = nil;
		startEndChanged = YES;
	}
	
	if(startEndChanged)
	{
		[self recalculateGraphData];
	}

	[self setGraphAxis];
	NSDrawerState state = [animationDrawer state];
	if(NSDrawerOpeningState == state || NSDrawerOpenState == state)
	{
		[self update];
	}
}

/**
 * This method loops over all of the networks and recalculates the plots based on the graph start and end and interval.
 * This method also updates the start time and end time text that sits below the histogram with the current graphStart and
 * graphEnd values
 */
- (void)recalculateGraphData
{		
	NSTimeInterval interval = ([graphEnd timeIntervalSinceDate:graphStart] / [timelineSlider maxValue]);
	
	for(NetworkPlot *np in [plots allValues])
	{
		[np recalculatePlotsWithStartDate:graphStart interval:interval numberOfPlots:(int)([timelineSlider maxValue] + 1)];
	}
	
	if(graphStart == nil || graphEnd == nil)
	{
		[graphStartText setStringValue:@"No AP Checked"];
		[graphEndText setStringValue:@"No AP Checked"];
	}
	else 
	{
		[graphStartText setStringValue:[graphStart descriptionWithCalendarFormat:@"%Y-%m-%d  %H:%M:%S" timeZone:nil locale:nil]];
		[graphEndText setStringValue:[graphEnd descriptionWithCalendarFormat:@"%Y-%m-%d  %H:%M:%S" timeZone:nil locale:nil]];
	}
}

/**
 * This method loops through all plots and finds the earliest signal sample time
 * @return The date of the earliest signal sample
 */
- (NSDate *)findEarliestPlotStartDate
{
	NSDate *earliestStart = [NSDate distantFuture];
	
	// Loop through each of the plots to find the earliest start
	for(NetworkPlot *np in [plots allValues])
	{
		if([[[np network] earliestSampleDate] earlierDate:earliestStart] == [[np network] earliestSampleDate])
		{
			earliestStart = [[np network] earliestSampleDate];
		}
	}
	
	return earliestStart;
}

/**
 * This method loops through all plots and finds the latest signal sample time
 * @return The date of the latest signal sample
 */
- (NSDate *)findLatestPlotEndDate
{
	NSDate *latestEnd = [NSDate distantPast];
	// Loop through each of the plots to find the latest end
	for(NetworkPlot *np in [plots allValues])
	{
		if([[[np network] latestSampleDate] laterDate:latestEnd] == [[np network] latestSampleDate])
		{
			latestEnd = [[np network] latestSampleDate];
		}
	}
	
	return latestEnd;
}

/**
 * This method determines what the scales of the X and Y axes on the graph should be.  The X axis is based on max and min values on the slider
 * The Y axis is based on the highest number of samples for any given reading on the histgram.  That value plus 10% is the value
 * used to set the max of the Y axis
 */
- (void)setGraphAxis
{
	long highestVal = 0;
	long temp = 0;
	
	for(int index = 0;index < [timelineSlider maxValue]; index++)
	{
		for(NetworkPlot *np in [plots allValues])
		{
			temp = temp + [[[np plots] objectAtIndex:index] count];
		}
		if(temp > highestVal)
		{
			highestVal = temp;
		}
		temp = 0;
	}
	
	CPXYPlotSpace *plotSpace = (CPXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(-1.0) length:CPDecimalFromFloat([timelineSlider maxValue] + 1)];
    plotSpace.yRange = [CPPlotRange plotRangeWithLocation:CPDecimalFromFloat(0.0) length:CPDecimalFromFloat(ceil(highestVal * 1.1))];
	[graph reloadData];
}


/**
 * This method builds the histogram for the animation drawer
 */
- (void)buildGraph
{
	// Create the graph
	graph = [(CPXYGraph *)[CPXYGraph alloc] initWithFrame:[hostView bounds]];
	hostView.hostedLayer = graph;
	
	// Remove axes
	graph.axisSet = nil;
	
	//Background
	CGColorRef grayColor = CGColorCreateGenericGray(0.7, 1.0);
	graph.fill = [CPFill fillWithColor:[CPColor colorWithCGColor:grayColor]];
	CGColorRelease(grayColor);
	
	// Plot area
	grayColor = CGColorCreateGenericGray(0.2, 0.3);
	graph.plotArea.fill = [CPFill fillWithColor:[CPColor colorWithCGColor:grayColor]];
	CGColorRelease(grayColor);
	
	// Set the padding around the graph to the edge of the hosting view
	graph.paddingTop = 0.f;
	graph.paddingBottom = 0.f;
	graph.paddingRight = 0.f;
	graph.paddingLeft = 0.f;
	
	// Setup plot space
	[self setGraphAxis];
	
	// Create the Histogram
	mainPlot = [[(CPBarPlot *)[CPBarPlot alloc] initWithFrame:graph.bounds] autorelease];
	mainPlot.identifier = @"mainPlot";
	mainPlot.fill = [CPFill fillWithColor:[CPColor redColor]];
	mainPlot.barWidth = 5.f;
	mainPlot.dataSource = self;
	[graph addPlot:mainPlot];
}

#pragma mark -
#pragma mark Plot Data Source Methods

/**
 * Method that returns the number of points for an input plot
 * @param plot The plot to return the number of points for
 # @return The number of points for the input plot
 */
-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot
{
	if([plots count] != 0)
	{
		// We generate a plot for each whole value on the slider
		return [timelineSlider maxValue];
	}
	else
	{
		return 0;
	}
}
/**
 * This method returns the point value (x or y depening on the fieldEnum value) for an input
 * plot, fieldEnum and index
 * @param plot The plot to return the value for
 * @param fieldEnum An enum for the field to return (either X or Y)
 * @param index The index of the point to return a value for
 * @return The X or Y value for the input plot and index
 */
-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	NSNumber *num;
	long count = 0;
	
	switch (fieldEnum) {
		case CPScatterPlotFieldX:
			num = [NSNumber numberWithUnsignedInteger:index];
			break;
		case CPScatterPlotFieldY:
			for(NetworkPlot *np in [plots allValues])
			{
				count = count + [[[np plots] objectAtIndex:index] count];
			}
			num = [NSNumber numberWithLong:count];
			break;
		default:
			num = [NSDecimalNumber zero];
	};
    return num;
}

/**
 * This method is called by the CPBarPlot instance to determine the color
 * that should be used for plot.  The color of the plot changes depending on the
 * location of the timeline slider
 */
- (CPFill *)barFillForBarPlot:(CPBarPlot *)barPlot recordIndex:(NSUInteger)index
{
	// We do this because the input index is an unsigned it which 
	NSInteger tempStartIndex = ([timelineSlider intValue] - WindowBuffer);
	if([timelineSlider intValue] < WindowBuffer)
	{
		tempStartIndex = 0;
	}
	if(index >= tempStartIndex && index <= ([timelineSlider intValue] + WindowBuffer))
	{
		return [CPFill fillWithColor:[CPColor colorWithComponentRed:0.2667 green:0.5373 blue:0.8314 alpha:1.0]];
	}

	return [CPFill fillWithColor:[CPColor redColor]];
	
}

/**
 * This method clears the contents of the map, then redraws the plots based on the value of the timeline slider
 */
- (void)update
{
	[mapController clearMap];
	
	int tempStartIndex = 0;
	int tempEndIndex = [timelineSlider maxValue];
	if([timelineSlider intValue] >= WindowBuffer)
	{
		tempStartIndex = [timelineSlider intValue] - WindowBuffer;
	}
	if([timelineSlider intValue] + WindowBuffer < [timelineSlider maxValue])
	{
		tempEndIndex = [timelineSlider intValue] + WindowBuffer;
	}
	for(int index = tempStartIndex; index <= tempEndIndex; index++)
	{
		for(NetworkPlot *np in [plots allValues])
		{
			[mapController addPointsToHeatMap:[[np plots] objectAtIndex:index]];
		}
	}
	
	[mapController redrawMap];
	[graph reloadData];
}

#pragma mark -
#pragma mark Animation Control Methods

/**
 * This method is called whenever the user manipulates the timeline slider control.  This forces
 * an update of the map
 * @param sender The timeline slider
 */
- (IBAction)timelineSliderMoved:(id)sender
{
	[self update];
}

/**
 * Increments the value of the timeline slider by 1, then calls the update method
 */
- (void)stepTimelineForward
{
	[timelineSlider setIntValue:[timelineSlider intValue] + 1];
	[self update];
}

/**
 * Decrements the value of the timeline slider by 1, then calls the update method
 */
- (void)stepTimelineBackward
{
	[timelineSlider setIntValue:[timelineSlider intValue] - 1];
	[self update];
}

/**
 * Catch all method for any mouse down event for any of the player buttons.  This method
 * determines which button invoked the method and responds.
 */
- (void)mouseDown:(NSEvent *)event sender:(id)sender
{
	
	if(sender == playPauseImageView)
	{
		// If we're playing or paused, set the image to pressed
		if([playPauseImageView image] == [imagesDictionary objectForKey:PlayEnabledActive])
		{
			[playPauseImageView setImage:[imagesDictionary objectForKey:PlayPressedActive]];
		}
		else if([playPauseImageView image] == [imagesDictionary objectForKey:PauseEnabledActive])
		{
			[playPauseImageView setImage:[imagesDictionary objectForKey:PausePressedActive]];
		}
	}
	else if(sender == forwardImageView)
	{
		// Set the button to be pressed, then start a timer which will start the playing of data
		// forward in time only to stop when the user releases the button
		[forwardImageView setImage:[imagesDictionary objectForKey:ForwardPressedActive]];
		mouseDownTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(stepTimelineForward) userInfo:nil repeats:YES];
	}
	else if(sender == backwardImageView)
	{
		// Set the button to be pressed, then start a timer which will start the playing of data
		// backward in time only to stop when the user releases the button
		[backwardImageView setImage:[imagesDictionary objectForKey:BackwardPressedActive]];
		mouseDownTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(stepTimelineBackward) userInfo:nil repeats:YES];
	}
	else if(sender == endImageView)
	{
		// Set the button to be pressed
		[endImageView setImage:[imagesDictionary objectForKey:EndPressedActive]];
	}
	else if(sender == beginningImageView)
	{
		// Set the button to be pressed
		[beginningImageView setImage:[imagesDictionary objectForKey:BeginningPressedActive]];
	}
}

/**
 * Catch all method for any mouse up event for any of the player buttons.  This method
 * determines which button invoked the method and responds.
 * param sender The instance of the ClickableImageView that is calling this method
 */
- (void)mouseUp:(NSEvent *)event sender:(id)sender
{
	if(sender == playPauseImageView)
	{
		if([playPauseImageView image] == [imagesDictionary objectForKey:PlayPressedActive])
		{
			[playPauseImageView setImage:[imagesDictionary objectForKey:PauseEnabledActive]];
			// This will "play" the plots on the map
			timerLoop = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(stepTimelineForward) userInfo:nil repeats:YES];
		}
		else if([playPauseImageView image] == [imagesDictionary objectForKey:PausePressedActive])
		{
			[playPauseImageView setImage:[imagesDictionary objectForKey:PlayEnabledActive]];
			// This stops the timer, which stops the plots from "playing" on the map
			[timerLoop invalidate];
		}
	}
	else if(sender == forwardImageView)
	{
		// Set the button and not pressed
		[forwardImageView setImage:[imagesDictionary objectForKey:ForwardEnabledActive]];
		[self stepTimelineForward];
		[mouseDownTimer invalidate];
	}
	else if(sender == backwardImageView)
	{
		// Set the button as not pressed
		[backwardImageView setImage:[imagesDictionary objectForKey:BackwardEnabledActive]];
		[self stepTimelineBackward];
		[mouseDownTimer invalidate];
	}
	else if(sender == endImageView)
	{
		// Set the button as not pressed
		[endImageView setImage:[imagesDictionary objectForKey:EndEnabledActive]];
		[timelineSlider setIntValue:[timelineSlider maxValue]];
		[self update];
	}
	else if(sender == beginningImageView)
	{
		[beginningImageView setImage:[imagesDictionary objectForKey:BeginningEnabledActive]];
		[timelineSlider setIntValue:[timelineSlider minValue]];
		[self update];
	}
}

- (void)dealloc
{
	[graph release];
	
	[plots release];
	[colors release];
	[timerLoop release];
	[mouseDownTimer release];
	[graphStart release];
	[graphEnd release];
	[mainPlot release];
	
	[imagesDictionary release];
	[super dealloc];
}

@end
