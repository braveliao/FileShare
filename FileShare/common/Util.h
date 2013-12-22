//
//  Util.h
//  FileShare
//
//  Created by liaoyong on 13-12-21.
//  Copyright (c) 2013年 redcdn.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+ (char *)convertStringToChar:(NSString *)string;
+ (NSArray *)dealDirData:(NSString *)dirString;
@end
