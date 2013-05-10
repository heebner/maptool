/*
 *  AppController.m
 *  Visualizer
 *
 *  Main controller class for the Visualizer HMI.  This class receives messages from the HMI and sends messages to the HMI to display data
 */
#import <Quartz/Quartz.h>
#import "AppController.h"
#import "JavascriptWrapper.h"
#import "NetworkReading.h"
#import "MapView.h"
#import "HeatMap.h"
#import "Constants.h"

/**
 * The String that defines the constant used for the AddHeatMapPlot Notification
 */
NSString * const TrilateratedPointMapName = @"TrilateratedPointMap";

@implementation AppController

@synthesize networkTable;

+ (void)initialize
{
	// This method is called before all other methods.  If the preference file doesn't exist, it'll be created here.
	NSString *userDirPath = NSHomeDirectory();
	NSString *preferenceFilePath = [userDirPath stringByAppendingPathComponent:@"Library/Preferences/com.bth.Visualizer.plist"];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:preferenceFilePath];
	
	if(fileExists == NO)
	{
		NSLog(@"The File doesn't exist at path %@", preferenceFilePath);
		// Get the path to the resource
		NSString *defaultPreferences = [[NSBundle mainBundle] pathForResource:@"com.bth.Visualizer" ofType:@"plist"];
        NSError *error;
		[[NSFileManager defaultManager] copyItemAtPath:defaultPreferences toPath:preferenceFilePath error:&error];
	}
}

/**
 * Initializing method for the AppController.  This method sets up the notifications that the AppController cares about.
 */
- (id)init
{
	// Register for Notifications we care about
	// We want to know when the map is enabled so we can enable the Grid Checkbox
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];	
	[nc addObserver:self
		   selector:@selector(mapLoaded:) 
			   name:MapLoadedNotification
			 object:nil];
	return self;
}

/**
 * Overriden method that retrieves the data from the sqlite files 
 * found in the resources directory of the project.  This
 * method also populates the Network Table.
 */
- (void)awakeFromNib
{	
	[mapController init];
	[networkTable setEnabled:NO];
	
    NSArray *accessPoints = [self createData];
    [accessPoints retain];
    
	for(AccessPoint *ap in accessPoints)	{
        Network *temp = [[Network alloc] initWithAccessPoint:ap];
		[networks addObject:temp];
        [temp release];

	}
    [accessPoints release];
	
	NSLog(@"Networks Loaded: %lu", [[networks arrangedObjects] count]);	

}

/**
 * We used to use CoreData to save/load data, but it got too fickle
 * when it changed versions.
 */
