//
//  EZJViewController.m
//  EZJUserDataCollectorLibIOS
//
//  Created by zhangjing on 12/11/2015.
//  Copyright (c) 2015 zhangjing. All rights reserved.
//

#import "EZJViewController.h"
#import "EZJUserDataCollector.h"
#import "FMDB.h"
#import "NSString+Path.h"
#import "EZJUserBehavior.h"
#import "EZJPageOneViewController.h"
#import "MobClick.h"

@interface EZJViewController ()
@property (nonatomic,strong) FMDatabaseQueue *queue;
@property (nonatomic,strong) EZJUserBehavior *behavior;
@end

@implementation EZJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"跳转" style:UIBarButtonItemStylePlain target:self action:@selector(forward)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(150, 200, 150, 150)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"奔溃一下" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(aaa:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)forward {
    EZJPageOneViewController *page = [[EZJPageOneViewController alloc] init];
    [self.navigationController pushViewController:page animated:YES];
}

//统计应用中某事件发生的次数
- (void)clickMe:(UIButton *)sender {
    [self.behavior event:@"click"];
}

//考虑事件在不同属性上的取值
- (void)buyBook:(UIButton *)sender {
    NSDictionary *dict = @{@"type" : @"book", @"quantity" : @"3"};
    [self.behavior event:@"purchase" attributes:dict];
}

- (EZJUserBehavior *)behavior {
    if (!_behavior) {
        _behavior = [EZJUserBehavior sharedInstance];
        Class cls = [MobClick class];
        _behavior.mobClick = cls;
    }
    return _behavior;
}

- (void)setupUI {
    
    // 发送事件
    UIButton *sendEventBtn = [[UIButton alloc] initWithFrame:CGRectMake(50,100, 200, 30)];
    [sendEventBtn setTitle:@"发送点击事件" forState:UIControlStateNormal];
    [sendEventBtn setBackgroundColor:[UIColor orangeColor]];
    [sendEventBtn addTarget:self action:@selector(clickMe:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sendAttrBtn = [[UIButton alloc] initWithFrame:CGRectMake(50,100, 300, 30)];
    [sendAttrBtn setTitle:@"发送带属性的点击事件" forState:UIControlStateNormal];
    [sendAttrBtn setBackgroundColor:[UIColor orangeColor]];
    [sendAttrBtn addTarget:self action:@selector(buyBook:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:sendEventBtn];
    [self.view addSubview:sendAttrBtn];
    
    sendEventBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sendEventBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:50]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sendEventBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:150]];
    
    sendAttrBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sendAttrBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:50]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:sendAttrBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:200]];
}

@end
