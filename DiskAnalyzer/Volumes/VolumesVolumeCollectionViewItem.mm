//
//  VolumesVolumeCollectionViewItem.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import "VolumesVolumeCollectionViewItem.hpp"
#import "NSTextField+LabelStyle.hpp"
#import "AnalyzeWindow.hpp"
#import <objc/message.h>
#import <optional>

namespace _VolumesVolumeCollectionViewItem {
    NSComparisonResult comparator(__kindof NSView *firstView, __kindof NSView *secondView, void * _Nullable context) {
        auto item = static_cast<VolumesVolumeCollectionViewItem *>(context);
        auto visualEffectView = reinterpret_cast<NSVisualEffectView * (*)(id, SEL)>(objc_msgSend)(item, NSSelectorFromString(@"visualEffectView"));
        
        if ([firstView isEqual:visualEffectView]) {
            return NSOrderedAscending;
        } else if ([secondView isEqual:visualEffectView]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    };
}

@interface VolumesVolumeCollectionViewItem ()
@property (retain) NSVisualEffectView *visualEffectView;
@property (assign) std::optional<_VolumesItemModel::VolumeInfo> volumeInfo;
@end

@implementation VolumesVolumeCollectionViewItem

- (void)dealloc {
    [_visualEffectView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextField];
    [self setupVisualEffectView];
    [self setupGestureRecognizer];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateVisualEffectView];
}

- (void)setHighlightState:(NSCollectionViewItemHighlightState)highlightState {
    [super setHighlightState:highlightState];
    [self updateVisualEffectView];
}

- (void)configureWithVolumeInfo:(_VolumesItemModel::VolumeInfo)volumeInfo {
    self.volumeInfo = volumeInfo;
    
    NSString *stringValue = [[NSString alloc] initWithCString:volumeInfo.title.data() encoding:NSUTF8StringEncoding];
    self.textField.stringValue = stringValue;
    [stringValue release];
}

- (void)setupTextField {
    NSTextField *textField = [NSTextField new];
    textField.textColor = NSColor.labelColor;
    [textField applyLabelStyle];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:textField];
    [NSLayoutConstraint activateConstraints:@[
        [textField.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [textField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [textField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [textField.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.textField = textField;
    [textField release];
}

- (void)setupVisualEffectView {
    NSVisualEffectView *visualEffectView = [[NSVisualEffectView alloc] initWithFrame:self.view.bounds];
    visualEffectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    visualEffectView.emphasized = YES;
    visualEffectView.material = NSVisualEffectMaterialSelection;
    visualEffectView.wantsLayer = YES;
    visualEffectView.layer.cornerRadius = 5.f;
    visualEffectView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    visualEffectView.hidden = !self.isSelected;
    
    [self.view addSubview:visualEffectView];
    self.visualEffectView = visualEffectView;
    [visualEffectView release];
    
    [self.view sortSubviewsUsingFunction:_VolumesVolumeCollectionViewItem::comparator context:self];
}

- (void)setupGestureRecognizer {
    NSClickGestureRecognizer *gestureRecognizer = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(didTriggerGestureRecognizer:)];
    gestureRecognizer.numberOfClicksRequired = 2;
    gestureRecognizer.delaysPrimaryMouseButtonEvents = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer release];
}

- (void)updateVisualEffectView {
    BOOL isSelected = self.isSelected;
    NSCollectionViewItemHighlightState highlightState = self.highlightState;
    
    BOOL isHidden;
    if (isSelected) {
        isHidden = NO;
    } else if (highlightState != NSCollectionViewItemHighlightNone) {
        isHidden = NO;
    } else {
        isHidden = YES;
    }
    
    CGFloat opacity;
    if (isSelected) {
        opacity = 1.f;
    } else if (highlightState != NSCollectionViewItemHighlightNone) {
        opacity = 0.4f;
    } else {
        opacity = 1.f;
    }
    
    self.visualEffectView.hidden = isHidden;
    self.visualEffectView.layer.opacity = opacity;
}

- (void)didTriggerGestureRecognizer:(NSClickGestureRecognizer *)sender {
    if (self.volumeInfo == std::nullopt) return;
    
    NSURL *url = self.volumeInfo.value().url;
    
    AnalyzeWindow *window = [[AnalyzeWindow alloc] initWithURL:url];
    [window makeKeyAndOrderFront:nullptr];
    [window release];
}

@end
