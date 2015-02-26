//
//  MZNavigationController.m
//  MZNavTabSample
//
//  Created by Jamin on 2/26/15.
//  Copyright (c) 2015 MZ. All rights reserved.
//

#import "MZNavigationController.h"

//Proxy of delegate
@interface MZNavigationControllerDelegateProxy : NSProxy

@property (nonatomic, weak) id originalDelegate;
@property (nonatomic, weak) id target;

@end


@implementation MZNavigationControllerDelegateProxy


- (instancetype)init
{
    if (self) {
        _target = nil;
        _originalDelegate = nil;
    }

    return self;
}


- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([self.target respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.target];
    }

    if ([self.originalDelegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.originalDelegate];
    }
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    if (nil != self.originalDelegate) {
        return [self.originalDelegate methodSignatureForSelector:sel];
    }

    return [self.target methodSignatureForSelector:sel];
}


- (BOOL)respondsToSelector:(SEL)aSelector {

    return ([self.target respondsToSelector:aSelector]
            || [self.originalDelegate respondsToSelector:aSelector]);

}


@end




@interface MZNavigationController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) MZNavigationControllerDelegateProxy * delegateProxy;

@end

@implementation MZNavigationController

@synthesize supportPopGesture = _supportPopGesture;


#pragma mark - UINavigationController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _supportPopGesture = YES;
        self.delegateProxy = [[MZNavigationControllerDelegateProxy alloc] init];

    }
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.supportPopGesture = YES;
    self.delegateProxy = [[MZNavigationControllerDelegateProxy alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 70000/*__IPHONE_7_0*/)
    __weak typeof(self) weakSelf = self;

    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        [self updatePopGestureSupport];
        self.delegate = weakSelf;
    }
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [[self.viewControllers lastObject] preferredStatusBarStyle];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}


#pragma mark - Override

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    //有其他的类也使用proxy来进行代理的话，会出现死锁
    //Don't setting another proxy to avoid deadlock
    if ([delegate isKindOfClass:[NSProxy class]]
        /*|| [delegate isKindOfClass:NSClassFromString(@"FlurryPageViewDelegate")]*/) {
        [super setDelegate:delegate];
        return;
    }

    [super setDelegate:(id <UINavigationControllerDelegate>)self.delegateProxy];
    self.delegateProxy.originalDelegate = delegate;
    if (self != delegate) {
        self.delegateProxy.target = self;
    }
}

//push
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated
{
    self.latestNavOperation = UINavigationControllerOperationPush;
    [super setViewControllers:viewControllers animated:animated];
    [self checkNavigationBarHiddenAnimated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self canPush]) {
        return;
    }

    //Prevent it pop too much
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }

    self.latestNavOperation = UINavigationControllerOperationPush;
    [super pushViewController:viewController animated:animated];
    [self checkNavigationBarHiddenAnimated:animated];
}

//pop
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (![self canPop]) {
        return nil;
    }

    self.latestNavOperation = UINavigationControllerOperationPop;
    UIViewController * popedViewController = [super popViewControllerAnimated:animated];
    if (nil != popedViewController) {
        [self checkNavigationBarHiddenAnimated:animated];
    }
    return popedViewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self canPop]) {
        return nil;
    }

    self.latestNavOperation = UINavigationControllerOperationPop;
    NSArray * popedViewControllers = [super popToViewController:viewController animated:animated];
    if (popedViewControllers.count > 0) {
        [self checkNavigationBarHiddenAnimated:animated];
    }
    return popedViewControllers;
}


- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if (![self canPop]) {
        return nil;
    }

    self.latestNavOperation = UINavigationControllerOperationPop;
    NSArray * popedViewControllers = [super popToRootViewControllerAnimated:animated];
    if (popedViewControllers.count > 0) {
        [self checkNavigationBarHiddenAnimated:animated];
    }
    return popedViewControllers;
}




#pragma mark - Public
- (void)setSupportPopGesture:(BOOL)supportPopGesture
{
    if (_supportPopGesture == supportPopGesture) {
        return;
    }

    _supportPopGesture = supportPopGesture;
    [self updatePopGestureSupport];
}

/**
 *  It don't support pop gesture until there is more than one vc in navigationController stack;
 *
 *  @return whether it support pop gesture
 */
- (BOOL)supportPopGesture
{
    if (![self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        return NO;
    }

    return (_supportPopGesture && self.viewControllers.count > 1);
}


- (void)updatePopGestureSupport
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = self.supportPopGesture;
    }

}


#pragma mark - Private

- (BOOL)canPush
{
    return YES;
}


- (BOOL)canPop
{
    return self.viewControllers.count > 1;
}


- (void)checkChildViewControllerNavigationBarHidden:(UIViewController *)viewController
                                           animated:(BOOL)animated
{
    if ([viewController respondsToSelector:@selector(shouldHideNavigationBar)]) {
        BOOL hideNavBar = [(id<MZNavigationChildViewController>)viewController shouldHideNavigationBar];
        if (hideNavBar != self.navigationBarHidden) {
            [self setNavigationBarHidden:hideNavBar animated:animated];
        }
    }
}


- (void)checkNavigationBarHiddenAnimated:(BOOL)animated
{
    [self checkChildViewControllerNavigationBarHidden:self.topViewController animated:animated];
}



#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{

}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (![navigationController isKindOfClass:[MZNavigationController class]]) {
        return;
    }
    [(MZNavigationController *)navigationController updatePopGestureSupport];
}



#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
{
    return self.supportPopGesture;
}



@end


