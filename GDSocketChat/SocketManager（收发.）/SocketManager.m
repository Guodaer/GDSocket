//
//  SocketManager.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "SocketManager.h"
#import <arpa/inet.h>

@implementation SocketManager

+ (instancetype)shareInstance {
    static SocketManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


/**
 json ->nsdata   json转发送的data流  带有长度的

 @param jsonString jsonString
 @return return value
 */
+ (NSData *)socket_dataFromJson:(NSString *)jsonString {
    NSData *originData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger bits = [originData length];
    short bit = bits;
    NSData *data2 = [NSData dataWithBytes:&bit length:sizeof(bit)];//低位高位
    Byte *originLengthByte = (Byte*)[data2 bytes];
    
    //修改高低位
    int one = originLengthByte[0];
    originLengthByte[0] = originLengthByte[1];
    originLengthByte[1] = one;
    
    NSData *lengthData  = [[NSData alloc] initWithBytes:originLengthByte length:2];//前两位是长度
    NSMutableData *mutableData = [[NSMutableData alloc] initWithData:lengthData];
    [mutableData appendData:originData];
    
    return mutableData;
}


/**
 发送data 至 socket通道

 @param jsonString 要发送的socket
 @param sock_fd sock_fd
 @return 是否发送成功
 */
+ (BOOL)socket_sendWithJson:(NSString *)jsonString SockFD:(int)sock_fd{
    NSData *data = [self socket_dataFromJson:jsonString];
    Byte *sendByte = (Byte*)[data bytes];
    
    struct timeval timeout = {30,5};
    setsockopt(sock_fd, SOL_SOCKET, SO_SNDTIMEO, (const char*)&timeout, sizeof(timeout));
    
    NSInteger result = send(sock_fd, sendByte, [data length], 0);
    if (result == -1) {
        return NO;
    }
    return YES;
}


/**
 读取通道中的data

 @param client_fd client_fd description
 @return return value description
 */
+ (BOOL)socket_recvDataWithClientFD:(int)client_fd complete:(void(^)(NSString *recvJson))finish{
    NSString *needReturnIn = nil;
    char buf[1024];
    int allLength = 0;
    int bits = 0;
#if __LP64__ || NS_BUILD_32_LIKE_64
    long br=0;
#else
    int br=0;
#endif
    //判断是否是第一次 1.第一次判断前两位长度
    BOOL isFirst = YES;
    NSMutableData *mutableData = [[NSMutableData alloc] init];
    
    //超时
    struct timeval timeout = {30,5};
    setsockopt(client_fd, SOL_SOCKET, SO_RCVTIMEO, (const char*)&timeout, sizeof(timeout));

    while ((br = recv(client_fd, buf, 1024, 0))!=-1) {//接受的长度
        
        if (!br) return NO;//客户端断开连接 recv不阻塞直接返回
        
        //取到所有json
        allLength +=br;
        //        XC_DebugLog(@"all=%d   br=%ld",allLength,br);
        NSData *headData = [[NSData alloc] initWithBytes:buf length:br];
        [mutableData appendData:headData];
        if (isFirst) {
            bits = [self bytes_to_IntWithData:headData Length:0];//应该接受的长度
            isFirst = NO;
        }
        //1.   如果已经接收的总长度allLehgth小于应该接收的长度Bits 继续接收
        //2.   否则break  跳出该循环
        //        NSLog(@"allLength = %d      br = %d 收到左右的JSON Break",allLength,br);
        
        //        NSString *newjsonString = [self convertToNSStringFromJavaUTF8:mutableData WithLength:bits];
        //        XC_DebugLog(@"🐒=%@",mutableData);
        if ((allLength -2) == bits) {
            NSString *jsonString = [self convertToNSStringFromJavaUTF8:mutableData WithLength:bits];
            needReturnIn = jsonString;
            break;
        }
        
        //memset(buf, 0, sizeof(buf));//总的作用：将已开辟内存空间 s 的首 n 个字节的值设为值 c。 函数常用于内存空间初始化
        if (br == 0) {
            close(client_fd);
            break;
        }
    }
//    return needReturnIn;
    if (finish) {
        finish(needReturnIn);
    }
    return YES;
    
}
//解析前两位得到要接收的长度
+ (int)bytes_to_IntWithData:(NSData*)data Length:(int)len{
    int  value=0;
    Byte *byte = (Byte*)[data bytes];
    if ([data length]>2) {//解析前两位
        value = (int)(byte[1+len] & 0xFF)|(byte[0+len]<<8 & 0xFF00);
    }
    return value;
}
//解析出除前两位剩下的data 转成json
+ (NSString*) convertToNSStringFromJavaUTF8 : (NSData*) data WithLength:(int)len{
    int length = (int)[data length];
    const uint8_t *bytes = (const uint8_t *)[data bytes];
    if(length < 2) {
        return nil;
    }
    bytes += 2;
    return [[NSString alloc] initWithBytes:bytes length:len encoding:NSUTF8StringEncoding];
    
#if 0 //+2就代表从第三位开始
    NSString *str1 = @"123456";
    NSData *data1 = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    int length = (int)[data1 length];
    const uint8_t *bytes = (const uint8_t*)[data1 bytes];
    NSString *json = [[NSString alloc] initWithBytes:bytes+2 length:length-2 encoding:NSUTF8StringEncoding];
    XCLog(@"%@",json);
#endif
}


@end
