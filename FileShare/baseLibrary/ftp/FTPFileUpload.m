//
//  FTPFileUpload.m
//  SoftwareInstall
//
//  Created by 朱丹 on 10-12-22.
//  Copyright 2010 朱丹. All rights reserved.
//

#import "FTPFileUpload.h"

@interface FTPFileUpload()

@property (nonatomic, retain)   NSOutputStream *  networkStream;
@property (nonatomic, retain)   NSInputStream *   fileStream;
@property (nonatomic, readonly) uint8_t *         buffer;
@property (nonatomic, assign)   size_t            bufferOffset;
@property (nonatomic, assign)   size_t            bufferLimit;

@end

@implementation FTPFileUpload

- (uint8_t *)buffer
{
    return self->_buffer;
}

#pragma mark 回调方法
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    //aStream 即为设置为代理的networkStream
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"NSStreamEventOpenCompleted");
        } break;
        case NSStreamEventHasBytesAvailable: {
            NSLog(@"NSStreamEventHasBytesAvailable");
            return;
           // assert(NO);     // 在上传的时候不会调用
        } break;
        case NSStreamEventHasSpaceAvailable: {
            NSLog(@"NSStreamEventHasSpaceAvailable");
            NSLog(@"bufferOffset is %zd",self.bufferOffset);
            NSLog(@"bufferLimit is %zu",self.bufferLimit);
            if (self.bufferOffset == self.bufferLimit) {
                NSInteger   bytesRead;
                bytesRead = [self.fileStream read:self.buffer maxLength:kSendBufferSize];
                
                if (bytesRead == -1) {
                    //读取文件错误
                    [self _stopSendWithStatus:@"读取文件错误"];
                } else if (bytesRead == 0) {
                    //文件读取完成 上传完成
                    [self _stopSendWithStatus:nil];
                } else {
                    self.bufferOffset = 0;
                    self.bufferLimit  = bytesRead;
                }
            }
            
            if (self.bufferOffset != self.bufferLimit) {
                //写入数据
                NSInteger bytesWritten;//bytesWritten为成功写入的数据
                bytesWritten = [self.networkStream write:&self.buffer[self.bufferOffset] maxLength:self.bufferLimit - self.bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self _stopSendWithStatus:@"网络写入错误"];
                } else {
                    self.bufferOffset += bytesWritten;
                }
            }
        } break;
        case NSStreamEventErrorOccurred: {
            [self _stopSendWithStatus:@"Stream打开错误"];
            assert(NO);
        } break;
        case NSStreamEventEndEncountered: {
            // 忽略
        } break;
        default: {
            assert(NO);
        } break;
    }
}

//结果处理
- (void)_stopSendWithStatus:(NSString *)statusString
{
    if (self.networkStream != nil) {
        [self.networkStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.networkStream.delegate = nil;
        [self.networkStream close];
        self.networkStream = nil;
    }
    if (self.fileStream != nil) {
        [self.fileStream close];
        self.fileStream = nil;
    }
    [self _sendDidStopWithStatus:statusString];
}

- (void)_sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"上传成功";
    }
 //   _status.text = statusString;
}

- (void)InitFTPInfo : (NSString *)account
          Password : (NSString *)password
        UploadPath : (NSString *)uploadPath
     LocalFilePath : (NSString *)localFilePath {
    
    NSURL *url;//ftp服务器地址
    CFWriteStreamRef ftpStream;
    
    //获得输入
    url = [NSURL URLWithString:uploadPath];
    //添加后缀（文件名称）
    url = [NSMakeCollectable(CFURLCreateCopyAppendingPathComponent(NULL, (CFURLRef) url, (CFStringRef) [localFilePath lastPathComponent], false)) autorelease];
    
    //读取文件，转化为输入流
    self.fileStream = [NSInputStream inputStreamWithFileAtPath:localFilePath];
    [self.fileStream open];
    
    //为url开启CFFTPStream输出流
    ftpStream = CFWriteStreamCreateWithFTPURL(NULL, (CFURLRef) url);
    self.networkStream = (NSOutputStream *) ftpStream;
    
    //设置ftp账号密码
    [self.networkStream setProperty:account forKey:(id)kCFStreamPropertyFTPUserName];
    [self.networkStream setProperty:password forKey:(id)kCFStreamPropertyFTPPassword];
    
    //设置networkStream流的代理，任何关于networkStream的事件发生都会调用代理方法
    self.networkStream.delegate = self;
    
    //设置runloop
    [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.networkStream open];
    
    //完成释放链接
    CFRelease(ftpStream);    
}

//test
- (void)ftpDownload {
        CFReadStreamRef ftpStream2;
        NSURL *url;
        
        //获得地址
        url = [NSURL URLWithString:@"ftp://192.168.1.107"];
        
        NSLog(@"url is %@",url);
        
        // 为文件存储路径打开流，filePath为文件写入的路径,hello为图片的名字，具体可换成自己的路径
        NSString* filePath = @"/Users/yangguang/Desktop/hello.png";
        self.fileStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
        [self.fileStream open];
        
        // 打开CFFTPStream
        ftpStream2 = CFReadStreamCreateWithFTPURL(NULL, (CFURLRef) url);
        self.networkStream = (NSInputStream *) ftpStream2;
        assert(ftpStream2 != NULL);
        
        // 设置代理
        self.networkStream.delegate = self;
        
        // 启动循环
        [self.networkStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.networkStream open];  
        
        //释放链接  
        CFRelease(ftpStream2);
     }

- (void)dealloc {
	[super dealloc];
}

@end
