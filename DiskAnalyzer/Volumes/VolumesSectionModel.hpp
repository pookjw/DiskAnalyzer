//
//  VolumesSectionModel.hpp
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import <Foundation/Foundation.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

namespace _VolumesSectionModel {
enum SectionType {
    Volumes
};
}

@interface VolumesSectionModel : NSObject
@property (readonly, assign) _VolumesSectionModel::SectionType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithVolumes;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
