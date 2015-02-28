//
//  MainTabBarController.m
//  MZNavTabSample
//
//  Created by Jamin on 2/26/15.
//  Copyright (c) 2015 MZ. All rights reserved.
//

#import "MainTabBarController.h"
#import "MZNavTabItemController.h"



@interface MainTabBarController ()

@end



#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

//#define BUILD_TAB_BAR_BY_CODE 1
#if BUILD_TAB_BAR_BY_CODE
    NSArray * barItems = @[[[UITabBarItem alloc] initWithTitle:@"Tab1" image:[UIImage imageNamed:@"ico_tab_m"] tag:1], [[UITabBarItem alloc] initWithTitle:@"Tab2" image:[UIImage imageNamed:@"ico_tab_z"] tag:2]];
    CGRect bounds = self.view.bounds;
    CGFloat tabBarHeight = 49.0;
    CGRect tabbarFrame = CGRectMake(0, bounds.size.height - tabBarHeight,
                                    bounds.size.width, tabBarHeight);
    UITabBar * tabBar = [[UITabBar alloc] initWithFrame:tabbarFrame];
    tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    tabBar.delegate = self;
    tabBar.items = barItems;
    tabBar.selectedItem = [barItems firstObject];
    self.tabBar = tabBar;
#endif

    self.tabBar.selectedImageTintColor = UIColorFromRGB(0x45addd);

    //    [self addChildViewController:navTabController2];
    UIViewController * viewController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
    UIViewController * viewController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController2"];
    self.itemViewControllers = @[viewController1, viewController2];
    self.tabBar.delegate = self;

//    [self tabBar:self.tabBar didSelectItem:[self.tabBar.items firstObject]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
