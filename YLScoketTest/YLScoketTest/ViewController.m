//
//  ViewController.m
//  YLScoketTest
//
//  Created by 王留根 on 17/2/14.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "ViewController.h"
#import "YLSocketManager.h"
@interface ViewController ()

@property (nonatomic,strong)UITextField * putInTextFeild;
@property (nonatomic,strong)YLSocketManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [YLSocketManager share];
    [self intialUI];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)intialUI {
    
    self.view.backgroundColor = [UIColor greenColor];
    UIButton  * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor brownColor];
    button.frame = CGRectMake( self.view.bounds.size.width/2 - 30,  self.view.bounds.size.height/2 - 150,  60,  50);
    [button setTitle:@"发送" forState:normal];
    [button addTarget:self action:@selector(sendMassege) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton  * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor brownColor];
    button1.frame = CGRectMake( self.view.bounds.size.width/2 - 30,  self.view.bounds.size.height/2 - 50,  60,  50);
    [button1 setTitle:@"连接" forState:normal];
    [button1 addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    

    
    UIButton  * button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.backgroundColor = [UIColor brownColor];
    button3.frame = CGRectMake( self.view.bounds.size.width/2 - 30,  self.view.bounds.size.height/2 + 50,  60,  50);
    [button3 setTitle:@"断开" forState:normal];
    [button3 addTarget:self action:@selector(disconnect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    self.putInTextFeild = [UITextField new];
    _putInTextFeild.frame = CGRectMake( self.view.bounds.size.width/2 - 100, 64,  200,  50);
    _putInTextFeild.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_putInTextFeild];
    
}

- (void)sendMassege {
    if (_putInTextFeild.text.length > 0) {
        [_manager sendMassege:_putInTextFeild.text];
    }else {
        [_manager sendMassege:@"你好，宝贝"];
    }
    
    
}

- (void)connect {
    
    [_manager connectFirst];
    
}

- (void)disconnect {
    
    [_manager disconnectFirst];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_putInTextFeild resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
