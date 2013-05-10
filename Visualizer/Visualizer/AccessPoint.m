//
//  AccessPoint.m
//  Visualizer
//
//  Created by Benjamin Heebner on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccessPoint.h"
#import "SignalSample.h"


@implementation AccessPoint

@synthesize hidden, channel, accessPointMode, capabilities, BSSID, SSID;
@synthesize channelFlags, encryption, beaconInterval;

- (id)init {
    self = [super init];
    samples = [[NSMutableArray alloc] init];
    return self;
}

- (NSNumber *)signalMagnitudeCoefficient
{
	return signalMagnitudeCoefficient;
}

- (void)setSignalMagnitudeCoefficient:(NSNumber *)value
{
    signalMagnitudeCoefficient = [value copy];
}

- (void)addSignalSamplesObject:(SignalSample *)value {
    [samples addObject:value];
}
- (void)removeSignalSamplesObject:(SignalSample *)value {
    [samples removeObject:value];
}
- (void)addSignalSamples:(NSSet *)values {
    [samples addObjectsFromArray:[values allObjects]];
}
- (void)removeSignalSamples:(NSSet *)values {
    [samples removeObjectsInArray:[values allObjects]];
}

- (NSSet *)signalSamples {
    NSSet *returnSet = [[[NSSet alloc] initWithArray:samples] autorelease];
    return returnSet;
    
}

- (void)setSignalSamples:(NSSet *)signalSamples {
    [samples release];
    samples = [[NSMutableArray alloc] initWithArray:[signalSamples allObjects]];
    
}

/**
 * Method that returns the values on this instance of the AccessPoint class as a string
 * @return A NSString containing all the values form this instance of the AccessPoint class
 */
- (NSString *)stringValue
{
	NSMutableString *returnString = [[[NSMutableString alloc] initWithString:@"AP START"] autorelease];
	
    [returnString appendString:[self BSSID]];
    [returnString appendString:[self SSID]];
	[returnString appendString:[[self hidden] stringValue]];
	[returnString appendString:[[self accessPointMode] stringValue]];
	[returnString appendString:[[self beaconInterval] stringValue]];
	[returnString appendString:[[self capabilities] stringValue]];
	[returnString appendString:[[self channel] stringValue]];
	[returnString appendString:[[self channelFlags] stringValue]];
	[returnString appendString:[[self encryption] stringValue]];
	
	[returnString appendString:@"SS START\n"];
	for(SignalSample *sigSamp in samples)
	{
		[returnString appendString:[sigSamp stringValue]];
	}
	[returnString appendString:@"SS END\n"];
	[returnString appendString:@"AP END\n"];
	
	return returnString;
}

- (NSString *)xmlString:(BOOL)includeAll
{
	NSMutableString *returnString = [[[NSMutableString alloc] initWithString:@"<accessPoint>"] autorelease];
	
	[returnString appendString:[NSString stringWithFormat:@"<bssid>%@</bssid>", [self BSSID]]];
	[returnString appendString:[NSString stringWithFormat:@"<ssid>%@</ssid>", [self SSID]]];
	[returnString appendString:[NSString stringWithFormat:@"<hidden>%@</hidden>", [[self hidden] stringValue]]];
	[returnString appendString:[NSString stringWithFormat:@"<apMode>%@</apMode>", [[self accessPointMode] stringValue]]];
	[returnString appendString:[NSString stringWithFormat:@"<beaconInterval>%@</beaconInterval>", [[self beaconInterval] stringValue]]];
	[returnString appendString:[NSString stringWithFormat:@"<capabilities>%@</capabilities>", [[self capabilities] stringValue]]];
	[returnString appendString:[NSString stringWithFormat:@"<channel>%@</channel>", [[self channel] stringValue]]];
	[returnString appendString:[NSString stringWithFormat:@"<channelFlags>%@</channelFlags>", [[self channelFlags] stringValue]]];
	[returnString appendString:[NSString stringWithFormat:@"<encryption>%@</encryption>", [[self encryption] stringValue]]];

	
	[returnString appendString:[NSString stringWithFormat:@"<signalSamples>"]];
	for(SignalSample *sigSamp in samples)
	{
		[returnString appendString:[NSString stringWithFormat:@"<signalSample>"]];
		[returnString appendString:[NSString stringWithFormat:@"%@", [sigSamp xmlString]]];
		[returnString appendString:[NSString stringWithFormat:@"</signalSample>"]];
		
	} 
	[returnString appendString:[NSString stringWithFormat:@"</signalSamples>"]];
	[returnString appendString:[NSString stringWithFormat:@"</accessPoint>"]];
	
	return returnString;
}

- (void)dealloc {
    [signalMagnitudeCoefficient release];
    [samples release];
    [super dealloc];
}

@end
