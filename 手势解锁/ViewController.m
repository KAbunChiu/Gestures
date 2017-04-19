//
//  ViewController.m
//  手势解锁
//
//  Created by KAbun on 17/4/19.
//  Copyright © 2017年 KABIN. All rights reserved.
//

#import "ViewController.h"
#import "KABINView.h"


@interface ViewController ()<KABINViewDelegate>

@property (weak, nonatomic) IBOutlet KABINView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImage;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];
    self.contentView.delegate=self;
}

-(void)KABINView:(KABINView *)kView :(NSString *)str{
    //开启一个图形上下文
    UIGraphicsBeginImageContextWithOptions(kView.frame.size, NO, 0.0);
    //获取图形上下文
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    //截图
    [self.contentView.layer renderInContext:ctx];
    //获取图片
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    //把获取的图片保存到contentImage中
    self.contentImage.image=image;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
