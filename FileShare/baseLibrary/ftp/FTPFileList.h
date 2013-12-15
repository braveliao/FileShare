//
//  FTPFileList.h
//  FileShare
//
//  Created by liaoyong on 12/15/13.
//  Copyright (c) 2013 redcdn.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTPFileList : NSObject <NSStreamDelegate>

- (void)startReceive;

@end
