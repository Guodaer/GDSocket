//
//  SocketHeartAliveManager.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/9.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "SocketHeartAliveManager.h"


@implementation GDHeartAliveModel

@end

@implementation SocketHeartAliveManager

+ (instancetype)shareInstance{
    
    static SocketHeartAliveManager *manager = nil;
    static dispatch_once_t hello;
    dispatch_once(&hello, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)sendHeartAliveInfoWithclientfd:(int)client_fd {
    GDHeartAliveModel *model = [[GDHeartAliveModel alloc] init];
    
    model.sock_in = Socket_HeartAlive;
    
    NSString *json = [model ObjectToJson];
    
    if ([SocketManager socket_sendWithJson:json SockFD:client_fd]) {
        GDLog(@"heart success");
    }else{
        GDLog(@"heart failed");
    }
}


@end
