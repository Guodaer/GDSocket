//
//  GDInputView.m
//  GDInputTextView
//
//  Created by 郭达 on 2018/7/4.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "GDInputView.h"

@interface GDInputView ()<UITextViewDelegate>{
    CGFloat keyboardY;
}

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIFont *font;

@property(nonatomic,assign)CGFloat topOrBottomEdge;//上下间距
@property(nonatomic ,assign) CGFloat originH;//记录初始化高度

@property (nonatomic, strong) UIView *gdBgView;//textview 背景


@end

@implementation GDInputView
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = Hex_Color(0xcccccc, 1).CGColor;
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        self.font = [UIFont systemFontOfSize:17];
        self.topOrBottomEdge = 8;
        _originH  = ceil (self.font.lineHeight) + 2 * self.topOrBottomEdge;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = Hex_Color(0xcccccc, 0.3);
    }
    return self;
}
- (void)tapAction:(UITapGestureRecognizer*)tap {
    [self.textView becomeFirstResponder];
}
- (void)returnKeyBoard {
    [self.textView endEditing:YES];
}
- (void)beginUpdateUI {
    _originH  = ceil (self.font.lineHeight) + 4 * self.topOrBottomEdge;
    CGFloat tabbar_height = Height_TabbarSafeBottom;
    self.frame =  CGRectMake(0, GScreenHeight - _originH-2-tabbar_height, GScreenWidth, _originH);
    if (self.inputViewHeight) {
        self.inputViewHeight(_originH);
    }
    [self setup];
}
-(void)setup{
    [self addSubview:self.gdBgView];
    self.gdBgView.frame = CGRectMake(10, self.topOrBottomEdge, self.width-70, self.height-2*self.topOrBottomEdge);
    
    [self.gdBgView addSubview:self.textView];
    self.textView.frame = CGRectMake(5, self.topOrBottomEdge, self.width - 80, ceil(self.font.lineHeight));
    
    
    [self addSubview:self.moreBtn];
    self.moreBtn.frame = CGRectMake(self.width - 50, self.topOrBottomEdge, 40, self.height-2*self.topOrBottomEdge);

}
- (void)restoreOriginalState {
    CGFloat originalY = self.y+self.height;
    self.frame = CGRectMake(0, originalY-self.originH, self.width, self.originH);
    self.gdBgView.height = self.height - 2*_topOrBottomEdge;
    self.textView.height = ceil(self.font.lineHeight);
    self.moreBtn.height = self.height - 2*_topOrBottomEdge;
    if (self.inputViewHeight) {
        self.inputViewHeight(_originH);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        if (self.sendAction) {
            self.sendAction(self.textView.text);
        }
        _textView.text = @"";
        [self restoreOriginalState];

        return NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    //改变textview高度
    CGFloat contentSizeH = self.textView.contentSize.height;
    CGFloat lineH = self.textView.font.lineHeight;
    CGFloat maxHeight = ceil(lineH * 4 + textView.textContainerInset.top + textView.textContainerInset.bottom);
    if (contentSizeH <= maxHeight) {
        self.textView.height = contentSizeH;
    }else{
        self.textView.height = maxHeight;
    }
    [textView scrollRangeToVisible:NSMakeRange(textView.selectedRange.location, 1)];
    CGFloat totalH = ceil(self.textView.height) + 4 * self.topOrBottomEdge;
    CGFloat originalY = self.y+self.height;
    if (self.inputViewHeight) {
        self.inputViewHeight(totalH);
    }
    self.frame = CGRectMake(0, originalY-totalH, self.width, totalH);
    self.gdBgView.height = self.height - 2*_topOrBottomEdge;
    self.moreBtn.height = self.height - 2*_topOrBottomEdge;
}

#pragma mark-键盘改变notification

- (void)KeyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardY = keyboardF.origin.y;
    CGFloat tabbar_height = Height_TabbarSafeBottom;
    [UIView animateWithDuration:duration animations:^{
        if (keyboardF.origin.y > GScreenHeight) {
            self.y = GScreenHeight - self.height-tabbar_height;
        }else{
            self.y = keyboardF.origin.y - self.height-tabbar_height;
        }
    }];
}
- (void)KeyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardY = keyboardF.origin.y;
//    CGFloat tabbar_height = Height_TabbarSafeBottom;
    [UIView animateWithDuration:duration animations:^{
        if (keyboardF.origin.y > GScreenHeight) {
            
            self.y = GScreenHeight - self.height;
        }else{
            self.y = keyboardF.origin.y - self.height;
        }
    }];
}

//-(void)keyboardWillChangeFrame:(NSNotification *)notification{
//    NSDictionary *userInfo = notification.userInfo;
//    // 动画的持续时间
//    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    // 键盘的frame
//    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    keyboardY = keyboardF.origin.y;
//    [self dealKeyBoardWithKeyboardF:keyboardY duration:duration];
//}
//#pragma mark---处理高度---
//-(void)dealKeyBoardWithKeyboardF:(CGFloat)keyboardY duration:(CGFloat)duration {
//    CGFloat tabbar_height = Height_TabbarSafeBottom;
//    [UIView animateWithDuration:duration animations:^{
//        if (keyboardY > GScreenHeight) {
//
//            self.y = GScreenHeight - self.height-tabbar_height;
//        }else{
//            self.y = keyboardY - self.height;
//        }
//    }];
//}
#pragma mark- 更多按钮
- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.backgroundColor = [UIColor yellowColor];
        [_moreBtn addTarget:self action:@selector(moreBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_moreBtn setTitle:@"GD" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _moreBtn;
}
- (void)moreBtnClickAction:(UIButton*)sender {
    if (self.moreBtnAction) {
        self.moreBtnAction();
    }
}
- (UIView *)gdBgView {
    if (!_gdBgView) {
        _gdBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _gdBgView.layer.cornerRadius = 5;
        _gdBgView.clipsToBounds = YES;
        _gdBgView.backgroundColor = [UIColor whiteColor];
        _gdBgView.userInteractionEnabled = YES;
    }
    return _gdBgView;
}
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = self.font;
        _textView.delegate = self;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.scrollsToTop = NO;
        _textView.textContainerInset = UIEdgeInsetsZero; //关闭textview的默认间距属性
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.returnKeyType = UIReturnKeySend;
        
    }
    return _textView;
}
+ (CGFloat)getOriginInputViewHeight {
    UIFont *font = [UIFont systemFontOfSize:17];
    CGFloat height =  ceil (font.lineHeight) + 4 * 8;
    return height;
}
@end
