//
//  KMLIconStyle.h
//  KMLParser
//
//  Created by Ben Heebner on 12/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KMLIcon.h"

/**
 KMLIconStyle.h
 KMLParser
 
 This class represents the Icon Style node of a KML document.
 */
@interface KMLIconStyle : NSObject {
	KMLIcon *icon; /**< The icon object associated with this style */ 
}

@property (nonatomic,retain)KMLIcon *icon;

/**
 Initializer for the KMLIconStyle object.  This initlizer uses in the input NSXMLElement to populate the class fields.
 @param element NSXMLElement instance used to popluate the class.
 */
- (id)initWithXMLElement:(NSXMLElement *)element;

/**
 This method creates the KML text for KML IconStyle
 */
- (NSString *)getKMLNodeText;

@end
