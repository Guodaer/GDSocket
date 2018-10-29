//
//  HomePageTableViewCell.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "HomePageTableViewCell.h"

@interface HomePageTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *redNotifiLabel;//小红点

@end

@implementation HomePageTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.redNotifiLabel];
    }
    return self;
}

- (void)setModel:(HomePageListModel *)model {
    _model = model;
    self.iconImgView.image = GDImage(model.icon);
    self.nameLabel.text = model.ud_nickName;
    self.messageLabel.text = model.chat_message;
    self.timeLabel.text = model.chat_last_time;
    self.redNotifiLabel.hidden = !model.isRed;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    CGFloat timeWidth = [self.timeLabel.text getNormalString_Width_Byfont:self.timeLabel.font AndSize:CGSizeMake(1000, 11)];
    
    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(timeWidth, 11));
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgView.mas_right).offset(10);
        make.right.equalTo(self.timeLabel.mas_left).offset(10);
        make.height.mas_equalTo(18);
        make.top.equalTo(self.iconImgView).offset(10);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel);
        make.height.mas_equalTo(16);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
    [self.redNotifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImgView).offset(-3);
        make.right.equalTo(self.iconImgView).offset(3);
        make.size.mas_equalTo(CGSizeMake(6, 6));
    }];
}

- (UIImageView *)iconImgView  {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_iconImgView clipsLayerCornerRadius:2];
    }
    return _iconImgView;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = font(18);
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.font = font(14);
        _messageLabel.textColor = color_666;
    }
    return _messageLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = font(11);
        _timeLabel.textColor = color_999;
        _timeLabel.text = @"00:00";
    }
    return _timeLabel;
}
- (UILabel *)redNotifiLabel {
    if (!_redNotifiLabel) {
        _redNotifiLabel = [[UILabel alloc] init];
        _redNotifiLabel.backgroundColor = [UIColor redColor];
        [_redNotifiLabel clipsLayerCornerRadius:3];
        _redNotifiLabel.hidden = YES;
    }
    return _redNotifiLabel;
}

+ (CGFloat)getCellSize {
    return 80;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.redNotifiLabel.backgroundColor = [UIColor redColor];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.redNotifiLabel.backgroundColor = [UIColor redColor];

}

@end
