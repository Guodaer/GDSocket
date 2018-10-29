//
//  SocketServer.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "SocketServer.h"
#import <sys/socket.h>
#import <arpa/inet.h>
#import "SocketRecvModel.h"
#define CONNECTNUMBER 10 //最多绑定数目

//#import <sys/time.h>
//#import <netdb.h>
//#include <sys/ioctl.h>
@interface SocketServer ()
{
    int sock_fd;//服务端的sock_fd  即标识
    struct sockaddr_in my_addr;//本地服务器地址
    struct sockaddr_in remote_addr;//链接的客户端的addr，可以传null
    
}
@property (nonatomic, strong) NSMutableArray *clientFDArray;//存储客户端标识

@end
static UInt16 port_num = 17878;//服务端端口号
@implementation SocketServer

+ (instancetype)shareInstance {
    static SocketServer *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)shutdownSocketService {
    for (int i=0; i<_clientFDArray.count; i++) {
        int clientfd = [NSString stringWithFormat:@"%@",_clientFDArray[i]].intValue;
        close(clientfd);
    }
    close(sock_fd);
}
//创建服务端
- (void)startServerService {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setUpServerService];
    });
}

- (void)setUpServerService {
    
    _clientFDArray = [NSMutableArray array];
    
    memset(&my_addr, 0, sizeof(my_addr));
    bzero(&my_addr, sizeof(my_addr));
    my_addr.sin_family = AF_INET;
    my_addr.sin_port = htons(port_num);
    my_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    my_addr.sin_len = sizeof(my_addr);
    bzero(&(my_addr.sin_zero), 8);

    if ((sock_fd=socket(AF_INET, SOCK_STREAM, 0))== -1) {
        GDLog(@"socket create error");
    }else{
        GDLog(@"socket create success");
    }
    
    //重用本地地址和端口
    // 这样的好处是，即使socket断了，调用前面的socket函数也不会占用另一个，而是始终就是一个端口
    // 这样防止socket始终连接不上，那么按照原来的做法，会不断地换端口。
    int nREUSEADDR = 1;
    setsockopt(sock_fd, SOL_SOCKET, SO_REUSEADDR, (const char*)&nREUSEADDR, sizeof(int));
    
    int bin = bind(sock_fd, (struct sockaddr *)&my_addr, sizeof(struct sockaddr));
    if (bin == -1) {
        NSLog(@"bind error");
        if (port_num < 17878 + 10) {
            port_num++;
            close(sock_fd);
            [self setUpServerService];
        }
    }else{
        GDLog(@"bind success %d",port_num);
    }
    
    if (listen(sock_fd, CONNECTNUMBER)==-1) {
        GDLog(@"listen error");
    }else{
        GDLog(@"listen success");
    }
    
    while (true) {
//        [BullTipsView showMessage:@"已开启服务，开始等待连接"];
        socklen_t sin_size = sizeof(struct sockaddr_in);
        
        int client_fd;
        
        if ((client_fd = accept(sock_fd, (struct sockaddr *)&remote_addr, &sin_size)) == -1) {
            GDLog(@"accept 失败");
            [BullTipsView showMessage:@"accept 失败"];
            break;
        }else{
            GDLog(@"accept 成功");
            [BullTipsView showMessage:[NSString stringWithFormat:@"有客户端连接进来fd=%d,client=%d",sock_fd,client_fd]];
            if ([_clientFDArray containsObject:[NSNumber numberWithInt:client_fd]]) {
                [_clientFDArray addObject:[NSNumber numberWithInt:client_fd]];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self connectedScuuessWithClientFD:client_fd];
            });
        }
    }
}
//链接成功监听通道的内容
- (void)connectedScuuessWithClientFD:(int)client_fd {
    while (true) {
//        NSString *json = [SocketManager socket_recvDataWithClientFD:client_fd];
#if 0
        NSString *json = [SocketManager socket_recvDataWithClientFD:client_fd complete:^(NSString *recvJson) {
            
        }];
        GDLog(@"222222222");
        if ([json checkIsNotNullString]) {
            [self analysisRecvJson:json AndClientFD:client_fd];
        }else{
            close(client_fd);
            break;
        }
#endif
        GDWeakSelf(weakSelf)
        BOOL isConnect = [SocketManager socket_recvDataWithClientFD:client_fd complete:^(NSString *recvJson) {
            if ([recvJson checkIsNotNullString]) [weakSelf analysisRecvJson:recvJson AndClientFD:client_fd];
        }];
        if (!isConnect) {
            [BullTipsView showMessage:[NSString stringWithFormat:@"clientfd：%d已断开连接",client_fd]];
            close(client_fd);
            break;
        }
        
    }
}
- (void)analysisRecvJson:(NSString *)json AndClientFD:(int)client_fd{
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    GDLog(@"server recv - %@",dataDic);
    SocketBaseModel *model = [SocketBaseModel mj_objectWithKeyValues:dataDic];
    if (model.sock_in == Socket_InitBindsc) {//初始化链接
        
    }else if (model.sock_in == Socket_HeartAlive){//心跳包
        
    }else if (model.sock_in == Socket_SendHandshakeSafe){//握手 每次发消息之前都要握手
        if ([SocketManager socket_sendWithJson:json SockFD:client_fd]) {
            //握手成功，接收消息
            //回到connectedScuuessWithClientFD:
            
        }
        
    }else if (model.sock_in == Socket_Send_Recv_Message) {
        
        SocketRecvModel *chatModel = [[SocketRecvModel alloc] init];
        chatModel.sock_in = Socket_Send_Recv_Message;
        chatModel.chat_uid = @"server";
        chatModel.chat_Touid = @"client";
        chatModel.chat_message = @"我是server";
        NSString *jsonString = [chatModel ObjectToJson];
        [SocketManager socket_sendWithJson:jsonString SockFD:client_fd];

    }
    
    
}


@end
