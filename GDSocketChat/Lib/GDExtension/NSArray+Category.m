//
//  NSArray+Category.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)

- (BOOL)checkIsNotEmptyArray {
    if ([self isEqual:[NSNull class]]) {
        return NO;
    }else if ([self isKindOfClass:[NSNull class]]) {
        return NO;
    }else if (self == nil || self.count <= 0){
        return NO;
    }else{
        return YES;
    }
}

@end
