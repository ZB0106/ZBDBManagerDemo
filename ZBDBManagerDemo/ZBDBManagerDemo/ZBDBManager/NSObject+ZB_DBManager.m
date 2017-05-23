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
#import "ZBPropertyType.h"

#import "VersionDBManager.h"


@implementation NSObject (ZB_DBManager)


const static NSMutableDictionary *_versionForClassDict;
+ (void)load
{
    
    _versionForClassDict = @{}.mutableCopy;
}

+ (BOOL)creatTableWithPrimaryKey:(NSString *)primaryKey primaryKeyType:(NSString *)primaryKeyType
{
    
    NSString *className = NSStringFromClass(self);
        
    NSString *version = [_versionForClassDict objectForKey:className];
    
    NSDictionary *propertydic = [self getPropertiesDict];
    if (!version) {
        NSArray *propertyArrary = [propertydic.allKeys sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES]]];
        version = [propertyArrary componentsJoinedByString:@"_"];
        [_versionForClassDict setObject:version forKey:className];
    }

    if (version.length) {
        if ([version isEqualToString:[VersionDBManager getVersionWithClassName:className]]) {
            
            return YES;
            
        } else {
            
            //做更新表的操作
            __block BOOL ret = NO;
            __block NSString *sql = nil;
            
            FMDatabaseQueue *dbQueue = [ZBDBbindingClass getDBForClass:self];
            [dbQueue inDatabase:^(FMDatabase *db) {
                sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' '%@' PRIMARY KEY)",NSStringFromClass(self),primaryKey,primaryKeyType];
               ret = [db executeUpdate:sql];
            }];
            
            if (ret) {
                [dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                    
                    [propertydic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, ZBPropertyType *obj, BOOL * _Nonnull stop) {
                        @autoreleasepool {
                            if (![db columnExists:key inTableWithName:className]) {
                                NSString *type = nil;
                                if (obj.isNumberType || obj.isBoolType) {
                                    type = @"integer";
                                    
                                } else if ([obj.typeClass isSubclassOfClass:[NSString class]]){
                                    type = @"TEXT";
                                    
                                } else if(obj.isFromFoundation) {
                                    type = @"BLOB";
                                    
                                } else {
                                    
                                }
                                NSString *alertStr = [NSString stringWithFormat:@"ALTER TABLE '%@' ADD '%@' '%@'",NSStringFromClass(self),key,type];
                                ret = [db executeUpdate:alertStr];
                                
                                if (!ret) {
                                    *rollback = YES;
                                }
                            }
                        }
                    }];
                }];
                if (ret) {
                    //保存版本信息
                    Version *versionClass = [Version versionWithClassName:className version:version];
                    [VersionDBManager replaceIntoWithVersion:versionClass];
                }
            }
            
            return ret;
        }
            
    } else {
        
    return NO;
    
    }
}

+ (BOOL)ZB_insertObject:(id)object primaryKey:(NSString *)primaryKey primaryKeyType:(NSString *)primaryKeyType
{
    __block BOOL ret = NO;
    
    if (![self creatTableWithPrimaryKey:primaryKey primaryKeyType:primaryKeyType]) {
        return ret;
    }
     FMDatabaseQueue *dbQueue = [ZBDBbindingClass getDBForClass:self];
    [dbQueue inDatabase:^(FMDatabase *db) {
        
        __block NSString *keyStr = @"";
        __block NSString *valueStr = @"";
//        __block NSMutableArray *valueArray = @[].mutableCopy;
        
        [[self getPropertiesDict].allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (idx == 0) {
//                keyStr = [keyStr stringByAppendingFormat:@"%@",obj];
//                valueStr = [valueStr stringByAppendingString:@"?"];
//            } else {
//                keyStr = [keyStr stringByAppendingFormat:@",%@",obj];
//                valueStr = [valueStr stringByAppendingString:@",?"];
//            }
//            id value = [object valueForKey:obj];
//            [valueArray addObject:value];
            
            if (idx == 0) {
                keyStr = [keyStr stringByAppendingFormat:@"'%@'",obj];
                valueStr = [valueStr stringByAppendingFormat:@"'%@'",[object valueForKey:obj]];
            } else {
                keyStr = [keyStr stringByAppendingFormat:@",'%@'",obj];
                valueStr = [valueStr stringByAppendingFormat:@",'%@'",[object valueForKey:obj]];
            }
        }];
        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO '%@' (%@) values (%@)",NSStringFromClass(self),keyStr,valueStr];
        ret = [db executeUpdate:sql];
//        NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ (%@) values (%@);",NSStringFromClass(self),keyStr,valueStr];
//        ret = [db executeUpdate:sql withArgumentsInArray:valueArray];
    }];
    return ret;
}

+ (BOOL)ZB_updateWithSql:(NSString *)sql primaryKey:(NSString *)primaryKey primaryKeyType:(NSString *)primaryKeyType
{
    if (![self creatTableWithPrimaryKey:primaryKey primaryKeyType:primaryKeyType]) {
        return nil;
    }
    __block BOOL ret = NO;
    
    FMDatabaseQueue *dbQueue = [ZBDBbindingClass getDBForClass:self];
    [dbQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    return ret;

}
+ (NSArray *)ZB_QueryWithSql:(NSString *)sql primaryKey:(NSString *)primaryKey primaryKeyType:(NSString *)primaryKeyType
{
    if (![self creatTableWithPrimaryKey:primaryKey primaryKeyType:primaryKeyType]) {
        return nil;
    }
    __block NSMutableArray *arrayM = @[].mutableCopy;
    
    FMDatabaseQueue *dbQueue = [ZBDBbindingClass getDBForClass:self];
    NSDictionary *dict = [self getPropertiesDict];
    [dbQueue inDatabase:^(FMDatabase *db) {
       FMResultSet *result = [db executeQuery:sql];
        while (result && [result next]) {
          id obj = [[self alloc] init];
            [dict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull property, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setValue:[result objectForColumnName:property] forKey:property];
            }];
            [arrayM addObject:obj];
        }
    }];
    return arrayM;
}
@end
