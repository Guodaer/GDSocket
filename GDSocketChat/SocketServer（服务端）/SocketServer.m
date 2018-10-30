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
#import "SocketBindModel.h"
#define CONNECTNUMBER 10 //最多绑定数目

//#import <sys/time.h>
//#import <netdb.h>
//#include <sys/ioctl.h>


//typedef struct {
//    char *uid;
//    int client_fd;
//} ClientFD;

@interface SocketServer ()
{
    int sock_fd;//服务端的sock_fd  即标识
    struct sockaddr_in my_addr;//本地服务器地址
    struct sockaddr_in remote_addr;//链接的客户端的addr，可以传null
    
}
@property (nonatomic, strong) NSMutableArray<Sock_ClientHasBindModel *> *clientFDArray;//存储客户端标识

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
        [BullTipsView showMessage:[NSString stringWithFormat:@"已绑定端口号%d",port_num]];
    }
    
    if (listen(sock_fd, CONNECTNUMBER)==-1) {
        GDLog(@"listen error");
    }else{
        GDLog(@"listen success");
    }
    
    
    while (true) {
        socklen_t sin_size = sizeof(struct sockaddr_in);
        
        int client_fd;
        
        if ((client_fd = accept(sock_fd, (struct sockaddr *)&remote_addr, &sin_size)) == -1) {
            GDLog(@"accept 失败");
            [BullTipsView showMessage:@"accept 失败"];
            if ([self.s_delegate respondsToSelector:@selector(serverAcceptFailed:)]) {
                [self.s_delegate serverAcceptFailed:sock_fd];
            }
            break;
        }else{
            GDLog(@"accept 成功");
            if ([self.s_delegate respondsToSelector:@selector(server:didAcceptNewSocket:)]) {
                [self.s_delegate server:sock_fd didAcceptNewSocket:client_fd];
            }
            [BullTipsView showMessage:[NSString stringWithFormat:@"有客户端连接进来fd=%d,client=%d",sock_fd,client_fd]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self connectedScuuessWithClientFD:client_fd];
            });
        }
    }
}

- (void)insertClientFDArrayWith_clientfd:(int)client_fd{
    
}

