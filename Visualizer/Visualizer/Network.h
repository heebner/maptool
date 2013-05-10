

#import <Cocoa/Cocoa.h>
#import "NetworkReading.h"
#import "MapView.h"
#import "AccessPoint.h"
#import "GeoCircle.h"
#import "ImagePoint.h"

typedef enum NetworkHealthTypes {
	Poor,
	Moderate,
	Good
} NetworkHealthType;

/**
 *  Network.h
 *  Visualizer
 *
 *  Encapsulates the meta-data and readings for a given network
 */
@interface Network : NSObject {
	NSMutableArray *readings; /**< A array of readings that correspond to this netowrk */
	AccessPoint *accessPt; /**< Access point that contains the data for this network */
	BOOL isChecked; /**< Flag that indicates whether or not the network should be shown */
	BOOL isSelected; /**< Flag that indicates whether or not the network is currently selected */
	BOOL shouldPlotAsHeatMap; /**< Flag that indicates whether or not the network is currently plotted as a Heat Map */
	BOOL shouldPlotAsSigMagMap; /**< Flag that indicates whether or not the network is currently plotted a Signal Magnitude Map */
	BOOL shouldShowTrilateration; /**< Flag that indicates whether or not the network is displaying and calculating it's trilateration point */
	ImagePoint *trilateratedPoint; /**< Point is the is trilateration of the access point */
	NetworkHealthType health; /**< This field holds the value that corresponds to the health of the network */

	NSDate *earliestSampleDate; /**< The date of the earliest network reading for this network */
	NSDate *latestSampleDate; /**< The date of the latest network reading for this network */
}

/**
 * Gets and Sets the readings for this Network
 */
@property (nonatomic, retain)NSMutableArray *readings;
@property (nonatomic)BOOL shouldPlotAsHeatMap;
@property (nonatomic)BOOL shouldPlotAsSigMagMap;
@property (nonatomic)BOOL shouldShowTrilateration;
@property (nonatomic, retain)AccessPoint *accessPt;
@property (nonatomic, retain)NSDate *earliestSampleDate;
@property (nonatomic, retain)NSDate *latestSampleDate;
@property (nonatomic, retain)NSNumber *signalMagnitudeCoefficient;

- (NetworkHealthType)getHealth;


- (id)initWithAccessPoint:(AccessPoint *)ap;
/**
 * Gets the isSelected flag.  YES if the network is selected, otherwise NO
 * @return YES if the network is selected, otherwise NO
 */
- (BOOL)isSelected;
- (void)setIsSelected:(BOOL)flag;
/**
 * Gets a flag indicating if any visualizations for this network are visible
 * @return YES if any of the visualizations for this network are visible, otherwise NO
 */
- (BOOL)isChecked;
- (void)setIsChecked:(BOOL)flag;
- (void)updateTrilateratedPoint;
- (ImagePoint *)getTrilateratedPoint;

//- (NSNumber *)signalMagnitudeCoefficient;
//- (void)setSignalMagnitudeCoefficient:(NSNumber *)value;
- (SinglePoint *)getCenterPoint;

- (NSString *)channel;
- (NSString *)BSSID;
- (NSString *)accessPointMode;
- (NSString *)beaconInterval;
- (NSString *)hidden;
- (NSString *)capabilities;
- (NSString *)SSID;
- (NSString *)encryption;
- (NSString *)channelFlags;

@end
