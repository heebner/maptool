//
//  Feed.h
//  Visualizer
//

#import <Cocoa/Cocoa.h>
#import <KMLParser/KMLParser.h>
#import "FeedPoint.h"

/**
 * This class is responsible for encapsulating all of the metadata about a feed as well as the points for the feed
 */
@interface Feed : NSObject {
	NSString *name; /**< The name of the feed */
	NSString *description; /**< A description of the feed */
	NSURL *url; /**< The URL of the feed, this could be a flat file location or internet address */
	NSMutableArray *points; /**< The collection of FeedPoints for this feed */
	BOOL isVisible; /**< Flag indicating if the feed is visible ot the user or not  */
	BOOL isSelected; /**< Flag indicating if the feed is selected in the display */
	BOOL isLoaded; /**< Flag indicating if this Feed is loaded into the main form table */
	
	KMLDocument *kmlFeed; /**< The underlying KML feed that is used to populate this object */
}

@property (nonatomic, retain)NSString *name;
@property (nonatomic, retain)NSString *description;
@property (nonatomic, retain)NSURL *url;
@property (nonatomic)BOOL isLoaded;
@property (nonatomic, retain)KMLDocument *kmlFeed;

/**
 * Gets the collection of points assocaited with this feed
 */
@property (nonatomic, readonly)NSArray *points;

- (id)initWithKMLDocument:(KMLDocument *)doc;

#pragma mark -
#pragma mark Encode/Decode Methods
- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

#pragma mark -	
#pragma mark Properties
- (void)setIsVisible:(BOOL)flag;
/**
 * Gets a flag indicated if the Feed is visible or not
 * @return A flag indicating if the feed is visible
 */
- (BOOL)isVisible;
- (void)setIsSelected:(BOOL)flag;
/**
 * Gets a flag indicating if the feed is selected or not
 * @return A flag indicating if the flag is selected or not
 */
- (BOOL)isSelected;


@end
