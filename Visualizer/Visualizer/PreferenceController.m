//
//  PreferenceController.m
//  Visualizer
//
//  Created by Ben Heebner on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreferenceController.h"
#import "Constants.h"


@implementation PreferenceController

- (id)init
{
	self = [super initWithWindowNibName:@"Preferences"];
	return self;
}

-(void)windowDidLoad
{
}

/**
 * Opens the preference pane on overtop of the main window
 * @param sender The menu item used byt he user to open the preferences
 */
- (IBAction)openPreferences:(id)sender
{
	[NSApp beginSheet:[self window] 
	   modalForWindow:mainWindow 
		modalDelegate:nil 
	   didEndSelector:NULL 
		  contextInfo:NULL];
	
	// Select the General Preferences
	[preferenceToolbar setSelectedItemIdentifier:@"GeneralPreferences"];
}

/**
 * The method is invoked when the user clicks the "Close" button the Feeds URLs window
 * @param sender The "Close" button the window
 */
- (IBAction)closePreferenceWindow:(id)sender
{
	[NSApp endSheet:[self window]];
	[[self window] orderOut:sender];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:PreferencesUpdatedNotification object:self];
}

/**
 Each of the toolbar button are hooked up to call this method when they are clicked.  This method
 uses the "tag" value on the toolbar item to map to the index of the view to display
 @param sender A toolbar button
 */
- (IBAction)displayPreferencePanel:(id)sender
{
	[viewPane selectTabViewItemAtIndex:[sender tag]];
}


@end
