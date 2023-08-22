//
//  AnalyzeWindow.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import "AnalyzeWindow.hpp"
#import "AnalyzeViewController.hpp"

namespace _AnalyzeWindow {
namespace identifiers {
static NSToolbarIdentifier const toolbarIdentifier = @"AnalyzeWindowToolbar";
};
}

@interface AnalyzeWindow () <NSToolbarDelegate>
@end

@implementation AnalyzeWindow

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [self init]) {
        self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
        self.movableByWindowBackground = YES;
        self.title = url.lastPathComponent;
        self.releasedWhenClosed = NO;
        self.titlebarAppearsTransparent = NO;
        self.contentMinSize = NSMakeSize(400.f, 600.f);
        
        NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:_AnalyzeWindow::identifiers::toolbarIdentifier];
        toolbar.delegate = self;
        self.toolbar = toolbar;
        [toolbar release];
        
        AnalyzeViewController *contentViewController = [[AnalyzeViewController alloc] initWithURL:url];
        self.contentViewController = contentViewController;
        [contentViewController release];
    }
    
    return self;
}

#pragma mark - NSToolbarDelegate

@end
