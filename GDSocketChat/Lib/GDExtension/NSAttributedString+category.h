//
//  NSAttributedString+category.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (category)

//获取attr的rect
- (CGRect)getNormalAttributeRectByOriginalSize:(CGSize)size;

@end
