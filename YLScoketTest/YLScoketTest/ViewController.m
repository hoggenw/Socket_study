//
//  ViewController.m
//  YLScoketTest
//
//  Created by 王留根 on 17/2/14.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "ViewController.h"
#import "YLSocketManager.h"
#import "YLGCDAsyncSocketManager.h"
#import "YLSocketRocktManager.h"
#import "YLMQTTManager.h"
#import "YLHintView.h"
//#import <ChatKit/LCChatKit.h>

#define managerType 4

@interface ViewController ()<receiveMessageDelegate>

@property (nonatomic,strong)UITextField * putInTextFeild;
@property (nonatomic,strong)UITextField * putOutTextFeild;
@property (nonatomic,strong)UIImageView * sendImageView;

@property (nonatomic,strong)YLSocketManager *manager;
@property (nonatomic,strong)YLGCDAsyncSocketManager *GCDManager;
@property (nonatomic, strong)YLSocketRocktManager *socketManager;
@property (nonatomic, strong)YLMQTTManager *mqttManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (managerType) {
        case 1:
            self.manager = [YLSocketManager share];
            break;
        case 2:
            _GCDManager = [YLGCDAsyncSocketManager shareManger];
            break;
        case 3:
            _socketManager = [YLSocketRocktManager shareManger];
            break;
        case 4:
            _mqttManager = [YLMQTTManager shareManager];
            _mqttManager.delegate = self;
            break;
            
        default:
            break;
    }
    
    [self intialUI];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)intialUI {
    
    self.view.backgroundColor = [UIColor greenColor];
    UIButton  * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor brownColor];
    button.frame = CGRectMake( self.view.bounds.size.width/2 - 100,  self.view.bounds.size.height/2 - 50,  60,  50);
    [button setTitle:@"发送" forState:normal];
    [button addTarget:self action:@selector(sendMassege) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *imageButton = [UIButton new];
    imageButton.backgroundColor = [UIColor brownColor];
    imageButton.frame = CGRectMake(self.view.bounds.size.width/2 + 40, self.view.bounds.size.height/2 - 50, 60, 50);
    [imageButton setTitle:@"发送图片" forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(sendImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:imageButton];
    
    
    
    
    UIButton  * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor brownColor];
    button1.frame = CGRectMake( self.view.bounds.size.width/2 - 100,  self.view.bounds.size.height/2 + 50,  60,  50);
    [button1 setTitle:@"连接" forState:normal];
    [button1 addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    

    
    UIButton  * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.backgroundColor = [UIColor brownColor];
    button3.frame = CGRectMake( self.view.bounds.size.width/2 + 40,  self.view.bounds.size.height/2 + 50,  60,  50);
    [button3 setTitle:@"断开" forState:normal];
    [button3 addTarget:self action:@selector(disconnect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
//    UIButton  * button4 = [UIButton buttonWithType:UIButtonTypeCustom];
//    button4.backgroundColor = [UIColor brownColor];
//    button4.frame = CGRectMake( self.view.bounds.size.width/2 - 30,  self.view.bounds.size.height/2 + 150,  60,  50);
//    [button4 setTitle:@"心跳" forState:normal];
//    [button4 addTarget:self action:@selector(ping) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button4];
//    
    self.putInTextFeild = [UITextField new];
    _putInTextFeild.frame = CGRectMake( self.view.bounds.size.width/2 - 100, 64,  200,  50);
    _putInTextFeild.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_putInTextFeild];
    
    
    self.putOutTextFeild = [UITextField new];
    _putOutTextFeild.frame = CGRectMake( self.view.bounds.size.width/2 - 100,  self.view.bounds.size.height/2 + 180,  200,  50);
    _putOutTextFeild.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_putOutTextFeild];
    
    self.sendImageView = [UIImageView new];
    
    
    UIButton  * button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.backgroundColor = [UIColor brownColor];
    button4.frame = CGRectMake( self.view.bounds.size.width/2 + 40,  self.view.bounds.size.height/2 + 120,  60,  50);
    [button4 setTitle:@"pingpong" forState:normal];
    [button4 addTarget:self action:@selector(ping) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    
    
}

- (void)testSDk {
    // 用于单聊，默认会创建一个只包含两个成员的 unique 对话(如果已经存在则直接进入，不会重复创建)
    //LCCKConversationViewController *conversationViewController = [[LCCKConversationViewController alloc] initWithPeerId: @"ssdsadcfsadasdas"];
//    [self presentViewController: conversationViewController animated: true completion:^{
//
//    }];
}

- (void)receiveMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
       self.putOutTextFeild.text = message;
    });
    //[YLHintView showMessageOnThisPage: message];
}
- (void)sendMassege {
    if (_putInTextFeild.text.length > 0) {
        switch (managerType) {
            case 1:
                [_manager sendMassege:_putInTextFeild.text];
                break;
            case 2:
                [_GCDManager sendMassege:_putInTextFeild.text];
                break;
            case 3:
                [_socketManager sendMassege:_putInTextFeild.text];
                break;
            case 4:
                [_mqttManager sendMessage:_putInTextFeild.text];
                break;
                
            default:
                break;
        }
    }else {
        NSString *defaultString = @"你好。宝贝";
        switch (managerType) {
                
            case 1:
                [_manager sendMassege: defaultString];
                break;
            case 2:
                [_GCDManager sendMassege: defaultString];
                break;
            case 3:
                [_socketManager sendMassege: defaultString];
                break;
            case 4:
                [_mqttManager sendMessage: defaultString];
                break;
                
            default:
                break;
        }
    }
    
    
}

- (void)sendImage {
    
}

- (void)connect {
    switch (managerType) {
            
        case 1:
            [_manager connectFirst];
            break;
        case 2:
            if ([_GCDManager connect]) {
                NSLog(@"连接成功");
            }

            break;
        case 3:
             [_socketManager connect];
            break;
        case 4:
             [_mqttManager connect];
            break;
            
        default:
            break;
    }
    
    
}

- (void)disconnect {
    
    switch (managerType) {
            
        case 1:
            [_manager disconnectFirst];
            break;
        case 2:
             [_GCDManager disconnnet];
            break;
        case 3:
            [_socketManager disconnnet];
            break;
        case 4:
           [_mqttManager disConnnect];
            break;
            
        default:
            break;
    }
    
    
}

- (void)ping {
    [_socketManager ping];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_putInTextFeild resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
