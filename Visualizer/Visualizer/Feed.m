//
//  Feed.m
//  Visualizer
//


#import "Feed.h"


@implementation Feed

@synthesize name;
@synthesize description;
@synthesize points;
@synthesize url;
@synthesize isLoaded;
@synthesize kmlFeed;

/**
 * Initializer that uses the input KMLDocument object to populates itself
 * @param doc The KMLDocument object instance used to popluate the Feed instance
 */
- (id)initWithKMLDocument:(KMLDocument *)doc
{
	self = [super init];
    [self setKmlFeed:doc];
	[self setName:[kmlFeed name]];
	[self setDescription:[kmlFeed description]];
    
    points = [[NSMutableArray alloc] init];
    for(KMLPlacemark *placemark in doc.placemarks) {
        FeedPoint *temp = [[FeedPoint alloc] initWithPlacemark:placemark style:[doc getStyle:placemark.styleURL]];
        [points addObject:temp];
        [temp release];
                               
    }
	
	return self;
}

#pragma mark -
#pragma mark Encode/Decode Methods

/**
 * Initializer used to populate the feed class from a saved file, this only populates the feed with
 * enough information to be able to refresh itself
 * @param coder Coder used to retrieve or 'decode' information from a saved file
 */
- (id)initWithCoder:(NSCoder *)coder
{
	return self;
}

/**
 * Encodes the settings on the Feed class to allow it to be loaded at a different time with enough
 * settings to refresh itself from the original source
 * @param coder The instance of the NSCoder used to encode the class
 */
- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:name forKey:@"feedName"];
	[coder encodeObject:url forKey:@"feedURL"];
}


#pragma mark -
#pragma mark Properties

/**
 * Sets a flag to indicate if the Feed is visible or not
 * @param flag YES if the Feed should be visible, NO if the feed should be hidden
 */
- (void)setIsVisible:(BOOL)flag
{
	isVisible = flag;
	for(FeedPoint *fp in points)
	{
		fp.isVisible = flag;
	}
}

/**
 * Gets a flag indicated if the Feed is visible or not
 * @return A flag indicating if the feed is visible
 */
- (BOOL)isVisible
{
	return isVisible;
}

/**
 * Sets the isSelected flag on the Feed
 * @param flag Flag indicating if the feed is selected
 */
- (void)setIsSelected:(BOOL)flag
{
	isSelected = flag;
}

/**
 * Gets a flag indicating if the feed is selected or not
 * @return A flag indicating if the flag is selected or not
 */
- (BOOL)isSelected
{
	return isSelected;
}

- (void)dealloc
{
	[name release];
	[description release];
	[url release];
	[points release];
	[kmlFeed release];
	[super dealloc];
}

@end
