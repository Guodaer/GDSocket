//
//  SocketManager.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketManager : NSObject

+ (instancetype)shareInstance;



/**
 json ->nsdata   json转发送的data流  带有长度的
 
 @param jsonString jsonString
 @return return value
 */
+ (NSData *)socket_dataFromJson:(NSString *)jsonString;


/**
 读取通道中的data
 
 @param client_fd client_fd description
 @return return value description
 */
//+ (NSString *)socket_recvDataWithClientFD:(int)client_fd;

+ (BOOL)socket_recvDataWithClientFD:(int)client_fd complete:(void(^)(NSString *recvJson))finish;


/**
 发送data 至 socket通道
 
 @param jsonString 要发送的socket
 @param sock_fd sock_fd
 @return 是否发送成功
 */
+ (BOOL)socket_sendWithJson:(NSString *)jsonString SockFD:(int)sock_fd;

@end
