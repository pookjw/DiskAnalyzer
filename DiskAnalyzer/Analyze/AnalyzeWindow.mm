//
//  AnalyzeWindow.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import "AnalyzeWindow.hpp"

namespace _AnalyzeWindow {
namespace identifiers {
static NSToolbarIdentifier const toolbarIdentifier = @"AnalyzeWindowToolbar";
};
}

@interface AnalyzeWindow () <NSToolbarDelegate>
@property (copy) NSURL *url;
@end

@implementation AnalyzeWindow

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [self init]) {
        self.url = url;
        
        self.styleMask = NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskFullSizeContentView | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
        self.movableByWindowBackground = YES;
        self.title = NSLocalizedString(@"VOLUMES", nullptr);
        self.releasedWhenClosed = NO;
        self.titlebarAppearsTransparent = NO;
        
        NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:_AnalyzeWindow::identifiers::toolbarIdentifier];
        toolbar.delegate = self;
        self.toolbar = toolbar;
        [toolbar release];
    }
    
    return nil;
}

- (void)dealloc {
    [_url release];
    [super dealloc];
}

@end
