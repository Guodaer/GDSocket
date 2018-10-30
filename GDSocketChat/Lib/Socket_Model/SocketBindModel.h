//
//  SocketBindModel.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/24.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "SocketBaseModel.h"

@interface SocketBindModel : SocketBaseModel


/**
 把当前的uid 与 接收的client_fd绑定
 */
@property (nonatomic, copy) NSString *bind_uid;

/**
 绑定时间
 */
@property (nonatomic, copy) NSString *bind_time;

/**
 服务器给客户端返回的绑定确认回馈
 */
@property (nonatomic, copy) NSString *bind_response;

/** 备用1*/
@property (nonatomic, copy) NSString *bind_other1;

/** 备用2*/
@property (nonatomic, copy) NSString *bind_other2;


@end


/** 连入服务器的客户端model 都存放在socketserver中的数组中，给谁发送的时候去里面遍历，找到touid->clientFD send */
@interface Sock_ClientHasBindModel:NSObject

@property (nonatomic, copy) NSString *bind_uid;

@property (nonatomic, assign) int bind_client_fd;

@end
