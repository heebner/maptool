/**
 *  NetworkReading.h
 *  Visualizer
 *
 *  Encapsulates the meta-data about an individual reading taken by a device
 */

#import <Cocoa/Cocoa.h>
#import "SignalSample.h"


@interface NetworkReading : NSObject
{
	SignalSample *signalSample; /**< Underlying data object that holds the signal sameple data */
	BOOL isSelected; /**< Flag indicating if this point is current selected */
	BOOL isChecked; /**< Flg indicating if this point is checked or not */
}

/**
 * Gets and Sets a flag indicating if the network reading is selected
 */
@property (nonatomic)BOOL isSelected;
/**
 * Gets a Sets a flag indicating if the network reading is checked
 */
@property (nonatomic)BOOL isChecked;
@property (nonatomic, retain)SignalSample *signalSample;
@property (nonatomic, readonly)NSString *sampledAtLocationLongitude;
@property (nonatomic, readonly)NSString *sampledAtLocationLatitude;
@property (nonatomic, readonly)NSString *sampledAtLocationElevation;
@property (nonatomic, readonly)NSString *sampledAtTimeStamp;
@property (nonatomic, readonly)NSString *RSSI;
@property (nonatomic, readonly)NSString *noise;
@property (nonatomic, readonly)NSString *scanWasDirected;
@property (nonatomic, readonly)NSString *handsetIdentifier;


- (id)initWithSignalSample:(SignalSample *)sample;

- (double)latitude;
- (double)longitude;
- (double)signalStrength;
- (double)RSSIAsDistanceInMeters;


@end
