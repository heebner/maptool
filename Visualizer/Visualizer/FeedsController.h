
#import <Cocoa/Cocoa.h>
#import "KMLParser/KMLParser.h"
#import "Feed.h"
#import "MapController.h"

/**
 FeedsController.h
 
 This class is the controller for adding and removing feeds from the feeds tableview.  This class also parses
 newly added feeds and adds/removes feed data from the map
 */
@interface FeedsController : NSObject {

	Feed *currentSelectedFeed; /**< The currently selected feed */
	IBOutlet MapController *mapController; /**< The instance of the map controller the maps points */
	IBOutlet NSTableView *feedsTable; /**< Holds a list of networks that can be viewed/plotted */
	IBOutlet NSWindow *mainWindow; /**< Main NSWindow is that the main window of the application */
	IBOutlet NSWindow *feedsWindow; /**< The panel that contains the controls to load and unload Feeds from URLs (KML feeds) */
	IBOutlet NSWindow *urlWindow; /**< The panel that contains the controls to load a url into the feeds window */
	IBOutlet NSTextField *urlPath; /**< The text field on the URL input window that contain the URL to the KML feed */
	IBOutlet NSTableView *feedsURLTable; /**< The table that holds the feed URLs */
	IBOutlet NSArrayController *feedsURLController; /**< Controller used to manage the URL feeds */
	IBOutlet NSArrayController *loadedFeeds; /**< Controller used to manage the loaded feeds (the feeds listed in the main window) */
}

@property(nonatomic, retain)Feed *currentSelectedFeed;

#pragma mark -
#pragma mark XML and Feeds Methods

- (IBAction)openFile:(id)sender;
- (IBAction)closeURL:(id)sender;
- (IBAction)openFeedWindow:(id)sender;
- (IBAction)closeFeedsURLWindow:(id)sender;
- (IBAction)removeFeed:(id)sender;
- (IBAction)feedLoadToggle:(id)sender;
- (IBAction)feedVisibleToggle:(id)sender;
- (void)parseXMLURL:(NSURL *)url;



@end
