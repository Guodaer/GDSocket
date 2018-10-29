//
//  NSAttributedString+category.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "NSAttributedString+category.h"

@implementation NSAttributedString (category)
- (CGRect)getNormalAttributeRectByOriginalSize:(CGSize)size {
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect;
}
@end
