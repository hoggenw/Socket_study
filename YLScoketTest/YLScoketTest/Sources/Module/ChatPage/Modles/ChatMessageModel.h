//
//  ChatMessageModel.h
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/22.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatUserModel.h"
#import <MapKit/MapKit.h>
#import "YlmessageModel.pbobjc.h"

/**
 *  消息拥有者
 */
typedef NS_ENUM(NSUInteger, YLMessageOwnerType){
    YLMessageOwnerTypeUnknown = 0,  // 未知的消息拥有者
    YLMessageOwnerTypeSystem = 1,   // 系统消息
    YLMessageOwnerTypeSelf = 2,     // 自己发送的消息
    YLMessageOwnerTypeOther = 3,    // 接收到的他人消息
};

/**
 *  消息类型
 */
typedef NS_ENUM(NSInteger, YLMessageType){
    YLMessageTypeUnknown = 0,       // 未知
    YLMessageTypeSystem = 1,        // 系统
    YLMessageTypeText = 2,          // 文字
    YLMessageTypeImage = 3,         // 图片
    YLMessageTypeVoice = 4,         // 语音
    YLMessageTypeVideo = 5,         // 视频
    YLMessageTypeFile = 6,          // 文件
    YLMessageTypeLocation = 7,      // 位置
    YLMessageTypeShake = 8,         // 抖动
};

/**
 *  消息发送状态
 */
typedef NS_ENUM(NSUInteger, YLMessageSendState){
    YLMessageSending = 0,       // 消息发送中
    YLMessageSendSuccess = 1,          // 消息发送失败
    YLMessageSendFail = 2,          // 消息发送失败
    YLMessageSourceError = 3,          // 语音消息重发源被系统删除
};

/**
 *  消息读取状态
 */
typedef NS_ENUM(NSUInteger, YLMessageReadState) {
    
    YLMessageUnRead = 0,            // 消息未读
    YLMessageReaded = 1,            // 消息已读
    
};

/**
 *  消息读取状态
 */
typedef NS_ENUM(NSUInteger, YLMessageModule) {
    
    YLMessageCommonModule = 101,           // 一般消息
  
    YLMessageUnsendMessgeGet = 102, //获取未收到的信息
};

/**
 *  消息读取状态
 */
typedef NS_ENUM(NSUInteger, YLMessageCMD) {
    
    YLMessageCMDPersontoPerson = 1,          // 一般消息commandMessage
    YLMessageCMDMessageSuccess=2,  //消息发送成功
    YLMessageCMDMessageGet =3,  //获取未接收消息
    YLMessageCMDNowIpGet =4,  //获取未接收消息
};

@interface ChatMessageModel : NSObject


@property (nonatomic, strong) YLUserModel *from;                    // 发送者信息
@property (nonatomic, strong) YLUserModel *toUser;                  // 发送者信息
@property(nonatomic, readwrite, copy) NSString *messageOtherUserId;
@property (nonatomic, strong) NSString *messageId;                    // 消息id
@property (nonatomic, strong) NSDate *date;                         // 发送时间
@property (nonatomic, strong) NSString *dateString;                 // 格式化的发送时间
@property (nonatomic, assign) YLMessageType messageType;            // 消息类型
@property (nonatomic, assign) YLMessageOwnerType ownerTyper;        // 发送者类型
@property (nonatomic, assign) YLMessageReadState readState;         // 读取状态
@property (nonatomic, assign) YLMessageSendState sendState;         // 发送状态

@property (nonatomic, assign) CGSize messageSize;                   // 消息大小
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSString *cellIndentify;

#pragma mark - 文字消息
@property (nonatomic, strong) NSString *text;                       // 文字信息
@property (nonatomic, strong) NSAttributedString *attrText;         // 格式化的文字信息

#pragma mark - 图片消息
@property (nonatomic, strong) NSString *sourcePath;                  // 文件source
@property (nonatomic, strong) UIImage *image;                       // 图片缓存
//@property (nonatomic, strong) NSString *imageURL;                   // 网络图片URL

#pragma mark - 位置消息
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;    // 经纬度
@property (nonatomic, strong) NSString *address;                    // 地址

#pragma mark - 语音消息
@property (nonatomic, assign) NSUInteger voiceSeconds;              // 语音时间
@property (nonatomic, strong) NSString *voiceUrl;                   // 网络语音URL
@property (nonatomic, strong) NSString *voicePath;                  // 本地语音Path
@property (nonatomic, strong) NSData *voiceData;                  // 本地语音

@end




/**
 *  定义一个表情的类型枚举
 */
typedef NS_ENUM(NSInteger, YLFaceType) {
    /**
     *  表情
     */
    YLFaceTypeEmoji,
    /**
     *  GIF表情
     */
    YLFaceTypeGIF,
};


@interface ChatFace : NSObject

@property (nonatomic, strong) NSString *faceID;
@property (nonatomic, strong) NSString *faceName;

@end

/**
 *  类拓展
 */
@interface ChatFaceGroup : NSObject

@property (nonatomic, assign) YLFaceType faceType;
@property (nonatomic, strong) NSString *groupID;
@property (nonatomic, strong) NSString *groupImageName;
@property (nonatomic, strong) NSArray *facesArray;

@end


@interface ChatFaceHeleper : NSObject

@property (nonatomic, strong) NSMutableArray *faceGroupArray;

+ (ChatFaceHeleper *) sharedFaceHelper;

- (NSArray *) getFaceArrayByGroupID:(NSString *)groupID;

@end
