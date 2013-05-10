//
//  SignalSample.h
//  Visualizer
//
//  Created by Benjamin Heebner on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AccessPoint;

@interface SignalSample : NSObject

@property (nonatomic, retain) NSNumber * scanWasDirected;
@property (nonatomic, retain) NSNumber * RSSI;
@property (nonatomic, retain) NSDate * sampledAtTimeStamp;
@property (nonatomic, retain) NSNumber * sampledAtLocationElevation;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * sampledAtLocationLongitude;
@property (nonatomic, retain) NSNumber * sampledAtLocationLatitude;
@property (nonatomic, retain) NSString * handsetIdentifier;
@property (nonatomic, retain) NSNumber * noise;
@property (nonatomic, retain) AccessPoint *accessPoint;


@property (nonatomic) BOOL shouldUseToTrilaterate;

- (NSString *)stringValue;
- (double)RSSIAsDistanceInMeters;

/**
 This method returns an XML string representation of this signal sample instance 
 */
- (NSString *)xmlString;

@end
