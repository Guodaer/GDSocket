//
//  ChatRecvCell.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/3.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "ChatRecvCell.h"

@interface ChatRecvCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UIImageView *chatImgView;

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation ChatRecvCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.chatImgView];
        [self.chatImgView addSubview:self.messageLabel];
    }
    return self;
}
- (void)setModel:(ChatModel *)model {
    _model = model;
    
    self.messageLabel.attributedText = [ChatManager getChatAttrWithMessage:model.chat_message];
    
//    CGSize size = [ChatManager get_Recv_ChatCellHeightWithMessage:model.chat_message];
    CGSize size = model.message_Size;
    [self.chatImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(55);
        make.top.equalTo(self.contentView).offset(8);
        make.size.mas_equalTo(CGSizeMake(size.width, size.height));
    }];
    
    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chatImgView).offset(15);
        make.top.equalTo(self.chatImgView).offset(10);
        make.size.mas_equalTo(CGSizeMake(size.width-25, size.height-20));
    }];
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(self.contentView).offset(8);
    }];
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = GDImage(@"user_icon");
    }
    return _iconImgView;
}
- (UIImageView *)chatImgView {
    if (!_chatImgView) {
        _chatImgView = [[UIImageView alloc] init];
        UIImage *img = GDImage(@"chat_recv_normal");
        img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(27, 15, 10, 10)];
        _chatImgView.image = img;
    }
    return _chatImgView;
}
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = @"";
        _messageLabel.font = font(14);
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
