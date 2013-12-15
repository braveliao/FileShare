//
//  FTPFileUpload.h
//  SoftwareInstall
//
//  Created by 朱丹 on 10-12-22.
//  Copyright 2010 朱丹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CFNetwork/CFFTPStream.h"

enum {
    kSendBufferSize = 32768
};
@protocol FTPFileUploadDelegate;

@interface FTPFileUpload : NSObject <NSStreamDelegate> {
    uint8_t _buffer[kSendBufferSize];
}

//初始化FTP信息
-(void)InitFTPInfo : (NSString *)account
          Password : (NSString *)password
        UploadPath : (NSString *)uploadPath
     LocalFilePath : (NSString *)localFilePath;
- (void)ftpDownload ;

@end

@protocol FTPFileUploadDelegate <NSObject>
@optional
//文件上传成功的委托操作
-(void)DidUploadIsFinish;            
//文件上传失败的委托操作
-(void)DidUploadIsFalse : (NSString *)FalseLog;      //失败信息
@end
