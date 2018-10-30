//
//  NSString+Category.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (NSString *)replaceStringReturnline {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
}

- (BOOL)checkIsNotNullString {
    if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    if (self == nil || self == NULL || [self isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

- (NSString *)removeSpecialCharactersWith:(NSString *)specialString {
    if (![self checkIsNotNullString]) {
        return self;
    }
    NSString *str2 = [self stringByReplacingOccurrencesOfString:specialString withString:@""];
    return str2;
}
- (CGFloat)getNormalString_Height_Byfont:(UIFont *)font AndSize:(CGSize)size {
    return [self getNormalStringRectByfont:font AndSize:size].size.height;
}
- (CGFloat)getNormalString_Width_Byfont:(UIFont *)font AndSize:(CGSize)size{
    return [self getNormalStringRectByfont:font AndSize:size].size.width;
}
- (CGRect)getNormalStringRectByfont:(UIFont*)font AndSize:(CGSize)size {
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect;
}


@end
