//
//  MZNavigationController.h
//  MZNavTabSample
//
//  Created by Jamin on 2/26/15.
//  Copyright (c) 2015 MZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZNavigationChildViewController <NSObject>

@required

/**
 *  MZNavigationController whould check if it should hide navigationBar while push/pop a vc,
 *  then it whould show/hide navigationBar.
 *  @return
 */
- (BOOL)shouldHideNavigationBar;

@end

@interface MZNavigationController : UINavigationController <UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL      supportPopGesture;  //Default is YES.

@property (nonatomic, assign) UINavigationControllerOperation   latestNavOperation;


/**
 *  update the support of popgesture
 */
- (void)updatePopGestureSupport;

@end
