//
//  AnalyzeService.hpp
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/21/23.
//

#import <Foundation/Foundation.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

@interface AnalyzeService : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)url;
- (void)requestPermissionWithCompletionHandler:(void (^)(NSError * _Nullable error))completionHandler;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
