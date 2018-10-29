//
//  GDInputView.h
//  GDInputTextView
//
//  Created by 郭达 on 2018/7/4.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GDInputView : UIView

@property (nonatomic, copy) void(^sendAction)(NSString *text);

@property (nonatomic, copy) void(^inputViewHeight)(CGFloat inputHeight);


- (void)beginUpdateUI;

+ (CGFloat)getOriginInputViewHeight;

- (void)returnKeyBoard;
@end
