//
//  ThirdViewController.m
//  MZNavTabSample
//
//  Created by Jamin on 2/26/15.
//  Copyright (c) 2015 MZ. All rights reserved.
//

#import "ThirdViewController.h"
#import "MZNavTabItemController.h"

@interface ThirdViewController () <MZNavTabItemChildViewController>

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Third";
    // Do any additional setup after loading the view.
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


#pragma mark - MZNavTabItemChildViewController
- (BOOL)shouldHideNavigationBar
{
    return NO;
}



@end
