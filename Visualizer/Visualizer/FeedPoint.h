//
//  FeedPoint.h
//  Visualizer
//


#import <Cocoa/Cocoa.h>
#import <KMLParser/KMLParser.h>
#import "SinglePoint.h"

/**
 * Class that holds the meta data about a point from a feed that is plotted on the main display
 */
@interface FeedPoint : NSObject {
	NSString *uid; /**< Unique ID associated with this Feed Point */
	NSString *description; /**< Description assocaited with this Feed Point */
	NSString *symbol; /**< Symbol used to represent this point on the map */
	SinglePoint *pt; /**< Class used to hold lat/lon/elevation information  */
	NSDate *timestamp; /**< Time of the Feed Point */
	BOOL isVisible; /**< A flag used to indicate whether or not the feed point is visible */
	double latitude; /**< Latitude of the Feed Point */
	double longitude; /**< Longitude of the Feed Point */
	double elevation; /**< Elevation of the Feed Point */
	
	KMLPlacemark *kmlPlacemark; /**< The KMLPlacemark that is used to populated this instance of the FeedPoint class with data */
}

@property (nonatomic, retain)NSString *uid;
@property (nonatomic, retain)NSString *description;
@property (nonatomic, retain)NSString *symbol;
@property (nonatomic, retain)NSDate *timestamp; 
@property (nonatomic)double latitude;
@property (nonatomic)double longitude;
@property (nonatomic)double elevation;
@property (nonatomic)BOOL isVisible;
@property (nonatomic, retain)KMLPlacemark *kmlPlacemark;
@property (nonatomic, retain)SinglePoint *pt;

- (id)initWithPlacemark:(KMLPlacemark *)pm style:(KMLStyle *)style;

- (SinglePoint *)getDrawingPoint;

@end
