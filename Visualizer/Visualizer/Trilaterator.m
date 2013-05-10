//
//  Trilaterator.m
//  Visualizer
//


#import "Trilaterator.h"
#import "Network.h"
#import "SignalSample.h"


@implementation Trilaterator

/**
 * This method determines the intersection points (0, 1, or 2) for the provided signal samples.
 * @param firstSample The first signal sample for the calculation
 * @param secondSample The second signal sample for the calculation
 * @return A GeoCircleIntersection object that represents where the two signal samples intersect
 */
+ (GeoCircleIntersection *)determineSignalSampleIntersectionPoints: (SignalSample *)firstSample secondSample:(SignalSample *)secondSample 
{
	
	GeoCircle *firstSampleCircle = [[GeoCircle alloc] initWithLatitudeLongitudeAndRadius: [firstSample.sampledAtLocationLatitude doubleValue]
																			   longitude: [firstSample.sampledAtLocationLongitude doubleValue]
																				  radius: [firstSample RSSIAsDistanceInMeters]];
	GeoCircle *secondSampleCircle = [[GeoCircle alloc] initWithLatitudeLongitudeAndRadius: [secondSample.sampledAtLocationLatitude doubleValue]
																				longitude: [secondSample.sampledAtLocationLongitude doubleValue]
																				   radius: [secondSample RSSIAsDistanceInMeters]];
	
	GeoCircleIntersection *intersection = [firstSampleCircle intersectionWithCircle: secondSampleCircle];
	
	[firstSampleCircle release];
	[secondSampleCircle release];
	
	return intersection;
}

/**
 * This method attempts to determine the location of an access point using trilateration.
 * @param accessPoint The access point to perform trilateration on - the method uses this access point's signal samples to perform the trilateration
 * @return The trilaterated location of the access point as a GeoCircle object (center = location, radius is basically the potential error)
 */
+ (GeoCircle *)trilaterate:(AccessPoint *)accessPoint
{
	// The object we intend to return
	GeoCircle *trilateratedLocationCircle = nil;
	
	// Calculate the intersections between each signal sample
	//NSArray *samples = [[accessPoint signalSamples] allObjects];
	NSMutableArray *samples = [[NSMutableArray alloc] init];
	for(SignalSample *ss in [[accessPoint signalSamples] allObjects])
	{
		if([ss shouldUseToTrilaterate] == YES)
		{
			[samples addObject:ss];
		}
	}
	
	
	NSMutableArray *intersectionPoints = [[NSMutableArray alloc] init];
	
	for (int i = 0; i < samples.count; i++) {
		for (int j = i; j < samples.count; j++) {
			GeoCircleIntersection *intersection = [self determineSignalSampleIntersectionPoints: [samples objectAtIndex: i]
																				   secondSample: [samples objectAtIndex: j]];
			
			if (intersection.intersectionPoint1.isValid) {
				[intersectionPoints addObject: intersection.intersectionPoint1];
			}
			
			if (intersection.intersectionPoint2.isValid) {
				[intersectionPoints addObject: intersection.intersectionPoint2];
			}
		}
	}
	
	
	if ([intersectionPoints count] > 0) 
	{
		// Calculate the number of nearest neighbors for each intersection point
		int intersectionPointNeighbors[[intersectionPoints count]];
		
		for (int i = 0; i < [intersectionPoints count]; i++) 
		{
			intersectionPointNeighbors[i] = 0;
			
			for (int j = i + 1; j < [intersectionPoints count]; j++) 
			{
				GeoCircle *intersectionCircle = [[GeoCircle alloc] initWithCenterAndRadius: [intersectionPoints objectAtIndex: i]
																					radius: intersectionRadiusVariationInMeters];
				GeoLocation *intersectionPoint = [intersectionPoints objectAtIndex: j];			
				
				if ([intersectionCircle containsLocation: intersectionPoint]) {
					intersectionPointNeighbors[i]++;
					intersectionPointNeighbors[j]++;
				}
				
				[intersectionCircle release];
			}
		}
		
		// Run through the list of intersection points, and find the largest cluster (most neighbors)
		int largestIntersectionClusterIndex = 0;
		int largestClusterCount = 0;
		
		for (int i = 0; i < [intersectionPoints count]; i++) {
			// Set the new max, and remember the index
			if (intersectionPointNeighbors[i] > largestClusterCount) {
				largestClusterCount = intersectionPointNeighbors[i];
				largestIntersectionClusterIndex = i;
			}
		}
		
		trilateratedLocationCircle = [GeoCircle geoCircleWithCenterAndRadius: [intersectionPoints objectAtIndex: largestIntersectionClusterIndex]
																	  radius: intersectionRadiusVariationInMeters];
	}
	
	[intersectionPoints release];
    [samples release];
	
	return trilateratedLocationCircle;	
}

@end
