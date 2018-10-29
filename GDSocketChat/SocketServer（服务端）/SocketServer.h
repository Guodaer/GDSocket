//
//  SocketServer.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketServer : NSObject


+ (instancetype)shareInstance;
//shut
- (void)shutdownSocketService;
//创建服务端
- (void)startServerService;

@end
