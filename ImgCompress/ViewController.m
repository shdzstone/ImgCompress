//
//  ViewController.m
//  VideoDemo
//
//  Created by cdz on 2019/5/31.
//  Copyright © 2019 cdz. All rights reserved.
//

#import "ViewController.h"

#import "UIImage+SHCompress.h"

typedef void(^completionHandler)(NSMutableArray *img);


@interface ViewController ()
@property (nonatomic, strong) NSMutableArray<UIImage *> *source;
@property (nonatomic, strong) NSMutableArray *compressedData;

@end

@implementation ViewController

#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"source.Count:%ld",self.source.count);
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)]];
}

-(void)viewWillLayoutSubviews{
    
}
#pragma mark - TouchEvent
-(void)tapAction:(id)sender {
    if (!self.compressedData) {
        self.compressedData = [NSMutableArray array];
    }
    [self.compressedData removeAllObjects];
    //
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i =  0; i < self.source.count; i++) {
        __weak typeof(self) weakself = self;
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            NSLog(@"第%i张图片压缩开始-------------------------------",i);
            int maxLength = 1;//最大5MB
            NSData *data = [self.source[i] compressWithLengthLimit:maxLength];
            [weakself.compressedData addObject:data];
            NSLog(@"第%i张图片压缩完成***************************",i);
            dispatch_semaphore_signal(semaphore);
            dispatch_group_leave(group);
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"压缩完成:%d",(int)self.compressedData.count);
    });
    
}


#pragma mark - 懒加载

- (NSMutableArray<UIImage *> *)source{
    if (!_source) {
        _source = @[].mutableCopy;
        for (int i= 0 ; i < 3; i++) {
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"%i.jpg",i]];
            [_source addObject:img];
        }
    }
    return _source;
}

@end
