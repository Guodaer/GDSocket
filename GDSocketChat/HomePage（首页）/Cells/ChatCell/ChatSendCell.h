//
//  ChatSendCell.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/3.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatManager.h"
static NSString *chatSendCell_ID = @"chatSendCell_ID";

@interface ChatSendCell : UITableViewCell
@property (nonatomic, strong) ChatModel *model;
@end
