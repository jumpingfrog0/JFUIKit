//
//  UIViewController+JFNavigation.h
//  JFUIKit
//
//  Created by jumpingfrog0 on 2017/07/27.
//
//
//  Copyright (c) 2017 - 2018 Donghong Huang <jumpingfrog0@gmail.com>
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

#import <UIKit/UIKit.h>

@interface UIViewController (JFNavigation)

#pragma mark - storyboard
+ (instancetype)jf_instantiateFromMainStoryboard;
+ (instancetype)jf_instantiateFromStoryboardWithName:(NSString *)name;
+ (instancetype)jf_instantiateFromStoryboardWithName:(NSString *)name bundle:(NSBundle *)bundle indentifier:(NSString *)indentifier;

#pragma mark - push

+ (void)jf_pushInNavigationController:(UINavigationController *)navVc fromStoryboard:(NSString *)storyboardName;
+ (void)jf_pushInNavigationController:(UINavigationController *)navVc;
+ (void)jf_pushInNavigationController:(UINavigationController *)navVc animated:(BOOL)animated;

#pragma mark - present

- (void)jf_present:(__kindof UIViewController *)viewControllerToPresent fromStoryboard:(NSString *)storyboardName inNavigationController:(__kindof UINavigationController *)navigationController;
- (void)jf_present:(__kindof UIViewController *)viewControllerToPresent inNavigationController:(__kindof UINavigationController *)navigationController;

#pragma mark - navigation

- (void)jf_pushViewController:(UIViewController *)vc backToNode:(NSArray *)nodeClasses;
- (void)jf_pushViewController:(UIViewController *)vc backToNode:(NSArray *)nodeClasses options:(NSEnumerationOptions)options;

- (void)jf_popToNode:(NSArray *)nodeClasses;
- (void)jf_popToNode:(NSArray *)nodeClasses options:(NSEnumerationOptions)options;

- (void)jf_popAndPushViewController:(UIViewController *)vc;
- (void)jf_popAndPushViewController:(UIViewController *)vc animated:(BOOL)animated;

- (UIViewController *)jf_rePushPreviousNodeIfExist:(Class)vcNode;
@end
