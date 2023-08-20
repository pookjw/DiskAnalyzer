//
//  VolumesVolumeCollectionViewItem.hpp
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import <Cocoa/Cocoa.h>
#import "VolumesItemModel.hpp"

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

@interface VolumesVolumeCollectionViewItem : NSCollectionViewItem
- (void)configureWithVolumeInfo:(_VolumesItemModel::VolumeInfo)volumeInfo;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
