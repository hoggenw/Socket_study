//
//  ChatBoxViewController.m
//  YLScoketTest
//
//  Created by 王留根 on 2018/1/19.
//  Copyright © 2018年 ios-mac. All rights reserved.
//

#import "ChatBoxViewController.h"
#import "YLChatFaceView.h"
#import "YLChatBoxView.h"
#import "YLChatBoxMoreView.h"
#import "ChatMessageModel.h"
#import "YLChatBoxItemView.h"
#import <QBImagePickerController/QBImagePickerController.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#define HEIGHT_CHATBOXVIEW  215// 更多 view
@interface ChatBoxViewController ()<YLChatBoxDelegate,YLChatBoxFaceViewDelegate,YLChatBoxMoreViewDelegate,QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) CGRect keyboardFrame;
@property (nonatomic, strong) YLChatBoxView *chatBox;
@property (nonatomic, strong) YLChatBoxMoreView *chatBoxMoreView;
@property (nonatomic, strong) YLChatFaceView *chatBoxFaceView;
//方形压缩图image 数组
//@property(nonatomic,strong) NSMutableArray<UIImage *> * imageArray;
//大图image 数组
//@property(nonatomic,strong) NSMutableArray<NSData *> * bigImageArray;

@end

@implementation ChatBoxViewController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillHideNotification object: nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.chatBox];
    /**
     *  添加两个键盘回收通知
     */
    // 即将隐藏
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 键盘的Frame值即将发生变化的时候创建的额监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  回收键盘方法
 *  
 */
- (BOOL) resignFirstResponder
{
    
    if (self.chatBox.status != YLChatBoxStatusNothing && self.chatBox.status != YLChatBoxStatusShowVoice)
    {
        // 回收键盘
        [self.chatBox resignFirstResponder];
        /**
         *  在外层已经判断是不是声音状态 和 Nothing 状态了，且判断是都不是才进来的，下面在判断是否多余了？
         *  它是判断是不是要设置成Nothing状态
         */
        self.chatBox.status = (self.chatBox.status == YLChatBoxStatusShowVoice ? self.chatBox.status : YLChatBoxStatusNothing);
        
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)])
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight];
                
            } completion:^(BOOL finished) {
                
                [self.chatBoxFaceView removeFromSuperview];
                [self.chatBoxMoreView removeFromSuperview];
                
            }];
        }
    }
    
    return [super resignFirstResponder];
}

/**
 *   在控制器里面添加键盘的监听，
 *
 *  @return <#return value description#>
 */
#pragma mark - Private Methods
- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyboardFrame = CGRectZero;
    if (_chatBox.status == YLChatBoxStatusShowFace || _chatBox.status == YLChatBoxStatusShowMore) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        
        [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight];
    }
}

/**
 *  点击了 textView 的时候，这个方法的调用是比  - (void) textViewDidBeginEditing:(UITextView *)textView 要早的。
 
 */
- (void)keyboardFrameWillChange:(NSNotification *)notification{
    
    // 键盘的Frame
    // po self.keyboardFrame 第一次点击 textview 的时候的值
    // (origin = (x = 0, y = 409), size = (width = 375, height = 258))
    // po self.chatBox.curHeight   49
    
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    if (_chatBox.status == YLChatBoxStatusShowKeyboard && self.keyboardFrame.size.height <= HEIGHT_CHATBOXVIEW) {
        
        return;
        
    }
    else if ((_chatBox.status == YLChatBoxStatusShowFace || _chatBox.status == YLChatBoxStatusShowMore) && self.keyboardFrame.size.height <= HEIGHT_CHATBOXVIEW) {
        
        return;
        
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        
        // 改变控制器.View 的高度 键盘的高度 + 当前的 49
        [_delegate chatBoxViewController:self didChangeChatBoxHeight: self.keyboardFrame.size.height + self.chatBox.curHeight];
        
    }
}

- (void)takePhoto {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = sourceType;
        imagePickerController.mediaTypes = @[CFBridgingRelease(kUTTypeImage)];
        imagePickerController.allowsEditing = false;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}


