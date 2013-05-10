//
//  NetworkPlot.h
//  Visualizer
//


#import <Cocoa/Cocoa.h>
#import "Network.h"

/**
 * This class is a wrapper around the Network class.  It contains method used to generate plots for the 
 * histogram created for the animation drawer
 */
@interface NetworkPlot : NSObject {
	Network *network; /**< Network that contains the metadata about the NetworkPlot instance */
	NSMutableArray *plots; /**< The plots that represent the network readings */
}

/**
 * Gets the plots associated with this network
 */
@property (nonatomic, retain, readonly)NSArray *plots;
/**
 * Gets the network used as the underlying data object for this class
 */
@property (nonatomic, retain)Network *network;

- (id)initWithNetwork:(Network *)ntwrk;
- (void)recalculatePlotsWithStartDate:(NSDate *)startDate interval:(NSTimeInterval)interval numberOfPlots:(int)numPlots;
@end
