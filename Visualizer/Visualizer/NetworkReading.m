/*
 *  NetworkReading.m
 *  Visualizer
 *
 *  Encapsulates the meta-dat about an individual reading taken by a device
 */


#import "NetworkReading.h"


@implementation NetworkReading

@synthesize isSelected;
@synthesize signalSample;

/**
 * Initializes the Network Reading class with a signal sample
 * @param sample The Signal Sample instance to use as the backing datasource
 */
- (id)initWithSignalSample:(SignalSample *)sample
{
    self = [super init];
    [self setSignalSample:sample];
	isChecked = YES;
	[signalSample setShouldUseToTrilaterate:YES];
	return self;
}

- (BOOL)isChecked
{
	return isChecked;
}

- (void)setIsChecked:(BOOL)flag
{
	[signalSample setShouldUseToTrilaterate:flag];
	isChecked = flag;
}


/**
 * Gets the Latitude of the Network Reading
 * @return Latitude as a double
 */
- (double)latitude
{
	return [[signalSample sampledAtLocationLatitude] doubleValue];
}

/**
 * Gets the longitude of the Network Reading
 * @return Longitude as a double
 */
- (double)longitude
{
	return [[signalSample sampledAtLocationLongitude] doubleValue];
}

/**
 * Gets the signal strength of the Network Reading
 * @return Signal Strength as a double
 */
- (double)signalStrength
{
	return [[signalSample RSSI] doubleValue];
}

/**
 * This method returns the signal sample's strength (RSSI) as a distance in meters.
 * @return The distance in meters for the signal sample's signal strength (RSSI)
 */
- (double)RSSIAsDistanceInMeters
{
	return [signalSample RSSIAsDistanceInMeters];
}

/// Returned from the wireless scan API calls, is always 0, not sure exactly what this value means
- (NSString *) scanWasDirected
{
    NSString *temp = [[signalSample.scanWasDirected copy] autorelease];
	return temp;
}

/// A unique identifier for the phone that obtained this signal sample - obtained from the UIDevice class's uniqueIdentifier property
- (NSString *) handsetIdentifier
{
    NSString *temp = [[signalSample.handsetIdentifier copy] autorelease];
	return temp;
}

/// The latitude for the location where this signal sample was obtained
- (NSString *) sampledAtLocationLatitude
{
    NSString *temp = [[[NSString alloc] initWithString:[signalSample.sampledAtLocationLatitude stringValue]] autorelease];
	return temp;
}

/// Returned from the wireless scan API calls, not sure exactly what this value means, values seem to vary wildly
- (NSString *) age;
{
    NSString *temp = [[[NSString alloc] initWithString:[signalSample.age stringValue]] autorelease];
	return temp;
}

/// The time (and date) at which this signal sample was obtained
- (NSString *) sampledAtTimeStamp
{
    NSString *temp = [[[NSString alloc] initWithString:[signalSample.sampledAtTimeStamp descriptionWithCalendarFormat:@"%Y-%m-%d %H:%M:%S" timeZone:nil locale:nil]] autorelease];
	return temp;
}

/// The Received Signal Strength Indication (RSSI) value for the signal sample, seems to range from -100 to 0
- (NSString *) RSSI
{
    NSString *temp = [[[NSString alloc] initWithString:[signalSample.RSSI stringValue]] autorelease];
	return temp;
}

/// The longitude for the location where this signal sample was obtained
- (NSString *) sampledAtLocationLongitude
{
    NSString *temp = [[[NSString alloc] initWithString:[signalSample.sampledAtLocationLongitude stringValue]] autorelease];
	return temp;
}

/// The elevation for the location where this signal sample was obtained
- (NSString *) sampledAtLocationElevation
{
    NSString *temp = [[[NSString alloc] initWithString:[signalSample.sampledAtLocationElevation stringValue]] autorelease];
	return temp;
}

/// A noise measurement for the signal sample, always seems to be a 0
- (NSString *) noise
{
    NSString *temp = [[[NSString alloc] initWithString:[signalSample.noise stringValue]] autorelease];
	return temp;
}

- (void)dealloc
{
	[signalSample release];
	[super dealloc];
}

@end
