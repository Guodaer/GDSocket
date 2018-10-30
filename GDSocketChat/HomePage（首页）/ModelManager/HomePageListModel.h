//
//  HomePageListModel.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePageListModel : NSObject

@property (nonatomic, copy) NSString *uid;//userid

@property (nonatomic, copy) NSString *icon;//图片，暂时为本地img

@property (nonatomic, copy) NSString *ud_nickName;

@property (nonatomic, copy) NSString *chat_message;//聊天内容

@property (nonatomic, copy) NSString *chat_last_time;//最后的时间

@property (nonatomic, assign) BOOL isRed;


@end
