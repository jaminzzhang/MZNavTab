//
//  SecondViewController.m
//  MZNavTabSample
//
//  Created by Jamin on 2/26/15.
//  Copyright (c) 2015 MZ. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "MZNavTabController.h"

@interface SecondViewController () <MZNavTabChildChildViewController>

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Second";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ThirdViewController * destViewController = [segue destinationViewController];
    if ([destViewController isKindOfClass:[ThirdViewController class]]) {
        destViewController.shouldHideTabBar = (self.nextHideButton == sender);
    }
}



#pragma mark - MZNavTabChildChildViewController
- (BOOL)shouldHideNavigationBar
{
    return NO;
}


- (BOOL)shouldHideTabBar
{
    return YES;
}


@end
