//
//  FTPFileDownload.h
//  FileShare
//
//  Created by liaoyong on 12/15/13.
//  Copyright (c) 2013 redcdn.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    kRecvBufferSize = 32768
};

@interface FTPFileDownload : NSObject <NSStreamDelegate>
{
    uint8_t _buffer[kRecvBufferSize];
}

- (void)ftpDownload ;

@end