- (NSArray *)createData{
    NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
    NSMutableDictionary *samples = [[NSMutableDictionary alloc] init];
    
    NSError *error;
    NSString *signalSamples = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"signalsample" ofType:@"csv"]
                                                        encoding:NSStringEncodingConversionAllowLossy
                                                           error:&error];
    NSArray *arrayOfLines = [signalSamples componentsSeparatedByString:@"\n"];

    
    for(NSString *line in arrayOfLines) {
        NSMutableString *temp = [[NSMutableString alloc] initWithString:line];
        NSUInteger s = 0;
        NSUInteger e = [line length];
        
        
        [temp replaceOccurrencesOfString:@"\"" 
                              withString:@"" 
                                 options:NSCaseInsensitiveSearch 
                                   range:NSMakeRange(s, e)]; 
        
        NSArray *values = [temp componentsSeparatedByString:@","];
        [temp release];
        //0  "Z_PK"
        //1  "Z_ENT"
        //2  "Z_OPT"
        //3  "ZSCANWASDIRECTED"
        //4  "ZAGE"
        //5  "ZRSSI"
        //6  "ZNOISE"
        //7  "ZACCESSPOINT"
        //8  "ZSAMPLEDATLOCATIONLATITUDE"
        //9  "ZSAMPLEDATTIMESTAMP",
        //10 "ZSAMPLEDATLOCATIONLONGITUDE",
        //11 "ZSAMPLEDATLOCATIONELEVATION",
        //12 "ZHANDSETIDENTIFIER"
        //SignalSample *ss = [NSEntityDescription
        //                    insertNewObjectForEntityForName:@"SignalSample"
        //                    inManagedObjectContext:[self managedObjectContext]];
        SignalSample *ss = [[SignalSample alloc] init];
        NSString *scanWasDirected = [values objectAtIndex:3];
        ss.scanWasDirected =        [NSNumber numberWithInteger:[scanWasDirected integerValue]];
        NSString *age =             [values objectAtIndex:4];
        ss.age =                    [NSNumber numberWithInteger:[age integerValue]];
        NSString *rssi =            [values objectAtIndex:5];
        ss.RSSI =                   [NSNumber numberWithInteger:[rssi integerValue]];
        NSString *noise =           [values objectAtIndex:6];
        ss.noise =                  [NSNumber numberWithInteger:[noise integerValue]];
        NSString *latitude =        [values objectAtIndex:8];
        ss.sampledAtLocationLatitude = [NSNumber numberWithDouble:[latitude doubleValue]];
        NSString *longitude =       [values objectAtIndex:10];
        ss.sampledAtLocationLongitude = [NSNumber numberWithDouble:[longitude doubleValue]];
        NSString *timestamp =       [values objectAtIndex:9];
        
        //275263402.314475
        NSTimeInterval interval = [timestamp doubleValue];
        NSCalendar *calendar = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setCalendar:calendar];
        [components setYear:2001];
        [components setMonth:1];
        [components setDay:1];
        [components setHour:0];
        [components setMinute:0];
        [components setSecond:0];
        NSDate *epoch = [calendar dateFromComponents:components];
        NSDate *d = [NSDate dateWithTimeInterval:interval sinceDate:epoch];
        ss.sampledAtTimeStamp = d;
        [components release];
        [calendar release];
        
        NSString *elevation =       [values objectAtIndex:11];
        ss.sampledAtLocationElevation = [NSNumber numberWithInteger:[elevation integerValue]];
        NSString *handset =         [values objectAtIndex:12];
        ss.handsetIdentifier =      handset;
        
        
        
        NSString *accessPoint =     [values objectAtIndex:7];
        if([samples objectForKey:accessPoint] == nil) {
            NSMutableArray *tempSamples = [[NSMutableArray alloc] init];
            [samples setObject:tempSamples forKey:accessPoint];
            [tempSamples release];
        }
        [[samples objectForKey:accessPoint] addObject:ss];
        [ss release];
        
    }
    
    NSString *accessPoints = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"accesspts" ofType:@"csv"]
                                                       encoding:NSStringEncodingConversionAllowLossy 
                                                          error:&error];
    
    arrayOfLines = [accessPoints componentsSeparatedByString:@"\n"];
    
    
    for(NSString *line in arrayOfLines) {
        NSMutableString *temp = [[NSMutableString alloc] initWithString:line];
        NSUInteger s = 0;
        NSUInteger e = [line length];
        
        
        [temp replaceOccurrencesOfString:@"\"" 
                              withString:@"" 
                                 options:NSCaseInsensitiveSearch 
                                   range:NSMakeRange(s, e)]; 
        
        NSArray *values = [temp componentsSeparatedByString:@","];
        [temp release];
        //0   "Z_PK",
        //1   "Z_ENT",
        //2   "Z_OPT",
        //3   "ZCHANNEL",
        //4   "ZACCESSPOINTMODE",
        //5   "ZCAPABILITIES",
        //6   "ZBEACONINTERVAL",
        //7   "ZENCRYPTION",
        //8   "ZHIDDEN",
        //9   "ZCHANNELFLAGS",
        //10  "ZBSSID",
        //11  "ZSSID",
        //12  "ZSUPPORTEDRATES"
        //AccessPoint *ap = [NSEntityDescription
        //                   insertNewObjectForEntityForName:@"AccessPoint"
        //                   inManagedObjectContext:[self managedObjectContext]];
        AccessPoint *ap = [[AccessPoint alloc] init];
        
        NSString *channel =         [values objectAtIndex:3];
        ap.channel =                [NSNumber numberWithInteger:[channel integerValue]];
        NSString *accesspointmode = [values objectAtIndex:4];
        ap.accessPointMode =        [NSNumber numberWithInteger:[accesspointmode integerValue]];
        NSString *capabilities =    [values objectAtIndex:5];
        ap.capabilities =           [NSNumber numberWithInteger:[capabilities integerValue]];
        NSString *beaconInterval =  [values objectAtIndex:6];
        ap.beaconInterval =         [NSNumber numberWithInteger:[beaconInterval integerValue]];
        NSString *encryption =      [values objectAtIndex:7];
        ap.encryption =             [NSNumber numberWithInteger:[encryption integerValue]];
        NSString *hidden =          [values objectAtIndex:8];
        ap.hidden =                 [NSNumber numberWithInteger:[hidden integerValue]];
        NSString *channelFlags =    [values objectAtIndex:9];
        ap.channelFlags =           [NSNumber numberWithInteger:[channelFlags integerValue]];
        NSString *bssid =           [values objectAtIndex:10];
        ap.BSSID = bssid;
        NSString *ssid =            [values objectAtIndex:11];
        ap.SSID = ssid;
        
        NSString *key = [values objectAtIndex:0];
        for(SignalSample *s in [samples objectForKey:key]){
            [s setAccessPoint:ap];
            [ap addSignalSamplesObject:s];
        }
        NSLog(@"Access Point: %@ has %lu signal samples.", ap.SSID, [ap.signalSamples count]);

        [returnArray addObject:ap];
        [ap release];
        
    }
    [samples release];
    return returnArray;
}

