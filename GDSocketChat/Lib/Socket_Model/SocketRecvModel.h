//
//  SocketRecvModel.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/10.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "SocketBaseModel.h"

@interface SocketRecvModel : SocketBaseModel

//聊天
@property (nonatomic, copy) NSString *chat_uid;

@property (nonatomic, copy) NSString *chat_Touid;

@property (nonatomic, copy) NSString *chat_time;

@property (nonatomic, assign) Chat_Send_Recv_Type chat_type;

@property (nonatomic, copy) NSString *chat_message;

@end
