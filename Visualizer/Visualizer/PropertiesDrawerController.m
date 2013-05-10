/*
 *  PropertiesDrawerController.m
 *  Visualizer
 *
 *  The class manages the properties drawer the slides out from the bottom of the main display
 */
#import "PropertiesDrawerController.h"
#import "MapController.h"
#import "GeoCircle.h"
#import "Trilaterator.h"
#import "AppController.h"


@implementation PropertiesDrawerController

@synthesize currentNetworkReading, currentNetwork;

/**
 * Method that toggles the showing/hiding of the properties drawer along the bottom of the page
 * @param sender The button that was clicked to show/hide the properties drawer
 */
- (IBAction)toggleDrawer:(id)sender
{
	NSDrawerState state = [propertiesDrawer state];
	if(NSDrawerOpeningState == state || NSDrawerOpenState == state)
	{
		[propertiesDrawer close];
	}
	else
	{ 
		[propertiesDrawer open];
	}
}

/**
 * This method takes in a network object and displays the details of the network in the drawer
 * @param network The network to display the details for
 */
- (void)displayNetworkDetails:(Network *)network
{
    //[currentNetwork release];
    [self setCurrentNetwork:network];
	
	switch ([network getHealth]) 
	{
		case Good:
			[healthBox setFillColor:[NSColor colorWithDeviceRed:0.0 green:0.7725 blue:0.1451 alpha:1.0]];
			break;
		case Moderate:
			[healthBox setFillColor:[NSColor colorWithDeviceRed:0.9373 green:0.6510 blue:0.0235 alpha:1.0]];
			break;
		default:
			[healthBox setFillColor:[NSColor colorWithDeviceRed:0.6078 green:0.0706 blue:0.0745 alpha:1.0]];
			break;
	}
}

/**
 * Method that handles the checking/unchecking of the Heat Map Visualization check box.  If checked, 
 * the map will display the current network's plot as a heat map
 * @param sender The heat map check box
 */
- (IBAction)toggleHeatMap:(id)sender
{
	currentNetwork.shouldPlotAsHeatMap = [heatMapCheckBox state];
	if(currentNetwork.shouldPlotAsHeatMap == YES)
	{
		[mapController addPointsToHeatMap:currentNetwork.readings];
	}
	else
	{
		[mapController removePointsFromHeatMap:currentNetwork.readings];
	}
	[networkTable reloadData];
}

/**
 * Method that handles the checking/unchecking of the Signal Magnitude Visualization check box. If
 * checked, the map will display the current network's plots as a signal magnitude visualization
 * @param sender The Signal Magnitude check box
 */
- (IBAction)toggleSigMagMap:(id)sender
{
	currentNetwork.shouldPlotAsSigMagMap = [sigMagCheckBox state];
	if(currentNetwork.shouldPlotAsSigMagMap == YES)
	{
		[mapController addPointsToSignalMagnitudeMap:currentNetwork.readings];
	}
	else
	{
		[mapController removePointsFromSignalMagnitudeMap:currentNetwork.readings];
	}
	[networkTable reloadData];
}

/**
 * Method that handles the checking/unchecking of the Trilateration Visualization check box.
 * If checked, the map will display the current network's trilaterated point.
 * @param sender The trilateration check box
 */
- (IBAction)toggleTrilateration:(id)sender
{
	currentNetwork.shouldShowTrilateration = [trilaterationCheckBox state];
	if(currentNetwork.shouldShowTrilateration == YES)
	{
		[currentNetwork updateTrilateratedPoint];
		[mapController addSinglePoint:[currentNetwork getTrilateratedPoint] forMap:TrilateratedPointMapName];
	}
	else
	{
		[mapController removeSinglePoint:[currentNetwork getTrilateratedPoint] forMap:TrilateratedPointMapName];
	}
	[networkTable reloadData];
}

/**
 * Method that is invoked whenver the value of the slider changes. This will redraw the signal magnitude map
 * with the new coefficient value applied
 * @param sender The Signal Magnitude Coefficient slider
 */
- (IBAction)coefficientSliderChanged:(id)sender
{
	[currentNetwork setSignalMagnitudeCoefficient:[NSNumber numberWithFloat:[signalMagnitudeCoefficientSlider floatValue]]];
	[signalMagnitudeCoefficientValue setStringValue:[signalMagnitudeCoefficientSlider stringValue]];
	if(currentNetwork.shouldShowTrilateration == YES)
	{
		[currentNetwork updateTrilateratedPoint];
	}
	[mapController redrawMap];
}

/**
 * This method is called whenever the user checks or unchecks the "View" checkbox on the Network Reading Table
 * @param sender The network reading table view
 */
- (IBAction)toggleNetworkReading:(id)sender
{
	if(currentNetwork.shouldShowTrilateration == YES)
	{
		[currentNetwork updateTrilateratedPoint];
	}
	[mapController redrawMap];
}

#pragma mark -
#pragma mark TableView Delegate Methods

/**
 * Method that fires when the user clicks on a row in the network table
 * @param sender The network table
 */
- (IBAction)rowSelected:(id)sender
{
	NetworkReading *reading = (NetworkReading *)[networkReadingController selection];
    NSLog(@"Retain Count: %lu", [reading retainCount]);
	if(currentNetworkReading != nil)
	{
        NSLog(@"Retain Count: %lu", [reading retainCount]);
		[currentNetworkReading setValue:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
	}
    NSLog(@"Retain Count: %lu", [reading retainCount]);
    [self setCurrentNetworkReading:reading];
    NSLog(@"Retain Count: %lu", [reading retainCount]);
	
	[mapController redrawMap];
}

- (void)dealloc
{
	[currentNetwork release];
	[currentNetworkReading release];
	[super dealloc];
}


@end
