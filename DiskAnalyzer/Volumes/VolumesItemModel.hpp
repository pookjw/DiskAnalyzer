//
//  VolumesItemModel.hpp
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import <Foundation/Foundation.h>
#import <variant>
#import <string>
#import <memory>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

namespace _VolumesItemModel {
enum ItemType {
    Volume
};

struct VolumeInfo {
    std::string title;
    NSURL *url = nullptr;
    
    VolumeInfo(std::string title, NSURL *url);
    ~VolumeInfo();
    VolumeInfo(const VolumeInfo &other);
    VolumeInfo & operator=(const VolumeInfo &other);
    bool operator==(const VolumeInfo &) const;
};
}

namespace std {
template <>
struct hash<_VolumesItemModel::VolumeInfo> {
    std::size_t operator()(const _VolumesItemModel::VolumeInfo &value) const;
};
}

@interface VolumesItemModel : NSObject
@property (readonly, assign) _VolumesItemModel::ItemType type;
@property (readonly, assign) std::shared_ptr<std::variant<_VolumesItemModel::VolumeInfo>> variantDataPtr;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithVolumeInfo:(_VolumesItemModel::VolumeInfo)volumeInfo;
- (instancetype)initWithType:(_VolumesItemModel::ItemType)type variantData:(std::variant<_VolumesItemModel::VolumeInfo>)variantData NS_DESIGNATED_INITIALIZER;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
