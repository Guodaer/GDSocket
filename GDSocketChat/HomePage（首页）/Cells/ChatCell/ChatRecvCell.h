//
//  ChatRecvCell.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/3.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatManager.h"
static NSString *chatRecvCell_ID = @"chatRecvCell_ID";

@interface ChatRecvCell : UITableViewCell

@property (nonatomic, strong) ChatModel *model;


@end