#pragma mark - YLChatBoxDelegate

- (void)chatBox:(YLChatBoxView *)chatBox changeStatusForm:(YLChatBoxStatus)fromStatus to:(YLChatBoxStatus)toStatus {
    
    switch (toStatus) {
        case YLChatBoxStatusShowKeyboard: {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.chatBoxFaceView  removeFromSuperview];
                [self.chatBoxMoreView removeFromSuperview];
            });
            return;
        }
        case YLChatBoxStatusShowVoice:{
            if (fromStatus == YLChatBoxStatusShowMore || fromStatus == YLChatBoxStatusShowFace) {
                [UIView animateWithDuration:0.3 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
                        
                    }
                } completion:^(BOOL finished) {
                    
                    [self.chatBoxFaceView removeFromSuperview];
                    [self.chatBoxMoreView removeFromSuperview];
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
                    }
                }];
            }
            return;
        }
        case YLChatBoxStatusShowFace:{
            /**
             *   变化到展示 表情View 的状态，这个过程中，根据 fromStatus 区分，要是是声音和无状态改变过来的，则高度变化是一样的。 其他的高度就是另外一种，根据 fromStatus 来进行一个区分。
             */
            if (fromStatus == YLChatBoxStatusShowVoice || fromStatus == YLChatBoxStatusNothing) {
                self.chatBoxFaceView.top = self.chatBox.curHeight;
                [self.view addSubview: self.chatBoxFaceView];
                [UIView animateWithDuration: 0.3 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                    }
                }];
            }else{
                // 表情高度变化
                self.chatBoxFaceView.top = self.chatBox.curHeight + HEIGHT_CHATBOXVIEW;
                [self.view addSubview:self.chatBoxFaceView];
                [UIView animateWithDuration:0.3 animations:^{
                    self.chatBoxFaceView.top = self.chatBox.curHeight;
                } completion:^(BOOL finished) {
                    [self.chatBoxMoreView removeFromSuperview];
                }];
                // 整个界面高度变化
                if (fromStatus != YLChatBoxStatusShowMore) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                            [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                        }
                    }];
                }
            }
            return;
        }
            
        case YLChatBoxStatusShowMore:{
            // 显示更多面板
            if (fromStatus == YLChatBoxStatusShowVoice || fromStatus == YLChatBoxStatusNothing) {
                self.chatBoxMoreView.top = self.chatBox.curHeight;
                [self.view addSubview:self.chatBoxMoreView];
                
                [UIView animateWithDuration:0.3 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                    }
                }];
            }
            else {
                
                self.chatBoxMoreView.top = self.chatBox.curHeight + HEIGHT_CHATBOXVIEW;
                [self.view addSubview:self.chatBoxMoreView];
                [UIView animateWithDuration:0.3 animations:^{
                    self.chatBoxMoreView.top = self.chatBox.curHeight;
                } completion:^(BOOL finished) {
                    [self.chatBoxFaceView removeFromSuperview];
                }];
                
                if (fromStatus != YLChatBoxStatusShowFace) {
                    
                    [UIView animateWithDuration:0.2 animations:^{
                        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                            [_delegate chatBoxViewController:self didChangeChatBoxHeight:self.chatBox.curHeight + HEIGHT_CHATBOXVIEW];
                        }
                    }];
                }
            }
            return;
        }
        default:
            break;
    }
    
}
/**
 *  发送文本消息
 */
- (void)chatBox:(YLChatBoxView *)chatBox sendTextMessage:(ChatMessageModel *)textMessage {
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController: sendMessage:)]) {
        
        [_delegate chatBoxViewController:self sendMessage: textMessage];
        
    }
    
}

