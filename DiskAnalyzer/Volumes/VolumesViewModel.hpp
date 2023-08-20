//
//  VolumesViewModel.hpp
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import <Cocoa/Cocoa.h>
#import <optional>
#import "VolumesSectionModel.hpp"
#import "VolumesItemModel.hpp"

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

namespace _VolumesViewModel {
typedef NSCollectionViewDiffableDataSource<VolumesSectionModel *, VolumesItemModel *> DataSource;
typedef NSDiffableDataSourceSnapshot<VolumesSectionModel *, VolumesItemModel *> Snapshot;
}

@interface VolumesViewModel : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(_VolumesViewModel::DataSource *)dataSource;
- (std::optional<_VolumesSectionModel::SectionType>)sectionTypeAtSectionIndex:(NSInteger)sectionIndex;
- (void)loadWithCompletionHandler:(void (^)())completionHandler;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
