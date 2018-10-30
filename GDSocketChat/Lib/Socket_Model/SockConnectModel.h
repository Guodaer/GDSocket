//
//  SockConnectModel.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/23.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SockConnectModel : NSObject

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, assign) int client_fd;


@end
