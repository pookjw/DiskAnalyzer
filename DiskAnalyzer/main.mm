//
//  main.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.hpp"

int main(int argc, const char * argv[]) {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    NSApplication *sharedApplication = NSApplication.sharedApplication;
    AppDelegate *delegate = [AppDelegate new];
    
    sharedApplication.delegate = delegate;
    [delegate release];
    
    [sharedApplication run];
    [pool release];
    
    return EXIT_SUCCESS;
}
