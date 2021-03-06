//
//  UINavigationItem+JFExtension.m
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

#import "UINavigationItem+JFExtension.h"
#import "UIColor+JF.h"
#import "UIView+JFRect.h"
#import "UINavigationBar+JF.h"

@implementation UINavigationItem (JFExtension)

- (void)jf_setTitleViewWithText:(NSString *)text {
    UIColor *color = [[UINavigationBar appearance] jf_tintColor];
    [self jf_setTitleViewWithText:text color:color];
}

- (void)jf_setLightColorTitleViewWithText:(NSString *)text
{
    UILabel *titleLabel        = [UILabel new];
    titleLabel.text            = text;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    titleLabel.textColor       = [UIColor whiteColor];
    titleLabel.font            = [UIFont systemFontOfSize:17.0];
    [titleLabel sizeToFit];

    [self.titleView removeFromSuperview];
    self.titleView = titleLabel;
}

- (void)jf_setTitleViewWithText:(NSString *)text color:(UIColor *)color {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text            = text;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    titleLabel.textColor       = color;
    titleLabel.font            = [UIFont boldSystemFontOfSize:17.0];
    [titleLabel sizeToFit];

    [self.titleView removeFromSuperview];
    self.titleView = titleLabel;
}

- (void)jf_setTitleViewWithActivityAndText:(NSString *)text
{
    CGFloat textWidth = [self __suitableWidthWithText:text font:[UIFont boldSystemFontOfSize:18] height:44.0];

    UIView *view         = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, textWidth + 25.0, 44.0)];
    view.backgroundColor = [UIColor clearColor];

    CGRect activityFrame = CGRectMake(0.0, 0.0, 20.0, 20.0);
    UIActivityIndicatorView *activityView =
                   [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = activityFrame;
    [view addSubview:activityView];

    CGRect titleFrame     = CGRectMake(activityFrame.size.width + 5.0, 0.0, textWidth, 44.0);
    UILabel *title        = [[UILabel alloc] initWithFrame:titleFrame];
    title.text            = text;
    title.font            = [UIFont boldSystemFontOfSize:18.0];
    title.textColor       = [UIColor blackColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment   = NSTextAlignmentRight;

    [view addSubview:title];
    [activityView jf_centerVerticallyInSuperview];

    [self.titleView removeFromSuperview];
    self.titleView = view;

    [activityView startAnimating];
}

- (void)jf_setLightColorTitleViewWithActivityAndText:(NSString *)text
{
    CGFloat textWidth = [self __suitableWidthWithText:text font:[UIFont boldSystemFontOfSize:18] height:44.0];

    UIView *view         = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, textWidth + 25.0, 44.0)];
    view.backgroundColor = [UIColor clearColor];

    CGRect activityFrame = CGRectMake(0.0, 0.0, 20.0, 20.0);
    UIActivityIndicatorView *activityView =
                   [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = activityFrame;
    [view addSubview:activityView];

    CGRect titleFrame     = CGRectMake(activityFrame.size.width + 5.0, 0.0, textWidth, 44.0);
    UILabel *title        = [[UILabel alloc] initWithFrame:titleFrame];
    title.text            = text;
    title.font            = [UIFont boldSystemFontOfSize:18.0];
    title.textColor       = [UIColor whiteColor];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment   = NSTextAlignmentRight;

    [view addSubview:title];
    [activityView jf_centerVerticallyInSuperview];

    [self.titleView removeFromSuperview];
    ;
    self.titleView = view;

    [activityView startAnimating];
}

- (void)jf_setupLeftBarButtonItem:(UIBarButtonItem *)barButtonItem {
    UIBarButtonItem *space =
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];

    UIButton *button = [barButtonItem customView];
    if (button.titleLabel.text) {
        space.width = -3;
    } else {
        space.width = 2;
    }

    [self setLeftBarButtonItems:[NSArray arrayWithObjects:space, barButtonItem, nil]];
}

- (void)jf_setupRightBarButtonItem:(UIBarButtonItem *)barButtonItem {
    UIBarButtonItem *space =
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -3;
    [self setRightBarButtonItems:[NSArray arrayWithObjects:space, barButtonItem, nil]];
}

- (void)jf_setupBackBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [self jf_setupLeftBarButtonItem:barButtonItem];
}

- (void)jf_setupRightBarButtonItems:(NSArray *)items {
    if (items.count == 0) {
        return;
    }

    UIBarButtonItem *space =
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -3;

    NSComparator comparator = ^(id obj1, id obj2) {
        return NSOrderedDescending;
    };
    NSArray      *array     = [[items arrayByAddingObject:space] sortedArrayUsingComparator:comparator];

    [self setRightBarButtonItems:array];
}

- (void)jf_setupLeftBarButtonItems:(NSArray *)items {
    if (items.count == 0) {
        return;
    }

    UIBarButtonItem *space =
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -3;

    NSArray *array = [@[space] arrayByAddingObjectsFromArray:items];
    [self setLeftBarButtonItems:array];
}

#pragma mark  - private
- (CGFloat)__suitableWidthWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height
{
    CGSize constraintSize = CGSizeMake(MAXFLOAT, height);
    CGSize realSize;
    if (!font) {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    NSDictionary *attribute = @{NSFontAttributeName: font};
    realSize                = [text boundingRectWithSize:constraintSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                              attributes:attribute
                                                 context:nil]
            .size;
    return ceilf(realSize.width);
}
@end