/**
 This method blows away any data in the Networks array controller and re-fills is with the contents
 of the TacCSA database
 @param sender The entity that invoked this method
 */
- (IBAction)refreshData:(id)sender
{
	[mapController clearMap];
    [networkTable reloadData];
	[mapController redrawMap];
}


/**
 * This method applies the current user defaults to display.  This method only deals with 
 * defaults that deal with "On Startup" options
 */
- (void)applyPreferences
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[self mapTypeMenuItemClicked:[mapTypeMenu itemAtIndex:[defaults integerForKey:PrefMapType]]];
    [mapController setZoomLevel:[defaults integerForKey:PrefMapZoom]];
	
	if([defaults boolForKey:PrefGridOnStartup] == YES)
	{
		[self toggleGrid:gridMenuItem];
	}
	
	if([defaults boolForKey:PrefShowDetailsDrawer] == YES)
	{
		[detailsButton performClick:NULL];
	}
	
	if([defaults boolForKey:PrefShowAnimationDrawer] == YES)
	{
		[animationButton performClick:NULL];
	}
	if([defaults boolForKey:PrefCenterOnFirstNetwork] == YES)
	{
		if([[networks arrangedObjects] count] > 0)
		{
			[networks setSelectionIndex:0];
			Network *network = [[networks arrangedObjects] objectAtIndex:0];
            SinglePoint *temp = [network getCenterPoint];
            [temp retain];
			[mapController centerMap:[network getCenterPoint]];
            [temp release];
			
		}
	}
    else if([defaults doubleForKey:PrefStartingLatitude] != 0 &&
            [defaults doubleForKey:PrefStartingLongitude] != 0) {
        SinglePoint *pt = [[SinglePoint alloc] initWithLatLong:[defaults doubleForKey:PrefStartingLatitude] Longitude:[defaults doubleForKey:PrefStartingLongitude]];
        [mapController centerMap:pt];
        [pt release];
    }
}

/**
 This method selects a hard-coded set of networks that look good for animation mode
 @param sender The menu item "Select Animation Networks"
 */
- (IBAction)selectNetworksForAnimation:(id)sender
{
	for(Network *network in [networks arrangedObjects])
	{
		if ([[network SSID] isEqualToString:@"wireless1"] == YES ||
			[[network SSID] isEqualToString:@"Bigglesworth"] == YES ||
			[[network SSID] isEqualToString:@"CAPT ZODD"] == YES ||
			[[network SSID] isEqualToString:@"Computer1"] == YES ||
			[[network SSID] isEqualToString:@"Library_Network"] == YES ||
			[[network SSID] isEqualToString:@"Mcmahon"] == YES ||
			[[network SSID] isEqualToString:@"RWN"] == YES ||
			[[network SSID] isEqualToString:@"Snoopy"] == YES ||
			[[network SSID] isEqualToString:@"WSNet"] == YES ||
			[[network SSID] isEqualToString:@"Wilson"] == YES)
		{
			if([network isChecked] != YES)
			{
				[network setIsChecked:YES];
				
				if([[animationController animationDrawer] state] == NSDrawerClosedState ||
				   [[animationController animationDrawer] state] == NSDrawerClosingState)
				{
					if([network shouldPlotAsHeatMap] == YES)
					{
						[mapController addPointsToHeatMap:network.readings];
					}
					if([network shouldPlotAsSigMagMap] == YES)
					{
						[mapController addPointsToSignalMagnitudeMap:network.readings];
					}
					if([network shouldShowTrilateration] == YES)
					{
						[mapController addSinglePoint:[network getTrilateratedPoint] forMap:TrilateratedPointMapName];
					}
				}			
				[animationController addNetworkToAnimate:network];
			}
			[propertyDrawerController displayNetworkDetails:network];
		}
	}
	[mapController redrawMap];
}

