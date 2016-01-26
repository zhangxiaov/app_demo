//
//  cfnetworkVC.m
//  app_demo
//
//  Created by 张新伟 on 16/1/25.
//  Copyright © 2016年 张新伟. All rights reserved.
//

#import "cfnetworkVC.h"

#import <sys/socket.h>

#import <netinet/in.h>

#import <arpa/inet.h>

#import "cfnetworkVC.h"


@implementation cfnetworkVC

CFSocketRef  _socket;

BOOL isOnline;

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    // 创建Socket,无须回调函数
    
    _socket = CFSocketCreate(kCFAllocatorDefault,
                             
                             PF_INET // 指定协议族,如果该参数为0或者负数,则默认为PF_INET
                             
                             // 指定Socket类型,如果协议族为PF_INEF,且该参数为0或负数
                             
                             // 则它会默认为SOCK_STREAM,如果要使用UDP协议,则该参数指定为SOCK_DGRAM
                             
                             , SOCK_STREAM
                             
                             // 指定通信协议.如果前一个参数为SOCK_STREAM,则默认使用TCP协议
                             
                             // 如果前一个参数SOCK_DGRAM,则默认使用UDP协议
                             
                             , IPPROTO_TCP
                             
                             // 该参数指定下一个回调函数所监听的事件类型
                             
                             ,  kCFSocketNoCallBack
                             
                             ,  nil
                             
                             ,  NULL);
    
    if(_socket != nil)
        
    {
        
        // 定义sockaddr_in类型的变量,该变量将作为CFSocket的地址
        
        struct  sockaddr_in  addr4;
        
        memset(&addr4, 0, sizeof(addr4));
        
        addr4.sin_len = sizeof(addr4);
        
        addr4.sin_family = AF_INET;
        
        // 设置连接远程服务器的地址
        
        addr4.sin_addr.s_addr = inet_addr("127.0.0.1");
        
        // 设置连接远程服务器的监听端口
        
        addr4.sin_port = htons(1234);
        
        // 将IPv4的地址转换为CFDataRef
        
        CFDataRef address = CFDataCreate(kCFAllocatorDefault,  (UInt8 *)&addr4, sizeof(addr4));
        
        // 连接远程服务器的Socket,并返回连接结果
        
        CFSocketError  result = CFSocketConnectToAddress(_socket, address // 指定远程服务器的IP地址和端口
                                                            
                                                            ,  5 // 指定连接超时时长, 如果该参数为负数, 则把连接操作放在后台进行
                                                            
                                                            //  当_socket消息类型为kCFSocketConnectCallBack时
                                                            
                                                            //  将会在连接成功或失败的时候在后台触发回调函数
                                                            
                                                            );
        
        // 如果连接远程服务器成功
        
        if(result == kCFSocketSuccess)
            
        {
            
            isOnline = YES;
            
            // 启动新线程来读取服务器响应的数据
            
            [NSThread detachNewThreadSelector:@selector(readStream) toTarget:self withObject:nil];
        }
    }
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(10, 70, 100, 40)];
    [button setTitle:@"send" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

// 读取接收的数据

- (void)readStream

{
    
    char buffer[2048];
    
    size_t hasRead;
    
    // 与本机关联的Socket如果已经失效,则返回-1:INVALID_SOCKET
    
    while ((hasRead = recv(CFSocketGetNative(_socket), buffer, sizeof(buffer), 0)))
        
    {
        
        NSLog(@"%@",[[NSString alloc] initWithBytes:buffer length:hasRead encoding:NSUTF8StringEncoding]);
        
    }
    
}

-  (void)clicked:(id)sender

{
    
    if(isOnline)
        
    {
        
        NSString* stringTosend = @"来自iOS客户端的问候";
        
        const char* data = [stringTosend UTF8String];
        
        send(CFSocketGetNative(_socket), data, strlen(data) +1, 1);
        
    }
    
    else
        
    {
        
        NSLog(@"暂未连接服务器");
        
    }
    
}

@end