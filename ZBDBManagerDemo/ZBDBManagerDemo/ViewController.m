//
//  ViewController.m
//  ZBDBManager
//
//  Created by 瞄财网 on 2017/5/18.
//  Copyright © 2017年 瞄财网. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+ZB_DBManager.h"
#import "CeShi.h"
#import "ZBDBbindingClass.h"
#import "NSObject+ZB_Properties.h"
@interface ViewController ()
@property (nonatomic, strong) FMDatabaseQueue *queque;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queque = [FMDatabaseQueue databaseQueueWithPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"ceshi.db"]];
    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject);
    
    
    CeShi *ce = [[CeShi alloc] init];
    ce.name = @"hahaha";
    ce.age = 11;
    ce.array = [NSArray array];
    ce.isMan = YES;
//    [ce creatTableWithDBQueue:self.queque primaryKey:@"name" primaryKeyType:@"TEXT"];
//    [ce ZB_insertObject:ce DBQueue:self.queque];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CeShi *ce = [[CeShi alloc] init];
    [ZBDBbindingClass getDBForClass:[ce class]];
    ce.name = @"hahaha";
    ce.age = 11;
    ce.array = [NSArray array];
    ce.isMan = YES;
    [ce ZB_insertObject:ce DBQueue:self.queque];
    
    [ce ZB_QueryWithDBQueue:self.queque];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
