//
//  BullTipsView.h
//  GDPickerView
//
//  Created by 郭达 on 2018/5/3.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BullTipsView : UIView


/**
 默认时间1.5s

 @param message message description
 */
+ (void)showMessage:(NSString*)message;


/**
 showmessage

 @param message message description
 @param time time description
 */
+ (void)showMessage:(NSString*)message duration:(NSTimeInterval)time;

@end
