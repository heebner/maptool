/*
 * MapModel.h
 * Visualizer
 *
 * This class is used to model the data for display in the Visualizer HMI.  This class
 * is responsible for maintaining the network data structures.
 */

#import "MapModel.h"
#import "AppController.h"

@implementation MapModel

@synthesize networkEntries;

- (id)init
{
	self = [super init];
	networkEntries = [[NSMutableArray alloc] init];
	return self;
}

/**
 * Method takes an NSArray of AccessPoint objects to add to the collection of displayed networks
 * @param networks The collect of networks to add to the collection
 */
- (void)addNetworks:(NSArray *)networks
{
	for(int index = 0; index < [networks count]; index++) {
		[networkEntries addObject:[networks objectAtIndex:index]];
	}
}

/**
 * Gets the visible networks (networks that have their 'isChecked' flag set to 'YES'
 * @return The set of visible networks
 */
- (NSArray *)getVisibleNetworks
{
	NSMutableArray *returnSet = [[[NSMutableArray alloc] init] autorelease];
	
	for(Network *network in networkEntries) {
		if(network.isChecked == YES) {
			[returnSet addObject:network];
		}
	}
	
	return returnSet;
}

- (void)dealloc
{
	[networkEntries release];
	[super dealloc];
}

@end
