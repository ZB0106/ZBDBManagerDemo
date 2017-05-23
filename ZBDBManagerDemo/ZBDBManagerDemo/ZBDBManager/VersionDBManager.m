//
//  VersionDBManager.m
//  ZBDBManager
//
//  Created by 瞄财网 on 2017/5/22.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import "VersionDBManager.h"
#import "ZBDBbindingClass.h"
#import <FMDB.h>

@implementation VersionDBManager

+ (BOOL)creatVersionTable
{
    __block BOOL ret = NO;
    FMDatabaseQueue *queue = [ZBDBbindingClass getDBForClass:[Version class]];
    __block NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' TEXT PRIMARY KEY, '%@' TEXT)",NSStringFromClass([Version class]),@"className",@"version"];
    [queue inDatabase:^(FMDatabase *db) {
       ret = [db executeUpdate:sql];
    }];
    return ret;
}

+ (BOOL)replaceIntoWithVersion:(Version *)version
{
    __block BOOL ret = NO;
    FMDatabaseQueue *queue = [ZBDBbindingClass getDBForClass:[Version class]];
    __block NSString *sql = [NSString stringWithFormat:@"REPLACE INTO '%@' ('%@','%@') VALUES ('%@','%@')",NSStringFromClass([Version class]),@"className",@"version",version.className,version.version];
    [queue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];

    return ret;
}

+ (BOOL)isExistVersionWithClassName:(NSString *)className
{
    __block BOOL ret = NO;
    return ret;
}
+ (NSString *)getVersionWithClassName:(NSString *)className
{
    __block NSString *resultStr = nil;
    FMDatabaseQueue *queue = [ZBDBbindingClass getDBForClass:[Version class]];
    __block NSString *sql = [NSString stringWithFormat:@"SELECT version FROM '%@' WHERE className = '%@'",NSStringFromClass([Version class]),className];
    [queue inDatabase:^(FMDatabase *db) {
        resultStr = [db stringForQuery:sql];
    }];

    return resultStr;
}
@end
