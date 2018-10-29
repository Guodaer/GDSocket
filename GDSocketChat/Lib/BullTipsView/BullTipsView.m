//
//  BullTipsView.m
//  GDPickerView
//
//  Created by 郭达 on 2018/5/3.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "BullTipsView.h"
#define GD_SHOW_DURATION       0.3     // 动画出现持续时间
#define GD_DISMISS_DURATION    0.3     // 动画消失持续时间
#define GD_HOLD_DURATION       1.5     // 提示持续时间
#define GD_WAIT_DURATION       10      // 最长等待时间
#define GD_PRE_DURATION        1.0     // 每一帧持续时间

#define GD_Max_Width 240
#define GD_Min_Width 150//后期宽度适配再说 最小的宽度
/*
    先按照最小的宽度计算，如果小于minwidth  则加宽
    到最大了还放不下那就加高度
*/
#define GD_Min_Height 50

#define GD_Space 15
#define Normal_Font [UIFont systemFontOfSize:16]
typedef NS_ENUM(NSInteger,BullTipsViewType) {
    BullTipsViewType_Normal = 0,
    BullTipsViewType_Begining
};

@interface BullTipsView ()

@property (nonatomic, assign) BullTipsViewType tipsStatus;//状态

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UIView *gd_tipsView;

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation BullTipsView

+ (instancetype)shareInstance {
    static BullTipsView *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (instancetype)init {
    self.window = [UIApplication sharedApplication].keyWindow;
    _tipsStatus = BullTipsViewType_Normal;
    return self;
}
+ (void)showMessage:(NSString*)message {
    [self showMessage:message duration:GD_HOLD_DURATION];
}

+ (void)showMessage:(NSString*)message duration:(NSTimeInterval)time {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self shareInstance]showMessage:message duration:time];
    });
}
- (void)showMessage:(NSString*)message duration:(NSTimeInterval)time {
    
    CGFloat currentWidth = 0,currentHeight = 0;
    
    //先按照最小的宽度计算
    CGFloat message_width = [self getNormalStringRectByfont:Normal_Font AndSize:CGSizeMake(1000, 16) AndMessage:message].size.width;
    if (message_width > GD_Max_Width-2*GD_Space) {
        currentWidth = GD_Max_Width - 2*GD_Space;
        //宽度最宽，开始计算高度了
        CGFloat Height = [self getNormalStringRectByfont:Normal_Font AndSize:CGSizeMake(GD_Max_Width-GD_Space*2, 1000) AndMessage:message].size.height;
        if (Height < GD_Min_Height-GD_Space*2) {
            Height = GD_Min_Height-GD_Space*2;
        }
        currentHeight = Height;
    }else {
        //就一行能城下
        if (message_width < GD_Min_Width-2*GD_Space) {
            currentWidth = GD_Min_Width-2*GD_Space;
        }else {
            currentWidth = message_width;
        }
        currentHeight = GD_Min_Height - GD_Space;
    }
    
    
    if (_tipsStatus == BullTipsViewType_Begining) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
        [self.mainView.layer removeAllAnimations];
        self.gd_tipsView.frame = CGRectMake(0, 0, currentWidth+GD_Space*2, currentHeight + GD_Space*2);
        self.gd_tipsView.center = self.mainView.center;
        self.messageLabel.frame = CGRectMake(GD_Space, GD_Space, currentWidth, currentHeight);
        
        self.messageLabel.text = message;
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:time];
        _tipsStatus = BullTipsViewType_Begining;

        return;
    }
    
    _tipsStatus = BullTipsViewType_Begining;
//    CGFloat Height = [self getNormalStringRectByfont:Normal_Font AndSize:CGSizeMake(GD_Max_Width-GD_Space*2, 1000) AndMessage:message].size.height;
//    if (Height < GD_Min_Height-GD_Space*2) {
//        Height = GD_Min_Height-GD_Space*2;
//    }
    
    self.mainView.alpha = 0;
    self.gd_tipsView.frame = CGRectMake(0, 0, currentWidth+GD_Space*2, currentHeight + GD_Space*2);
    self.gd_tipsView.center = self.mainView.center;
    self.messageLabel.frame = CGRectMake(GD_Space, GD_Space, currentWidth, currentHeight);
    self.messageLabel.text = message;
    [self.gd_tipsView addSubview:self.messageLabel];
    
    self.mainView.transform = CGAffineTransformMakeScale(0.5,0.5);
    [UIView animateWithDuration:GD_SHOW_DURATION animations:^{
        self.mainView.transform = CGAffineTransformMakeScale(1, 1);
        self.mainView.alpha = 1;
    }];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:time];
    
}
- (void)dismiss {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:GD_DISMISS_DURATION animations:^{
            self.mainView.alpha = 0;
            self.mainView.transform = CGAffineTransformMakeScale(0.5,0.5);
        } completion:^(BOOL finished) {
            if (finished) {
                [self immediatelyDismiss];
            }else{
                self.mainView.alpha = 1;
                [UIView animateWithDuration:0.1 animations:^{
                    self.mainView.transform = CGAffineTransformMakeScale(1,1);
                }];
            }
        }];
    });
    
}
- (void)immediatelyDismiss {
    [self.messageLabel removeFromSuperview];
    self.messageLabel = nil;
    [self.gd_tipsView removeFromSuperview];
    self.gd_tipsView = nil;
    [self.mainView removeFromSuperview];
    self.mainView = nil;
    _tipsStatus = BullTipsViewType_Normal;
}
- (CGRect)getNormalStringRectByfont:(UIFont*)font AndSize:(CGSize)size AndMessage:(NSString*)message{
    CGRect rect = [message boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = Normal_Font;
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}
- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:self.window.bounds];
        _mainView.backgroundColor = [UIColor clearColor];
        [self.window addSubview:_mainView];
    }
    return _mainView;
}
- (UIView *)gd_tipsView {
    if (!_gd_tipsView) {
        _gd_tipsView = [[UIView alloc] init];
        _gd_tipsView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5];
        _gd_tipsView.layer.cornerRadius = 8;
        _gd_tipsView.clipsToBounds = YES;
        [self.mainView addSubview:_gd_tipsView];
    }
    return _gd_tipsView;
}

@end
