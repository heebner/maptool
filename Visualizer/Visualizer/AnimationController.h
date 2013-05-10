

#import <Cocoa/Cocoa.h>
#import <CorePlot/CorePlot.h>
#import "Network.h"
#import "NetworkPlot.h"
#import "MapController.h"
#import "ClickableImageView.h"

extern NSString * const PlayEnabledActive;
extern NSString * const PlayPressedActive;
extern NSString * const PauseEnabledActive;
extern NSString * const PausePressedActive;
extern NSString * const BackwardEnabledActive;
extern NSString * const BackwardPressedActive;
extern NSString * const BeginningEnabledActive;
extern NSString * const BeginningPressedActive;
extern NSString * const EndEnabledActive;
extern NSString * const EndPressedActive;
extern NSString * const ForwardEnabledActive;
extern NSString * const ForwardPressedActive;
extern int const WindowBuffer;

/**
 AnimationController.h
 
 This class is responsible for the controlling of animation of network data on the screen. This 
 class generates the histogram that is displayed below the timeline slider.  This class also manages
 the mouse interactions with the player buttons on the drawer
 */
@interface AnimationController : NSObject <CPScatterPlotDataSource> {
	IBOutlet NSDrawer *animationDrawer;/**< The drawer the conatins the controls to animate the map */
	IBOutlet NSSlider *timelineSlider; /**< The slider used to manipulate the timeline */
	IBOutlet NSTextField *graphStartText; /**< The text field used to display the start time of the graph */
	IBOutlet NSTextField *graphEndText; /**< The text field used to display the end time of the graph */
	IBOutlet CPLayerHostingView *hostView; /**< The view that contains the graph */
	IBOutlet MapController *mapController; /**< Controller used to draw items on the map */
	CPXYGraph *graph; /**< Graph that holds the data about the networks be displayed */

	NSMutableDictionary *plots; /**< Collect of plots indexed by BSSID */
	NSMutableArray *colors; /**< Array of color to cycle through for each newly added network */
	NSTimer *timerLoop; /**< Loop used for the playing of the animation */
	NSTimer *mouseDownTimer; /**< Timer used to allow the user to hold down the Forward or Backward buttons for continuous play */
	NSDate *graphStart; /**< Date value of the start of the graph */ 
	NSDate *graphEnd; /**< Date value of the end of the graph */
	CPBarPlot *mainPlot; /**< Plot the contains the main histogram data */
	
	NSMutableDictionary *imagesDictionary; /**< Dictionary used to store the images for the player */
	IBOutlet ClickableImageView *playPauseImageView; /**< Image View for the play/pause button */
	IBOutlet ClickableImageView *forwardImageView; /**< Image View for the forward button */
	IBOutlet ClickableImageView *backwardImageView; /**< Image view for the backward button */
	IBOutlet ClickableImageView *endImageView; /**< Image view for the end button*/
	IBOutlet ClickableImageView *beginningImageView; /**< Image view for the beginning button */
}

/**
 * Gets the NSDrawer object that is the animation drawer
 */
@property (nonatomic, retain, readonly)NSDrawer *animationDrawer;

#pragma mark _
#pragma mark Methods for histogram Creation/Manipulation
- (IBAction)toggleDrawer:(id)sender;
- (IBAction)timelineSliderMoved:(id)sender;
- (void)buildGraph;
- (void)addNetworkToAnimate:(Network *)network;
- (void)removeNetwork:(Network *)network;
- (NSDate *)findEarliestPlotStartDate;
- (NSDate *)findLatestPlotEndDate;
- (void)recalculateGraphData;
- (void)initializeMapAfterOpening;
- (void)resetMapAfterClosing;
- (void)update;
- (void)setGraphAxis;

#pragma mark -
#pragma mark Plot Data Source Methods
-(NSUInteger)numberOfRecordsForPlot:(CPPlot *)plot;
-(NSNumber *)numberForPlot:(CPPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index;

#pragma mark -
#pragma mark Animation Control Methods
- (IBAction)timelineSliderMoved:(id)sender;
- (void)stepTimelineForward;
- (void)stepTimelineBackward;

@end
