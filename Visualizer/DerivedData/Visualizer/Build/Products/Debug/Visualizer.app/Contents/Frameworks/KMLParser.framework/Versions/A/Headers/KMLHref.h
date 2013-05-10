//
//  KMLHref.h
//  KMLParser
//
//  Created by Ben Heebner on 12/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 KMLHref.h
 KMLParser
 
 This class represents the Href node of a KML document.
 */
@interface KMLHref : NSObject {
	NSString *url; /**< The string represenatation of the hyperlink reference */
}

@property (nonatomic, retain)NSString *url;

/**
 Initializer for the KMLHref class. This class takes the input data and saves it in it's class members
 @param element The NSXMLElement that contains the KML data to popluate the class
 */
- (id)initWithXMLElement:(NSXMLElement *)element;

/**
 This method creates the KML text for KML Href
 */
- (NSString *)getKMLNodeText;


@end
