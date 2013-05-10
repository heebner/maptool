/*
 *  Network.m
 *  Visualizer
 *
 *  Encapsulates the meta-data and readings for a given network
 */

#import <QuartzCore/QuartzCore.h>
#import "Network.h"
#import "NetworkReading.h"
#import "MapView.h"
#import "SignalSample.h"
#import "Trilaterator.h"
#import "Constants.h"

@implementation Network

@synthesize readings;
@synthesize shouldPlotAsHeatMap;
@synthesize shouldPlotAsSigMagMap;
@synthesize shouldShowTrilateration;
@synthesize accessPt;
@synthesize earliestSampleDate;
@synthesize latestSampleDate;

#pragma mark -
#pragma mark Methods

/**
 * Initializes the Network class with an Access point as an underlying data class
 * @param ap Access Point to use as a backing for the Network instance
 */
- (id)initWithAccessPoint:(AccessPoint *)ap
{		
	self = [super init];
    [self setAccessPt:ap];
	readings = [[NSMutableArray alloc] init];
	for(SignalSample *sigSamp in ap.signalSamples)
	{
		NetworkReading *newReading = [[NetworkReading alloc] initWithSignalSample:sigSamp];
		[readings addObject:newReading];
        [newReading release];
		
		if(earliestSampleDate != nil && latestSampleDate != nil)
		{
            [self setEarliestSampleDate:[earliestSampleDate earlierDate:[sigSamp sampledAtTimeStamp]]];
            [self setLatestSampleDate:[latestSampleDate laterDate:[sigSamp sampledAtTimeStamp]]];
		}
		else
		{
            [self setEarliestSampleDate:[sigSamp sampledAtTimeStamp]];
            [self setLatestSampleDate:[sigSamp sampledAtTimeStamp]];
		}
	}
	
	// Read in the user settings to determine what should be displayed
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	shouldPlotAsHeatMap = [defaults boolForKey:PrefDisplayHeatMap];
	shouldPlotAsSigMagMap = [defaults boolForKey:PrefDisplaySignalMagnitude];
	shouldShowTrilateration = [defaults boolForKey:PrefDisplayTrilateration];
	[self setSignalMagnitudeCoefficient:[NSNumber numberWithDouble:[defaults doubleForKey:PrefSigMagCoefficientValue]]];
	
	// By default turn on the network off
	isChecked = NO;	
	// Since we're just init-ing this network can't be selected
	isSelected = NO;
	
	// Create a random network health value
	NSInteger temp = [readings count] % 3;
	switch (temp) {
		case 0:
			health = Good;
			break;
		case 1:
			health = Moderate;
			break;
		default:
			health = Poor;
			break;
	}
	
	return self;
}

- (void)applyPreferences
{
}


/**
 * Gets the health of the network
 * @return The health of the network as a NetworkHealthType enum
 */
- (NetworkHealthType)getHealth
{
	return health;
}

/**
 * Gets a flag indicating if any visualizations for this network are visible
 * @return YES if any of the visualizations for this network are visible, otherwise NO
 */
- (BOOL)isChecked
{	
	return isChecked;
}

/**
 * Sets a flag to "turn-on" the default visualizations for this network
 * @param flag YES to turn default network visualizations
 */
- (void)setIsChecked:(BOOL)flag
{
	isChecked = flag;
}

/**
 * Gets the isSelected flag.  YES if the network is selected, otherwise NO
 * @return YES if the network is selected, otherwise NO
 */
- (BOOL)isSelected
{
	return isSelected;
}

/**
 * Sets the isSelected flag.
 * @param flag YES is the network is selected, otherwise NO
 */
- (void)setIsSelected:(BOOL)flag
{
	for(NetworkReading *reading in readings)
	{
		reading.isSelected = flag;
	}
	isSelected = flag;
}

/**
 * This method updates the network's trilaterated point
 */
- (void)updateTrilateratedPoint
{
	GeoCircle *c = [Trilaterator trilaterate:accessPt];
	trilateratedPoint.latitude = c.center.locationLatitude;
	trilateratedPoint.longitude = c.center.locationLongitude;
}

/** 
 * Gets the Trilaterated Point
 * @return The trilaterated point as an ImagePoint that can be plotted on a Single Point Map
 */
- (ImagePoint *)getTrilateratedPoint
{
	if(trilateratedPoint == nil)
	{
		GeoCircle *circle = [Trilaterator trilaterate:accessPt];
		NSURL *imgPath;
		switch (health) {
			case Good:
				imgPath = [[NSBundle mainBundle] URLForResource:@"trilat-green" withExtension:@"png"];
				break;
			case Moderate:
				imgPath = [[NSBundle mainBundle] URLForResource:@"trilat-yellow" withExtension:@"png"];
				break;
			default:
				imgPath = [[NSBundle mainBundle] URLForResource:@"trilat-red" withExtension:@"png"];
				break;
		}
		
        NSData *data = [NSData dataWithContentsOfURL:imgPath];
		trilateratedPoint = [[ImagePoint alloc] initWithData:data Latitude:circle.center.locationLatitude Longitude:circle.center.locationLongitude];
	}
	return trilateratedPoint;
}

