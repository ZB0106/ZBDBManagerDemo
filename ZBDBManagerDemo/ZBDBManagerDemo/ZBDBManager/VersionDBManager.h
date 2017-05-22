//
//  VersionDBManager.h
//  ZBDBManager
//
//  Created by 瞄财网 on 2017/5/22.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Version.h"

@interface VersionDBManager : NSObject

+ (BOOL)replaceIntoWithVersion:(Version *)version;
+ (NSString *)getVersionWithClassName:(NSString *)className;
+ (BOOL)isExistVersionWithClassName:(NSString *)className;

@end