- (void)chatBox:(YLChatBoxView *)chatBox changeChatBoxHeight:(CGFloat)height {
    self.chatBoxFaceView.top = height;
    self.chatBoxMoreView.top = height;
    if (_delegate && [_delegate respondsToSelector: @selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        float changedHieght = (self.chatBox.status == YLChatBoxStatusShowFace ? HEIGHT_CHATBOXVIEW : self.keyboardFrame.size.height) + height;
        [_delegate chatBoxViewController: self didChangeChatBoxHeight: changedHieght];
    }
}

#pragma mark - YLChatBoxFaceViewDelegate
- (void) chatBoxFaceViewDidSelectedFace:(ChatFace *)face type:(YLFaceType)type {
    if (type == YLFaceTypeEmoji) {
        [self.chatBox addEmojiFace:face];
    }
}
- (void) chatBoxFaceViewDeleteButtonDown{
    [self.chatBox deleteButtonDown];
}
- (void) chatBoxFaceViewSendButtonDown{
     [self.chatBox sendCurrentMessage];
}


#pragma mark - TLChatBoxMoreViewDelegate
- (void) chatBoxMoreView:(YLChatBoxMoreView *)chatBoxMoreView didSelectItem:(YLChatBoxItem)itemType
{
    
    switch (itemType) {
            
        case YLChatBoxItemAlbum:{//相册
            QBImagePickerController *imagePickerController = [QBImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.allowsMultipleSelection = YES;
            imagePickerController.maximumNumberOfSelection = 8;//设置选择图像数量上限
            imagePickerController.assetCollectionSubtypes = @[
                                                              @(PHAssetCollectionSubtypeSmartAlbumUserLibrary), //相机胶卷
                                                              @(PHAssetCollectionSubtypeAlbumMyPhotoStream), //我的照片流
                                                              @(PHAssetCollectionSubtypeSmartAlbumPanoramas), //全景图
                                                              @(PHAssetCollectionSubtypeSmartAlbumVideos), //视频
                                                              //@(PHAssetCollectionSubtypeSmartAlbumBursts) //连拍模式拍摄的照片
                                                              ];
            imagePickerController.mediaType = QBImagePickerMediaTypeAny;//图片和视频
            imagePickerController.showsNumberOfSelectedAssets = YES;//在界面下方显示已经选择图像的数量
            [self presentViewController:imagePickerController animated:YES completion:nil];  
            //NSLog(@"相册");
            break;
        }
        case YLChatBoxItemCamera:{//拍摄
            [self takePhoto];
            //NSLog(@"拍摄");
            break;
        }
        default:
            break;
    }
    
}
#pragma mark - Image Picker Controller Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        ChatMessageModel * message = [[ChatMessageModel alloc] init];
        message.messageType = YLMessageTypeImage;
        message.ownerTyper = YLMessageOwnerTypeSelf;
        message.image = [image compressImageWithSice:CGSizeMake(ScreenWidth * 0.38,ScreenHeight * 0.38)];
        message.imagePath = [[NSString stringWithFormat:@"%@",info[@"PHImageFileURLKey"]] substringFromIndex: 8];
        message.date = [NSDate  date];
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController: sendMessage:)]) {
            
            [_delegate chatBoxViewController:self sendMessage:message];
            
        }
        //NSLog(@"info = %@, image: %@",info,message.image);
    }];
}

#pragma mark -QBImagePickerControllerDelegate
//选中
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    [self dismissViewControllerAnimated:YES completion:^{
        //NSLog(@"%@",assets);
        int index = 0;
        for (PHAsset * asset in assets) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(index * 0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (asset.mediaType == PHAssetMediaTypeImage) {
                    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                    options.version = PHImageRequestOptionsVersionCurrent;
                    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                    options.synchronous = YES;
                    [[PHImageManager defaultManager]requestImageForAsset:asset targetSize:CGSizeMake(ScreenWidth * 0.38,ScreenHeight * 0.38) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

                        ChatMessageModel * message = [[ChatMessageModel alloc] init];
                        message.messageType = YLMessageTypeImage;
                        message.ownerTyper = YLMessageOwnerTypeSelf;
                        message.image = result;
                        message.imagePath = @"file:"; // [[NSString stringWithFormat:@"%@",info[@"PHImageFileURLKey"]] substringFromIndex: 8];
                        message.voiceData = UIImagePNGRepresentation(result);
                        message.date = [NSDate  date];
                        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController: sendMessage:)]) {

                            [_delegate chatBoxViewController:self sendMessage:message];

                        }
                       // NSLog(@"info = %@, message.imagePath: %@",info,message.imagePath);
                    }];


                }else if (asset.mediaType == PHAssetMediaTypeVideo){
                    NSLog(@"视频Type");
                }
            });
            index++;
        }
    }];
}
//取消
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Getter
- (YLChatBoxView *) chatBox
{
    // 6 的初始化 0.0.375.49
    if (_chatBox == nil) {
        _chatBox = [[YLChatBoxView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HEIGHT_TABBAR)];
        _chatBox.delegate = self; // 0 0 宽 49
    }
    
    return _chatBox;
    
}

