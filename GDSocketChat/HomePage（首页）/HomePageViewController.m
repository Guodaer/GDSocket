//
//  HomePageViewController.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "HomePageViewController.h"
#import "ChatViewController.h"
#import "HomePageTableViewCell.h"
//socket
#import "SocketServer.h"

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *gdtableView;

@property (nonatomic, strong) NSMutableArray<HomePageListModel *> *listArray;


@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupMainView];
    
//    [[SocketServer shareInstance] startServerService];
    [[SocketClient shareInstance] startClientService];
}

- (void)setupMainView {
    [self.view addSubview:self.gdtableView];
    CGFloat navigationHeight = Height_NavBar,tabbarHeight = Height_TabBar;
    [self.gdtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(navigationHeight);
        make.bottom.equalTo(self.view).offset(-tabbarHeight);
        make.left.right.equalTo(self.view);
    }];
    
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [HomePageTableViewCell getCellSize];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homePageTableViewCell_ID forIndexPath:indexPath];
        cell.model = self.listArray[indexPath.row];
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController *chatVC = [[ChatViewController alloc] init];
    chatVC.title = self.listArray[indexPath.row].ud_nickName;
    [self.navigationController pushViewController:chatVC animated:YES];
}


- (UITableView *)gdtableView {
    if (!_gdtableView) {
        _gdtableView = [[UITableView alloc] init];
        _gdtableView.delegate = self;
        _gdtableView.dataSource = self;
        [_gdtableView registerClass:[HomePageTableViewCell class] forCellReuseIdentifier:homePageTableViewCell_ID];
        _gdtableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _gdtableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _gdtableView.estimatedRowHeight = 0;
            _gdtableView.estimatedSectionFooterHeight = 0;
            _gdtableView.estimatedSectionHeaderHeight = 0;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _gdtableView;
}
- (NSMutableArray<HomePageListModel *> *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc] init];
        HomePageListModel *model = [HomePageListModel new];
        model.icon = @"server_icon";//user_icon
        model.ud_nickName = @"YH";
        model.chat_message = @"你好，我是YH永辉超市";
        model.uid = @"1";
        model.chat_last_time = @"12:07";
        model.isRed = YES;
        [_listArray addObject:model];
    }
    return _listArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
