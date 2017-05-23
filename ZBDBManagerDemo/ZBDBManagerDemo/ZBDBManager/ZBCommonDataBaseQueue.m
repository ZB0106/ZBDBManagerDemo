//
//  ZBCommonDataBaseQueue.m
//  ZBDBManager
//
//  Created by mac  on 17/5/20.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import "ZBCommonDataBaseQueue.h"
#import <sqlite3.h>

@implementation ZBCommonDataBaseQueue

static ZBCommonDataBaseQueue *_instance = nil;
+ (instancetype)zb_ShareCommonDataBaseQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [self databaseQueueWithPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"common.db"] flags:SQLITE_OPEN_FILEPROTECTION_NONE | SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE];
    });
    return _instance;
}

@end
