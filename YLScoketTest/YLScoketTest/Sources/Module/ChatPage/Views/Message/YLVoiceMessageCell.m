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

@implementation YLVoiceMessageCell

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
        [self addSubview: self.voiceImageView];
    }
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
        
        [self.timeLabel setFrame:CGRectMake(self.messageBackgroundImageView.left - 40, self.messageBackgroundImageView.top, 35, self.messageBackgroundImageView.height)];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        
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
        [weakSelf.voiceImageView startAnimating];
        if (messageModel.voiceData .length > 20) {
            [[DPAudioPlayer sharedInstance] startPlayWithData: messageModel.voiceData];
        }else{
            //播放url
            NSLog(@"messageModel.voicePath : %@",messageModel.voicePath);
            [[DPAudioPlayer sharedInstance] startPlayWithURL: messageModel.voicePath];
        }
        
        
        [DPAudioPlayer sharedInstance].playComplete = ^{
            [weakSelf.voiceImageView stopAnimating];
        };
    }];
    self.timeLabel.text = [NSString stringWithFormat:@"%@\"",@(messageModel.voiceSeconds)];
    
    
    
    
}

-(UIImageView *)voiceImageView {
    if (_voiceImageView == nil) {
        _voiceImageView = [[UIImageView alloc] init];
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

