//
//  UIView+JFExtension.m
//  JFUIKit
//
//  Created by jumpingfrog0 on 2018/08/02.
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

#import "UIView+JFExtension.h"
#import "UIImage+JFExtension.h"

@implementation UIView (JFExtension)

- (UIViewController *)jf_viewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)jf_setTopLineWithColor:(UIColor *)color {
    CGRect frame = CGRectMake(0.0, 0.0, self.bounds.size.width, 1);
    UIImageView *imageView     = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor  = color;
    [self addSubview:imageView];
}

- (void)jf_setTopLineWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat width = [UIScreen mainScreen].bounds.size.width < self.bounds.size.width ? [UIScreen mainScreen].bounds.size.width : self.bounds.size.width;
    CGRect frame = CGRectMake(0.0, 0.0, width, image.size.height);
    UIImageView *imageView     = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor  = [UIColor clearColor];
    imageView.image = [UIImage jf_resizableImageNamed:imageName];
    [self addSubview:imageView];
}

- (void)jf_setBottomLineWithColor:(UIColor *)color {
    CGRect frame = CGRectMake(0.0, self.bounds.size.height, self.bounds.size.width, 1);
    UIImageView *imageView     = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor  = color;
    [self addSubview:imageView];
}

- (void)jf_setBottomLineWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat width = [UIScreen mainScreen].bounds.size.width < self.bounds.size.width ? [UIScreen mainScreen].bounds.size.width : self.bounds.size.width;
    CGRect frame = CGRectMake(0.0, self.bounds.size.height - 1, width, image.size.height);
    UIImageView *imageView     = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor  = [UIColor clearColor];
    imageView.image = [UIImage jf_resizableImageNamed:imageName];
    [self addSubview:imageView];
}

- (void)jf_removeLayerAnimationsRecursively {
    [self.layer removeAllAnimations];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj jf_removeLayerAnimationsRecursively];
    }];
}

- (UIWindow *)jf_getCurrentWindow {
    UIWindow *window = nil;
    // check device
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) { // iPhone
        // get key window
        for (UIWindow *a_w in [UIApplication sharedApplication].windows) {
            if (a_w.isKeyWindow) {
                window = a_w;
                break;
            }
        }
        
        // if key window is not exist
        if (!window) {
            window = [UIApplication sharedApplication].windows.firstObject;
            
        }
        if (!window) {   // if window still is not exists
            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
                window = [UIApplication sharedApplication].delegate.window;
            }
        }
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) { // iPad
        // get key window
        for (UIWindow *a_w in [UIApplication sharedApplication].windows) {
            if (a_w.isKeyWindow) {
                window = a_w;
                break;
            }
        }
        if (!window) {  // 如果也没取到keyWindow，拿第一个Window
            window = [UIApplication sharedApplication].windows.firstObject;
        }
    }
    return window;
}
@end
