//
//  OutlineDictionary.m
//  Visualizer
//


#import "OutlineDictionary.h"
#import "Network.h"


@implementation OutlineDictionary
	
@synthesize root;

- (id)init
{
	self = [super init];
    root = [[NSMutableDictionary alloc] init];
	[root setObject:@"Root Node" forKey:@"root"];
	
	return self;
}

- (void)dealloc
{
	[root release];
	[super dealloc];
}

/**
 * This method add the input object to the root object using the input key
 * @param obj The object to add to the root object
 * @param key The key to use to set the object on the root object
 */
- (void)addToRoot:(id)obj WithKey:(NSString *)key
{
	[root setObject:obj forKey:key];
	[obj release];
	[key release];
}

- (NSUInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	// The NSOutlineView calls this when it needs to know how many children
    // a particular item has. Because we are using a standard tree of NSDictionary,
    // NSArray, NSString etc objects, we can just return the count.
    
    // The root node is special; if the NSOutline view asks for the children of nil,
    // we give it the count of the root dictionary.
    
    if (item == nil)
    {
        return [root count];
    }
	
    // If it's an NSArray or NSDictionary, return the count.
    
    if ([item isKindOfClass:[NSDictionary class]] || [item isKindOfClass:[NSArray class]]) 
    {
        return [item count];
    }
	
    // It can't have children if it's not an NSDictionary or NSArray.
	
    return 0; 
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    // NSOutlineView calls this when it needs to know if an item can be expanded.
    // In our case, if an item is an NSArray or NSDictionary AND their count is > 0
    // then they are expandable.
    
    if ([item isKindOfClass:[NSArray class]] || [item isKindOfClass:[NSDictionary class]])
    {
        if ([item count] > 0)
            return YES;
    }
    
    // Return NO in all other cases.
    
    return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item
{
    // NSOutlineView will iterate over every child of every item, recursively asking
    // for the entry at each index. We return the item at a given array index,
    // or at the given dictionary key index.
    
    if (item == nil)
    {
        item = root;
    }
    
    if ([item isKindOfClass:[NSArray class]]) 
    {
        return [item objectAtIndex:index];
    }
    else if ([item isKindOfClass:[NSDictionary class]]) 
	{
        return [item objectForKey:[[item allKeys] objectAtIndex:index]];
    }
    
    return nil;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{

    // NSOutlineView calls this for each column in your NSOutlineView, for each item.
    // You need to work out what you want displayed in each column; in our case we
    // create in Interface Builder two columns, one called "Key" and the other "Value".
    // 
    // If the NSOutlineView is after the key for an item, we use either the NSDictionary
    // key for that item, or we count from 0 for NSArrays. 
    //
    // Note that you can find the parent of a given item using [outlineView parentForItem:item];
    
    //if ([[[tableColumn headerCell] stringValue] compare:@"Views"] == NSOrderedSame) 
    //{
        // Return the key for this item. First, get the parent array or dictionary.
        // If the parent is nil, then that must be root, so we'll get the root
        // dictionary.
        if([outlineView parentForItem:item] == nil)
		{
			id temp = [[root allKeysForObject:item] objectAtIndex:0];
			// This means the item is the root
			NSLog(@"%@ temp:", temp);
			//NSLog(@"%@ item:", item);
			return temp;
		}
		else
		{
			if([item isKindOfClass:[Network class]] == YES)
			{
				Network *temp = (Network *)item;
				NSButtonCell *newCell = [[[NSButtonCell alloc] initTextCell:[temp BSSID]] autorelease];
				[newCell setState:[temp isChecked]];
				
				NSLog(@"Got Here: %@", [temp BSSID]);
				return @"Something Else";
			}
		}
		
		
        /*id parentObject = [outlineView parentForItem:item] ? [outlineView parentForItem:item] : root;
        
        if ([parentObject isKindOfClass:[NSDictionary class]]) 
        {
            // Dictionaries have keys, so we can return the key name. We'll assume
            // here that keys/objects have a one to one relationship.
			NSButtonCell *cell = [[NSButtonCell alloc] init];
			NSString *t = [[parentObject allKeysForObject:item] objectAtIndex:0];
			[cell setTitle:[[parentObject allKeysForObject:item] objectAtIndex:0]];
			NSLog(@"%@", [cell title]);
			//return [cell title];
            //return [[parentObject allKeysForObject:item] objectAtIndex:0];
        } 
        else if ([parentObject isKindOfClass:[NSArray class]]) 
        {
            // Arrays don't have keys (usually), so we have to use a name
            // based on the index of the object.
            
            return [NSString stringWithFormat:@"Item %d", [parentObject indexOfObject:item]];
        }*/
    //} 

    return nil;
}

@end
