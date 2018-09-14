//
//  UINavigationController+JFSwipeBack.m
//  JFUIKit
//
//  Created by jumpingfrog0 on 2018/09/15.
//
//
//  Copyright (c) 2017 Jumpingfrog0 LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "UINavigationController+JFSwipeBack.h"
#import <JFFoundation/NSObject+JFSwizzling.h>
#import <objc/runtime.h>

@implementation UINavigationController (JFSwipeBack)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self jf_changeSelector:@selector(viewDidLoad) withSelector:@selector(jf_swizzled_viewDidLoad)];
        [self jf_changeSelector:@selector(pushViewController:animated:) withSelector:@selector(jf_swizzled_pushViewController:animated:)];
    });
}

- (void)jf_swizzled_viewDidLoad {
    [self jf_swizzled_viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self.jf_swipeBackEnabled ? self : nil;
}

- (void)jf_swizzled_pushViewController:(UIViewController *)controller animated:(BOOL)animated {
    [self jf_swizzled_pushViewController:controller animated:animated];
    self.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - UIGestureRecognizerDelegate

// Prevent `interactiveGestureRecognizer` from canceling navigation button's touch event.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]] && [touch.view isDescendantOfView:self.navigationBar]) {
        UIButton *button = (id)touch.view;
        button.highlighted = YES;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 || !self.jf_swipeBackEnabled) {
        return NO;
    }

    CGPoint location = [gestureRecognizer locationInView:self.navigationBar];
    UIView *view = [self.navigationBar hitTest:location withEvent:nil];

    if ([view isKindOfClass:[UIButton class]] && [view isDescendantOfView:self.navigationBar]) {
        UIButton *button = (id)view;
        button.highlighted = NO;
    }
    return YES;
}

#pragma mark - swipeBackEnabled
- (BOOL)jf_swipeBackEnabled {
    NSNumber *enabled = objc_getAssociatedObject(self, @selector(jf_swipeBackEnabled));
    if (!enabled) {
        return YES; // default value
    }
    return enabled.boolValue;
}

- (void)jf_setSwipeBackEnabled:(BOOL)enabled {
    objc_setAssociatedObject(self, @selector(jf_swipeBackEnabled), @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