/**
 * This method returns a point that is the center all of the network readings this network has
 * @return An instance of the SinglePoint class with a lat/lon of the center of the network
 */
-(SinglePoint *)getCenterPoint
{
	double minLat = 90.0;
	double minLon = 180.0;
	double maxLat = -90.0;
	double maxLon = -180.0;
	
	for(NetworkReading *nr in readings)
	{
		if([nr latitude] < minLat)
		{
			minLat = [nr latitude];
		}
		else if([nr latitude] > maxLat)
		{
			maxLat = [nr latitude];
		}
		
		if([nr longitude] < minLon)
		{
			minLon = [nr longitude];
		}
		else if([nr longitude] > maxLon)
		{
			maxLon = [nr longitude];
		}
	}
	
	// Now we should have the max and min lat's and long's
    SinglePoint *retPoint = [[SinglePoint alloc] initWithLatLong:minLat + ((maxLat - minLat) / 2.0) Longitude:minLon + ((maxLon - minLon) / 2.0) ];
    [retPoint autorelease];
	return retPoint;
}

/**
 * Gets the signal magnitude coefficient for the network
 * @return The signal magnitude coefficient for the network as an NSNumber
 */
- (NSNumber *)signalMagnitudeCoefficient
{
    NSNumber *temp = [[accessPt.signalMagnitudeCoefficient copy] autorelease];
	return temp;
}

/**
 * Sets the signal magnitude coefficient for the network
 * @param value The value to set the signal magnitude coefficient to
 */
- (void)setSignalMagnitudeCoefficient:(NSNumber *)value
{
    [accessPt setSignalMagnitudeCoefficient:value];
}

/**
 * The channel used by the access point
 */
 - (NSString *)channel
{
    NSString *temp = [[[NSString alloc] initWithString:[accessPt.channel stringValue]] autorelease];
	return temp;
}

/** 
 * The Basic Service Set Identifier (BSSID) for the access point, typically noted in Media Access Control (MAC) address form
*/
- (NSString *)BSSID
{
    NSString *temp = [[accessPt.BSSID copy] autorelease];
	return temp;
}

/**
 * The mode of the access point ('ad-hoc' or 'infrastructure')
 */
- (NSString *)accessPointMode
{
	switch ([[accessPt accessPointMode] intValue]) 
	{
		case 1:
			return [[[NSString alloc] initWithString:@"ad-hoc"] autorelease];
			break;
		default:
			return [[[NSString alloc] initWithString:@"infrastructure"] autorelease];
			break;
	}
}

/**
 * The beacon interval for the access point
 */
- (NSString *)beaconInterval
{
    NSString *temp = [[[NSString alloc] initWithString:[accessPt.beaconInterval stringValue]] autorelease];
	return temp;
}

/**
 * A boolean indicating whether or not the access point is "hidden", i.e. not broadcasting its Service Set Identifier (SSID)
 */
- (NSString *)hidden
{
	if(accessPt.hidden)
	{
		return [[[NSString alloc] initWithString:@"YES"] autorelease];
	}
	return [[[NSString alloc] initWithString:@"NO"] autorelease];
}

/**
 * A bitmasked capabilities list for the access point - the meaning of the values are mostly unknown at this point
 */
- (NSString *)capabilities
{
    NSString *temp = [[[NSString alloc] initWithString:[accessPt.capabilities stringValue]] autorelease];
	return temp;
}

/**
 * The Service Set Identifier (SSID) for the access point, which is generally its "name"
 */
- (NSString *)SSID
{
    NSString *temp = [[accessPt.SSID copy] autorelease];
	return temp;
}

/**
 * The encryption setup employed by the access point.
 *   - 0 = none
 *   - 1 = WEP
 *   - 2 = WPA
 *   - 3 = WPA2 w/AES
 *   - 4 = WPA2 w/TKIP+AES
 */
- (NSString *)encryption
{
    NSString *temp;
	switch ([[accessPt encryption] intValue]) 
	{
		case 0:
			temp = [[[NSString alloc] initWithString:@"none"] autorelease];
			break;
		case 1:
			temp = [[[NSString alloc] initWithString:@"WEP"] autorelease];
			break;
		case 2:
			temp = [[[NSString alloc] initWithString:@"WPA"] autorelease];
			break;
		case 3:
			temp = [[[NSString alloc] initWithString:@"WPA2 w/AES"] autorelease];
			break;
		default:
			temp = [[[NSString alloc] initWithString:@"WPA2 w/TKIP+AES"] autorelease];
			break;
	}
    return temp;
}

/**
 * A bitmasked channel flag list for the access point - the meaning of the values are mostly unknown at this point
 */
- (NSString *)channelFlags
{
    NSString *temp = [[[NSString alloc] initWithString:[accessPt.channelFlags stringValue]] autorelease];
	return temp;
}


- (void)dealloc
{
	[earliestSampleDate  release];
	[latestSampleDate release];
	[trilateratedPoint release];
	[readings release];
	[accessPt release];
	[super dealloc];
}

@end
