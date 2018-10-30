//
//  NSString+Category.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)


/**
 检查空字符串

 @return NO 是  yes 不是空
 */
- (BOOL)checkIsNotNullString;

/**
 去掉前后回车符
 
 @return 去掉之后的字符串
 */
- (NSString *)replaceStringReturnline;


/**
 删除字符串特殊字符
 
 @param specialString 需要去掉的字符 比如@",.=-% @"等
 @return 去掉之后的字符串
 */
- (NSString *)removeSpecialCharactersWith:(NSString*)specialString;


/**
 获取字符串rect
 
 @param font font for label
 @param size size
 @return rect
 */
- (CGRect)getNormalStringRectByfont:(UIFont*)font AndSize:(CGSize)size;
- (CGFloat)getNormalString_Width_Byfont:(UIFont*)font AndSize:(CGSize)size;
- (CGFloat)getNormalString_Height_Byfont:(UIFont*)font AndSize:(CGSize)size;

@end
