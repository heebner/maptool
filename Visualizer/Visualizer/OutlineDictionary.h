//
//  OutlineDictionary.h
//  Visualizer
//


#import <Cocoa/Cocoa.h>
/**
 * The OutlineDictionary class is used as the datasource for the NSOutlineView on the main form
 */
@interface OutlineDictionary : NSObject {
	NSMutableDictionary *root; /**< This is the root Dictionary for the outline, it contains the lowest level nodes */
}

@property (assign, readonly) NSMutableDictionary *root;

- (void)addToRoot:(id)obj WithKey:(NSString *)key;

@end
