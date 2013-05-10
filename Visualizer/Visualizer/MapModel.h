/**
 * MapModel.h
 * Visualizer
 *
 * This class is used to model the data for display in the Visualizer HMI.  This class
 * is responsible for maintaining the network data structures.
 */

#import <Cocoa/Cocoa.h>
#import "Network.h"

@interface MapModel : NSObject 
{	
	NSMutableArray *networkEntries; /**< This is the array used to hold all of the network data entries. */ 
}

/**
 * Accessors for getting and setting values on the network entires array
 */
@property (nonatomic, retain)NSMutableArray *networkEntries;

- (void)addNetworks:(NSArray *)networks;

- (NSArray *)getVisibleNetworks;

@end
