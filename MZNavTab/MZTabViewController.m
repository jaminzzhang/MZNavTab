//
//  MZTabViewController.m
//  MZNavTab
//
//  Created by Jamin on 2/27/15.
//  Copyright (c) 2015 MZ. All rights reserved.
//

#import "MZTabViewController.h"
#import "MZNavTabItemController.h"

@interface MZTabViewController ()

@property (nonatomic, strong) NSArray * navControllers;

@end

@implementation MZTabViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedItemIndex = -1;
    }

    return self;
}



- (instancetype)initWithTabBar:(UIView *)tabBar
           itemViewControllers:(NSArray *)itemViewControllers
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.tabBar = tabBar;
        self.itemViewControllers = itemViewControllers;
    }

    return self;
}


- (instancetype)initWithTabBarItems:(NSArray *)tabBarItems
                itemViewControllers:(NSArray *)itemViewControllers;
{
    UITabBar * tabBar = [self buildTabBarWithItems:tabBarItems];
    self = [self initWithTabBar:tabBar itemViewControllers:itemViewControllers];
    if (self) {

    }

    return self;
}


- (void) awakeFromNib
{
    [super awakeFromNib];
    self.selectedItemIndex = -1;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (nil == self.tabBar.superview) {
        [self.view addSubview:self.tabBar];
    }

    [self selectItemAtIndex:0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setter & Getter

- (void)setTabBar:(UIView *)tabBar
{
    if (_tabBar == tabBar) {
        return;
    }

    UIView * oldTabBar = _tabBar;
    if (self.isViewLoaded) {
        [oldTabBar removeFromSuperview];
        [self.view addSubview:tabBar];
    }

    _tabBar = tabBar;

    
    for (MZNavTabItemController * navController in self.navControllers) {
        navController.tabBar = tabBar;
    }
}


- (void)setItemViewControllers:(NSArray *)viewControllers
{
    if (_itemViewControllers == viewControllers) {
        return;
    }

    _itemViewControllers = viewControllers;
    [self reloadItemViewControllers];
}


#pragma mark - Tab Bar Items

- (UITabBar *)buildTabBarWithItems:(NSArray *)barItems
{
    CGRect bounds = self.view.bounds;
    CGFloat tabBarHeight = 49.0;
    CGRect tabbarFrame = CGRectMake(0, bounds.size.height - tabBarHeight,
                                    bounds.size.width, tabBarHeight);
    UITabBar * tabBar = [[UITabBar alloc] initWithFrame:tabbarFrame];
    tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    tabBar.delegate = self;
    return tabBar;
}

- (void)reloadItemViewControllers
{
    //Clear old childViewControllers
    for (UINavigationController * navController in self.navControllers) {
        [navController removeFromParentViewController];
        [navController.view removeFromSuperview];
    }

    NSMutableArray * mNavControllers = [NSMutableArray array];
    NSInteger itemCount = self.itemViewControllers.count;
    for (NSInteger index = 0; index < itemCount; index++) {
        UIViewController * viewController = self.itemViewControllers[index];
        MZNavTabItemController * navController = [[MZNavTabItemController alloc] initWithRootViewController:viewController];
        navController.tabBar = self.tabBar;
        navController.tabBarViewController = self;
        [mNavControllers addObject:navController];
        [self addChildViewController:navController];
    }
    self.navControllers = mNavControllers;

    [self selectItemAtIndex:-1];
    [self selectItemAtIndex:0];

}



#pragma mark - Public
- (void)selectItemAtIndex:(NSInteger)index
{

    if (self.selectedItemIndex == index) {
        return;
    }

    if (index >= self.navControllers.count || index < 0) {
        return;
    }

    self.selectedItemIndex = index;
    [self.selectedItemViewController.view removeFromSuperview];
    self.selectedItemViewController = self.navControllers[index];
    [self.view insertSubview:self.selectedItemViewController.view belowSubview:self.tabBar];

    if ([self.delegate respondsToSelector:@selector(tabViewController:didSelecteItemAtIndex:)]) {
        [self.delegate tabViewController:self didSelecteItemAtIndex:index];
    }
}



- (void)setItems:(NSArray *)items animated:(BOOL)animated
{
    if (nil == self.tabBar) {
        self.tabBar = [self buildTabBarWithItems:items];
    } else if ([self.tabBar isKindOfClass:[UITabBar class]]) {
        [(UITabBar *)self.tabBar setItems:items animated:animated];
    }
}



#pragma mark - UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [tabBar.items indexOfObject:item];
    [self selectItemAtIndex:index];
}


@end
