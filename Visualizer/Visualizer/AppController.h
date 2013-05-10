/**
 \mainpage Visualizer
 \section intro_sec Introduction
 The Visualizer application is the "server-side" solution for viewing and manipulating information gathered by remote devices 
 running TacCSA software.  This application allows users to view data across multiple time frames and multiple devices.  The 
 users also have to ability to tweak data to better fit the area in which the data was collected.  The application can be 
 broken up in to 6 main capabilities, each of which has a separate controller class:
 <ul>
 <li>Map (MapController)</li>
 <li>Network table (AppController)</li>
 <li>Details Pane (PropertiesDrawerController)</li>
 <li>Animation (AnimationController)</li>
 <li>Preferences/Settings (PreferenceController</li>
 <li>KML Feed Viewer (FeedsController)</li>
 </ul>  
 Each of these pieces have associated controllers.  See the documentation for each controller for a more specific explanation 
 of each piece of the HMI.
 \section depend_sec Project Dependencies
 This Visualizer application relies on the use of two thrid party frameworks: KMLParser and CorePlot.  KMLParser is a framework
 that parses a KML file into objects.  This project is configured to include the KML Parser Framework within the application package,
 meaning that if user wants to run this on a machine, all that is needed is the application.  However, to build this code on a machine 
 the KMLParser project folder should reside at the same location as the Visualizer project folder.  
 <br>
 CorePlot is a framework hosted on google code.  This framework is also included in the Visualizer application bundle like KMLParser.
 However, to be able to build the Visualizer application the CorePlot folder should reside in the home directory of the user.
 */


#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <CoreData/CoreData.h>
//#import <LibMySQL/LibMySQL.h>
#import "MapController.h"
#import "NetworkView.h"
#import "MapView.h"
#import "MapModel.h"
#import "PropertiesDrawerController.h"
#import "PreferenceController.h"
#import "AnimationController.h"
#import "OutlineDictionary.h"
#import "FeedsController.h"

extern NSString * const TrilateratedPointMapName;

/**
 *  AppController.h
 *  Visualizer
 *
 *  Main controller class for the Visualizer HMI.  This class receives messages from the HMI and sends messages to the HMI to display data
 */
@interface AppController : NSController {
	
	NSManagedObjectModel *managedObjectModel; /**< Object Model to hold on to managed objects in memory */
    NSPersistentStoreCoordinator *persistentStoreCoordinator; /**< Used by the managedObjectModel to load sqlite files in from disk */
	/// The managed object context used within the application for CoreData storage
	NSManagedObjectContext *managedObjectContext;
	
    NSMutableArray *networksArray; /**< Collection of retrieved networks */
	
	// Outlets
	IBOutlet NSTableView *networkTable; /**< Holds a list of networks that can be viewed/plotted */
	IBOutlet NSMenuItem *currentMapType; /**< Saves the currently selected map type */
	IBOutlet NSMenuItem *gridMenuItem; /**< Menu item that corresponds to showing/hiding the grid */
	IBOutlet NSMenu *mapTypeMenu; /**< The menu the holds all the map types */
	IBOutlet NSButton *animationButton; /**< The button used to toggle the animation drawer */
	IBOutlet NSButton *detailsButton; /**< The button used to toggle the details drawer */
	
	// Controllers
	IBOutlet FeedsController *feedsController; /**< The controller that manages teh reading in/removing of external feeds */
	IBOutlet PropertiesDrawerController *propertyDrawerController; /**< Controller that manages the properties drawer */
	IBOutlet AnimationController *animationController; /**< Controller that manages the animation of the map */
	IBOutlet MapController *mapController; /**< Controller that is responsible for the map, and the drawing layers on top of the map */
	IBOutlet NSArrayController *networks; /**< The array of all networks */
	IBOutlet PreferenceController *preferenceController; /**< Controller that is used to manage the user settings */
}

@property(nonatomic, retain)IBOutlet NSTableView *networkTable;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;

- (IBAction)toggleGrid:(id)sender;
- (IBAction)mapTypeMenuItemClicked:(id)sender;
- (IBAction)rowSelected:(id)sender;
- (IBAction)centerMapOnSelectedNetwork:(id)sender;
- (IBAction)toggleNetworkVisibility:(id)sender;
- (IBAction)refreshData:(id)sender;
- (IBAction)selectNetworksForAnimation:(id)sender;
- (void)applyPreferences;
- (NSArray *)createData;

#pragma mark -
#pragma mark Received Notifications
- (void)mapLoaded:(NSNotification *)note;


@end
