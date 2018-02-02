//
//  ChatMessageModel.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/22.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "ChatMessageModel.h"



@implementation ChatFace

@end

@implementation ChatFaceGroup

@end

static ChatFaceHeleper * faceHeleper = nil;

@implementation ChatFaceHeleper

+(ChatFaceHeleper * )sharedFaceHelper
{
    if (!faceHeleper) {
        
        faceHeleper = [[ChatFaceHeleper alloc]init];
        
    }
    
    return  faceHeleper;
}

/**
 *   通过这个方法，从  plist 文件中取出来表情
 */
#pragma mark - Public Methods
- (NSArray *) getFaceArrayByGroupID:(NSString *)groupID
{
    
    //NSLog(@"groupID：%@  path: %@ path2: %@",groupID,[[NSBundle mainBundle] pathForResource: [NSString stringWithFormat:@"Supporting Files/%@", groupID] ofType:@"plist"] ,[[NSBundle mainBundle] pathForResource: [NSString stringWithFormat:@"%@", groupID] ofType:@"plist"] );
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", groupID] ofType:@"plist"]];
    //NSLog(@"array.count: %@", @(array.count));
    NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        ChatFace *face = [[ChatFace alloc] init];
        face.faceID = [dic objectForKey:@"face_id"];
        face.faceName = [dic objectForKey:@"face_name"];
        [data addObject:face];
    }
    
    return data;
}

#pragma mark -  ChatFaceGroup Getter
- (NSMutableArray *) faceGroupArray
{
    
    if (_faceGroupArray == nil) {
        _faceGroupArray = [[NSMutableArray alloc] init];
        
        ChatFaceGroup *group = [[ChatFaceGroup alloc] init];
        group.faceType = YLFaceTypeEmoji;
        group.groupID = @"normal_face";
        group.groupImageName = @"EmotionsEmojiHL";
        group.facesArray = nil;
        [_faceGroupArray addObject:group];
    }
    return _faceGroupArray;
}

@end



static UILabel *label = nil;
@implementation ChatMessageModel


-(id)init
{
    if (self = [super init]) {
        
        if (label == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
              label = [UILabel new];
                [label setNumberOfLines:0];
                [label setFont:[UIFont systemFontOfSize:16.0f]];
            });
            
           
        }
    }
    
    return self;
}

#pragma mark - Setter
-(void) setText:(NSString *)text
{
    _text = text;
    if (text.length > 0) {
        
        _attrText = [self formatMessageString:text];
        
    }
}
- (NSAttributedString *) formatMessageString:(NSString *)text
{
    //1、创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    //2、通过正则表达式来匹配字符串
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    //3、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        
        ChatFaceGroup   *group = [[[ChatFaceHeleper  sharedFaceHelper] faceGroupArray] objectAtIndex:0];
        for (ChatFace *face in group.facesArray) {
            if ([face.faceName isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:face.faceName];
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                textAttachment.bounds = CGRectMake(0, -4, 20, 20);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
                
            }
        }
    }
    
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    return attributeString;
    
}


-(void)setMessageType:(YLMessageType)messageType {
    _messageType = messageType;
    switch (messageType) {
        case YLMessageTypeText:
            self.cellIndentify = @"YLTextTableViewCell";
            break;
        case YLMessageTypeImage:
            self.cellIndentify = @"YLImageMessageCell";
            break;
        case YLMessageTypeVoice:
            self.cellIndentify = @"YLVoiceMessageCell";
            break;
        case YLMessageTypeSystem:
            self.cellIndentify = @"YLSystemMessageCell";
            break;
        default:
            break;
    }
}

-(CGSize)messageSize {
    
    switch (self.messageType) {
            
        case YLMessageTypeText:
            [label setAttributedText:self.attrText];
            _messageSize = [label sizeThatFits:CGSizeMake(ScreenWidth * 0.58, MAXFLOAT)];
            break;
            
        case YLMessageTypeImage:
        {
            //NSString *path = self.imagePath;
            //_image = [UIImage imageWithContentsOfFile: path];
            //NSLog(@"path：%@   获取路径的image： %@",path,_image);
            if (_image != nil) {
                _messageSize = (_image.size.width > ScreenWidth * 0.5 ? CGSizeMake(ScreenWidth * 0.5, ScreenWidth * 0.5 / _image.size.width * _image.size.height) : _image.size);
                _messageSize = (_messageSize.height > 60 ? (_messageSize.height < 200 ? _messageSize : CGSizeMake(_messageSize.width, 200)) : CGSizeMake(60.0 / _messageSize.height * _messageSize.width, 60));
            }
            else {
                _messageSize = CGSizeMake(0, 0);
            }
            break;
        }
        case YLMessageTypeVoice:{
            float width = 60;
            if (self.voiceSeconds > 3 &&  self.voiceSeconds <= 6) {
                width = 90;
            }else if (self.voiceSeconds > 3 &&  self.voiceSeconds <= 10){
                width = 120;
            }else if (self.voiceSeconds > 10 &&  self.voiceSeconds <= 16){
                width = 150;
            }else if (self.voiceSeconds > 16){
                width = 180;
            }
            _messageSize = CGSizeMake(width, 35);
            break;
        }
        case YLMessageTypeSystem:
            break;
            
        default:
            break;
    }
    
    return _messageSize;
}

-(CGFloat)cellHeight {
    switch (self.messageType) {
            // cell 上下间隔为10
        case YLMessageTypeText:
            
            return self.messageSize.height + 40 > 60 ? self.messageSize.height + 40 : 60;
            break;
            
        case YLMessageTypeImage:
            
            return self.messageSize.height + 20;
            break;
            
        case YLMessageTypeVoice:
            
            return 35 + 20;
            break;
            
        default:
            
            break;
    }
    return self.messageSize.height;
}

@end

































