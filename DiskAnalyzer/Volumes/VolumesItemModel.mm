//
//  VolumesItemModel.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import "VolumesItemModel.hpp"
#import <memory>

bool _VolumesItemModel::VolumeInfo::operator==(const VolumeInfo &other) const {
    return this->path == other.path;
}

std::size_t std::hash<_VolumesItemModel::VolumeInfo>::operator()(const _VolumesItemModel::VolumeInfo &value) const {
    auto stringHasher = std::hash<std::string>();
    
    return stringHasher(value.path);
}

@interface VolumesItemModel ()
@property (assign) _VolumesItemModel::ItemType type;
@property (assign) std::shared_ptr<std::variant<_VolumesItemModel::VolumeInfo>> variantDataPtr;
- (instancetype)initWithType:(_VolumesItemModel::ItemType)type variantData:(std::variant<_VolumesItemModel::VolumeInfo>)variantData NS_DESIGNATED_INITIALIZER;
@end

@implementation VolumesItemModel

- (instancetype)initWithVolumeInfo:(_VolumesItemModel::VolumeInfo)volumeInfo {
    return [self initWithType:_VolumesItemModel::Volume variantData:volumeInfo];
}

- (instancetype)initWithType:(_VolumesItemModel::ItemType)type variantData:(std::variant<_VolumesItemModel::VolumeInfo>)variantData {
    if (self = [super init]) {
        self.type = type;
        self.variantDataPtr = std::make_shared<std::variant<_VolumesItemModel::VolumeInfo>>(variantData);
    }
    
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        auto otherModel = static_cast<VolumesItemModel *>(other);
        
        if (self.type == otherModel.type) {
            switch (self.type) {
                case _VolumesItemModel::Volume:
                    return *self.variantDataPtr.get() == *otherModel.variantDataPtr.get();
                default:
                    return NO;
            }
        } else {
            return NO;
        }
    }
}

- (NSUInteger)hash {
    switch (self.type) {
        case _VolumesItemModel::Volume: {
            auto hasher = std::hash<_VolumesItemModel::VolumeInfo>();
            auto volumeInfo = std::get<_VolumesItemModel::VolumeInfo>(*self.variantDataPtr.get());
            
            return hasher(volumeInfo);
        }
        default:
            return 0;
    }
}

@end
