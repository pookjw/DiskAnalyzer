//
//  AnalyzeViewController.hpp
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/21/23.
//

#import <Cocoa/Cocoa.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

@interface AnalyzeViewController : NSViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)url;
@end

NS_HEADER_AUDIT_END(nullability, sendability)