//链接成功监听通道的内容
- (void)connectedScuuessWithClientFD:(int)client_fd {
    while (true) {
        GDWeakSelf(weakSelf)
        BOOL isConnect = [SocketManager socket_recvDataWithClientFD:client_fd complete:^(NSString *recvJson) {
            if ([recvJson checkIsNotNullString]){
                if ([self.s_delegate respondsToSelector:@selector(server:didReadData:withclientFD:)]) {
                    [self.s_delegate server:self->sock_fd didReadData:recvJson withclientFD:client_fd];
                }
                [weakSelf analysisRecvJson:recvJson AndClientFD:client_fd];
                
            }
        }];
        if (!isConnect) {
            if ([self.s_delegate respondsToSelector:@selector(server:didLostClient:)]) {
                [self.s_delegate server:sock_fd didLostClient:client_fd];
            }
            
            [self removeBindModelWithClient_FD:client_fd];
            
            [BullTipsView showMessage:[NSString stringWithFormat:@"clientfd：%d已断开连接",client_fd]];
            close(client_fd);
            break;
        }
        
    }
}
- (void)analysisRecvJson:(NSString *)json AndClientFD:(int)client_fd{
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    GDLog(@"server recv %d- %@",client_fd,dataDic);
    [BullTipsView showMessage:dataDic[@"chat_message"]];
    
    SocketBaseModel *model = [SocketBaseModel mj_objectWithKeyValues:dataDic];
    if ([model.sock_in isEqualToString:Socket_InitBindsc]) {//初始化链接
        
        
        
        SocketBindModel *recvbindModel = [SocketBindModel mj_objectWithKeyValues:dataDic];
        
        Sock_ClientHasBindModel *hasBindModel = [[Sock_ClientHasBindModel alloc] init];
        hasBindModel.bind_uid = recvbindModel.bind_uid;
        hasBindModel.bind_client_fd = client_fd;
        
        //服务端做记录，把uid和clientfd绑定，转发的时候直接去查
        if (![self checkArrayIsHaveUid:recvbindModel.bind_uid]) {
            [_clientFDArray addObject:hasBindModel];
        }else{
            [self removeBindModelWithUid:recvbindModel.bind_uid];
            [_clientFDArray addObject:hasBindModel];
        }
        
        //回馈客户端，你已经连接
        NSString *jsonString = [recvbindModel ObjectToJson];
        [SocketManager socket_sendWithJson:jsonString SockFD:client_fd];
        
        
    }else if ([model.sock_in isEqualToString:Socket_HeartAlive]){//心跳包
        
        GDHeartAliveModel *aliveModel = [GDHeartAliveModel mj_objectWithKeyValues:dataDic];
        NSString *jsonString = [aliveModel ObjectToJson];
        [SocketManager socket_sendWithJson:jsonString SockFD:client_fd];
        
        
    }else if ([model.sock_in isEqualToString:Socket_SendHandshakeSafe]){//握手
        if ([SocketManager socket_sendWithJson:json SockFD:client_fd]) {
            //握手成功，接收消息
            //回到connectedScuuessWithClientFD:
            
        }
        
    }else if ([model.sock_in isEqualToString:Socket_Send_Recv_Message]) {
        
        SocketRecvModel *recvModel = [SocketRecvModel mj_objectWithKeyValues:dataDic];
        
        if ([self checkArrayIsHaveUid:recvModel.chat_Touid]) {//对方在线
            int willSendClientfd = [self obtainClient_FDWithTouid:recvModel.chat_Touid];
            SocketRecvModel *sendModel = [[SocketRecvModel alloc] init];
            sendModel.sock_in = Socket_Send_Recv_Message;
            sendModel.chat_uid = recvModel.chat_uid;
            sendModel.chat_Touid = recvModel.chat_Touid;
            sendModel.chat_message = recvModel.chat_message;
            NSString *jsonString = [sendModel ObjectToJson];
            [SocketManager socket_sendWithJson:jsonString SockFD:willSendClientfd];
            
        }else{//没在线，以后要存数据库存起来，每次有新设备连进的时候判断是否有没转发的消息
            
            //            SocketRecvModel *chatModel = [[SocketRecvModel alloc] init];
            //            chatModel.sock_in = Socket_Send_Recv_Message;
            //            chatModel.chat_uid = @"server";
            //            chatModel.chat_Touid = @"client";
            //            chatModel.chat_message = @"我是server";
            //            NSString *jsonString = [chatModel ObjectToJson];
            //            [SocketManager socket_sendWithJson:jsonString SockFD:client_fd];
            
        }
        
        
        
        
    }
}

/**
 转发的时候找出发送的clientfd
 
 @param touid touid description
 @return return value description
 */
- (int)obtainClient_FDWithTouid:(NSString*)touid {
    for (Sock_ClientHasBindModel *model in _clientFDArray) {
        if ([model.bind_uid isEqualToString:touid]) {
            return model.bind_client_fd;
        }
    }
    return 0;
}
/**
 检测客户端是否在线
 
 @param uid uid
 @return return bool
 */
- (BOOL)checkArrayIsHaveUid:(NSString *)uid {
    for (Sock_ClientHasBindModel *model in _clientFDArray) {
        if ([model.bind_uid isEqualToString:uid]) {
            return YES;
        }
    }
    return NO;
}

/**
 客户端断开连接，删除相关的在线信息
 
 @param client_fd client_fd
 */
- (void)removeBindModelWithClient_FD:(int)client_fd{
    for (Sock_ClientHasBindModel *model in _clientFDArray) {
        if (model.bind_client_fd == client_fd) {
            [_clientFDArray removeObject:model];
            break;
        }
    }
}
- (void)removeBindModelWithUid:(NSString*)uid {
    for (Sock_ClientHasBindModel *model in _clientFDArray) {
        if ([model.bind_uid isEqualToString:uid]) {
            [_clientFDArray removeObject:model];
            break;
        }
    }
}
@end
