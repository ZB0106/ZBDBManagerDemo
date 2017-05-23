//
//  ZBDBbindingClass.m
//  ZBDBManager
//
//  Created by mac  on 17/5/20.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import "ZBDBbindingClass.h"
#import "ZBCommonDataBaseQueue.h"


@interface ZBDBbindingClass ()


@end

@implementation ZBDBbindingClass

const static NSDictionary *_bindingdict = nil;

+(void)load
{
    _bindingdict = @{
                     @"CeShi":@"ZBCommonDataBaseQueue",
                     @"Version":@"ZBCommonDataBaseQueue"
                     };
}

+ (FMDatabaseQueue *)getDBForClass:(Class)theClass
{
    NSLog(@"%@== %@",NSStringFromClass(theClass),_bindingdict);
    NSString *db = [_bindingdict objectForKey:NSStringFromClass(theClass)];
    if (NSClassFromString(db) == [ZBCommonDataBaseQueue class]) {
        return [ZBCommonDataBaseQueue zb_ShareCommonDataBaseQueue];
    }
    return nil;
}

@end
