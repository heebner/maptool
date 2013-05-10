//
//  SignalSample.m
//  Visualizer
//
//  Created by Benjamin Heebner on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignalSample.h"
#import "AccessPoint.h"


@implementation SignalSample

@synthesize scanWasDirected, RSSI, sampledAtTimeStamp, sampledAtLocationLatitude;
@synthesize age, sampledAtLocationElevation, sampledAtLocationLongitude, handsetIdentifier;
@synthesize noise, accessPoint, shouldUseToTrilaterate;

/**
 * Method that returns the values on this instance of the SignalSample class as a string
 * @return A NSString containing all the values form this instance of the SignalSample class
 */
- (NSString *)stringValue
{
	NSMutableString *returnString = [[[NSMutableString alloc] init] autorelease];
	
	[returnString appendString:[[self RSSI] stringValue]];
    [returnString appendString:[[self age] stringValue]];
    [returnString appendString:[self handsetIdentifier]];
    [returnString appendString:[[self noise] stringValue]];
    [returnString appendString:[[self sampledAtLocationElevation] stringValue]];
    [returnString appendString:[[self sampledAtLocationLatitude] stringValue]];
    [returnString appendString:[[self sampledAtLocationLongitude] stringValue]];
    [returnString appendString:[[self sampledAtTimeStamp] description]];
    [returnString appendString:[[self scanWasDirected] stringValue]];
	
	return returnString;
}

- (NSString *)xmlString
{
	NSMutableString *returnString = [[[NSMutableString alloc] init] autorelease];
	
    [returnString appendFormat:@"<rssi>%@</rssi>", [[self RSSI] stringValue]];
    [returnString appendFormat:@"<age>%@</age>", [[self age] stringValue]];
    [returnString appendFormat:@"<handsetID>%@</handsetID>", [self handsetIdentifier]];
    [returnString appendFormat:@"<noise>%@</noise>", [[self noise] stringValue]];
    [returnString appendFormat:@"<elevation>%@</elevation>", [[self sampledAtLocationElevation] stringValue]];
    [returnString appendFormat:@"<latitude>%@</latitude>", [[self sampledAtLocationLatitude] stringValue]];
    [returnString appendFormat:@"<longitude>%@</longitude>", [[self sampledAtLocationLongitude] stringValue]];
    [returnString appendFormat:@"<timestamp>%@</timestamp>", [[self sampledAtTimeStamp] description]];
    [returnString appendFormat:@"<scanWasDirected>%@</scanWasDirected>", [[self scanWasDirected] stringValue]];
	
	return returnString;
}


/**
 * This method returns the signal sample's strength (RSSI) as a distance in meters.
 * @return The distance in meters for the signal sample's signal strength (RSSI)
 */
- (double)RSSIAsDistanceInMeters {
	// This calculation is based on curve-fitting data that James and Josh sampled outdoors (no obstructions)
	//double exponent = (22.610084324291361 + [self.RSSI shortValue]) / -33.925153100105277;
	double exponent = ([[[self accessPoint] signalMagnitudeCoefficient] floatValue] + [self.RSSI shortValue]) / -33.925153100105277;
	
	// This calculation is based on research paper data
	//	double exponent = (-18.0 - [self.RSSI shortValue]) / 35.0;
	
	double distanceInMeters = pow(10.0, exponent);
	return distanceInMeters;
}

@end
