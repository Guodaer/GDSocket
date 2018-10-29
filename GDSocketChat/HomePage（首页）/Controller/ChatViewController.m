//
//  ChatViewController.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatManager.h"
#import "ChatRecvCell.h"
#import "ChatSendCell.h"
#import "GDInputView.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *gd_tableView;

@property (nonatomic, strong) NSMutableArray<ChatModel *> *chatArray;

@property (nonatomic, strong) GDInputView *inputView;//输入框

@property (nonatomic, assign) CGFloat inputViewHeight;//输入框高度

@property (nonatomic, assign) CGFloat gd_keyboardF;

@property (nonatomic, assign) BOOL isFinished;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputViewHeight = [GDInputView getOriginInputViewHeight];
    [self createInputView];
    [self setupChatView];

    _isFinished = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(chatKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

static int number = 0;
- (void)testSendMessageWith:(NSString*)message{
    
    ChatModel *model = [[ChatModel alloc] init];
    model.chat_message = message;
    if (number % 2 == 0) {
        model.chat_type = Chat_Send_Recv_Type_Recv;
        model.chat_uid = @"189";
    }else{
        model.chat_type = Chat_Send_Recv_Type_Send;
        model.chat_uid = @"210";
    }
    model.message_Size = [ChatManager get_Recv_ChatCellHeightWithMessage:message];
    [self.chatArray addObject:model];
    [self.gd_tableView reloadData];
    [self scrollToFootWithAnimation:YES];
    number += 1;
    
    [[SocketClient shareInstance] sendMessage:message];

}

#pragma mark - 滚动代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_isFinished) {
        _isFinished = NO;
        [self.inputView returnKeyBoard];
    }
    
}
#pragma mark- 键盘
- (void)chatKeyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.gd_keyboardF = keyboardF.origin.y;
    [self updateTableViewHeightWithKeyboardF:keyboardF.origin.y duration:duration];
}
- (void)updateTableViewHeightWithKeyboardF:(CGFloat)keyboardY duration:(CGFloat)duration {
    CGFloat navigationHeight = Height_NavBar;
    [UIView animateWithDuration:duration animations:^{
        if (keyboardY > GScreenHeight) {
            self.gd_tableView.height = GScreenHeight - navigationHeight - self.inputViewHeight;
        }else{
            self.gd_tableView.height = keyboardY - self.inputViewHeight - navigationHeight;
        }
    }completion:^(BOOL finished) {
        self.isFinished = YES;
    }];
    [self scrollToFootWithAnimation:YES];

}
#pragma mark - 输入框高度变 ---> tableview也变
- (void)inputToChangeTableviewHeight {
    CGFloat navigationHeight = Height_NavBar;
    [UIView animateWithDuration:0.1 animations:^{
        self.gd_tableView.frame = CGRectMake(0, navigationHeight, GScreenWidth, self.gd_keyboardF - navigationHeight-self.inputViewHeight);
    }];
    [self scrollToFootWithAnimation:YES];
}
- (void)setupChatView {
    [self.view addSubview:self.gd_tableView];
    CGFloat navigationHeight = Height_NavBar,tabbarHeight = Height_TabbarSafeBottom;
    self.gd_tableView.frame = CGRectMake(0, navigationHeight, GScreenWidth, GScreenHeight-self.inputViewHeight-tabbarHeight-navigationHeight);
    //滚动到最下面
    [self scrollToFootWithAnimation:NO];
}
#pragma mark - input
- (void)createInputView {
    [self.view addSubview:self.inputView];
    
    CGFloat tabbarHeight = Height_TabbarSafeBottom;
    
    self.inputView.frame = CGRectMake(0, GScreenHeight - tabbarHeight - self.inputViewHeight, GScreenWidth, self.inputViewHeight);
    
    [self.inputView beginUpdateUI];
    
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.chatArray[indexPath.row].message_Size.height + 16;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatModel *model = self.chatArray[indexPath.row];
    if (model.chat_type == Chat_Send_Recv_Type_Send) {
        ChatSendCell *sendCell = [tableView dequeueReusableCellWithIdentifier:chatSendCell_ID forIndexPath:indexPath];
        sendCell.model = model;
        return sendCell;
        
    }else if (model.chat_type == Chat_Send_Recv_Type_Recv){
        ChatRecvCell *recvCell = [tableView dequeueReusableCellWithIdentifier:chatRecvCell_ID forIndexPath:indexPath];
        recvCell.model = model;
        return recvCell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollToFootWithAnimation:(BOOL)animation {
    NSInteger r = [self.gd_tableView numberOfRowsInSection:0]; //最后一组有多少行
    if (r< 1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:0];  //取最后一行数据
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.gd_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animation]; //滚动到最后一行
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 控件
- (UITableView *)gd_tableView {
    if (!_gd_tableView) {
        _gd_tableView = [[UITableView alloc] init];
        _gd_tableView.tableFooterView = [[UIView alloc] init];
        _gd_tableView.delegate = self;
        _gd_tableView.dataSource = self;
        _gd_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_gd_tableView registerClass:[ChatRecvCell class] forCellReuseIdentifier:chatRecvCell_ID];
        [_gd_tableView registerClass:[ChatSendCell class] forCellReuseIdentifier:chatSendCell_ID];
        _gd_tableView.tableFooterView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _gd_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _gd_tableView.estimatedRowHeight = 0;
            _gd_tableView.estimatedSectionFooterHeight = 0;
            _gd_tableView.estimatedSectionHeaderHeight = 0;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _gd_tableView;
}
- (NSMutableArray<ChatModel*> *)chatArray {
    if (!_chatArray) {
        _chatArray = [NSMutableArray array];
        NSMutableString *attr = [[NSMutableString alloc] initWithString:@"111我的\n"];
        for (int i=0; i<10; i++) {
            [attr appendString:@"开始架子你好啊第几遍"];
            ChatModel *model = [[ChatModel alloc] init];
            model.chat_message = attr;
            if (i % 2 == 0) {
                model.chat_type = Chat_Send_Recv_Type_Recv;
                model.chat_uid = @"189";
            }else{
                model.chat_type = Chat_Send_Recv_Type_Send;
                model.chat_uid = @"210";
            }
            model.message_Size = [ChatManager get_Recv_ChatCellHeightWithMessage:attr];
            [_chatArray addObject:model];
        }
    }
    return _chatArray;
}
- (GDInputView *)inputView{
    if (!_inputView) {
        _inputView = [[GDInputView alloc] initWithFrame:CGRectZero];
        GDWeakSelf(weakSelf)
        _inputView.sendAction = ^(NSString *text) {
            [weakSelf testSendMessageWith:text];
        };
        _inputView.inputViewHeight = ^(CGFloat inputHeight) {
            if (weakSelf.inputViewHeight != inputHeight) {
                weakSelf.inputViewHeight = inputHeight;
                [weakSelf inputToChangeTableviewHeight];
            }
        };
    }
    return _inputView;
}

-(void)dealloc {
    GDLog(@"ChatVC dealloc");
}
@end
