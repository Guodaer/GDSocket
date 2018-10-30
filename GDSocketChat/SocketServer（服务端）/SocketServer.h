//
//  SocketServer.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BioSockServerDelegate.h"
@interface SocketServer : NSObject


@property (nonatomic, assign) id<BioSockServerDelegate>s_delegate;


+ (instancetype)shareInstance;
//shut
- (void)shutdownSocketService;
//创建服务端
- (void)startServerService;

@end
