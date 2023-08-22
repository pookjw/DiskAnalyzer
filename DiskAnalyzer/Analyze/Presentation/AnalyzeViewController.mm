//
//  AnalyzeViewController.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/21/23.
//

#import "AnalyzeViewController.hpp"
#import "AnalyzeViewModel.hpp"

@interface AnalyzeViewController () <NSOpenSavePanelDelegate>
@property (retain) AnalyzeViewModel *viewModel;
@end

@implementation AnalyzeViewController

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [self init]) {
        AnalyzeViewModel *viewModel = [[AnalyzeViewModel alloc] initWithURL:url];
        self.viewModel = viewModel;
        [viewModel release];
    }
    
    return self;
}

- (void)dealloc {
    [_viewModel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [self.viewModel foo];
}

@end
