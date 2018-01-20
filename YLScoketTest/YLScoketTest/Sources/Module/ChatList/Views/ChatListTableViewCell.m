//
//  ChatListTableViewCell.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/19.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "ChatListTableViewCell.h"
#import "ChatListUserModel.h"


@interface ChatListTableViewCell()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *messageCountLable;
@property (nonatomic, strong) UIImageView *noHintImageView;



@end

@implementation ChatListTableViewCell



- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.avatarImageView];
        [self addSubview:self.usernameLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.messageLabel];
        [self addSubview:self.messageCountLable];
        [self addSubview:self.noHintImageView];
    }
    
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
//EmotionsEmojiHL
- (void)layoutSubviews
{
    
    CGFloat leftFreeSpace = self.height * 0.14;
    [super layoutSubviews];
    
    float imageWidth = self.height * 0.72;
    float space = leftFreeSpace;
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(space);
        make.top.equalTo(self.mas_top).offset(space);
        make.width.equalTo(@(imageWidth));
        make.height.equalTo(@(imageWidth));
    }];
    
    float labelX = space * 2 + imageWidth;
    float labelY = self.height * 0.135;
    float labelHeight = self.height * 0.4;
    float labelWidth = self.width - labelX - space * 1.5;
    
    float dateWidth = 70;
    float dateHeight = labelHeight * 0.75;
    float dateX = self.width - space * 1.5 - dateWidth;
    [_dateLabel setFrame:CGRectMake(dateX, labelY * 0.7, dateWidth, dateHeight)];
    
    
    
    float usernameLabelWidth = self.width - labelX - dateWidth - space * 2;
    [_usernameLabel setFrame:CGRectMake(labelX, labelY, usernameLabelWidth, labelHeight)];
    
    labelY = self.height * 0.91 - labelHeight;
    [_messageLabel setFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
    
    [_noHintImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_dateLabel.mas_right);
        make.top.equalTo(_messageLabel.mas_top);
        make.bottom.equalTo(_messageLabel.mas_bottom);
        make.width.equalTo(_messageLabel.mas_height);
    }];
    
}


- (void)setUserModel:(ChatListUserModel *)userModel
{
    _userModel = userModel;
    [_avatarImageView setImage:[UIImage imageNamed:[NSString stringWithFormat: @"%@", _userModel.avatarURL]]];
    [_usernameLabel setText:_userModel.from];
    [_dateLabel setText:@"11:01"];
    [_messageLabel setText:_userModel.message];
    
    if (_userModel.messageCount > 0) {
        [self.messageCountLable setHidden: false];
        CGFloat radiusHeight;
        if (userModel.needHint) {
            NSString *messageCountString;
            CGFloat width;
            if (userModel.messageCount > 99) {
                messageCountString = @"99+";
                CGSize rect = [messageCountString sizeWithFont: [UIFont systemFontOfSize:12] maxSize: CGSizeMake(50, 50) lineMargin:0];
                width = rect.width + 8;
                radiusHeight = rect.height ;
            }else {
                messageCountString = [NSString stringWithFormat: @"%@",@(userModel.messageCount)];
                CGSize rect = [messageCountString sizeWithFont: [UIFont systemFontOfSize:12] maxSize: CGSizeMake(50, 50) lineMargin:0];
                width = rect.width + 8;
                radiusHeight = rect.width + 8;
            }
            
            [_messageCountLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_avatarImageView.mas_top).offset(-3);
                make.right.equalTo(_avatarImageView.mas_right).offset(5);
                make.width.equalTo(@(width));
                make.height.equalTo(@(radiusHeight));
            }];
            self.messageCountLable.text = messageCountString;
        }else{
            [_messageCountLable mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarImageView.mas_top).offset(-3);
                make.right.equalTo(self.avatarImageView.mas_right).offset(3);
                make.width.height.equalTo(@(8));
            }];
            [_noHintImageView setHidden: false];
            radiusHeight = 8;
        }
        
        self.messageCountLable.layer.cornerRadius = radiusHeight/2;
    }
}

#pragma mark - Getter and Setter
- (UIImageView *) avatarImageView
{
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView.layer setMasksToBounds:YES];
        [_avatarImageView.layer setCornerRadius:5.0f];
    }
    return _avatarImageView;
}

- (UIImageView *) noHintImageView {
    if (_noHintImageView == nil) {
        _noHintImageView = [[UIImageView alloc] init];
        [_noHintImageView.layer setMasksToBounds:YES];
        _noHintImageView.image = [UIImage imageNamed: @"EmotionsEmojiHL"];
        [_noHintImageView setHidden: true];
    }
    return _noHintImageView;
}

- (UILabel *) usernameLabel
{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [_usernameLabel setFont:[UIFont systemFontOfSize:16]];
    }
    return _usernameLabel;
}

- (UILabel *) dateLabel
{
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setAlpha:0.8];
        [_dateLabel setFont:[UIFont systemFontOfSize:12]];
        [_dateLabel setTextAlignment:NSTextAlignmentRight];
        [_dateLabel setTextColor:[UIColor grayColor]];
    }
    return _dateLabel;
}

- (UILabel *) messageLabel
{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setTextColor:[UIColor grayColor]];
        
        [_messageLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _messageLabel;
}

- (UILabel *) messageCountLable {
    if (_messageCountLable == nil) {
        _messageCountLable = [[UILabel alloc] init];
        _messageCountLable.clipsToBounds = true;
        _messageCountLable.font = [UIFont systemFontOfSize:12];
        _messageCountLable.textAlignment = NSTextAlignmentCenter;
        _messageCountLable.backgroundColor = [UIColor redColor];
        _messageCountLable.textColor = [UIColor whiteColor];
    }
    return _messageCountLable;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_avatarImageView setImage: NULL];
    [_usernameLabel setText: @""];
    [_dateLabel setText:@""];
    [_messageLabel setText: @""];
    [self.messageCountLable setHidden: true];
    [self.noHintImageView setHidden: true];
    self.messageCountLable.text  = @"";
    [_noHintImageView setHidden: true];
}


@end

