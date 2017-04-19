//
//  KABINView.m
//  手势解锁
//
//  Created by KAbun on 17/4/19.
//  Copyright © 2017年 KABIN. All rights reserved.
//

#import "KABINView.h"
@interface KABINView()

@property(nonatomic,strong)NSMutableArray *arrM;

@property(nonatomic,assign)CGPoint point;

@end
@implementation KABINView

-(NSMutableArray *)arrM{
    if (!_arrM) {
        _arrM=[NSMutableArray new];
    }
    return _arrM;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI{
    for (int i=0; i<9; i++) {
        UIButton *btn=[UIButton new];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        ;
        btn.userInteractionEnabled=NO;
        btn.tag=1+i;
        [self addSubview:btn];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //按钮的宽
    CGFloat btnW=75;
    //按钮的高
    CGFloat btnH=btnW;
    //父控件的宽
    CGFloat supW=self.frame.size.width;
    //父控件的高
    CGFloat supH=self.frame.size.height;
    
    //竖直两边的间隔
    CGFloat marginR=(supW-btnW*3)/4;
    //横向两边的间隔
    CGFloat marginC=(supH-btnH*3)/4;

    for (int i=0; i<9; i++) {
        CGFloat btnX=marginR+(btnW+marginR)*(i/3);
        CGFloat btnY=marginC+(btnH+marginC)*(i%3);
        UIButton *btn=[UIButton new];
        btn=self.subviews[i];
        btn.frame=CGRectMake(btnX, btnY, btnW, btnH);
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取触控对象
    UITouch *touch=[touches anyObject];
    //获取触控对象的点坐标
    CGPoint touchP=[touch locationInView:touch.view];
    //判断点坐标是否在按钮区域内
    for (int i=0; i<self.subviews.count; i++) {
        //获取按钮
        UIButton *btn=self.subviews[i];
        //判断这点是否在按钮区域内
        if (CGRectContainsPoint(btn.frame, touchP) && btn.selected==NO) {
            //如果是则为选中状态
            btn.selected=YES;
            //把选中的按钮添加到数组中
            [self.arrM addObject:btn];
        }
    }
}

//手指移动
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //创建出最后一条没有连接的线路
    UITouch *touch=[touches anyObject];
    self.point=[touch locationInView:touch.view];
    [self touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

//手指离开
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //把最后一个点的中心点赋值给属性记录的那个点
    self.point=[[self.arrM lastObject] center];
    //重绘
    [self setNeedsDisplay];
    //拼接字符
    NSMutableString *strM=[[NSMutableString alloc]init];
    for (int i=0; i<self.arrM.count; i++) {
        UIButton *btn=[UIButton new];
        btn=self.arrM[i];
        //拼接
        [strM appendFormat:@"%@",@(btn.tag)];
    }
    //实现代理
    if ([self.delegate respondsToSelector:@selector(KABINView::)]) {
        [self.delegate KABINView:self :strM];
    }
    //移除所有按钮的选中状态
    for (UIButton *btn in self.arrM) {
        btn.selected=NO;
    }
    //移除数组里面的子控件
    [self.arrM removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    //如果数组不为空就执行
    if (self.arrM.count!=0) {
        //绘制路劲
        UIBezierPath *path=[UIBezierPath bezierPath];
        //设置线宽
        path.lineWidth=5;
        //设置颜色
        [[UIColor yellowColor]set];
        //设置其实处样式
        path.lineCapStyle=kCGLineCapRound;
        //设置交点样式
        path.lineJoinStyle=kCGLineJoinRound;
        //设置起始点和线路
        for (int i=0; i<self.arrM.count; i++) {
            UIButton *btn=[UIButton new];
            btn=self.arrM[i];
            CGPoint cen=btn.center;
            if (i==0) {
                [path moveToPoint:cen];
            }else{
                [path addLineToPoint:cen];
            }
        }
    //把最后一条线路添加进去
        [path addLineToPoint:self.point];
        //绘制
        [path stroke];
    
    }
}
@end

