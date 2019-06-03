//
//  UIImage+SHCompress.h
//  RushRabbit
//
//  Created by stone on 2018/12/20.
//  Copyright © 2018 cdz's mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage(SHCompress)
/*
 *  压缩图片方法(先压缩质量再压缩尺寸)
 */
- (NSData *)compressWithLengthLimit:(int)maxLength;
@end

NS_ASSUME_NONNULL_END
