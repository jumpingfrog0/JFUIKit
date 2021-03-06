//
//  UIView+Drawing.m
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

#import "UIView+JFDraw.h"
#import <objc/runtime.h>
#import "UIImage+JFUIKit.h"

static NSString *const kProgressLayerKey = @"kProgressLayerKey";
static NSString *const kShapeLayerKey    = @"kShapeLayerKey";

@implementation UIView (JFDraw)

+ (UIView *)jf_topLine {
    UIImage *image = [UIImage jf_imageNamedInJFUIKitBundle:@"horizontal-separator-default"];
    CGRect frame =
                    CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, ceilf(image.size.height / [UIScreen mainScreen].scale));
    UIImageView *imageView     = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor  = [UIColor clearColor];
    imageView.image            = [image stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    return imageView;
}

+ (UIView *)jf_bottomLineWithOffsetX:(CGFloat)offsetX containerHeight:(CGFloat)height {
    UIImage *image = [UIImage jf_imageNamedInJFUIKitBundle:@"horizontal-separator-default"];
    CGRect frame   = CGRectMake(offsetX,
            height - image.size.height,
            [UIScreen mainScreen].bounds.size.width - offsetX,
            ceilf(image.size.height / [UIScreen mainScreen].scale));
    UIImageView *imageView     = [[UIImageView alloc] initWithFrame:frame];
    imageView.backgroundColor  = [UIColor clearColor];
    imageView.image            = [image stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    return imageView;
}

- (void)jf_setCircleHollowWithMaskColor:(UIColor *)color radius:(CGFloat)radius center:(CGPoint)center {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.bounds]];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center
                                                    radius:radius
                                                startAngle:0
                                                  endAngle:(CGFloat) (2 * M_PI)
                                                 clockwise:NO]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path      = path.CGPath;
    shapeLayer.fillRule  = kCAFillRuleEvenOdd;
    shapeLayer.fillColor = color.CGColor;

    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:shapeLayer];
}

- (void)jf_setCenterCircleHollowWithMaskColor:(UIColor *)color radius:(CGFloat)radius {
    [self jf_setCircleHollowWithMaskColor:color
                                radius:radius
                                center:CGPointMake((CGFloat) (self.bounds.size.width * 0.5), (CGFloat) (self.bounds.size.height * 0.5))];
}

- (void)jf_setHollowWithMaskColor:(UIColor *)color rect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path appendPath:[UIBezierPath bezierPathWithRect:self.bounds]];
    [path appendPath:[UIBezierPath bezierPathWithRect:rect]];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path      = path.CGPath;
    shapeLayer.fillRule  = kCAFillRuleEvenOdd;
    shapeLayer.fillColor = color.CGColor;

    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:shapeLayer];
}

- (void)jf_addCycleProgress:(CGFloat)progress color:(UIColor *)color width:(CGFloat)width {

    if (self.jf_progressLayer != nil) {
        [self.jf_progressLayer removeFromSuperlayer];
    }

    CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat radius = 0.0;
    radius = ceilf((self.bounds.size.width - width) * 0.5) + 0.5;
    CGFloat startPoint = -M_PI_2;                       //设置进度条起点位置
    CGFloat endPoint   = -M_PI_2 + M_PI * 2 * progress; //设置进度条终点位置

    //环形路径
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame       = self.bounds;
    progressLayer.fillColor   = [[UIColor clearColor] CGColor];            // 填充色为无色
    progressLayer.strokeColor = [color CGColor];                           // 指定path的渲染颜色
    progressLayer.opacity     = 1;                                         //背景颜色的透明度
    progressLayer.lineWidth   = width * [UIScreen mainScreen].scale * 0.5; //线的宽度

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startPoint
                                                      endAngle:endPoint
                                                     clockwise:YES];
    progressLayer.path = [path CGPath];
    [self.layer addSublayer:progressLayer];
     
    [self jf_setProgressLayer:progressLayer];
}

