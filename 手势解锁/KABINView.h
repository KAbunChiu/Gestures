//
//  KABINView.h
//  手势解锁
//
//  Created by KAbun on 17/4/19.
//  Copyright © 2017年 KABIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KABINView;

@protocol KABINViewDelegate <NSObject>

-(void)KABINView:(KABINView *)kView :(NSString *)str;

@end

@interface KABINView : UIView

@property(nonatomic)id<KABINViewDelegate>delegate;

@end
