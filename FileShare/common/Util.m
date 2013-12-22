//
//  Util.m
//  FileShare
//
//  Created by liaoyong on 13-12-21.
//  Copyright (c) 2013年 redcdn.cn. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (char *)convertStringToChar:(NSString *)string {
    return (char *)[string cStringUsingEncoding:NSASCIIStringEncoding];
}

+ (NSArray *)dealDirData:(NSString *)dirString {
    NSArray *tempArray = [dirString componentsSeparatedByString:@"\n"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSString* s in tempArray) {
        if ([s isEqualToString:@""]) {
            NSLog(@"string is null..");
            continue;
        }
        NSString* temSting = [s substringFromIndex:38];
        [array addObject:temSting];
    }
    return (NSArray *)array;
}

@end