- (void)jf_addCircleLayerWithColor:(UIColor *)color width:(CGFloat)width radius:(CGFloat)radius {
    if (self.jf_shapeLayer != nil) {
        [self.jf_shapeLayer removeFromSuperlayer];
    }

    CGPoint center     = CGPointMake((CGFloat) (self.bounds.size.width * 0.5), (CGFloat) (self.bounds.size.height * 0.5));
    CGFloat startPoint = (CGFloat) -M_PI_2;            //设置进度条起点位置
    CGFloat endPoint   = (CGFloat) (-M_PI_2 + M_PI * 2); //设置进度条终点位置

    //环形路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame       = self.bounds;
    shapeLayer.fillColor   = [[UIColor clearColor] CGColor];            // 填充色为无色
    shapeLayer.strokeColor = [color CGColor];                           // 指定path的渲染颜色
    shapeLayer.opacity     = 1;                                         //背景颜色的透明度
    shapeLayer.lineWidth   = (CGFloat) (width * [UIScreen mainScreen].scale * 0.5); //线的宽度

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startPoint
                                                      endAngle:endPoint
                                                     clockwise:YES];
    shapeLayer.path = [path CGPath];
    [self.layer addSublayer:shapeLayer];

    [self jf_setShapeLayer:shapeLayer];
}

- (void)jf_addRectLayerWithColor:(UIColor *)color width:(CGFloat)width inRect:(CGRect)rect {
    if (self.jf_shapeLayer != nil) {
        [self.jf_shapeLayer removeFromSuperlayer];
    }

    // 路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame       = self.bounds;
    shapeLayer.fillColor   = [[UIColor clearColor] CGColor];            // 填充色为无色
    shapeLayer.strokeColor = [color CGColor];                           // 指定path的渲染颜色
    shapeLayer.opacity     = 1;                                         //背景颜色的透明度
    shapeLayer.lineWidth   = (CGFloat) (width * [UIScreen mainScreen].scale * 0.5); //线的宽度

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    shapeLayer.path = [path CGPath];
    [self.layer addSublayer:shapeLayer];

    [self jf_setShapeLayer:shapeLayer];
}

#pragma mark -

- (void)jf_setShapeLayer:(CAShapeLayer *)shapeLayer {
    objc_setAssociatedObject(self, &kShapeLayerKey, shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)jf_shapeLayer {
    return (CAShapeLayer *) objc_getAssociatedObject(self, &kShapeLayerKey);
}

- (void)jf_setProgressLayer:(CAShapeLayer *)progressLayer {
    objc_setAssociatedObject(self, &kProgressLayerKey, progressLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)jf_progressLayer {
    return (CAShapeLayer *) objc_getAssociatedObject(self, &kProgressLayerKey);
}

#pragma mark -

- (void)jf_addRoundedCorners:(UIRectCorner)corners
                withRadius:(CGFloat)radius {
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];

    self.layer.mask = shape;
}

- (void)jf_setGradientLayer:(UIColor *)startColor endColor:(UIColor *)endColor isHorizontal:(BOOL)isHorizontal {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.startPoint = isHorizontal ? CGPointMake(0, 0.5) : CGPointMake(0.5, 0);
    gradientLayer.endPoint = isHorizontal ? CGPointMake(1, 0.5) : CGPointMake(0.5, 1);
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
    if (!CGRectEqualToRect(self.bounds, CGRectZero)) {
        [self.layer insertSublayer:gradientLayer atIndex:0];
    }
}

- (void)jf_setGradientLayer:(UIColor *)startColor endColor:(UIColor *)endColor rect:(CGRect)rect isHorizontal:(BOOL)isHorizontal {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = rect;
    gradientLayer.startPoint = isHorizontal ? CGPointMake(0, 0.5) : CGPointMake(0.5, 0);
    gradientLayer.endPoint = isHorizontal ? CGPointMake(1, 0.5) : CGPointMake(0.5, 1);
    gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
    if (!CGRectEqualToRect(rect, CGRectZero)) {
        [self.layer insertSublayer:gradientLayer atIndex:0];
    }
}

@end
