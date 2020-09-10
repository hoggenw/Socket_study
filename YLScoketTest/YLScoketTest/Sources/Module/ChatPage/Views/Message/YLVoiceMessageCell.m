//
//  YLVoiceMessageCell.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/23.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "YLVoiceMessageCell.h"
#import "ChatMessageModel.h"
#import "DPAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>


@interface YLVoiceMessageCell ()


@property (nonatomic, strong)YLImageView  * voiceImageView;
@end

@implementation YLVoiceMessageCell


-(void)dealloc{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:Y_Notification_Close_Voice_Animation  object: nil];
}

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
        [self addSubview:self.timeLabel];
        self.voiceImageView.userInteractionEnabled = true;
        [self addSubview: self.voiceImageView];
    }
    
    /**
     *  通知更新
     */
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName: Y_Notification_Close_Voice_Animation object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        [self.voiceImageView stopAnimating];
        
    }];
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    float widthVoice = 30;
    float hieghtVoice = 25;
    float y = self.avatarImageView.top - 3;
    if (self.messageModel.ownerTyper == YLMessageOwnerTypeSelf) {
        float x = self.avatarImageView.left - self.messageModel.messageSize.width - 15;
        self.voiceImageView.image = [UIImage imageNamed:@"message_voice_sender_playing_3"];
        self.voiceImageView.animationImages = [NSArray arrayWithObjects:
                                               [UIImage imageNamed:@"message_voice_sender_playing_1"],
                                               [UIImage imageNamed:@"message_voice_sender_playing_2"],
                                               [UIImage imageNamed:@"message_voice_sender_playing_3"],nil];
        [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.messageModel.messageSize.width+ 10, self.messageModel.messageSize.height + 10)];
        
        float voiceX = self.messageBackgroundImageView.right - 10 - widthVoice;
        float voiceY = self.messageBackgroundImageView.top + 10;
        [self.voiceImageView setFrame: CGRectMake(voiceX, voiceY, widthVoice, hieghtVoice)];
        
        [self.timeLabel setFrame:CGRectMake(self.messageBackgroundImageView.left - 40, self.messageBackgroundImageView.top, 30, self.messageBackgroundImageView.height)];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
         float messageSendStatusImageViewX = self.timeLabel.left ;
         [self.messageSendStatusImageView setFrame:CGRectMake(messageSendStatusImageViewX - 30, (self.timeLabel.top + 10), 30, 30)];
        
    }
    else if (self.messageModel.ownerTyper == YLMessageOwnerTypeOther) {
        float x = self.avatarImageView.left + self.avatarImageView.width + 5;
        self.voiceImageView.image = [UIImage imageNamed:@"message_voice_receiver_playing_3"];
        self.voiceImageView.animationImages = [NSArray arrayWithObjects:
                                               [UIImage imageNamed:@"message_voice_receiver_playing_1"],
                                               [UIImage imageNamed:@"message_voice_receiver_playing_2"],
                                               [UIImage imageNamed:@"message_voice_receiver_playing_3"],nil];
        [self.messageBackgroundImageView setFrame:CGRectMake(x, y, self.messageModel.messageSize.width+ 10, self.messageModel.messageSize.height + 10)];
        float voiceX = self.messageBackgroundImageView.left + 10;
        float voiceY = self.messageBackgroundImageView.top + 10;
        [self.voiceImageView setFrame: CGRectMake(voiceX, voiceY, widthVoice, hieghtVoice)];
        
        [self.timeLabel setFrame:CGRectMake(self.messageBackgroundImageView.right + 5, self.messageBackgroundImageView.top, 35, self.messageBackgroundImageView.height)];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    
}
-(void)setMessageModel:(ChatMessageModel *)messageModel
{
    
    [super setMessageModel:messageModel];
    __weak typeof(self) weakSelf = self;

    [self.messageBackgroundImageView setTapActionWithBlock:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:Y_Notification_Close_Voice_Animation object:nil];
        [weakSelf.voiceImageView startAnimating];
        if (messageModel.voiceData .length > 20) {
            [[DPAudioPlayer sharedInstance] startPlayWithData: messageModel.voiceData];
        }else{
            //播放url
           // NSLog(@"messageModel.voicePath : %@",messageModel.voicePath);
            [[DPAudioPlayer sharedInstance] startPlayWithURL: messageModel.sourcePath];
        }
        
        
        [DPAudioPlayer sharedInstance].playComplete = ^{
            [weakSelf.voiceImageView stopAnimating];
        };
    }];
    
    [self.voiceImageView setTapActionWithBlock:^{
        [weakSelf.voiceImageView startAnimating];
        if (messageModel.voiceData .length > 20) {
            [[DPAudioPlayer sharedInstance] startPlayWithData: messageModel.voiceData];
        }else{
            //播放url
           // NSLog(@"messageModel.voicePath : %@",messageModel.voicePath);
            [[DPAudioPlayer sharedInstance] startPlayWithURL: messageModel.sourcePath];
        }
        
        
        [DPAudioPlayer sharedInstance].playComplete = ^{
            [weakSelf.voiceImageView stopAnimating];
        };
    }];
    self.timeLabel.text = [NSString stringWithFormat:@"%@\"",@(messageModel.voiceSeconds)];
    
    
    
    
}

-(YLImageView *)voiceImageView {
    if (_voiceImageView == nil) {
        _voiceImageView = [[YLImageView  alloc] init];
        [_voiceImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_voiceImageView setClipsToBounds:YES];
        _voiceImageView.userInteractionEnabled = true;
        _voiceImageView.animationDuration = 1;
        _voiceImageView.animationRepeatCount = 0;
        
    }
    return  _voiceImageView;
}


- (UILabel *) timeLabel {
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_timeLabel setNumberOfLines:1];
        _timeLabel.textColor = [UIColor darkGrayColor];
        _timeLabel.userInteractionEnabled = true;
    }
    return _timeLabel;
}

@end

