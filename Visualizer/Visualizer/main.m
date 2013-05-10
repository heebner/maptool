//
//  main.m
//  Visualizer
//
//  Created by Benjamin Heebner on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // This method is called before all other methods.  If the preference file doesn't exist, it'll be created here.
	NSString *userDirPath = NSHomeDirectory();
	NSString *preferenceFilePath = [userDirPath stringByAppendingPathComponent:@"Library/Preferences/com.bth.Visualizer.plist"];
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:preferenceFilePath];
	
	if(fileExists == NO)
	{
		NSLog(@"The File doesn't exist at path %@", preferenceFilePath);
		// Get the path to the resource
		NSString *defaultPreferences = [[NSBundle mainBundle] pathForResource:@"com.bth.Visualizer" ofType:@"plist"];
        NSError *error;
		[[NSFileManager defaultManager] copyItemAtPath:defaultPreferences toPath:preferenceFilePath error:&error];
	}
	
    int retVal = NSApplicationMain(argc,  (const char **) argv);
    [pool release];
    
    return retVal;
}
