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

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,BioSockServerDelegate,BioSockClientDelegate>

@property (nonatomic, strong) UITableView *gdtableView;

@property (nonatomic, strong) NSMutableArray<HomePageListModel *> *listArray;


@end

@implementation HomePageViewController

#pragma mark - 旋转
//-(BOOL)shouldAutorotate
//{
//    return NO;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupMainView];
    
    
    
#if 0
    [SocketServer shareInstance].s_delegate = self;
    [[SocketServer shareInstance] startServerService];
#else
    [SocketClient shareInstance].c_delegate = self;
    [[SocketClient shareInstance] startClientService];
#endif
    

    
}
#pragma mark - 客户端
- (void)client_ConnectFailed:(int)client_fd {
    GDLog(@"client:-连接失败");
}
- (void)client_didlostConnect:(int)client_fd {
    GDLog(@"client:-server 连接断开");
}
- (void)client_connectSuccess:(int)client_fd ipAddress:(NSString *)ip port:(int)port {
    GDLog(@"client:—连接成功ip=%@,port=%d",ip,port);
}
- (void)client_fd:(int)client_fd didReadData:(NSString *)recvJson {
    GDLog(@"clientRecv:%@",recvJson);
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:[recvJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    SocketBaseModel *model = [SocketBaseModel mj_objectWithKeyValues:dataDic];
    if ([model.sock_in isEqualToString:Socket_Send_Recv_Message]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_RecvMessage object:nil userInfo:@{@"recv":dataDic}];
    }
    
}


#pragma mark - 服务端
- (void)serverAcceptFailed:(int)sock_fd {
    GDLog(@"server:accept失败，重启socket");
}
- (void)server:(int)sock_fd didAcceptNewSocket:(int)client_fd {
    GDLog(@"server:%d-%d",sock_fd,client_fd);
}
- (void)server:(int)sock_fd didLostClient:(int)client_fd {
    GDLog(@"server:与clientfd=%d断开连接",client_fd);
}
- (void)server:(int)sock_fd didReadData:(NSString *)recvJson withclientFD:(long)client_fd{
    GDLog(@"serverRecv:%@",recvJson);
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
