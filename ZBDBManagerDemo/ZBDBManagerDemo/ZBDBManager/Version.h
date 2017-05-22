//
//  Version.h
//  ZBDBManager
//
//  Created by 瞄财网 on 2017/5/22.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Version : NSObject

@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) NSString *version;
+ (instancetype)versionWithClassName:(NSString *)className version:(NSString *)version;
@end
