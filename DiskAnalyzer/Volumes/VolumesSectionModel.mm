//
//  VolumesSectionModel.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import "VolumesSectionModel.hpp"

@interface VolumesSectionModel ()
@property (assign) _VolumesSectionModel::SectionType type;
- (instancetype)initWithType:(_VolumesSectionModel::SectionType)type NS_DESIGNATED_INITIALIZER;
@end

@implementation VolumesSectionModel

- (instancetype)initWithVolumes {
    return [self initWithType:_VolumesSectionModel::SectionType::Volumes];
}

- (instancetype)initWithType:(_VolumesSectionModel::SectionType)type {
    if (self = [super init]) {
        self.type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![super isEqual:other]) {
        return NO;
    } else {
        auto otherModel = static_cast<VolumesSectionModel *>(other);
        return self.type == otherModel.type;
    }
}

- (NSUInteger)hash {
    return self.type;
}

@end
