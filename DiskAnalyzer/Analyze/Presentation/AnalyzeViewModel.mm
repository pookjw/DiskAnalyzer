//
//  AnalyzeViewModel.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/21/23.
//

#import "AnalyzeViewModel.hpp"
#import "AnalyzeService.hpp"

@interface AnalyzeViewModel ()
@property (retain) AnalyzeService *service;
@end

@implementation AnalyzeViewModel

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [self init]) {
        AnalyzeService *service = [[AnalyzeService alloc] initWithURL:url];
        self.service = service;
        [service release];
    }
    
    return self;
}

- (void)dealloc {
    [_service release];
    [super dealloc];
}

- (void)foo {
    [self.service requestPermissionWithCompletionHandler:^(NSError * _Nullable error) {
        NSAssert(!error, error.localizedDescription);
    }];
}

@end
