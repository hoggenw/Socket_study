//
//  YLSystemMessageCell.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLSystemMessageCell.h"

@implementation YLSystemMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self.messageTextLabel setFrame:CGRectMake(0, 0, self.width, 20)];
   
    
}
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.messageTextLabel];
    }
    return self;
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
        [_messageTextLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_messageTextLabel setNumberOfLines:1];
        _messageTextLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        _messageTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageTextLabel;
}
@end
