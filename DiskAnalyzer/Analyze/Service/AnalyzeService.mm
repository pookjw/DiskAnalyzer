//
//  AnalyzeService.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/21/23.
//

#import "AnalyzeService.hpp"
#import <Cocoa/Cocoa.h>

@interface AnalyzeService () <NSOpenSavePanelDelegate>
@property (copy) NSURL *url;
@property (copy, nullable) NSURL *escapedURL;
@property (retain) NSOperationQueue *queue;
@end

@implementation AnalyzeService

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [self init]) {
        self.url = url;
        
        NSOperationQueue *queue = [NSOperationQueue new];
        queue.qualityOfService = NSQualityOfServiceUtility;
        self.queue = queue;
        [queue release];
    }
    
    return self;
}

- (void)dealloc {
    [_queue cancelAllOperations];
    [_url release];
    [_queue release];
    [_escapedURL stopAccessingSecurityScopedResource];
    [_escapedURL release];
    [super dealloc];
}

- (void)requestPermissionWithCompletionHandler:(void (^)(NSError * _Nullable))completionHandler {
    [self.queue addOperationWithBlock:^{
        if (self.escapedURL) {
            completionHandler(nullptr);
            return;
        }
        
        NSUserDefaults *userDefaults = [[[NSUserDefaults alloc] initWithSuiteName:@"com.pookjw.DiskAnalyzer.AnalyzeFilePresenter"] autorelease];
        NSData * _Nullable bookmarkData = [userDefaults dataForKey:self.url.path];
        
        if (bookmarkData) {
            BOOL bookmarkDataIsStale;
            NSURL * _Nullable result = [NSURL URLByResolvingBookmarkData:bookmarkData
                                                                 options:NSURLBookmarkResolutionWithSecurityScope
                                                           relativeToURL:nullptr
                                                     bookmarkDataIsStale:&bookmarkDataIsStale
                                                                   error:nullptr];
            
            if (!bookmarkDataIsStale && result) {
                self.escapedURL = result;
                completionHandler(nullptr);
                return;
            }
        }
        
        //
        
        __block NSURL * _Nullable result = nullptr;
        dispatch_block_t openPanelBlock = ^{
            NSOpenPanel *openPanel = [NSOpenPanel new];
            openPanel.canCreateDirectories = NO;
            openPanel.canChooseFiles = NO;
            openPanel.canChooseDirectories = YES;
            openPanel.allowsMultipleSelection = NO;
            openPanel.directoryURL = self.url;
            openPanel.delegate = self;
            
            NSModalResponse response = [openPanel runModal];
            
            if (response == NSModalResponseOK) {
                result = openPanel.URL;
            }
        };
        
        if (NSThread.isMainThread) {
            openPanelBlock();
        } else {
            dispatch_sync(dispatch_get_main_queue(), openPanelBlock);
        }
        
        //
        
        if (result) {
            NSError * _Nullable error = nullptr;
            NSData * _Nullable bookmarkData = [result bookmarkDataWithOptions:NSURLBookmarkCreationSecurityScopeAllowOnlyReadAccess includingResourceValuesForKeys:nullptr relativeToURL:nullptr error:&error];
            
            if (error) {
                completionHandler(error);
                return;
            }
            
            [userDefaults setValue:bookmarkData forKey:self.url.path];
            
            self.escapedURL = result;
            completionHandler(nullptr);
            return;
        }
        
        completionHandler([NSError errorWithDomain:NSURLErrorDomain code:NSFileReadNoPermissionError userInfo:nullptr]);
    }];
}

#pragma mark - NSOpenSavePanelDelegate

- (BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url {
    return [self.url isEqual:url];
}

@end
