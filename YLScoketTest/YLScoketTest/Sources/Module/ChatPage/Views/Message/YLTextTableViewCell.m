//
//  YLTextTableViewCell.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLTextTableViewCell.h"
#import "ChatMessageModel.h"

@implementation YLTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.messageTextLabel];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    /**
     *  Label 的位置根据头像的位置来确定
     */
    float y = self.avatarImageView.top + 11;
    float x = self.avatarImageView.left + (self.messageModel.ownerTyper == YLMessageOwnerTypeSelf ? - self.messageTextLabel.width - 27 : self.avatarImageView.width + 23);
    [self.messageTextLabel setOrigin:CGPointMake(x, y)];
    
    x -= 18;                                    // 左边距离头像 5
    y = self.avatarImageView.top - 5;       // 上边与头像对齐
    float h = MAX(self.messageTextLabel.height + 30, self.avatarImageView.height + 10);
    [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.messageTextLabel.width + 40, h)];
    
}

-(void)setMessageModel:(ChatMessageModel *)messageModel {
    [super setMessageModel: messageModel];
    _messageTextLabel.size = messageModel.messageSize;
    [_messageTextLabel setAttributedText:messageModel.attrText];
}
- (UILabel *) messageTextLabel
{
    if (_messageTextLabel == nil) {
        _messageTextLabel = [[UILabel alloc] init];
        [_messageTextLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_messageTextLabel setNumberOfLines:0];
    }
    return _messageTextLabel;
}
@end





























