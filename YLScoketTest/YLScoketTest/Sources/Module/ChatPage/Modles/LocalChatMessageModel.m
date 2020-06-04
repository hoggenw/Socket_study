//
//  LocalChatMessageModel.m
//  YLScoketTest
//
//  Created by hoggen on 2020/3/9.
//  Copyright © 2020 ios-mac. All rights reserved.
//

#import "LocalChatMessageModel.h"

@implementation LocalChatMessageModel

+ (LocalChatMessageModel *)localChatMessageModelchangeWith:(YLMessageModel *)pMessage{
    LocalChatMessageModel * returnModel = [LocalChatMessageModel new];
    switch (pMessage.messageType) {
        case  YLMessageTypeImage:{ // 图片
            returnModel.textString = @"这是图片";
            returnModel.messageType = YLMessageTypeImage;
            returnModel.messageSource = pMessage.messageSource;
            break;
        }
        case  YLMessageTypeText:{ // 文字
            returnModel.textString = pMessage.textString;
            returnModel.messageType = YLMessageTypeText;
            break;
        }
        case  YLMessageTypeVoice:{ // 语音
            returnModel.messageSource = pMessage.messageSource;
            returnModel.messageType = YLMessageTypeVoice;
            returnModel.voiceSeconds = pMessage.voiceLength;
            break;
        }
        case  YLMessageTypeVideo:{ // 视频
            returnModel.textString = @"这是视频";
            returnModel.messageSource = pMessage.messageSource;
            returnModel.messageType = YLMessageTypeVideo;
            break;
        }
        case  YLMessageTypeFile:{ // 文件
            returnModel.textString = @"这是文件";
            returnModel.messageSource = pMessage.messageSource;
            returnModel.messageType = YLMessageTypeFile;
            break;
        }
        case  YLMessageTypeLocation:{ // 位置
            returnModel.textString = @"这是位置";
            returnModel.messageSource = pMessage.messageSource;
            returnModel.messageType = YLMessageTypeLocation;
            break;
        }
        default:
            break;
    }
    returnModel.fromName =  pMessage.fromUser.name;
    returnModel.fromAvatar =  pMessage.fromUser.avatar;
    returnModel.fromUserId =  pMessage.fromUser.userId;
    
    returnModel.toUserName =  pMessage.toUser.name;
    returnModel.toUserAvatar =  pMessage.toUser.avatar;
    returnModel.toUserUserId =  pMessage.toUser.userId;
    returnModel.messageId =  pMessage.messageId;
    //NSLog(@"%@,",pMessage.messageId);
    
    return returnModel;
    
}
+ (ChatMessageModel *)chatMessageModelChangeWith:(LocalChatMessageModel *)pMessage{
    ChatMessageModel * returnModel = [ChatMessageModel new];
    switch (pMessage.messageType) {
           case  YLMessageTypeImage:{ // 图片
               returnModel.text = @"这是图片";
               returnModel.messageType = YLMessageTypeImage;
               returnModel.sourcePath = pMessage.messageSource;
               break;
           }
           case  YLMessageTypeText:{ // 文字
               returnModel.text = pMessage.textString;
               returnModel.messageType = YLMessageTypeText;
               break;
           }
           case  YLMessageTypeVoice:{ // 语音
               returnModel.sourcePath = pMessage.messageSource;
               returnModel.messageType = YLMessageTypeVoice;
               returnModel.voiceSeconds = (uint32_t) pMessage.voiceSeconds;
               break;
           }
           case  YLMessageTypeVideo:{ // 视频
               returnModel.text = @"这是视频";
               returnModel.sourcePath = pMessage.messageSource;
               returnModel.messageType = YLMessageTypeVideo;
               break;
           }
           case  YLMessageTypeFile:{ // 文件
               returnModel.text = @"这是文件";
               returnModel.sourcePath = pMessage.messageSource;
               returnModel.messageType = YLMessageTypeFile;
               break;
           }
           case  YLMessageTypeLocation:{ // 位置
               returnModel.text = @"这是位置";
               returnModel.sourcePath = pMessage.messageSource;
               returnModel.messageType = YLMessageTypeLocation;
               break;
           }
           default:
               break;
       }
    YLUserModel * from = [YLUserModel new];
    YLUserModel *  to = [YLUserModel new];
    from.name = pMessage.fromName;
     from.avatar = pMessage.fromAvatar;
     from.userId = pMessage.fromUserId;
    
    to.name = pMessage.toUserName;
    to.avatar = pMessage.toUserAvatar;
    to.userId = pMessage.toUserUserId;
   
    returnModel.from = from;
    returnModel.toUser = to;
    returnModel.dateString =  pMessage.dateString;
    returnModel.messageOtherUserId = pMessage.messageOtherUserId;
    returnModel.messageId = pMessage.messageId;
    if ([from.userId isEqualToString: [[AccountManager sharedInstance] fetch].userID ]) {
         returnModel.ownerTyper = YLMessageOwnerTypeSelf;
    }else{
         returnModel.ownerTyper = YLMessageOwnerTypeOther;
    }
    returnModel.date = pMessage.date;
   
    
    return returnModel;
}

@end
