//
//  KMLPoint.h
//  KMLParser
//
//  Created by Ben Heebner on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KMLCoordinates.h"

/**
 KMLPoint.h
 KMLParser
 
 This class represents the Point node of a KML document.
 */
@interface KMLPoint : NSObject {
	KMLCoordinates *coordinates; /**< The coordinates associated with the point */
}

@property (nonatomic, retain)KMLCoordinates *coordinates;

/**
 Initializer for the KMLPoint object.  This initlizer uses in the input NSXMLElement to populate the class fields.
 @param element NSXMLElement instace used to popluate the class.
 */
- (id)initWithXMLElement:(NSXMLElement *)element;

/**
 This method creates the KML text for KML Point
 */
- (NSString *)getKMLNodeText;
@end
