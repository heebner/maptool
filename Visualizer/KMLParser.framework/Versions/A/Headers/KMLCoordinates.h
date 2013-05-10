//
//  KMLCoordinates.h
//  KMLParser
//
//  Created by Ben Heebner on 12/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 KMLCoordinates.h
 KMLParser
 
 This class represents the Coordinates node of a KML document.
 */
@interface KMLCoordinates : NSObject {
	
	double latitude; /**< The latitude of the point */
	double longitude; /**< The longitude of the point */
	double elevation; /**< The elevation of the point */
}

@property (nonatomic)double latitude;
@property (nonatomic)double longitude;
@property (nonatomic)double elevation;

/**
 Initializer for the KMLCoordinates class. This class takes the input data and saves it in it's class members
 @param element The NSXMLElement that contains the KML data to popluate the class
 */
- (id)initWithXMLElement:(NSXMLElement *)element;

/**
 This method creates the KML text for KML Coordinate
 */
- (NSString *)getKMLNodeText;


@end
