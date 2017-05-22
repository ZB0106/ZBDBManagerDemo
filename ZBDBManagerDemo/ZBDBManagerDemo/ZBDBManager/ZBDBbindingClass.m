//
//  ZBDBbindingClass.m
//  ZBDBManager
//
//  Created by mac  on 17/5/20.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import "ZBDBbindingClass.h"


@interface ZBDBbindingClass ()


@end

@implementation ZBDBbindingClass

const static NSDictionary *_bindingdict = nil;

+(void)load
{
    _bindingdict = @{
                     @"ZBCommonDataBaseQueue":@"Ceshi"
                     };
}

+ (FMDatabaseQueue *)getDBForClass:(Class)theClass
{
    
    NSString *db = [_bindingdict objectForKey:NSStringFromClass(theClass)];
    
    return [[NSClassFromString(db) alloc] init];
}

@end
