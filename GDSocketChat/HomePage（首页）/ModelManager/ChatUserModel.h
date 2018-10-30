//
//  ChatUserModel.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/3.
//  Copyright © 2018年 DouNiu. All rights reserved.
//
//用户信息
#import <Foundation/Foundation.h>

@interface ChatUserModel : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *ud_nickName;

@property (nonatomic, copy) NSString *ufield_path;//头像名字

@end
