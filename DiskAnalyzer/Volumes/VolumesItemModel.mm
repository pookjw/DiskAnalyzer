//
//  VolumesItemModel.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import "VolumesItemModel.hpp"
#import <memory>

_VolumesItemModel::VolumeInfo::VolumeInfo(std::string title, NSURL *url) {
    this->title = title;
    this->url = [url copy];
}

_VolumesItemModel::VolumeInfo::~VolumeInfo() {
    [this->url release];
}

_VolumesItemModel::VolumeInfo::VolumeInfo(const VolumeInfo &other) {
    this->title = other.title;
    
    [this->url release];
    this->url = [other.url copy];
}

_VolumesItemModel::VolumeInfo & _VolumesItemModel::VolumeInfo::operator=(const VolumeInfo &other) {
    if (this == &other) {
        return *this;
    }
    
    this->title = other.title;
    
    [this->url release];
    this->url = [other.url copy];
    
    return *this;
}

bool _VolumesItemModel::VolumeInfo::operator==(const VolumeInfo &other) const {
    return this->title == other.title && [this->url isEqual:other.url];
}

std::size_t std::hash<_VolumesItemModel::VolumeInfo>::operator()(const _VolumesItemModel::VolumeInfo &value) const {
    auto stringHasher = std::hash<std::string>();
    
    return stringHasher(value.title) ^ value.url.hash;
}

@interface VolumesItemModel ()
@property (assign) _VolumesItemModel::ItemType type;
@property (assign) std::shared_ptr<std::variant<_VolumesItemModel::VolumeInfo>> variantDataPtr;
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
