//
//  MZTabViewController.h
//  MZNavTab
//
//  Created by Jamin on 2/27/15.
//  Copyright (c) 2015 MZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZTabViewController;

@protocol MZTabViewControllerDelegate <NSObject>

/**
 *  Call back while selected item
 *
 *  @param tabViewController
 *  @param index
 */
- (void)tabViewController:(MZTabViewController *)tabViewController
    didSelecteItemAtIndex:(NSInteger)index;


@end


@interface MZTabViewController : UIViewController <UITabBarDelegate>

/** TabBar can be custom, default is UITabBar**/
@property (nonatomic, strong) UIView * tabBar;
@property (nonatomic, assign) NSInteger selectedItemIndex;
@property (nonatomic, strong) NSArray * itemViewControllers;
@property (nonatomic, strong) UIViewController * selectedItemViewController;

@property (nonatomic, weak) id<MZTabViewControllerDelegate> delegate;



/**
 *  Init with tab bar and view controllers of tab bar items
 *
 *  @param tabBar
 *  @param itemViewControllers
 *
 *  @return
 */
- (instancetype)initWithTabBar:(UIView *)tabBar
           itemViewControllers:(NSArray *)itemViewControllers;



/**
 *  Init with tab bar items and their view controllers
 *
 *  @param tabBarItems         UITabBarItems
 *  @param itemViewControllers
 *
 *  @return
 */
- (instancetype)initWithTabBarItems:(NSArray *)tabBarItems
                itemViewControllers:(NSArray *)itemViewControllers;


/**
 *  Called while user touch a tab bar item
 *
 *  @param index    The index of tab bar items
 */
- (void)selectItemAtIndex:(NSInteger)index;



/**
 *  set tab bar items
 *
 *  @param items    UITabBarItems
 *  @param animated using fade animation
 */
- (void)setItems:(NSArray *)items animated:(BOOL)animated;


@end
