//
//  SocketClient.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "SocketClient.h"
#import <arpa/inet.h>
#import <netdb.h>
#include <sys/ioctl.h>
#import <sys/time.h>
#import "SocketRecvModel.h"
@interface SocketClient ()
{
    int sock_fd;
    struct hostent *host;
    struct sockaddr_in server_addr;
    int loopcount;
}

@end

static int PortNum_server;     //端口号
const char *IP_server;        //车端IP地址

@implementation SocketClient

+ (instancetype)shareInstance {
    static SocketClient *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)getIP_Port {
    PortNum_server = 17878;
    NSString *ipString = @"192.168.11.121";
    IP_server = ipString.UTF8String;
}

- (void)startClientService {
    [self getIP_Port];
    loopcount = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self openClientService];
    });
}

- (void)openClientService {
    
    if (PortNum_server == 0) {
        return;
    }
    if ((host = gethostbyname(IP_server)) == NULL) {
        NSLog(@"host Error");
    }
    
    if ((sock_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        NSLog(@"create Socket Error");
    }
    GDLog(@"%d",sock_fd);
    //设置调用closesocket()后,仍可继续重用该socket。调用closesocket()一般不会立即关闭socket，而经历TIME_WAIT的过程
    BOOL nREUSEADDR = true;
    setsockopt(sock_fd, SOL_SOCKET, SO_REUSEADDR, (const char*)&nREUSEADDR, sizeof(int));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(PortNum_server);
    server_addr.sin_addr = *((struct in_addr*)host->h_addr);
    bzero(&(server_addr.sin_zero), 8);
    
    //异常
    sigset_t set;
    sigemptyset(&set);
    sigaddset(&set, SIGPIPE);
    sigprocmask(SIG_BLOCK, &set, NULL);
    
    if (connect(sock_fd, (struct sockaddr *)&server_addr, sizeof(struct sockaddr)) == -1) {
        if (PortNum_server <= 17878 + 10) {
            PortNum_server += 1;
            close(sock_fd);
            [self openClientService];
        }else{
            perror("connect error");close(sock_fd);
            return;
        }
    }else{
        [self connectedScuuessWithClientFD:sock_fd];

    }
    
#if 0
    //设置为非阻塞，能改connect超时时间
    struct timeval timeout;
    unsigned long ul = 1;
    fd_set  writeset;
    int ret;
    ioctl(sock_fd, FIONBIO, &ul);
    
    if (connect(sock_fd, (struct sockaddr *)&server_addr, sizeof(struct sockaddr)) == -1) {
        timeout.tv_sec  = 10;
        timeout.tv_usec = 0;
        FD_ZERO(&writeset); //清除fd_set的所有位
        FD_SET(sock_fd, &writeset);//设置fd_set的位fd
        ret = select(sock_fd+1, NULL, &writeset, NULL, &timeout);
        if (ret == 0) {
            GDLog(@"1绑定失败");
        }else if (ret == -1){
            loopcount += 1;
            if (loopcount > 10) {
                GDLog(@"2绑定失败");
                close(sock_fd);
                return;
            }
            if (PortNum_server <= 17878 + 10) {
                PortNum_server += 1;
                close(sock_fd);
                [self openClientService];
            }else{
                perror("connect error");close(sock_fd);
                return;
            }
            
        }else{
            int error;
            socklen_t len = sizeof(unsigned int);
            getsockopt(sock_fd, SOL_SOCKET, SO_ERROR, &error, &len);
            if(error == 0)
            {
                //true
            }
            else
            {
                perror("connect error");close(sock_fd);
                [[NSThread currentThread] cancel];
                return;
            }
            ul = 0;
            ioctl(sock_fd, FIONBIO, &ul); //重新将socket设置成阻塞模式
            [self connectedScuuessWithClientFD:sock_fd];

        }
    
    
    }else{
        ul = 0;
        ioctl(sock_fd, FIONBIO, &ul); //重新将socket设置成阻塞模式
        [self connectedScuuessWithClientFD:sock_fd];
    }
#endif
}
//链接成功监听通道的内容
- (void)connectedScuuessWithClientFD:(int)client_fd {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (true) {
#if 0
            NSString *json = [SocketManager socket_recvDataWithClientFD:client_fd complete:^(NSString *recvJson) {
                
            }];
            GDLog(@"1111111111111111");
            [self analysisRecvJson:json AndClientFD:client_fd];
#endif
            GDWeakSelf(weakSelf)
            BOOL isConnect = [SocketManager socket_recvDataWithClientFD:client_fd complete:^(NSString *recvJson) {
                if ([recvJson checkIsNotNullString]) [weakSelf analysisRecvJson:recvJson AndClientFD:client_fd];
            }];
            if (!isConnect) {
                close(client_fd);
                break;
            }
            
        }
    });
    
}
- (void)analysisRecvJson:(NSString *)json AndClientFD:(int)client_fd{
    GDLog(@"client - %@",json);
    
}
- (void)sendMessage:(NSString*)message {
    
    SocketRecvModel *chatModel = [[SocketRecvModel alloc] init];
    chatModel.sock_in = Socket_Send_Recv_Message;
    chatModel.chat_uid = @"server";
    chatModel.chat_Touid = @"client";
    chatModel.chat_message = message;
    NSString *jsonString = [chatModel ObjectToJson];
    [SocketManager socket_sendWithJson:jsonString SockFD:sock_fd];
}
@end
