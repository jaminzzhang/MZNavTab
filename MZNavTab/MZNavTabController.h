//
//  MZNavTabController.h
//  MZNavTabSample
//
//  Created by Jamin on 2/26/15.
//  Copyright (c) 2015 MZ. All rights reserved.
//

#import "MZNavigationController.h"


@protocol MZNavTabChildChildViewController <MZNavigationChildViewController>

@required
/**
 *  MZNavTabController whould check if it should hide tabBar while push/pop a vc,
 *  then it whould show/hide tabBar.
 *  @return
 */
- (BOOL)shouldHideTabBar;

@end



@interface MZNavTabController : MZNavigationController


@property (nonatomic, weak) UIView * tabBar;
@property (nonatomic, weak) UIViewController * tabBarViewController;
//@property (nonatomic, strong) NSArray * tabBarLayoutConstraints;
@property (nonatomic, assign) BOOL supportAutoLayout;

@end
