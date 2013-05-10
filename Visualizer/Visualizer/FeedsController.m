//
//  FeedsController.m
//  Visualizer
//
//  Created by Ben Heebner on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "FeedsController.h"
#import "FeedPoint.h"


@implementation FeedsController

@synthesize currentSelectedFeed;

- (id)init
{
	self = [super init];
	return self;
}

#pragma mark -
#pragma mark XML and Feeds Methods

/**
 * Opens the window to display the URL feeds that can be turned on and off
 * @param sender The menu option to open the window
 */
- (IBAction)openFeedWindow:(id)sender
{
	[NSApp beginSheet:feedsWindow 
	   modalForWindow:mainWindow 
		modalDelegate:nil 
	   didEndSelector:NULL 
		  contextInfo:NULL];

}

/**
 * The method is invoked when the user clicks the "Close" button the Feeds URLs window
 * @param sender The "Close" button the feeds URL window
 */
- (IBAction)closeFeedsURLWindow:(id)sender
{
	[NSApp endSheet:feedsWindow];
	[feedsWindow orderOut:sender];
}

/**
 * This method closes the window used to enter in a KML feed from a web address
 * @param sender The "OK" button on the window used to enter in KML feeds
 */
- (IBAction)closeURL:(id)sender
{
	[NSApp endSheet:urlWindow];
	[urlWindow orderOut:sender];
	NSLog(@"Trying to parse KML stream at: %@", [urlPath stringValue]);
	NSURL *kmlFeed = [NSURL URLWithString:[urlPath stringValue]];
	
    if (kmlFeed != nil) 
	{
		[self parseXMLURL:kmlFeed];
    }
	else
	{
		NSAlert *alert = [NSAlert alertWithMessageText:@"Mal-Formed URL" 
										 defaultButton:@"OK" 
									   alternateButton:nil 
										   otherButton:nil 
							 informativeTextWithFormat:@"The input URL is not a valid URL, data cannot be loaded in"];
		[alert beginSheetModalForWindow:feedsWindow 
						  modalDelegate:nil 
						 didEndSelector:nil 
							contextInfo:NULL];
	}
}

/**
 * This method is invoked when the user clicks on the "Open Feed" menu item under "File".  This will prompt the user to 
 * choose a file to load from. 
 * @param sender The "Open Feed" menu item
 */
- (IBAction)openFile:(id)sender
{
	NSArray *fileTypes = [NSArray arrayWithObject:@"kml"];
	NSOpenPanel *oPanel = [NSOpenPanel openPanel];
	// TODO: Actually add this to the preferences
	NSURL *startingDir = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"StartingDirectory"]];
	if(!startingDir)
	{
		startingDir = [NSURL URLWithString:NSHomeDirectory()];
	}
    [oPanel setDirectoryURL:startingDir];   
    [oPanel setAllowedFileTypes:fileTypes];
	[oPanel setAllowsMultipleSelection:NO];

    [oPanel beginSheetModalForWindow:feedsWindow completionHandler:^(NSInteger returnCode)
    {
        NSURL *pathToFile = nil;
        if(returnCode == NSOKButton)
        {
            pathToFile = [[oPanel URLs] objectAtIndex:0];
        }
        
        if(pathToFile)
        {
            NSString *startingDir = [[pathToFile path] stringByDeletingLastPathComponent];
            [[NSUserDefaults standardUserDefaults] setObject:startingDir forKey:@"StartingDirectory"];
                    NSLog(@"%@", pathToFile);
            [self parseXMLURL:pathToFile];
            [feedsTable reloadData];
        }
    }];
}

/**
 * This method is called when the user click the display to remove a feed from the list of feeds
 * @param sender The control that the user interacts with to remove a feed
 */
- (IBAction)removeFeed:(id)sender
{
	Feed *selectedFeed = [[loadedFeeds selectedObjects] objectAtIndex:0];
	[selectedFeed setIsLoaded:NO];
	if([selectedFeed isVisible] == YES)
	{
		for(FeedPoint *fp in selectedFeed.points)
		{
			[mapController removeSinglePoint:[fp getDrawingPoint] forMap:selectedFeed.kmlFeed.name];
		}
		[selectedFeed setIsVisible:NO];
	}
	
	[loadedFeeds removeObject:selectedFeed];

}

/**
 * Method used ot parse the XML file selected by the user using the "Open Feed" menu item
 * @param url The url to the XML file to parse
 */
- (void)parseXMLURL:(NSURL *)url
{	
	KMLRoot *root = [KMLParser parseKMLFromURL:url];
    [root retain];
	for(KMLDocument *doc in [root documents])
	{
		Feed *newFeed = [[Feed alloc] initWithKMLDocument:doc];
		newFeed.url = url;
		[feedsURLController addObject:newFeed];
		[newFeed release];
	}
    [root release];
}

#pragma mark -
#pragma mark TableView Methods

/**
 * This method is called when the user clicks the checkbox on the Feeds Dialog.  If the checkbox is checked
 * the feed is added to the main dialog
 * @param sender The checkbox cell in the Feed Dialog
 */
- (IBAction)feedLoadToggle:(id)sender
{
	NSTableView *table = (NSTableView *)sender;
	NSInteger temp = [table selectedRow];
	Feed *feed = [[feedsURLController arrangedObjects] objectAtIndex:temp];	

	if([feed isLoaded] == YES)
	{
		[loadedFeeds addObject:feed];
        [feed setIsVisible:YES];
        for(FeedPoint *fp in feed.points)
		{
			[mapController addSinglePoint:[fp getDrawingPoint] forMap:feed.kmlFeed.name];
		}
	}
	else
	{
		[loadedFeeds removeObject:feed];
		[feed setIsVisible:NO];
		for(FeedPoint *fp in feed.points)
		{
			[mapController removeSinglePoint:[fp getDrawingPoint] forMap:feed.name];
		}
	}
}

/**
 * This method is called when the user clicks the checkbox on the feeds table in the main form.  If the checkbox is checked
 * the feed's plots are added to the map
 * @param sender The checkbox cell in the feeds table on the main form
 */
-(IBAction)feedVisibleToggle:(id)sender
{
	NSTableView *table = (NSTableView *)sender;
	NSInteger temp = [table selectedRow];
	Feed *feed = [[loadedFeeds arrangedObjects] objectAtIndex:temp];

	if([feed isVisible] == YES)
	{
        [mapController showSinglePointMapForName:feed.kmlFeed.name];
	}
	else
	{
        [mapController hideSinglePointMapForName:feed.kmlFeed.name];
	}
}


/**
 * Sets the input network as the selected network
 */
- (void)setSelectedFeed:(Feed *)feed
{
	if(currentSelectedFeed != nil)
	{
		[currentSelectedFeed setIsSelected:NO];
	}
	currentSelectedFeed = feed;
	[currentSelectedFeed setIsSelected:YES];
}

- (void)dealloc
{
	[currentSelectedFeed release];
	[super dealloc];
}

@end
