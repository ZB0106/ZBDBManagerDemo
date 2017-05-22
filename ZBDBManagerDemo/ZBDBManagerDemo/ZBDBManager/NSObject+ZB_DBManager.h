//
//  NSObject+ZB_DBManager.h
//  ZBDBManager
//
//  Created by 瞄财网 on 2017/5/18.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface NSObject (ZB_DBManager)

- (BOOL)creatTableWithPrimaryKey:(NSString *)primaryKey primaryKeyType:(NSString *)primaryKeyType;
- (BOOL)ZB_insertObject:(id)object DBQueue:(FMDatabaseQueue *)dbQueue;
- (FMResultSet *)ZB_QueryWithDBQueue:(FMDatabaseQueue *)dbQueue;

@end
