//
//  ZBDBbindingClass.h
//  ZBDBManager
//
//  Created by mac  on 17/5/20.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
@interface ZBDBbindingClass : NSObject

@property (nonatomic, copy) NSString *ClassName;
@property (nonatomic, copy) NSString *DBClassName;
+ (FMDatabaseQueue *)getDBForClass:(Class)theClass;
@end
