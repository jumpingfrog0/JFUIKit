//  UIImage+JFCompress.m
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

#import "UIImage+JFCompress.h"
#import "UIImage+JFResize.h"

@implementation UIImage (JFCompress)

- (NSData *)jf_compressedJPEGImageData
{
    CGFloat compressRate = 0.3;
    CGSize imageSize     = [UIImage __jf_sizeForUploadWithImageSize:self.size compressRate:&compressRate];
    UIImage *targetImage = [self jf_resizedImage:imageSize interpolationQuality:kCGInterpolationDefault];

    return UIImageJPEGRepresentation(targetImage, compressRate);
}

+ (CGSize)__jf_sizeForUploadWithImageSize:(CGSize)size compressRate:(CGFloat *)compressRate
{
    CGFloat imageWidth  = size.width;
    CGFloat imageHeight = size.height;

    CGFloat imageMaxWidth = 1280.0;

    if (imageWidth >= 1280.0) {
        CGFloat ratio = imageWidth / imageMaxWidth;
        imageHeight   = imageHeight / ratio;
        imageWidth    = imageMaxWidth;
        *compressRate = 0.3;
    } else if (imageWidth <= 720) {
        *compressRate = 0.6;
    } else {
        *compressRate = 0.8;
    }
    return CGSizeMake(imageWidth, imageHeight);
}

+ (UIImage *)jf_compressedImage:(UIImage *)image maxDataSize:(NSUInteger)dataSize {
    if (!image) {
        return nil;
    }

    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (imageData.length > dataSize) {
        float scaleSize = (dataSize * 1.0f)/(imageData.length);
        scaleSize = 0.9f * sqrtf(scaleSize);
        return [self __jf_compressedImage:image toScale:scaleSize maxDataSize:dataSize];
    } else {
        return image;
    }
}

+ (UIImage *)__jf_compressedImage:(UIImage *)image toScale:(float)scaleSize maxDataSize:(NSUInteger)dataSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize - 1, image.size.height * scaleSize - 1));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *imageData = UIImageJPEGRepresentation(scaledImage, 1.0);
    if (imageData.length > dataSize) {
        float scale = (dataSize * 1.0f) / (imageData.length);
        scale = 0.9f * sqrtf(scale);
        return [self __jf_compressedImage:scaledImage toScale:scale maxDataSize:dataSize];
    }
    return scaledImage;
}

- (UIImage *)jf_decompressWithSize:(CGSize)targetSize {
    CGImageRef imageRef = self.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);

    BOOL sameSize = NO;

    if (CGSizeEqualToSize(targetSize, CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)))) {
        targetSize = CGSizeMake(1, 1);
        sameSize = YES;
    }

    size_t imageWidth = (size_t)targetSize.width;
    size_t imageHeight = (size_t)targetSize.height;
    CGContextRef context = CGBitmapContextCreate(NULL,
            imageWidth,
            imageHeight,
            8,
            imageWidth * 4,   // Just always return width * 4 will be enough
            colorSpace,       // System only supports RGB, set explicitly
            alphaInfo | kCGBitmapByteOrder32Little  // Makes system don't need to do extra conversion when displayed.
    );


    CGColorSpaceRelease(colorSpace);

    if (!context) {
        return nil;
    }

    CGRect rect = (CGRect){CGPointZero, {imageWidth, imageHeight}};
    CGContextDrawImage(context, rect, imageRef);
    if (sameSize) {
        CGContextRelease(context);
        return self;
    }
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    UIImage *decompressedImage = [[UIImage alloc] initWithCGImage:decompressedImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(decompressedImageRef);

    return decompressedImage;
}

- (NSData *)jf_compressedImageDataForShare
{
    CGFloat compressRate = 1;
    CGSize imageSize = CGSizeMake(500, 500);
    UIImage *targetImage = [self jf_resizedImage:imageSize interpolationQuality:kCGInterpolationDefault];

    return UIImageJPEGRepresentation(targetImage, compressRate);
}
@end
