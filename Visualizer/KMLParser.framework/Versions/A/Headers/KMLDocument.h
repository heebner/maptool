//
//  KMLDocument.h
//  KMLParser
//
//  Created by Ben Heebner on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KMLStyle.h"

/**
 KMLDocument.h
 KMLParser
 
 This class represents the document node of a KML document.
 */
@interface KMLDocument : NSObject {
	NSString *identifier; /**< The identifier of the KML Document */ 
	NSString *name; /**< The name of the document */
	NSString *description; /**< A description of the document */
	NSString *address; /**< The address of the KML Document */
	NSMutableDictionary *styles; /**< The collection of icon style used by the placemarks, indexed by name */
	NSMutableArray *placemarks; /**< The collection of placemarks for the document  */
}

@property(nonatomic,retain)NSString *identifier;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,retain)NSString	*description;
@property(nonatomic,retain)NSString *address;
@property(nonatomic,retain)NSMutableArray *placemarks;

/**
 Initializer for the KMLDocument class.  This initializer uses the input NSXMLElement to parse out data
 to populate the members this instance.
 @param element NSXMLElement instance that contains the KML data for this instance of the KMLDocument object
 */
- (id)initWithXMLElement:(NSXMLElement *)element;

/**
 This method creates the KML text for KML Document
 */
- (NSString *)getKMLNodeText;

/**
 Adds an IconStyle to be used by the document object
 @param style The instance of the KMLIconStyle class to add to the document
 */
- (void)addStyle:(KMLStyle *)style;

/**
 Gets the IconStyle for the input name
 @param styleUrl The name of the icon style
 */
- (KMLStyle *)getStyle:(NSString *)styleUrl;


@end
