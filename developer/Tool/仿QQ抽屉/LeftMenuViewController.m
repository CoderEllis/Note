//
//  leftVC.m
//  baisibudele
//
//  Created by Soul Ai on 9/3/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "DrawerViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *addbutton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:addbutton];
    addbutton.center = self.view.center;
    [addbutton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
}
//headerView上边的按钮点击事件
- (void)btnClick{
//    NSLog(@"%s",__FUNCTION__);
    //创建控制器
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor yellowColor];
    vc.title = @"增加按钮点击进来的控制器";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:[DrawerViewController shareDrawerVc] action:@selector(backHomeViewController)];
    vc.view.frame = self.view.bounds;
    //把我的nav传过去，来切换控制器
    [[DrawerViewController shareDrawerVc]switchViewController:nav];
}

@end
