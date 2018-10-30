//
//  ChatModel.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/3.
//  Copyright © 2018年 DouNiu. All rights reserved.
//
//聊天发送接收信息
#import <Foundation/Foundation.h>



@interface ChatModel : NSObject

@property (nonatomic, copy) NSString *chat_message;

@property (nonatomic, assign) Chat_Send_Recv_Type chat_type;

@property (nonatomic, copy) NSString *chat_uid;

@property (nonatomic, copy) NSString *chat_time;

@property (nonatomic, assign) CGSize message_Size;//size


@end
