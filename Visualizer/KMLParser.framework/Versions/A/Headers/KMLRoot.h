//
//  KMLRoot.h
//  KMLParser
//
//  Created by Ben Heebner on 10/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 KMLRoot.h
 KMLParser
 
 This class represents the root node of a KML document.
 */
@interface KMLRoot : NSObject {
	NSMutableArray *documents; /**< The collection of documents found in the KML root node */
}

@property(nonatomic,retain)NSMutableArray *documents;

/**
 Initializer for the KMLRoot object. This method takes in an NSXMLDocument object and uses it to parse
 out the data for the root node.  This is mainly document objects.
 @param document The NXSMLDocument object used to pull KML data from
 */
- (id)initWithXMLDocument:(NSXMLDocument *)document;

/**
 This method creates the KML text for KML Root
 */
- (NSString *)getKMLNodeText;

@end
