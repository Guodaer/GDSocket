//
//  SocketHeartAliveManager.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/9.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "SocketBaseModel.h"

@interface GDHeartAliveModel:SocketBaseModel

@property (nonatomic, copy) NSString *alive_heart;

@end


@interface SocketHeartAliveManager : NSObject


/**
 发送心跳包

 @param client_fd client_fd
 */
+ (void)sendHeartAliveInfoWithclientfd:(int)client_fd;

@end
