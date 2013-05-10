//
//  KMLStyle.h
//  KMLParser
//
//  Created by Ben Heebner on 12/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KMLIconStyle.h"

/**
 KMLStyle.h
 KMLParser
 
 This class represents the Style node of a KML document.
 */
@interface KMLStyle : NSObject {
	KMLIconStyle *iconStyle; /**< Icon style associated with this style object */
	NSString *identifier; /**< Name of the style */
}

@property (nonatomic,retain)KMLIconStyle *iconStyle;
@property (nonatomic,retain)NSString *identifier;


/**
 Initializer for the KMLStyle object.  This initlizer uses in the input NSXMLElement to populate the class fields.
 @param element NSXMLElement instance used to popluate the class.
 */
- (id)initWithXMLElement:(NSXMLElement *)element;

/**
 This method creates the KML text for KML Style
 */
- (NSString *)getKMLNodeText;
@end
