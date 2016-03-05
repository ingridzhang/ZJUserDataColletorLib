//
//  EZJPageOneViewController.m
//  EZJUserDataCollectorLibIOS
//
//  Created by Apple on 15/12/18.
//  Copyright © 2015年 zhangjing. All rights reserved.
//

#import "EZJPageOneViewController.h"
#import "EZJUserBehavior.h"

@interface EZJPageOneViewController ()
@property (nonatomic,strong) EZJUserBehavior *behavior;
@end

@implementation EZJPageOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [self.behavior beginLogPageView:@"EZJViewController"];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [self.behavior endLogPageView:@"EZJViewController"];
//}

- (EZJUserBehavior *)behavior {
    if (!_behavior) {
        _behavior = [[EZJUserBehavior alloc] init];
    }
    return _behavior;
}
@end
