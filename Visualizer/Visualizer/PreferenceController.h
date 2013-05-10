
#import <Cocoa/Cocoa.h>


/**
 PreferenceController.h
 
 This class controls the preferences for the Visualizer Application.  This controller maps the 
 buttons on the toolbar across to the top fo the preference window to the view in the viewPane NSTabView.
 */
@interface PreferenceController : NSWindowController 
{
	
	IBOutlet NSUserDefaultsController *userDefaults; /**< Controller used to save/load user defaults */
	IBOutlet NSTabView *viewPane; /**< The tabview controller used to switch between different preference tabs */
	IBOutlet NSWindow *mainWindow; /**< The main windows of the Visualizer Application */
	IBOutlet NSToolbar *preferenceToolbar; /**< The toolbar on the top of the preferences window */
}


- (IBAction)openPreferences:(id)sender;
- (IBAction)closePreferenceWindow:(id)sender;
- (IBAction)displayPreferencePanel:(id)sender;

@end
