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

@interface ViewController ()

@property (nonatomic,strong)UITextField * putInTextFeild;
@property (nonatomic,strong)UIImageView * sendImageView;

@property (nonatomic,strong)YLSocketManager *manager;
@property (nonatomic,strong)YLGCDAsyncSocketManager *GCDManager;
@property (nonatomic, strong)YLSocketRocktManager *socketManager;
@property (nonatomic, strong)YLMQTTManager *mqttManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //_GCDManager = [YLGCDAsyncSocketManager shareManger];

    //_socketManager = [YLSocketRocktManager shareManger];
    _mqttManager = [YLMQTTManager shareManager];
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
    
    self.sendImageView = [UIImageView new];
    
    
    
    
}

- (void)sendMassege {
    if (_putInTextFeild.text.length > 0) {
       // [_manager sendMassege:_putInTextFeild.text];
       //  [_GCDManager sendMassege:_putInTextFeild.text];
        //[_socketManager sendMassege:_putInTextFeild.text];
        [_mqttManager sendMessage:_putInTextFeild.text];
    }else {
        [_mqttManager sendMessage:@"你好。宝贝"];
    }
    
    
}

- (void)sendImage {
    
}

- (void)connect {
    
   // [_manager connectFirst];
//    if ([_GCDManager connect]) {
//        NSLog(@"连接成功");
//    }
//    [_socketManager connect];
    [_mqttManager connect];

    
}

- (void)disconnect {
    
   // [_manager disconnectFirst];
    // [_GCDManager disconnnet];
    [_mqttManager disConnnect];
    
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
