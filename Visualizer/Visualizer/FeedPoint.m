//
//  FeedPoint.m
//  Visualizer
//


#import "FeedPoint.h"
#import "ImagePoint.h"


@implementation FeedPoint

@synthesize uid;
@synthesize description;
@synthesize timestamp;
@synthesize symbol;
@synthesize isVisible;
@synthesize latitude;
@synthesize longitude;
@synthesize elevation;
@synthesize kmlPlacemark;
@synthesize pt;

/**
 * Initializer that uses the input KMLPlacemark to populate itself
 * @param placemark The instance of the KMLPlacemark class used to populate the FeedPoint instance
 * @param style The style to use for the placemark
 */
- (id)initWithPlacemark:(KMLPlacemark *)pm style:(KMLStyle *)style;
{
	self = [super init];
    [self setKmlPlacemark:pm];
    [self setDescription:kmlPlacemark.description];
    [self setUid:kmlPlacemark.name];
    [self setLatitude:kmlPlacemark.point.coordinates.latitude];
    [self setLongitude:kmlPlacemark.point.coordinates.longitude];
		
    // We need to get the icon style for the placemark (if applicable
		
    NSURL *imgPath = [[NSBundle mainBundle] URLForResource:[style.iconStyle.icon.href.url stringByDeletingPathExtension] withExtension:[style.iconStyle.icon.href.url pathExtension]];
    NSData *data = [NSData dataWithContentsOfURL:imgPath];
    ImagePoint *image = [[ImagePoint alloc] initWithData:data Latitude:kmlPlacemark.point.coordinates.latitude Longitude:kmlPlacemark.point.coordinates.longitude];
    
    [self setPt:image];
    [image release];
	
	return self;
}

/**
 * The method gets the point to use to draw on the map.  It uses the values on the class to create the drawing point.
 * @return The point to draw on the map
 */
- (SinglePoint *)getDrawingPoint
{
	return pt;
}

- (void)dealloc
{
	[uid release];
	[description release];
	[symbol release];
	[pt release];
	[timestamp release];
		
	[kmlPlacemark release];
	[super dealloc];
}

@end
