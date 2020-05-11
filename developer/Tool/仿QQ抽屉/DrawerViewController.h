//
//  ViewController.h
//  baisibudele
//
//  Created by Soul Ai on 7/3/2019.
//  Copyright © 2019 Soul Ai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerViewController : UIViewController

- (void)openLeftVc;

//*  快速获得抽屉控制器
+ (instancetype)shareDrawerVc;

+ (instancetype)drawerVcWithMainVc:(UIViewController *)mainVc leftMenuVc:(UIViewController *)leftMenuVc;

- (void)switchViewController:(UIViewController *)destVc;

- (void)backHomeViewController;
@end

