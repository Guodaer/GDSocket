

//
//  ChatManager.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/3.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "ChatManager.h"

@implementation ChatManager //55 40   -  top:27   bottom: 10   left:10   right: 15

+ (CGSize)get_Send_ChatCellHeightWithMessage:(NSString *)message {
    return [self get_ChatBgImgSizeWithLabelContent:message];
}

+ (CGSize)get_Recv_ChatCellHeightWithMessage:(NSString *)message {
    return [self get_Send_ChatCellHeightWithMessage:message];
}
#pragma mark - 获取chat聊天背景的size
+ (CGSize)get_ChatBgImgSizeWithLabelContent:(NSString *)content {
    CGSize labelSize = [self get_chatLabelSize:content];
    return CGSizeMake(labelSize.width + 25, labelSize.height + 20);
}


#pragma mark - 获取富文本label的size
+ (CGSize)get_chatLabelSize:(NSString*)message {
    if (![message checkIsNotNullString]) {
        message = @"";
    }
    NSArray *array = [message componentsSeparatedByString:@"\n"];
    //排序，最长的在第一位，直接计算最长的宽度
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *str1 = obj1;
        NSString *str2 = obj2;
        NSComparisonResult result;
        
        if (str1.length > str2.length)
        {
            result = NSOrderedAscending;
        }
        else if (str1.length < str2.length)
        {
            result = NSOrderedDescending;
        }
        else
        {
            result = NSOrderedSame;
        }
        return result;
    }];
    NSMutableAttributedString *allAttr = [self getChatAttrWithMessage:message];
    NSMutableAttributedString *firstAttr = [self getChatAttrWithMessage:array[0]];
    
    //- 头像80 - 屏幕两边20 - 气泡距头像距离 10 - label(25)
    CGSize size = CGSizeMake(GScreenWidth - 80 - 20 - 10 - 25 - 20 , 20);//这是label的   img:width:+25   height:+20
    CGFloat maxWidth = size.width;//最大的宽度
    
    CGSize labelSize = [self gd_attributeBoundingRectWithAtt:firstAttr AndSize:CGSizeMake(1000, ceil(size.height))];
    if (labelSize.width > maxWidth) {
        CGSize newSize = [self gd_attributeBoundingRectWithAtt:allAttr AndSize:CGSizeMake(maxWidth, 100000)];
        labelSize = CGSizeMake(maxWidth, ceil(newSize.height));
    }else{
        CGSize newSize = [self gd_attributeBoundingRectWithAtt:allAttr AndSize:CGSizeMake(ceil(labelSize.width), 10000)];
        labelSize = CGSizeMake(ceil(labelSize.width), ceil(newSize.height));
    }
    return labelSize;
}
#pragma mark- 转换成富文本显示
+ (NSMutableAttributedString *)getChatAttrWithMessage:(NSString *)message {
    if (message == nil) {
        return [[NSMutableAttributedString alloc] init];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *eachattr = [[NSMutableAttributedString alloc] initWithString:message];
    [eachattr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [message length])];
    [eachattr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [message length])];
    [eachattr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
    return eachattr;
}
#pragma mark - 获取富文本 size
+ (CGSize)gd_attributeBoundingRectWithAtt:(NSMutableAttributedString *)attribute AndSize:(CGSize)size{
    CGSize attSize = [attribute getNormalAttributeRectByOriginalSize:size].size;
    return attSize;
}



@end
