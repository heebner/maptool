/**
 PropertiesDrawerController.h
 Visualizer

 The class manages the properties drawer the slides out from the bottom of the main display.  It's responsible for displaying
 the details of the currently selected network in the network.  This pane also displays the all of the network readings for
 the selected network.  The controls to turn on/off different Visualizations are contained on this pane as well.
 */

#import <Cocoa/Cocoa.h>
#import "Network.h"
#import "MapController.h"

@interface PropertiesDrawerController : NSObject {
	Network *currentNetwork; /**< The currently displayed network in the properties drawer */
	NetworkReading *currentNetworkReading; /**< The currently selected network reading in the networkReadingTable */
	IBOutlet NSArrayController *networkReadingController; /**< Controller used to display the network readings in the network readigns table */
	IBOutlet NSDrawer *propertiesDrawer; /**< Drawer used to display the properties */
	IBOutlet MapController *mapController; /**< Controller used to plot points on the map */
	IBOutlet NSTableView *networkTable; /**< Holds a list of networks that can be viewed/plotted */
	
	// Access Point "stuff"
	IBOutlet NSTextField *accessPointMode; /**< The mode of the access point ('ad-hoc' or 'infrastructure') */
	IBOutlet NSTextField *beaconInterval; /**< The beacon interval for the access point */
	IBOutlet NSTextField *BSSID; /**< The Basic Service Set Identifier (BSSID) for the access point, typically noted in Media Access Control (MAC) address form */
	IBOutlet NSTextField *channel; /**< The channel used by the access point */
	IBOutlet NSTextField *channelFlags; /**< A bitmasked channel flag list for the access point - the meaning of the values are mostly unknown at this point */
	IBOutlet NSBox *healthBox; /**< The box used to indicate the health of the network */
	/**
	 * The encryption setup employed by the access point.
	 *   - 0 = none
	 *   - 1 = WEP
	 *   - 2 = WPA
	 *   - 3 = WPA2 w/AES
	 *   - 4 = WPA2 w/TKIP+AES
	 */
	IBOutlet NSTextField *encryption; /**< Text field the shows the encryption of the network */
	IBOutlet NSTextField *hidden; /**< A boolean indicating whether or not the access point is "hidden", i.e. not broadcasting its Service Set Identifier (SSID) */
	IBOutlet NSTextField *SSID; /**< The Service Set Identifier (SSID) for the access point, which is generally its "name" */	
	IBOutlet NSButton *heatMapCheckBox; /**< Checkbox used to determine if the network should be drawn as a heat map */
	IBOutlet NSButton *sigMagCheckBox; /**< Checkbox used to determine if the network should be drawn as a signal magnitude map */
	IBOutlet NSButton *trilaterationCheckBox; /**< Checkbox used to determine if the network should show the trilaterated point */
	IBOutlet NSSlider *signalMagnitudeCoefficientSlider; /**< Slider used to change the signal magnitude coefficient */
	IBOutlet NSTextField *signalMagnitudeCoefficientValue; /**< Text field that displays the current coefficient slider value */
	
	// Signal Sample "stuff"
	IBOutlet NSTableView *networkReadingTable; /**< Table to hold the signal samples for the current Network */
	IBOutlet NSTextField *latitude; /**< The latitude for the location where this signal sample was obtained */
	IBOutlet NSTextField *longitude; /**< The longitude for the location where this signal sample was obtained */
	IBOutlet NSTextField *elevation; /**< The elevation for the location where this signal sample was obtained */
	IBOutlet NSTextField *noise; /**< A noise measurement for the signal sample, always seems to be a 0 */
	IBOutlet NSTextField *age; /**< Returned from the wireless scan API calls, not sure exactly what this value means, values seem to vary wildly */
	IBOutlet NSTextField *scanDirection; /**< Returned from the wireless scan API calls, is always 0, not sure exactly what this value means */
}

@property (nonatomic, retain) Network *currentNetwork;
@property (nonatomic, retain) NetworkReading *currentNetworkReading;


- (IBAction)toggleDrawer:(id)sender;
- (IBAction)toggleHeatMap:(id)sender;
- (IBAction)toggleSigMagMap:(id)sender;
- (IBAction)coefficientSliderChanged:(id)sender;
- (IBAction)rowSelected:(id)sender;
- (void)displayNetworkDetails:(Network *)network;
- (IBAction)toggleTrilateration:(id)sender;
- (IBAction)toggleNetworkReading:(id)sender;

@end
