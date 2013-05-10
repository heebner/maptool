//
//  NetworkPlot.m
//  Visualizer
//


#import "NetworkPlot.h"


@implementation NetworkPlot

@synthesize plots;
@synthesize network;

/**
 * Initializes the NetworkPlot class with a network to use as the underlying data object
 * @param ntwrk The network to use at the underlying data object
 */
- (id)initWithNetwork:(Network *)ntwrk
{
	self = [super init];
    [self setNetwork:ntwrk];
    plots = [[NSMutableArray alloc] init];
	
	return self;
}


/**
 * Recalculates the plots for this network based on the input start date, interval and number of plots
 * @param startDate The starting date to use as the first plot location (this may be before the start of data for this network)
 * @param interval The interval of time to use to bin the network data into
 * @param numPlots The number plots or bins to create for the network data
 */
- (void)recalculatePlotsWithStartDate:(NSDate *)startDate interval:(NSTimeInterval)interval numberOfPlots:(int)numPlots
{
	[plots removeAllObjects];
	[plots release];
	plots = [[NSMutableArray alloc] initWithCapacity:numPlots];

	for(int index = 0; index < numPlots; index++)
	{
		NSMutableArray *temp = [[NSMutableArray alloc] init];
		// initialize the array with empty arrays
		[plots insertObject:temp atIndex:index];
        [temp release];
	}
	
	for(NetworkReading *nr in [network readings])
	{
		NSTimeInterval span = [[[nr signalSample] sampledAtTimeStamp] timeIntervalSinceDate:startDate];
		int index = floor(span / interval);
		// Create n array of the plots at the index
		NSMutableArray *tempPlots = [plots objectAtIndex:index];
		[tempPlots addObject:nr];		
	}
}

- (NSArray *)getPlotsForSpan:(NSDate *)time withInterval:(NSTimeInterval)interval
{
	NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
	NSDate *endTime = [time dateByAddingTimeInterval:interval];
	for(NetworkReading *nr in [network readings])
	{
		if([[[nr signalSample] sampledAtTimeStamp] earlierDate:endTime] == [[nr signalSample] sampledAtTimeStamp] &&
		   [[[nr signalSample] sampledAtTimeStamp] laterDate:time] == [[nr signalSample] sampledAtTimeStamp])
		{
			[returnArray addObject:nr];
		}
	}
	return returnArray;
}

- (void)dealloc
{
	[network release];
	[plots release];
	[super dealloc];
}

@end