#pragma mark -
#pragma mark Received Notifications
/**
 * Method that is invoked when the map is loaded.  We can't show the grid until the map is loaded, so we
 * won't allow the user to turn it on until the map is loaded
 * @param note Object associated with the notification
 */
- (void)mapLoaded:(NSNotification *)note
{
	[networkTable setEnabled:YES];
    [networkTable reloadData];
	[self applyPreferences];
}

#pragma mark -
#pragma mark Show/Hide Grid Methods

/**
 * Method that is invoked whenever the Grid checkbox is checked/unchecked
 * @param sender The grid checkbox
 */
- (IBAction)toggleGrid:(id)sender
{
	if([[sender title] isEqualToString:@"Show Grid"] == YES)
	{
		[sender setTitle:@"Hide Grid"];
	}
	else
	{
		[sender setTitle:@"Show Grid"];
	}
	[gridMenuItem setState:![gridMenuItem state]];
	[mapController shouldDrawGrid:[gridMenuItem state]];
}

/**
 * This method is called whenever the user uses a control to center the map onthe currently selected network
 * @param sender The menu option on the toolbar, or on the context menu for the network table
 */
- (IBAction)centerMapOnSelectedNetwork:(id)sender
{
	NSInteger temp = [networkTable selectedRow];
	Network *network = [[networks arrangedObjects] objectAtIndex:temp];
	
	if(network != nil)
	{
        SinglePoint *temp = [network getCenterPoint];
        [temp retain];
		[mapController centerMap:[network getCenterPoint]];
        [temp release];
	}
}


/**
 * This is invoked whenever the user checks/unchecks the checkbox associated with the network
 * @param sender The network table view
 */
- (IBAction)toggleNetworkVisibility:(id)sender
{
	NSTableView *table = (NSTableView *)sender;
	NSInteger temp = [table selectedRow];
	Network *network = [[networks arrangedObjects] objectAtIndex:temp];
	
	if([network isChecked] == NSOnState || [network isChecked] == NSMixedState)
	{
		if([[animationController animationDrawer] state] == NSDrawerClosedState ||
			[[animationController animationDrawer] state] == NSDrawerClosingState)
		{
			if([network shouldPlotAsHeatMap] == YES)
			{
				[mapController addPointsToHeatMap:network.readings];
			}
			if([network shouldPlotAsSigMagMap] == YES)
			{
				[mapController addPointsToSignalMagnitudeMap:network.readings];
			}
			if([network shouldShowTrilateration] == YES)
			{
				[mapController addSinglePoint:[network getTrilateratedPoint] forMap:TrilateratedPointMapName];
			}
		}			
		[animationController addNetworkToAnimate:network];
	}
	else
	{
		[mapController removePointsFromHeatMap:network.readings]; 	
		[mapController removePointsFromSignalMagnitudeMap:network.readings];
		[mapController removeSinglePoint:[network getTrilateratedPoint] forMap:TrilateratedPointMapName];
		[animationController removeNetwork:network];
		
	}
	[propertyDrawerController displayNetworkDetails:network];
}

/**
 * Method that fires when the user clicks on a row in the network table
 * @param sender The network table
 */
- (IBAction)rowSelected:(id)sender
{
	NSTableView *table = (NSTableView *)sender;
	NSInteger temp = [table selectedRow];
	Network *network = [[networks arrangedObjects] objectAtIndex:temp];
	[propertyDrawerController displayNetworkDetails:network];
	[mapController redrawMap];
}

#pragma mark -
#pragma mark Changing Map Type Methods

/**
 * Method that handles the action of when the user clicks on a map type in the toolbar
 * @param sender The menu item that ws clicked
 */
- (IBAction)mapTypeMenuItemClicked:(id)sender
{
	NSMenuItem *item = (NSMenuItem *)sender;
	[currentMapType setState:NSOffState];
	currentMapType = item;
	[currentMapType setState:NSOnState];
	
	[mapController changeMapType:[currentMapType title]];
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
	
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    //NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Visualizer.sqlite"]];
	NSURL *storeUrl = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"Visualizer" ofType:@"sqlite"]];
	
	NSError *error;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        // Handle error
    }    
	
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


	
#pragma mark -
#pragma mark Class Cleanup
-(void)dealloc
{
	[networkTable release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];
	[managedObjectContext release];
	[mapController release];
	[preferenceController release]; 
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	
	[super dealloc];
}



@end
