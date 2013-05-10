//
//  Constants.h
//  Visualizer
//
//  Created by Ben Heebner on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const PreferencesUpdatedNotification;

extern NSString * const PrefMapType;
extern NSString * const PrefNormalMapGridColor;
extern NSString * const PrefSatelliteMapGridColor;
extern NSString * const PrefGridOnStartup;
extern NSString * const PrefMapZoom;
extern NSString * const PrefDisplayHeatMap;
extern NSString * const PrefDisplaySignalMagnitude;
extern NSString * const PrefDisplayTrilateration;
extern NSString * const PrefShowDetailsDrawer;
extern NSString * const PrefShowAnimationDrawer;
extern NSString * const PrefSourceHighlightColor;
extern NSString * const PrefSigMagCoefficientValue;
extern NSString * const PrefStartingLatitude;
extern NSString * const PrefStartingLongitude;
extern NSString * const PrefCenterOnFirstNetwork;

extern NSString * const PrefMySQLIPAddress;
extern NSString * const PrefMySQLPort;
extern NSString * const PrefMySQLUsername;
extern NSString * const PrefMySQLPassword;
extern NSString * const PrefDemoMode;

@interface Constants : NSObject {

}

@end
