//
//  BioSockClientDelegate.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/12.
//  Copyright © 2018年 DouNiu. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol BioSockClientDelegate <NSObject>

@optional


/**
 连接服务器失败

 @param client_fd client_fd
 */
- (void)client_ConnectFailed:(int)client_fd;


/**
 连接服务器成功

 @param client_fd client_fd
 */
- (void)client_connectSuccess:(int)client_fd ipAddress:(NSString *)ip port:(int)port;


/**
 读取sock管道中的数据，转成json

 @param client_fd client_fd
 @param recvJson recvJson
 */
- (void)client_fd:(int)client_fd didReadData:(NSString *)recvJson;


/**
 与服务器断开连接

 @param client_fd client_fd
 */
- (void)client_didlostConnect:(int)client_fd;
@end
