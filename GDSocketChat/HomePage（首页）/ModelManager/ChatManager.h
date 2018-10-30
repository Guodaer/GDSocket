//
//  ChatManager.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/3.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatModel.h"

@interface ChatManager : NSObject

/**
 获取发送标签的size

 @param message 发送内容
 @return return size
 */
+ (CGSize)get_Send_ChatCellHeightWithMessage:(NSString *)message;


/**
 获取接收标签的size

 @param message 接收到的内容
 @return return size
 */
+ (CGSize)get_Recv_ChatCellHeightWithMessage:(NSString *)message;



#pragma mark- 转换成富文本显示

/**
 转换成富文本显示

 @param message message
 @return attr
 */
+ (NSMutableAttributedString *)getChatAttrWithMessage:(NSString *)message;
@end
