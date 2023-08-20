//
//  VolumesViewController.mm
//  DiskAnalyzer
//
//  Created by Jinwoo Kim on 8/20/23.
//

#import "VolumesViewController.hpp"
#import "VolumesViewModel.hpp"
#import "VolumesVolumeCollectionViewItem.hpp"
#import <memory>
#import <cstdint>
#import <algorithm>

namespace _VolumesViewController {
namespace identifiers {
static NSUserInterfaceItemIdentifier const volumeItemIdentifier = @"VolueItemIdentifier";
}
}

@interface VolumesViewController () <NSCollectionViewDelegate>
@property (retain) NSLayoutConstraint *heightLayoutConstraint;
@property (retain) NSVisualEffectView *visualEffectView;
@property (retain) NSScrollView *scrollView;
@property (retain) NSCollectionView *collectonView;
@property (retain) VolumesViewModel *viewModel;
@property (assign) std::shared_ptr<std::uint8_t> context;
@end

@implementation VolumesViewController

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _context = std::make_shared<std::uint8_t>();
    }
    
    return self;
}

- (void)dealloc {
    [_heightLayoutConstraint release];
    [_visualEffectView release];
    [_scrollView release];
    [_collectonView release];
    [_viewModel release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == _context.get()) {
        auto value = static_cast<NSValue *>(change[NSKeyValueChangeNewKey]);
        CGRect rect = value.rectValue;
        self.heightLayoutConstraint.constant = std::fminf(rect.size.height, 600.f);
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVisualEffectView];
    [self setupScrollView];
    [self setupCollectionView];
    [self setupViewModel];
}
- (void)setupVisualEffectView {
    NSVisualEffectView *visualEffectView = [[NSVisualEffectView alloc] initWithFrame:self.view.bounds];
    visualEffectView.material = NSVisualEffectMaterialPopover;
    visualEffectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    visualEffectView.state = NSVisualEffectStateActive;
    visualEffectView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    [self.view addSubview:visualEffectView];
    self.visualEffectView = visualEffectView;
    [visualEffectView release];
}

- (void)setupScrollView {
    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.drawsBackground = NO;
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *heightLayoutConstraint = [scrollView.heightAnchor constraintEqualToConstant:400.f];
    
    [self.view addSubview:scrollView];
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [scrollView.widthAnchor constraintEqualToConstant:400.f],
        heightLayoutConstraint
    ]];
    
    self.scrollView = scrollView;
    self.heightLayoutConstraint = heightLayoutConstraint;
    [scrollView release];
}

- (void)setupCollectionView {
    NSCollectionViewCompositionalLayout *collectionViewLayout = [self makeCollectionViewLayout];
    [collectionViewLayout addObserver:self forKeyPath:@"contentFrame" options:NSKeyValueObservingOptionNew context:_context.get()];
    
    NSCollectionView *collectionView = [[NSCollectionView alloc] initWithFrame:self.view.bounds];
    collectionView.collectionViewLayout = collectionViewLayout;
    collectionView.backgroundColors = @[NSColor.clearColor];
    collectionView.allowsEmptySelection = YES;
    collectionView.selectable = YES;
    collectionView.delegate = self;
    
    [collectionView registerClass:VolumesVolumeCollectionViewItem.class forItemWithIdentifier:_VolumesViewController::identifiers::volumeItemIdentifier];
    
    self.scrollView.documentView = collectionView;
    self.collectonView = collectionView;
    [collectionView release];
}

- (void)setupViewModel {
    _VolumesViewModel::DataSource *dataSource = [self makeDataSource];
    VolumesViewModel *viewModel = [[VolumesViewModel alloc] initWithDataSource:dataSource];
    
    [viewModel loadWithCompletionHandler:^{
        NSLog(@"Loaded!");
    }];
    
    self.viewModel = viewModel;
    [viewModel release];
}

- (NSCollectionViewCompositionalLayout *)makeCollectionViewLayout {
    NSCollectionViewCompositionalLayoutConfiguration *configuration = [NSCollectionViewCompositionalLayoutConfiguration new];
    configuration.scrollDirection = NSCollectionViewScrollDirectionVertical;
    
    __block VolumesViewController *unretainedSelf = self;
    
    NSCollectionViewCompositionalLayout *collectionViewLayout = [[NSCollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger section, id<NSCollectionLayoutEnvironment> _Nonnull) {
        
        std::optional<_VolumesSectionModel::SectionType> sectionType = [unretainedSelf.viewModel sectionTypeAtSectionIndex:section];
        if (!sectionType.has_value()) return nullptr;
        
        switch (sectionType.value()) {
            case _VolumesSectionModel::Volumes: {
                NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.f]
                                                                                  heightDimension:[NSCollectionLayoutDimension estimatedDimension:44.f]];
                
                NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
                
                NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.f]
                                                                                   heightDimension:[NSCollectionLayoutDimension estimatedDimension:44.f]];
                
                NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:groupSize subitem:item count:1];
                
                NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
                
                return section;
            }
            default:
                return nullptr;
        }
    }
                                                                                                                       configuration:configuration];
    
    [configuration release];
    
    return [collectionViewLayout autorelease];
}

- (_VolumesViewModel::DataSource *)makeDataSource {
    _VolumesViewModel::DataSource *dataSource = [[_VolumesViewModel::DataSource alloc] initWithCollectionView:self.collectonView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, VolumesItemModel * _Nonnull itemModel) {
        switch (itemModel.type) {
            case _VolumesItemModel::Volume: {
                VolumesVolumeCollectionViewItem *item = [collectionView makeItemWithIdentifier:_VolumesViewController::identifiers::volumeItemIdentifier forIndexPath:indexPath];
                auto volumeInfo = std::get<_VolumesItemModel::VolumeInfo>(*itemModel.variantDataPtr.get());
                
                [item configureWithVolumeInfo:volumeInfo];
                
                return item;
            }
            default:
                return nullptr;
        }
    }];
    
    return [dataSource autorelease];
}

- (void)didChangeCollectionViewBounds:(NSNotification *)notification {
    auto contentView = static_cast<__kindof NSView * _Nullable>(notification.object);
    if (!contentView) return;
    
    self.heightLayoutConstraint.constant = contentView.bounds.size.height;
}

#pragma mark - NSCollectionViewDelegate

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    
}

@end
