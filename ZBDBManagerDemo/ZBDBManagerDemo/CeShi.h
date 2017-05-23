//
//  CeShi.h
//  ZBDBManager
//
//  Created by 瞄财网 on 2017/5/18.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CeShi : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign, getter=isgetMan) BOOL isMan;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSArray *array;

@end
