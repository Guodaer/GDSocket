//
//  HomePageTableViewCell.h
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageListModel.h"
static NSString *homePageTableViewCell_ID = @"homePageTableViewCell_ID";

@interface HomePageTableViewCell : UITableViewCell

@property (nonatomic, strong) HomePageListModel *model;

+ (CGFloat)getCellSize;


@end
