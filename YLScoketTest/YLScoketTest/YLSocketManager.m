//
//  YLSocketManager.m
//  YLScoketTest
//
//  Created by 王留根 on 17/2/14.
//  Copyright © 2017年 ios-mac. All rights reserved.
//

#import "YLSocketManager.h"
#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>



@interface YLSocketManager ()
    
@property (nonatomic,assign) BOOL ifContinue;
@property (nonatomic, assign) int clienScoket;
@property (nonatomic, strong) NSThread *thread;

@end

@implementation YLSocketManager

+(instancetype)share {
    static YLSocketManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YLSocketManager alloc] init];
        [manager initScoket];
        [manager pullMassege];
    });
    return manager;
}

-(void)initScoket {
    //每次连接前，先断开连接
    if (_clienScoket != 0) {
        [self disconnectFirst];
        _clienScoket = 0;
    }
    _ifContinue = YES;
    //创建客户端socket
    _clienScoket = CreateClineSocket();
    NSLog(@"_clienScoket = %d",_clienScoket);
    //服务器Ip
    const char * server_ip = "192.168.20.14";
    short server_port = 6969;
    //等于0说明连接失败
    if (ConnectionToServer(_clienScoket,server_ip,server_port) == 0) {
        printf("connet to server error\n");
        return;
    }
    
    printf("connet  to server success\n");
    
}

static int ConnectionToServer(int clinet_socket,const char *sever_ip, unsigned short port) {
    //生成一个socket——in类型的结构体
    struct sockaddr_in sAddr ;
    memset(&sAddr, '0', sizeof(sAddr));
    //端口转换
    //htons是将整型变量从主机字节顺序转变成网络字节顺序，赋值端口号
    sAddr.sin_port = htons(port);
    //设置IPv4
    sAddr.sin_family =  AF_INET;
    //inet_aton是一个改进的方法将一个字符串Ip地址转换为一个32为的网络序列IP地址
    //如果这个函数成功，函数的返回值非零，如果输入地址不正确则返回零。
    //ip地址转换
    //inet_pton(AF_INET, sever_ip, &sAddr.sin_addr);
    inet_aton(sever_ip, &sAddr.sin_addr);

    //用socket和服务器地址，发起连接。
    //客户端像特定网络地址的服务器发送链接请求，连接成功返回0，失败返回-1
    //注意：该接口调用会阻塞当前线程，直到服务器返回
    if (connect(clinet_socket, (struct sockaddr *)&sAddr, sizeof(sAddr)) == 0) {
        return  clinet_socket;
    }
    
    
    return 0;
}

static int CreateClineSocket() {
    int ClinetSocket = 0;
    //创建一个socket，返回值是Int。是从客厅其实就是Int类型
    //第一个参数addressFamily IPv4(AF_INET)或IPv6（AF_INET6）;
    //第二个参数TYPE表示socket 的类型，通常是流Stream（SOCK_STREAM）或者数据报文datagram(SOCK_DGrAM)
    //第三个参数protcol参数通常设置为0，以便让系统自动为我们选择合适的协议，对于stream socket来说会是TCP协议（IPPROTO_TCP）,而对于datagram来说会是UDP协议（IPPRODO_UDP）
    ClinetSocket = socket(AF_INET, SOCK_STREAM, 0);
    return ClinetSocket;
}

-(void) connectFirst {
    [self initScoket];
    
}

-(void)disconnectFirst {
    _ifContinue = NO;
    int result = close(self.clienScoket);
    NSLog(@"disconnect = %@",@(result));
    
}
//发送消息
-(void)sendMassege:(NSString *)message {
    _ifContinue = NO;
    const char * send_Message = [message UTF8String];
    send(self.clienScoket, send_Message, strlen(send_Message) + 1, 0);
    _ifContinue = YES;
}
    
-(void)setIfContinue:(BOOL)ifContinue {
    _ifContinue = ifContinue;
    if (_ifContinue) {
        [self pullMassege];
    }else {
        [_thread cancel];
        _thread = nil;
    }
}
#pragma mark - 新线程来接收消息

-(void) pullMassege {
    
    _thread = [[NSThread alloc]initWithTarget:self selector:@selector(recieveAction) object:nil];
    [_thread start];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self recieveAction];
//    });
    
}

-(void) recieveAction {
    while (1) {
        char recv_Message[1024] = {0};
        if (recv(self.clienScoket, recv_Message, sizeof(recv_Message), 0) != -1) {
            printf("%s\n",recv_Message);
        }
    }
}
@end



























