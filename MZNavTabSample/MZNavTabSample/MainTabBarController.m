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



@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

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
