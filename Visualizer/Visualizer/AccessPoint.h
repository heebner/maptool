//
//  AccessPoint.h
//  Visualizer
//
//  Created by Benjamin Heebner on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SignalSample.h"

@class SignalSample;

@interface AccessPoint : NSObject {
    NSNumber *signalMagnitudeCoefficient; /**< Class member that holds the coefficient for plotting the signal magnitude */
    NSMutableArray *samples;
}

@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSNumber * channel;
@property (nonatomic, retain) NSNumber * accessPointMode;
@property (nonatomic, retain) NSNumber * capabilities;
@property (nonatomic, retain) NSString * BSSID;
@property (nonatomic, retain) NSString * SSID;
@property (nonatomic, retain) NSNumber * channelFlags;
@property (nonatomic, retain) NSNumber * encryption;
@property (nonatomic, retain) NSNumber * beaconInterval;
@property (nonatomic, retain) NSSet *signalSamples;


/// The value to use for determining the RSSI in meters for a signal sample
@property (nonatomic, retain) NSNumber *signalMagnitudeCoefficient;

- (NSString *)stringValue;

/**
 This method returns an XML string representation of this access point instance as well as the
 signal samples held onto by the access point.  The input flag is used to determine if the 
 signal samples in the return XML string contain all signal samples, or just the ones not yet
 sent to the server
 @param includeAll Flag indicating whether or not all samples should be sent, or only ones not sent to the server yet
 */
- (NSString *)xmlString:(BOOL)includeAll;

- (void)addSignalSamplesObject:(SignalSample *)value;
- (void)removeSignalSamplesObject:(SignalSample *)value;
- (void)addSignalSamples:(NSSet *)values;
- (void)removeSignalSamples:(NSSet *)values;

@end
