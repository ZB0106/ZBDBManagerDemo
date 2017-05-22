//
//  NSObject+ZB_DBManager.m
//  ZBDBManager
//
//  Created by 瞄财网 on 2017/5/18.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import "NSObject+ZB_DBManager.h"
#import <objc/runtime.h>
#import "NSObject+ZB_Properties.h"
#import "ZBDBbindingClass.h"

#import "VersionDBManager.h"


@implementation NSObject (ZB_DBManager)

const static NSMutableDictionary *_propertiesForClassDict;
+ (void)load
{
    _propertiesForClassDict = @{}.mutableCopy;
}

- (BOOL)creatTableWithDBQueue:(FMDatabaseQueue *)dbQueue primaryKey:(NSString *)primaryKey primaryKeyType:(NSString *)primaryKeyType
{
    
    NSString *className = NSStringFromClass([self class]);
    NSDictionary *propertydic = [_propertiesForClassDict objectForKey:className];
    if (!propertydic) {
        propertydic = [self getPropertiesDict];
        [_propertiesForClassDict setObject:propertydic forKey:className];
    }
    
    BOOL isExsit = [VersionDBManager isExistVersionWithClassName:className];
    if (isExsit) {
        
        NSString *version = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:propertydic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        Version *versionClass = [Version versionWithClassName:className version:version];
        
        if ([[VersionDBManager getVersionWithClassName:className] isEqualToString:version]) {
            return YES;
        } else {
            [VersionDBManager replaceIntoWithVersion:versionClass];
            //做更新表的操作
        }
    } else {
        //做创建表的操作
    }
    __block BOOL ret = NO;
    
    __block NSString *sql = nil;
    [dbQueue inDatabase:^(FMDatabase *db) {
        sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ %@ PRIMARY KEY);",NSStringFromClass([self class]),primaryKey,primaryKeyType];
        [db executeUpdate:sql];
    }];
    [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [[self getPropertiesDict] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            @autoreleasepool {
                if (![db columnExists:key inTableWithName:NSStringFromClass([self class])]) {
                    NSString *type = nil;
                    if ([obj isKindOfClass:[NSNumber class]]) {
                        type = @"integer";
                        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@",NSStringFromClass([self class]),key,type];
                        ret = [db executeUpdate:alertStr];
                        
                    } else if ([obj isKindOfClass:[NSString class]]){
                        type = @"TEXT";
                        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@",NSStringFromClass([self class]),key,type];
                        ret = [db executeUpdate:alertStr];
                        
                    } else if([obj isKindOfClass:[NSData class]]) {
                        type = @"BLOB";
                        NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@",NSStringFromClass([self class]),key,type];
                        ret = [db executeUpdate:alertStr];
                        
                    } else {
                        
                    }
                    if (!ret) {
                        *rollback = YES;
                    }
                }
            }
        }];
     }];    
    return ret;
}

- (BOOL)ZB_insertObject:(id)object DBQueue:(FMDatabaseQueue *)dbQueue
{
    __block BOOL ret = NO;
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        __block NSString *keyStr = @"";
        __block NSString *valueStr = @"";
        __block NSMutableArray *valueArray = @[].mutableCopy;
        __block int idx = 0;
        
        [[self getPropertiesDict] enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (idx == 0) {
                keyStr = [keyStr stringByAppendingFormat:@"%@",key];
                valueStr = [valueStr stringByAppendingString:@"?"];
            } else {
                keyStr = [keyStr stringByAppendingFormat:@",%@",key];
                valueStr = [valueStr stringByAppendingString:@",?"];
            }
            idx ++;
            [valueArray addObject:obj];

        }];
        
        NSLog(@"%@",[self getPropertiesDict]);
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ (%@) values (%@);",NSStringFromClass([self class]),keyStr,valueStr];
        ret = [db executeUpdate:sql withArgumentsInArray:valueArray];
    }];
    return ret;
}

- (FMResultSet *)ZB_QueryWithDBQueue:(FMDatabaseQueue *)dbQueue
{
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM \'%@\'",NSStringFromClass([self class])];
       FMResultSet *result = [db executeQuery:sql];
        while (result && [result next]) {
            id ce = [result objectForColumnName:@"name"];
            NSLog(@"11111111===%@====%@",ce,NSStringFromClass([ce class]));
            
        }
    }];
    return nil;
}
@end
