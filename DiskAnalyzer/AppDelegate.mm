//
//  AppDelegate.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import "AppDelegate.hpp"
#import "VolumesWindow.hpp"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    VolumesWindow *window = [VolumesWindow new];
    [window makeKeyAndOrderFront:nil];
    [window release];
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

@end
