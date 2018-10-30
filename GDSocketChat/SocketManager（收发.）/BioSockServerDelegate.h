//
//  BioSockServerDelegate.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/12.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
//Class SocketServer;
//#import "SocketServer.h"
@protocol BioSockServerDelegate <NSObject>

@optional



/**
 accept失败，重新开socket

 @param sock_fd sock_fd
 */
- (void)serverAcceptFailed:(int)sock_fd;

/**
 服务器端监听到有client连接进来

 @param sock_fd sock_fd
 @param client_fd 连接进来的client_fd
 */
- (void)server:(int)sock_fd didAcceptNewSocket:(int)client_fd;


/**
 服务器收到的socket消息，目前全是json，以后传图片文件的时候再接data

 @param sock_fd 服务端sockfd
 @param recvJson recvJson
 @param client_fd 客户端client_fd
 */
- (void)server:(int)sock_fd didReadData:(NSString *)recvJson withclientFD:(long)client_fd;


/**
 与客户端断开连接

 @param sock_fd sock_fd
 @param client_fd client_fd
 */
- (void)server:(int)sock_fd didLostClient:(int)client_fd;
@end
