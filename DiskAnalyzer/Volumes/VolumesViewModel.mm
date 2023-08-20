//
//  VolumesViewModel.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import "VolumesViewModel.hpp"
#import <objc/message.h>
#import <vector>
#import <algorithm>

@interface VolumesViewModel ()
@property (retain) _VolumesViewModel::DataSource *dataSource;
@property (retain) NSOperationQueue *queue;
@end

@implementation VolumesViewModel

- (instancetype)initWithDataSource:(_VolumesViewModel::DataSource *)dataSource {
    if (self = [self init]) {
        self.dataSource = dataSource;
        [self setupQueue];
    }
    
    return self;
}

- (void)dealloc {
    [_queue cancelAllOperations];
    [_dataSource release];
    [_queue release];
    [super dealloc];
}

- (void)loadWithCompletionHandler:(void (^)())completionHandler {
    auto dataSource = self.dataSource;
    
    [self.queue addBarrierBlock:^{
        auto snapshot = dataSource.snapshot;
        
        VolumesSectionModel *volumesSectionModel = [[VolumesSectionModel alloc] initWithVolumes];
        
        [snapshot appendSectionsWithIdentifiers:@[volumesSectionModel]];
        
        NSArray<NSURL *> *mountedVolumeURLs = [NSFileManager.defaultManager mountedVolumeURLsIncludingResourceValuesForKeys:nullptr options:NSVolumeEnumerationSkipHiddenVolumes];
//        NSArray<NSURL *> *mountedVolumeURLs = [NSFileManager.defaultManager mountedVolumeURLsIncludingResourceValuesForKeys:nullptr options:0];
        
        __block std::vector<VolumesItemModel *> volumeItemModels {};
        
        [mountedVolumeURLs enumerateObjectsUsingBlock:^(NSURL * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            VolumesItemModel *demoItemModel = [[VolumesItemModel alloc] initWithVolumeInfo:{obj.path.UTF8String}];
            volumeItemModels.push_back([demoItemModel retain]);
            [demoItemModel release];
        }];
        
        [snapshot appendItemsWithIdentifiers:[NSArray arrayWithObjects:volumeItemModels.data() count:volumeItemModels.size()] intoSectionWithIdentifier:volumesSectionModel];
        
        [volumesSectionModel release];
        
        std::for_each(volumeItemModels.cbegin(), volumeItemModels.cend(), [](VolumesItemModel *itmeModel) {
            [itmeModel release];
        });
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        reinterpret_cast<void (*)(id, SEL, id, BOOL, id)>(objc_msgSend)(dataSource, NSSelectorFromString(@"applySnapshot:animatingDifferences:completion:"), snapshot, YES, ^{
            completionHandler();
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_release(semaphore);
    }];
}

- (std::optional<_VolumesSectionModel::SectionType>)sectionTypeAtSectionIndex:(NSInteger)sectionIndex {
    _VolumesViewModel::Snapshot *snapshot = self.dataSource.snapshot;
    if (snapshot.numberOfSections < sectionIndex)
        return std::nullopt;
    
    VolumesSectionModel * _Nullable sectionModel = snapshot.sectionIdentifiers[sectionIndex];
    if (!sectionModel)
        return std::nullopt;
    
    return sectionModel.type;
}

- (void)setupQueue {
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.qualityOfService = NSQualityOfServiceUtility;
    self.queue = queue;
    [queue release];
}

@end
