/**
 \mainpage KMLParser
 \section intro_sec Introduction
 The KMLParser framework is a self-contained package the creates data objects from KML feeds and vice versa.
 The main class used to manipulate KML and KML data objects is the KMLParser class.  This works solely with
 the KMLRoot object.
 */


#import <Cocoa/Cocoa.h>
#import "KMLRoot.h"
#import "KMLDocument.h"
#import "KMLPlacemark.h"
#import "KMLIcon.h"
#import "KMLPoint.h"

/**
 KMLParser.h
 KMLParser
 
 This class has two responsibilities. First is to parse out data from a KML file.  The data within
 the KML file is returned to the user via the KMLRoot object.
 */
@interface KMLParser : NSObject {
    
}

/**
 * Parses and converts the input KML file.  The return KMLRoot object contains popluated KML objects.
 * @param url URL to the file that contains KML
 * @return An instance of the KMLRoot object that contains the KML data.
 */
+ (KMLRoot *)parseKMLFromURL:(NSURL *)url;

/**
 Generates a string of KML based on the information contained in the input KMLRoot object.
 @param root Instance of the KML Root object to generate KML from
 @return An instance of NSString that conatins the KML data
 */
+ (NSString *)generateKML:(KMLRoot *)root;
//+ (KMLRoot *)parseKMZFromURL:(NSURL *)url toLocation:(NSString *)path;

@end
