//
//  FTPFileDownload.m
//  FileShare
//
//  Created by liaoyong on 12/15/13.
//  Copyright (c) 2013 redcdn.cn. All rights reserved.
//

#import "FTPFileDownload.h"

@interface FTPFileDownload()

@property (nonatomic, retain)   NSInputStream *  networkStream;
@property (nonatomic, retain)   NSOutputStream *   fileStream;
@property (nonatomic, readonly) uint8_t *         buffer;
@property (nonatomic, assign)   size_t            bufferOffset;
@property (nonatomic, assign)   size_t            bufferLimit;

@end

@implementation FTPFileDownload

- (uint8_t *)buffer
{
    return self->_buffer;
}

#pragma mark NSStreamDelegate委托方法
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"NSStreamEventOpenCompleted");
        } break;
        case NSStreamEventHasBytesAvailable: {
            NSLog(@"NSStreamEventHasBytesAvailable");
            NSInteger bytesRead;
            uint8_t buffer[32768];//缓冲区的大小 32768可以设置，uint8_t为一个字节大小的无符号int类型
            
            // 读取数据            
            bytesRead = [self.networkStream read:buffer maxLength:sizeof(buffer)];
            if (bytesRead == -1) {
                [self _stopReceiveWithStatus:@"读取网络数据出错"];
            } else if (bytesRead == 0) {
                //下载成功
                [self _stopReceiveWithStatus:nil];
            } else {
                NSInteger   bytesWritten;//实际写入数据
                NSInteger   bytesWrittenSoFar;//当前数据写入位置
                
                // 写入文件
                bytesWrittenSoFar = 0;
                do {
                    bytesWritten = [self.fileStream write:&buffer[bytesWrittenSoFar] maxLength:bytesRead - bytesWrittenSoFar];
                    assert(bytesWritten != 0);
                    if (bytesWritten == -1) {
                        [self _stopReceiveWithStatus:@"文件写入出错"];
                        assert(NO);
                        break;
                    } else {
                        bytesWrittenSoFar += bytesWritten;
                    }
                } while (bytesWrittenSoFar != bytesRead);
            }
        } break;
        case NSStreamEventHasSpaceAvailable: {
            assert(NO);
        } break;
        case NSStreamEventErrorOccurred: {
            [self _stopReceiveWithStatus:@"打开出错，请检查路径"];
            assert(NO);
        case NSStreamEventEndEncountered: {
        } break;
        default:
            assert(NO);
            break;
        }
    }
}

#pragma mark 结果处理，关闭链接
- (void)_stopReceiveWithStatus:(NSString *)statusString
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
    if(statusString == nil){
        statusString = @"下载成功";
    }
    NSLog(@"status:%@",statusString);
    
 //   self.filePath = nil;
}


- (void)_sendDidStopWithStatus:(NSString *)statusString
{
    if (statusString == nil) {
        statusString = @"上传成功";
    }
    //   _status.text = statusString;
}

//test
- (void)ftpDownload {
    NSURL *url;
    
    //获得地址
    url = [NSURL URLWithString:@"ftp://192.168.1.107"];
    
    NSLog(@"url is %@",url);
    
    // 为文件存储路径打开流，filePath为文件写入的路径,hello为图片的名字，具体可换成自己的路径
    NSString* filePath = @"/home/liaoyong/Default.png";
    self.fileStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    [self.fileStream open];
    
    // 打开CFFTPStream
    CFReadStreamRef ftpStream2;
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
