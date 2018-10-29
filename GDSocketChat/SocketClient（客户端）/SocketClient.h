//
//  SocketClient.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketClient : NSObject

+ (instancetype)shareInstance;


/**
 启动客户端socket
 */
- (void)startClientService;
/**
 发送message 临时

 @param message message description
 */
- (void)sendMessage:(NSString*)message ;

@end
