//
//  GlobalConfig.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "GlobalConfig.h"
NSString * const FirstHomeCacheKey = @"firstHomeCacheKey";//

NSString * const Socket_HeartAlive = @"Socket_HeartAlive";//心跳

NSString * const Socket_InitBindsc = @"Socket_InitBindsc";//初始化绑定  

NSString * const Socket_SendHandshakeSafe = @"Socket_SendHandshakeSafe";//握手

NSString * const Socket_Send_Recv_Message = @"Socket_Send_Recv_Message";//通信in

NSString * const Socket_SureMessage = @"Socket_SureMessage";//收到消息，返回确认信息

NSString * const Notification_RecvMessage = @"Notification_RecvMessage";//通信in

@implementation GlobalConfig

#pragma mark - 获取当前时间戳
+ (NSString *)getNowTimeInterval{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970];// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}


@end
