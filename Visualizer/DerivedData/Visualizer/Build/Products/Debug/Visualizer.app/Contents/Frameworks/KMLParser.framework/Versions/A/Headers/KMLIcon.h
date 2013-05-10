//
//  KMLIcon.h
//  KMLParser
//
//  Created by Ben Heebner on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KMLHref.h"

/**
 KMLIcon.h
 KMLParser
 
 This class represents the Icon node of a KML document.
 */
@interface KMLIcon : NSObject {
	KMLHref *href; /**< A hyperlinked refence to an external file to display as the icon */
	NSImage *image; /**< If the href node is populated with an image than this member contains the image pointed to by the href tag */
}

@property(nonatomic,retain)KMLHref *href;
@property(nonatomic,retain)NSImage *image;

/**
 Initializer for the KMLIcon object.  This initlizer uses in the input NSXMLElement to populate the class fields.
 @param element NSXMLElement instance used to popluate the class.
 */
- (id)initWithXMLElement:(NSXMLElement *)element;

/**
 This method creates the KML text for KML Icon
 */
- (NSString *)getKMLNodeText;

@end
