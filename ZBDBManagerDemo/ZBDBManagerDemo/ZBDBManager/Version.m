//
//  Version.m
//  ZBDBManager
//
//  Created by 瞄财网 on 2017/5/22.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import "Version.h"

@implementation Version

+ (instancetype)versionWithClassName:(NSString *)className version:(NSString *)version
{
    Version *versionClass = [[self alloc] init];
    versionClass.className = className;
    versionClass.version = version;
    return versionClass;
}

@end
