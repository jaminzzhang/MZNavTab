//
//  MainTabBarController.m
//  MZNavTabSample
//
//  Created by Jamin on 2/26/15.
//  Copyright (c) 2015 MZ. All rights reserved.
//

#import "MainTabBarController.h"
#import "MZNavTabController.h"



@interface MainTabBarController ()

@property (nonatomic, strong) NSArray * viewControllers;
@property (nonatomic, weak) UIViewController * currentViewController;

@end



@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.delegate = self;

    MZNavTabController * navTabController1 = [self.storyboard instantiateViewControllerWithIdentifier:@"navTabController1"];
    if ([navTabController1 isKindOfClass:[MZNavTabController class]]) {
        navTabController1.tabBar = self.tabBar;
        navTabController1.tabBarViewController = self;
        UIViewController * viewController1 = [navTabController1.storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
        if ([viewController1 isKindOfClass:[UIViewController class]]) {
            [navTabController1 pushViewController:viewController1 animated:NO];
        }
    }
//    [self.view addSubview:navTabController1.view];
    [self addChildViewController:navTabController1];

    MZNavTabController * navTabController2 = [self.storyboard instantiateViewControllerWithIdentifier:@"navTabController2"];
    if ([navTabController2 isKindOfClass:[MZNavTabController class]]) {
        navTabController2.tabBar = self.tabBar;
        navTabController2.tabBarViewController = self;
        UIViewController * viewController2 = [navTabController2.storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
        if ([viewController2 isKindOfClass:[UIViewController class]]) {
            [navTabController2 pushViewController:viewController2 animated:NO];
        }
    }
//    [self addChildViewController:navTabController2];
    self.viewControllers = @[navTabController1, navTabController2];


    [self tabBar:self.tabBar didSelectItem:[self.tabBar.items firstObject]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index >= self.viewControllers.count || index < 0) {
        return;
    }

    [self.currentViewController.view removeFromSuperview];
    self.currentViewController = self.viewControllers[index];
    [self.view insertSubview:self.currentViewController.view belowSubview:self.tabBar];
}

@end
