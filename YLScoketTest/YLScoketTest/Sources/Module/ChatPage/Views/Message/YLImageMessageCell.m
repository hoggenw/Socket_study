//
//  YLImageMessageCell.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLImageMessageCell.h"
#import "ChatMessageModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


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
    
    float h = MAX(self.messageImageView.height + 30, self.avatarImageView.height + 10);
    if (self.messageModel.ownerTyper == YLMessageOwnerTypeSelf) {
        float x = self.avatarImageView.left - self.messageImageView.width - 5;
        [self.messageSendStatusImageView setFrame:CGRectMake(x - 35, y + h/2 - 15, 30, 30)];
    }
      
}

#pragma mark - Getter and Setter
-(void)setMessageModel:(ChatMessageModel *)messageModel
{
    [super setMessageModel:messageModel];
    PHAuthorizationStatus status =  [PHPhotoLibrary authorizationStatus];
       if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
//           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请您先去设置允许APP访问您的相册 设置>隐私>相册" preferredStyle:(UIAlertControllerStyleAlert)];
//           UIAlertAction *action = [UIAlertAction actionWithTitle:@"我知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//
//           }];
//           [alertController addAction:action];
//           [self presentViewController:alertController animated:YES completion:nil];
           NSLog(@"有相册权限");
       }
    if(messageModel.sourcePath != nil) {
        if (messageModel.image !=  nil) {
            [self.messageImageView setImage:messageModel.image];
            
        }else if(messageModel.voiceData.length > 20) {
            [self.messageImageView setImage: [UIImage imageWithData: messageModel.voiceData]];
            
        }else if(messageModel.sourcePath.length > 0) {
             // network Image
           // NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString: messageModel.sourcePath]];
//            [self.messageImageView sd_setImageWithURL:<#(nullable NSURL *)#>]
            [self.messageImageView sd_setImageWithURL:[NSURL URLWithString: messageModel.sourcePath]];
            
        }else {
            NSLog(@"无效文件");
        }
        
        [self.messageImageView setSize:CGSizeMake(messageModel.messageSize.width + 10, messageModel.messageSize.height + 10)];
        [self bringSubviewToFront:self.messageImageView];
    }
    
    switch (self.messageModel.ownerTyper) {
        case YLMessageOwnerTypeSelf:
            self.messageBackgroundImageView.image = [[UIImage imageNamed:@"message_sender_background_reversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            self.messageBackgroundImageView.userInteractionEnabled = true;
            break;
        case YLMessageOwnerTypeOther:
            [self.messageBackgroundImageView setImage:[[UIImage imageNamed:@"message_receiver_background_reversed"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
            self.messageBackgroundImageView.userInteractionEnabled = true;
         
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
