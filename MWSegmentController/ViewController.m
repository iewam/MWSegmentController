//
//  ViewController.m
//  MWSegmentController
//
//  Created by caifeng on 2016/12/27.
//  Copyright © 2016年 facaishu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    TestViewController *test1 = [[TestViewController alloc] init];
    test1.title = @"test1test1test1test1";
    [self addChildViewController:test1];
    
    TestViewController *test2 = [[TestViewController alloc] init];
    test2.title = @"test2";
    [self addChildViewController:test2];
    
    TestViewController *test3 = [[TestViewController alloc] init];
    test3.title = @"test3test3";
    [self addChildViewController:test3];
//    
    TestViewController *test4 = [[TestViewController alloc] init];
    test4.title = @"test4test4test4";
    [self addChildViewController:test4];
    
    TestViewController *test5 = [[TestViewController alloc] init];
    test5.title = @"test5";
    [self addChildViewController:test5];
    
    TestViewController *test6 = [[TestViewController alloc] init];
    test6.title = @"test6test6";
    [self addChildViewController:test6];
    
    TestViewController *test7 = [[TestViewController alloc] init];
    test7.title = @"test7";
    [self addChildViewController:test7];
    
    // 设置标题是否缩放
    self.isShowTitleScale = YES;
    // 一次性设置标题样式
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        
        *titleScrollViewColor = [UIColor whiteColor];
        *norColor = [UIColor blackColor];
        *selColor = [UIColor orangeColor];
    }];
    
}



@end
