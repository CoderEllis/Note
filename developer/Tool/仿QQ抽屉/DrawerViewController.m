//
//  ViewController.m
//  baisibudele
//
//  Created by Soul Ai on 7/3/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

#import "DrawerViewController.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
@interface DrawerViewController ()

/**
 *  遮盖按钮
 */
@property (nonatomic,strong) UIButton *coverView;
@property (nonatomic, weak)  UIViewController *leftMenuVc;
@property (nonatomic, weak)  UIViewController *mainV;


/**
 *  记录当前正在显示的VC
 */
@property (nonatomic,strong) UIViewController *showingVc;

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //给tabBarVc的所有子控制器添加一个边缘拖拽的手势
    for (UIViewController *childVc in self.mainV.childViewControllers) {
        [self addScreenEdgePanGestureRecognizerToView:childVc.view];
    }
    //左边view 添加手势
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panG:)];
    [self.leftMenuVc.view addGestureRecognizer:panG];
    
    
    
}


//快速获得抽屉控制器
+ (instancetype)shareDrawerVc{
    return (DrawerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

//创建抽屉控制器
+ (instancetype)drawerVcWithMainVc:(UIViewController *)mainVc leftMenuVc:(UIViewController *)leftMenuVc{
    DrawerViewController *drawerVc = [[DrawerViewController alloc] init];
    drawerVc.mainV = mainVc;
    drawerVc.leftMenuVc = leftMenuVc;
    //将左边菜单控制器的view添加到抽屉控制器的view上
    [drawerVc.view addSubview:leftMenuVc.view];
    [drawerVc.view addSubview:mainVc.view];
    //苹果官方规定 如果“两个控制器的view”互为父子关系，这“两个控制器”与也必须互为父子关系
    [drawerVc addChildViewController:leftMenuVc];
    [drawerVc addChildViewController:mainVc];
    
    return drawerVc;
}


// 切换控制器的方法  切换到指定的控制器
// @param destVc 目标控制器
- (void)switchViewController:(UIViewController *)destVc{
    destVc.view.frame = self.view.bounds;
    destVc.view.transform = self.mainV.view.transform;
    [self.view addSubview:destVc.view];
    [self addChildViewController:destVc];
    [self resetAndRemoveCovreView];
    self.showingVc = destVc;
    
}

//回到主界面
- (void)backHomeViewController{
    //以动画形式 让控制器回到最初状态
    [UIView animateWithDuration:0.25 animations:^{
        self.showingVc.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
    }completion:^(BOOL finished) {
        [self.showingVc removeFromParentViewController];
        [self.showingVc.view removeFromSuperview];
        self.showingVc = nil;
    }];
    
    
}


/**
 *  给指定的view添加边缘拖拽手势
 */
- (void)addScreenEdgePanGestureRecognizerToView:(UIView *)View{
    //创建边缘拖拽对象
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.edges = UIRectEdgeLeft;
    //设置手势方向，触发左边缘时才触发
    pan.edges = UIRectEdgeLeft;
    [View addGestureRecognizer:pan];
}


//给左边的 view 左滑关闭方法
- (void)panG: (UIPanGestureRecognizer *)panG {
    CGPoint transP = [panG translationInView:self.mainV.view];
//    NSLog(@"%f",transP.x);
    if (transP.x < 0) {
        [self resetAndRemoveCovreView];
    }
}

//让MainV复位 
- (void)resetAndRemoveCovreView {
    [UIView animateWithDuration:0.5 animations:^{
        self.mainV.view.frame = self.view.bounds;
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
}



//遮蔽btn的方法
- (void)panCoverView:(UIPanGestureRecognizer *)panView{
    //获取偏移量
    CGPoint transP = [panView translationInView:self.mainV.view];
    
    self.mainV.view.frame = [self frameWithOffsetX:transP.x];
    
    //当手指松开时,做自动定位.
    CGFloat target = 0;
    if (panView.state == UIGestureRecognizerStateEnded) {
        //判断在右侧
        if (self.mainV.view.frame.origin.x > screenW * 0.5) {
            target = screenW * 0.8; //自定义 x 的偏移量
        }
        //计算当前mainV的frame.
        CGFloat offset = target - self.mainV.view.frame.origin.x;
        [UIView animateWithDuration:0.5 animations:^{
            self.mainV.view.frame = [self frameWithOffsetX:offset];
        }];
    }
    
    //复位
    [panView setTranslation:CGPointZero inView:self.mainV.view];
}

//mainV边缘拖拽方法
- (void)pan: (UIScreenEdgePanGestureRecognizer *)pan {
    //获取偏移量
    CGPoint transP = [pan translationInView:self.mainV.view];
    
    self.mainV.view.frame = [self frameWithOffsetX:transP.x];
    
    //当手指松开时,做自动定位.
    CGFloat target = 0;
    if (pan.state == UIGestureRecognizerStateEnded) {
        //判断在右侧
        if (self.mainV.view.frame.origin.x > screenW * 0.5) {
            target = screenW * 0.8; //自定义 x 的偏移量
            [self.mainV.view addSubview:self.coverView];
        }
        //计算当前mainV的frame.
        CGFloat offset = target - self.mainV.view.frame.origin.x;
        [UIView animateWithDuration:0.5 animations:^{
            self.mainV.view.frame = [self frameWithOffsetX:offset];
        }];
    }
    
    //复位
    [pan setTranslation:CGPointZero inView:self.mainV.view];
}


#define maxY 100
//根据偏移量计算MainV的frame
- (CGRect)frameWithOffsetX: (CGFloat)offsetX {
//    NSLog(@"offsetX===%f",offsetX);
    
    CGRect frame = self.mainV.view.frame;
    
//    NSLog(@"x====%f",frame.origin.x);
    
    frame.origin.x += offsetX;
    
    //当拖动的View的x值等于屏幕宽度时,maxY为最大,最大为100
    // 375 * 100 / 375 = 100
    //对计算的结果取绝对值
    CGFloat y = fabs(frame.origin.x * maxY / screenW);
    
    frame.origin.y = y;
    //屏幕的高度减去两倍的Y值
    frame.size.height = screenH - 2 * frame.origin.y;
    if (self.mainV.view.frame.origin.x == 0) {
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }
    return frame;
    
}

/**
 *  打开左边控制器方法
 */
- (void)openLeftVc{
//    NSLog(@"%s",__func__);
    [UIView animateWithDuration:0.5 animations:^{
        self.mainV.view.frame = [self frameWithOffsetX:screenW * 0.8];
    } completion:^(BOOL finished) {
        [self.mainV.view addSubview:self.coverView];
    }];
}


#pragma mark -懒加载 遮盖
-(UIButton *)coverView{
    if (_coverView == nil) {
        _coverView = [[UIButton alloc] init];
        _coverView.frame = self.mainV.view.bounds;
        _coverView.backgroundColor = [UIColor clearColor];
        //创建一个拖拽手势
        [_coverView addTarget:self action:@selector(resetAndRemoveCovreView) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCoverView:)];
        [_coverView  addGestureRecognizer:pan];
    }
    return _coverView;
}


@end