// 添加创建更多View
- (YLChatBoxMoreView *) chatBoxMoreView
{
    if (_chatBoxMoreView == nil) {
        _chatBoxMoreView = [[YLChatBoxMoreView alloc] initWithFrame:CGRectMake(0, HEIGHT_TABBAR, ScreenWidth, HEIGHT_CHATBOXVIEW)];
        YLChatBoxItemView *photosItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"照片"
                                                                                imageName:@"sharemore_pic"];
        YLChatBoxItemView *takePictureItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"拍摄"
                                                                                     imageName:@"sharemore_video"];
        YLChatBoxItemView *videoItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"小视频"
                                                                               imageName:@"sharemore_sight"];
        YLChatBoxItemView *videoCallItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"视频聊天"
                                                                                   imageName:@"sharemore_videovoip"];
        YLChatBoxItemView *giftItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"红包"
                                                                              imageName:@"sharemore_wallet"];
        YLChatBoxItemView *transferItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"转账"
                                                                                  imageName:@"sharemorePay"];
        YLChatBoxItemView *positionItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"位置"
                                                                                  imageName:@"sharemore_location"];
        YLChatBoxItemView *favoriteItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"收藏"
                                                                                  imageName:@"sharemore_myfav"];
        YLChatBoxItemView *businessCardItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"名片"
                                                                                      imageName:@"sharemore_friendcard" ];
        YLChatBoxItemView *interphoneItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"实时对讲机"
                                                                                    imageName:@"sharemore_wxtalk" ];
        YLChatBoxItemView *voiceItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"语音输入"
                                                                               imageName:@"sharemore_voiceinput"];
        YLChatBoxItemView *cardsItem = [YLChatBoxItemView createChatBoxMoreItemWithTitle:@"卡券"
                                                                               imageName:@"sharemore_wallet"];
//        [_chatBoxMoreView setItems:[[NSMutableArray alloc] initWithObjects:photosItem, takePictureItem, videoItem, videoCallItem, giftItem, transferItem, positionItem, favoriteItem, businessCardItem, interphoneItem, voiceItem, cardsItem, nil]];
        [_chatBoxMoreView setItems:[[NSMutableArray alloc] initWithObjects:photosItem, takePictureItem, videoItem,positionItem, voiceItem, nil]];
        _chatBoxMoreView.delegate = self;
    }
    return _chatBoxMoreView;
}


-(YLChatFaceView *) chatBoxFaceView
{
    if (_chatBoxFaceView == nil) {
        _chatBoxFaceView = [[YLChatFaceView alloc] initWithFrame:CGRectMake(0, HEIGHT_TABBAR, ScreenWidth, HEIGHT_CHATBOXVIEW)];
        _chatBoxFaceView.delegate = self;
    }
    return _chatBoxFaceView;
}

//-(NSMutableArray<NSData *> *)bigImageArray {
//    if (_bigImageArray == nil) {
//        _bigImageArray = [NSMutableArray array];
//    }
//    return _bigImageArray;
//}
//-(NSMutableArray<UIImage *> *)imageArray {
//    if (_imageArray == nil) {
//        _imageArray = [NSMutableArray array];
//    }
//    return _imageArray;
//}

@end


























