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

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CeShi *ce = [[CeShi alloc] init];
    [ZBDBbindingClass getDBForClass:[ce class]];
    ce.name = @"hahaha";
    ce.age = 11;
    ce.array = [NSArray array];
    ce.isMan = YES;
    
    [CeShi ZB_insertObject:ce primaryKey:@"name" primaryKeyType:@"TEXT"];
    
    NSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
