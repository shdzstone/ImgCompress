//
//  UIImage+SHCompress.m
//  RushRabbit
//
//  Created by stone on 2018/12/20.
//  Copyright © 2018 cdz's mac. All rights reserved.
//

#import "UIImage+SHCompress.h"

@implementation UIImage(SHCompress)
- (NSData *)compressWithLengthLimit:(int)maxLength {
    //图片质量压缩
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    NSLog(@"压缩前:%.4fMB  最大值:%iMB",data.length/1024/1024.0,maxLength);
    maxLength = maxLength*1024*1024;
    if (data.length < maxLength)
        return data;
    CGFloat max = 1;
    CGFloat min = 0.2;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        if (compression>=0.6) {
            data = UIImageJPEGRepresentation(self, compression);
            NSLog(@"第%i次图片质量压缩,压缩率:%.1f,图片大小%.4fMB",i,compression, data.length /1024/1024.0);
            if (data.length < maxLength * 0.9) {
                min = compression;
            } else if (data.length > maxLength) {
                max = compression;
            } else {
                break;
            }
        }
    }
    NSLog(@"质量压缩后图片大小:%.4fMB",data.length/1024/1024.0);
    if (data.length < maxLength)
        return data;
    
    UIImage *resultImage = [UIImage imageWithData:data];
    // 尺寸压缩
    NSLog(@"原图尺寸:%@",NSStringFromCGSize(self.size));
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        NSLog(@"尺寸压缩比率:%.4f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    NSLog(@"尺寸压缩后图片大小: %.4f MB", data.length/1024/1024.0);
    NSLog(@"压缩后尺寸:%@",NSStringFromCGSize(resultImage.size));
    return data;
}

@end
