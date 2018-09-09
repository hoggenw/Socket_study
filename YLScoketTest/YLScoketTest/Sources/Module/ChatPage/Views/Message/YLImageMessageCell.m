//
//  YLImageMessageCell.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLImageMessageCell.h"
#import "ChatMessageModel.h"



@implementation YLImageMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   // Configure the view for the selected state
}

- (void)imageViewTaped:(UITapGestureRecognizer *)sender {
    NSLog(@"图片点击");
    [self routerEventWithName: kRouterEventCellImageTapEventName userInfo: @{ kChoiceCellMessageModelKey : self.messageModel}];
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self insertSubview:self.messageImageView belowSubview:self.messageBackgroundImageView];
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    float y = self.avatarImageView.top - 3;
    if (self.messageModel.ownerTyper == YLMessageOwnerTypeSelf) {
        float x = self.avatarImageView.left - self.messageImageView.width - 5;
        [self.messageImageView setOrigin:CGPointMake(x , y)];
        [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.messageModel.messageSize.width+ 10, self.messageModel.messageSize.height + 10)];
    }
    else if (self.messageModel.ownerTyper == YLMessageOwnerTypeOther) {
        float x = self.avatarImageView.left + self.avatarImageView.width + 5;
        [self.messageImageView setOrigin:CGPointMake(x, y)];
        [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.messageModel.messageSize.width+ 10, self.messageModel.messageSize.height + 10)];
    }
}

#pragma mark - Getter and Setter
-(void)setMessageModel:(ChatMessageModel *)messageModel
{
    [super setMessageModel:messageModel];
    if(messageModel.imagePath != nil) {
        if (messageModel.image !=  nil) {
            [self.messageImageView setImage:messageModel.image];
            
        }else if(messageModel.voiceData.length > 20) {
            [self.messageImageView setImage: [UIImage imageWithData: messageModel.voiceData]];
            
        }else if(messageModel.imagePath.length > 0) {
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString: messageModel.imagePath]];
            [self.messageImageView setImage: [UIImage imageWithData: data]];
            
        }else {
            // network Image
        }
        
        [self.messageImageView setSize:CGSizeMake(messageModel.messageSize.width + 10, messageModel.messageSize.height + 10)];
    }
    
    switch (self.messageModel.ownerTyper) {
        case YLMessageOwnerTypeSelf:
            self.messageBackgroundImageView.image = [[UIImage imageNamed:@"message_sender_background_reversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            break;
        case YLMessageOwnerTypeOther:
            [self.messageBackgroundImageView setImage:[[UIImage imageNamed:@"message_receiver_background_reversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
            break;
        default:
            break;
    }
    
}

- (UIImageView *) messageImageView
{
    if (_messageImageView == nil) {
        _messageImageView = [[UIImageView alloc] init];
        [_messageImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_messageImageView setClipsToBounds:YES];
        _messageImageView.userInteractionEnabled = true;
        [_messageImageView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(imageViewTaped:)]];
    }
    return _messageImageView;
}

@end
