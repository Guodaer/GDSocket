//
//  GDTabbarViewController.m
//  GDSocketChat
//
//  Created by 郭达 on 2018/7/2.
//  Copyright © 2018年 DouNiu. All rights reserved.
//

#import "GDTabbarViewController.h"
#import "GDNavigationViewController.h"

#import "HomePageViewController.h"
#import "MineViewController.h"

@interface GDTabbarViewController ()

@end

@implementation GDTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    HomePageViewController *messageVc = [[HomePageViewController alloc] init];
    [self addChildVc:messageVc title:@"首页" image:@"tabbar_mainframe" selectedImage:@"tabbar_mainframeHL"];
    
    
    MineViewController *mineVc = [[MineViewController alloc] init];
    [self addChildVc:mineVc title:@"我的" image:@"tabbar_me" selectedImage:@"tabbar_meHL"];

}


- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = rgb_Color(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = rgb_Color(26, 178, 10);
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    GDNavigationViewController *nav = [[GDNavigationViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
