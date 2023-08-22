//
//  VolumesWindow.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import "VolumesWindow.hpp"
#import "VolumesViewController.hpp"

namespace _VolumesWindow {
namespace identifiers {
static NSToolbarIdentifier const toolbarIdentifier = @"VolumesWindowToolbar";
};
}

@interface VolumesWindow () <NSToolbarDelegate>

@end

@implementation VolumesWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag {
    if (self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag]) {
        self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
        self.movableByWindowBackground = YES;
        self.title = NSLocalizedString(@"VOLUMES", nullptr);
        self.releasedWhenClosed = NO;
        self.titlebarAppearsTransparent = YES;
        
        NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:_VolumesWindow::identifiers::toolbarIdentifier];
        toolbar.delegate = self;
        self.toolbar = toolbar;
        [toolbar release];
        
        VolumesViewController *contentViewController = [VolumesViewController new];
        self.contentViewController = contentViewController;
        [contentViewController release];
    }
    
    return self;
}

#pragma mark - NSToolbarDelegate

@end
