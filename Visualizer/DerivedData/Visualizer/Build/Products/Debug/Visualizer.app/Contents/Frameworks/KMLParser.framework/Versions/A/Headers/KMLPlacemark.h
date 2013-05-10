//
//  KMLPlacemark.h
//  KMLParser
//
//  Created by Ben Heebner on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KMLIcon.h"
#import "KMLPoint.h"

/**
 KMLPlacemark.h
 KMLParser
 
 This class represents the placemark node of a KML document.
 */
@interface KMLPlacemark : NSObject {
	NSString *name; /**< The name of the placemark */
	NSString *description; /**< A description of the placemark */
	NSString *styleURL; /**< The name of the style to apply to this placemark */
	KMLPoint *point; /**< The geographic location of the placemark */
}

@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *styleURL;
@property(nonatomic,retain)KMLPoint *point;

/**
 Initializer for the KMLPlacemark object.  This initlizer uses in the input NSXMLElement to populate the class fields.
 @param element NSXMLElement instance used to popluate the class.
 */
- (id)initWithXMLElement:(NSXMLElement *)element;

/**
 This method creates the KML text for KML Placemark
 */
- (NSString *)getKMLNodeText;

@end
