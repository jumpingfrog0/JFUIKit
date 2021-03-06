//
//  UIImage+Extend.m
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

#import "UIImage+JFExtension.h"
#import "UIImage+JFResize.h"

NSString *const kJFSaveImageToPhotosAlbumSuccessNotification = @"kJFSaveImageToPhotosAlbumSuccessNotification";
NSString *const kJFSaveImageToPhotosAlbumFailureNotification = @"kJFSaveImageToPhotosAlbumFailureNotification";

@implementation UIImage (JFExtension)

// TODO: 适配UIImageView的大小和contentMode
+ (instancetype)jf_generateWithWatermark:(UIImage *)watermark ForImage:(UIImage *)image;
{
    // 创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(image.size, YES, 0.0);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];

    // 画水印
    CGFloat scale = 0.2;
    CGFloat margin = 5;
    CGFloat waterW = watermark.size.width * scale;
    CGFloat waterH = watermark.size.height * scale;
    CGFloat waterX = image.size.width - waterW - margin;
    CGFloat waterY = image.size.height - waterH - margin;
    [watermark drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];

    // 从上下文中取得制作完毕的UIImage对象
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    // 结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)jf_resizableImageNamed:(NSString *)name
{
    UIImage *origin = [UIImage imageNamed:name];

#ifdef DEBUG
    NSAssert(origin != nil, @"The resizable image should not be nil.");
#else
    NSLog(@"The resizable image should not be nil.");
#endif

    return [origin jf_autoResize];
}

+ (UIImage *)jf_imageNamed:(NSString *)imageName inBundle:(NSString *)bundleName {
    if (!bundleName) {
        return [UIImage imageNamed:imageName];
    }

    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bundlePath   = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *imagePath    = [bundlePath stringByAppendingPathComponent:imageName];
    imagePath              = [imagePath stringByAppendingPathExtension:@"png"];

    return [UIImage imageWithContentsOfFile:imagePath];
}

#pragma mark - snapshot

+ (UIImage *)jf_imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}

+ (UIImage *)jf_imageFromView:(UIView *)view inRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(rect);
    [view.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return theImage;
}

#pragma mark - save

- (void)jf_saveToPhotosAlbum {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
#pragma clang diagnostic pop
}

- (void)jf_image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (!error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kJFSaveImageToPhotosAlbumSuccessNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kJFSaveImageToPhotosAlbumFailureNotification object:nil];
    }
}

#pragma mark - rotate

CGFloat degreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat radiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

- (UIImage *)jf_imageRotatedByRadians:(CGFloat)radians {
    return [self jf_imageRotatedByDegrees:radiansToDegrees(radians)];
}

- (UIImage *)jf_imageRotatedByDegrees:(CGFloat)degrees {
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;

    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();

    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);

    // Rotate the image context
    CGContextRotateCTM(bitmap, degreesToRadians(degrees));

    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)jf_adjustRotation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
