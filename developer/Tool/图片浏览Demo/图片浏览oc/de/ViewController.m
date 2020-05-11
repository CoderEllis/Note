//
//  ViewController.m
//  de
//
//  Created by Soul Ai on 11/10/18.
//  Copyright © 2018年 Soul Ai. All rights reserved.
//

#import "ViewController.h"
#import "MyPhotoBrowser.h"
#import "MBCircularProgressBarView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //dengdeng 那个MB开头的文件，就是进度条控件。
    MBCircularProgressBarView *circular = [[MBCircularProgressBarView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    circular.center = self.view.center;
    circular.backgroundColor = [UIColor whiteColor];
    circular.maxValue = 1;
    circular.value = 0.70;
    circular.progressLineWidth = 2; //进度条宽度
    circular.progressColor = [UIColor blueColor]; //进度条中间颜色
    circular.progressStrokeColor = [UIColor blueColor]; //进度条外部颜色
    circular.emptyLineColor = [UIColor greenColor];//进度条背景颜色
    circular.decimalPlaces = 2; // 小数点位数
//    [self.view addSubview:circular];
    
    
    
    UIButton *button = [self.view viewWithTag:1000];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)buttonAction
{
    NSArray *imageArray = @[@"https://f12.baidu.com/it/u=3351520644,1070383534&fm=72",
                            @"https://f12.baidu.com/it/u=752933719,2910359121&fm=72",
                            @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=4235563522,1399401048&fm=200&gp=0.jpg"];
    
    
    
    MyPhotoBrowser *photo = [MyPhotoBrowser showImageArray:imageArray placeholderImage:nil Index:0 AnimateWithStartPoint:^CGPoint{
        UILabel *label = [self.view viewWithTag:100];
        return label.center;  //这里就 开始位置
    } AnimateWithEndPoint:^CGPoint(NSInteger index) {
        UILabel *label = [self.view viewWithTag:200];
        return label.center;// 这里就e结束位置, 这两个位置要自己算
    }];// index 就i当前浏览的l图片位置
    
    // 长按
    [photo ShowActionSheetWithTitle:@[@"保存到手机",@"1",@"2"] ChickIndex:^(NSInteger index, UIImage *image) {
        NSLog(@"按了第%ld个按钮",index);
    }];
    
    
    
    
}

@end
