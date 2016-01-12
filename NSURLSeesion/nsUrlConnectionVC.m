//
//  nsUrlConnectionVC.m
//  NSURLSeesion
//
//  Created by roarrain on 16/1/12.
//  Copyright © 2016年 roarrain. All rights reserved.
//

#import "nsUrlConnectionVC.h"


@interface nsUrlConnectionVC ()<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connect;
@property (nonatomic, strong) NSFileHandle *writeHandle;
@property (nonatomic, assign) long long totalLength;
@property (nonatomic, assign) long long currentLength;


@end

@implementation nsUrlConnectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self downLoad];
    
}

- (void)downLoad {
  
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:@""];
    [request setValue:[NSString stringWithFormat:@"bytes=%d-",100] forHTTPHeaderField:@"Range"];
    self.connect = [NSURLConnection connectionWithRequest:request delegate:self];
//    如果需要暂停的话可以设置
//    [self.connect cancel];
    
    
   }


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    if (self.currentLength) return;

    // 文件路径
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filepath = [caches stringByAppendingPathComponent:response.suggestedFilename];
    
    // 创建一个空的文件到沙盒中
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr createFileAtPath:filepath contents:nil attributes:nil];
    
    // 创建一个用来写数据的文件句柄
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:filepath];
    
    // 获得文件的总大小
    self.totalLength = response.expectedContentLength;


}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
      [self.writeHandle seekToEndOfFile];
    
    // 将数据写入沙盒
    [self.writeHandle writeData:data];
    
    // 累计文件的长度
    self.currentLength += data.length;
    
//    (double)self.currentLength/ self.totalLength;



}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.currentLength = 0;
    self.totalLength = 0;
    
    // 关闭文件
    [self.writeHandle closeFile];
    self.writeHandle = nil;


}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{


}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
