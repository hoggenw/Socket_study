//
//  YLMessageTableViewCell.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLMessageTableViewCell.h"
#import "ChatMessageModel.h"
#import "YLSocketRocktManager.h"

@implementation YLMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.messageBackgroundImageView];
        [self addSubview:self.avatarImageView];
        [self addSubview:self.messageSendStatusImageView];
        
    }
    
    return  self;
}

- (void)setMessageModel:(ChatMessageModel *)messageModel {
    _messageModel = messageModel;
    __weak typeof(self) weakSelf = self;
    [self.messageBackgroundImageView setLongTapActionWithBlock:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            if ([[LocalSQliteManager sharedInstance] deletLoaclMessageModelByMessageId: messageModel.messageId]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Y_Notification_Refresh_ChatMessage_State object:nil];
            }else{
                [YLHintView showMessageOnThisPage: @"删除失败"];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        UITableView *tableView = (UITableView *) weakSelf.superview;
        UIViewController *vc = (UIViewController *) tableView.dataSource;
        [vc presentViewController:alertController animated:YES completion:nil];
    }];
    
    switch (_messageModel.ownerTyper) {
        case YLMessageOwnerTypeSelf:
            /**
             *  自己发的消息
             */
            [self.avatarImageView setHidden:NO];
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_messageModel.from.avatar] placeholderImage:[UIImage imageNamed:@"self_header"]];
            [self.messageBackgroundImageView setHidden:NO];
            /**
             *  UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
             UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片
             比如下面方法中的拉伸区域：UIEdgeInsetsMake(28, 20, 15, 20)
             */
            
            self.messageBackgroundImageView.image = [[UIImage imageNamed: @"message_sender_background_normal"] resizableImageWithCapInsets: UIEdgeInsetsMake(28, 20, 15, 20) resizingMode: UIImageResizingModeStretch];
            // 设置高亮图片
            self.messageBackgroundImageView.highlightedImage = [[UIImage imageNamed:@"message_sender_background_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            
            
            break;
        case YLMessageOwnerTypeOther:
            /**
             *  自己接收到的消息
             */
            [self.avatarImageView setHidden:NO];
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_messageModel.from.avatar] placeholderImage:[UIImage imageNamed:@"other_header"]];
            [self.messageBackgroundImageView setHidden:NO];
            [self.messageBackgroundImageView setImage:[[UIImage imageNamed:@"message_receiver_background_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch]];
            self.messageBackgroundImageView.highlightedImage = [[UIImage imageNamed:@"message_receiver_background_highlight"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
            break;
            
        case YLMessageOwnerTypeSystem:
            [self.avatarImageView setHidden:YES];
            [self.messageBackgroundImageView setHidden:YES];
            [self.messageSendStatusImageView setHidden: YES];
            break;
            
        default:
            break;
    }
    
    [self.messageSendStatusImageView removeAllSubViews];
    self.messageSendStatusImageView.image = nil;
    UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    self.messageSendStatusImageView.userInteractionEnabled = false;
    switch (messageModel.sendState) {
        case YLMessageSending:
            
            [self.messageSendStatusImageView addSubview: activityIndicator];
            activityIndicator.frame= CGRectMake(0, 0, 30, 30);
            activityIndicator.color = [UIColor whiteColor];
            activityIndicator.backgroundColor = [UIColor clearColor];
            activityIndicator.hidesWhenStopped = NO;
            
            [activityIndicator startAnimating];
            
            break;
        case YLMessageSendSuccess:
            [self.messageSendStatusImageView removeAllSubViews];
            self.messageSendStatusImageView.image = nil;
            break;
        case YLMessageSendFail:{
            
            self.messageSendStatusImageView.userInteractionEnabled = true;
            [self.messageSendStatusImageView removeAllSubViews];
            self.messageSendStatusImageView.image  = [UIImage imageNamed:@"message_send_failed"];
            [self.messageSendStatusImageView setTapActionWithBlock:^{
                [[YLSocketRocktManager shareManger] resendMassege: messageModel];
            }];
            break;
        }
        default:
            break;
    }
    
}

-(void)layoutSubviews
{
    
    /**
     *  聊天的具体界面，只要考虑这两种类型，自己的，别人的。
     */
    [super layoutSubviews];
    if (_messageModel.ownerTyper == YLMessageOwnerTypeSelf) {
        // 屏幕宽 - 10 - 头像宽
        [self.avatarImageView setOrigin:CGPointMake(self.width - 10 - self.avatarImageView.width, 10)];
    }
    else if (_messageModel.ownerTyper == YLMessageOwnerTypeOther) {
        [self.avatarImageView setOrigin:CGPointMake(10, 10)];
        
    }
}

- (YLImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        float imageWidth = 40;
        _avatarImageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageWidth)];
        [_avatarImageView setHidden:YES];
    }
    return  _avatarImageView;
}
/**
 *  聊天背景图
 */
- (YLImageView *) messageBackgroundImageView
{
    if (_messageBackgroundImageView == nil) {
        _messageBackgroundImageView = [[YLImageView alloc] init];
        [_messageBackgroundImageView setHidden:YES];
        _messageBackgroundImageView.userInteractionEnabled = true;
    }
    return _messageBackgroundImageView;
}

- (YLImageView *) messageSendStatusImageView
{
    if (_messageSendStatusImageView == nil) {
        _messageSendStatusImageView = [[YLImageView alloc] init];
        [_messageSendStatusImageView setHidden:false];
        _messageSendStatusImageView.userInteractionEnabled = true;
    }
    return _messageSendStatusImageView;
}

@end
































