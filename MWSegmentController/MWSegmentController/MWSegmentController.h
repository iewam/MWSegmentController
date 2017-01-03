//
//  MWSegmentController.h
//  MWSegmentController
//
//  Created by caifeng on 2016/12/27.
//  Copyright © 2016年 facaishu. All rights reserved.
//

#import <UIKit/UIKit.h>



// 颜色渐变样式
typedef enum : NSUInteger {
    YZTitleColorGradientStyleRGB, //切换时整体变深变浅
    YZTitleColorGradientStyleFill,  //切换时颜色深度不变, 移动
} YZTitleColorGradientStyle;


@interface MWSegmentController : UIViewController



#pragma mark ******* 内容


/**
 根据角标，选中对应的控制器
 */
@property (nonatomic, assign) NSInteger selectIndex;

/** 标题间距 */
@property (nonatomic, assign) CGFloat titleMargin; //当传入View数组时间距为0, 默认20

/** 标题间距 */
@property (nonatomic, assign) BOOL scrollAnimation; //点击标题, 内容视图是否有滚动动画, 默认没有

/**************************************内容************************************/

#pragma mark ******* 标题

/**
 标题滚动视图背景颜色
 */
@property (nonatomic, strong) UIColor *titleScrollViewColor;


/**
 标题高度
 */
@property (nonatomic, assign) CGFloat titleHeight;

/**
 标题宽度(外部需要设定固定宽度)
 */
@property (nonatomic, assign) CGFloat titleWidth;

/**
 正常标题颜色
 */
@property (nonatomic, strong) UIColor *norColor;

/**
 选中标题颜色
 */
@property (nonatomic, strong) UIColor *selColor;

/**
 标题字体
 */
@property (nonatomic, strong) UIFont *titleFont;

// 一次性设置所有标题属性
- (void)setUpTitleEffect:(void(^)(UIColor **titleScrollViewColor,UIColor **norColor,UIColor **selColor,UIFont **titleFont,CGFloat *titleHeight, CGFloat *titleWidth))titleEffectBlock;

/**************************************标题************************************/





#pragma mark ******* 下标

/**
 是否需要下标
 */
@property (nonatomic, assign) BOOL isShowUnderLine;


/**
 是否延迟滚动下标
 */
@property (nonatomic, assign) BOOL isDelayScroll;

/**
 下标颜色
 */
@property (nonatomic, strong) UIColor *underLineColor;

/**
 下标高度
 */
@property (nonatomic, assign) CGFloat underLineH;

/**
 下标宽度
 */
@property (nonatomic, assign) CGFloat underLineW;

// 一次性设置所有下标属性
- (void)setUpUnderLineEffect:(void(^)(BOOL *isShowUnderLine, BOOL *isDelayScroll, CGFloat *underLineH, CGFloat *underLineW, UIColor **underLineColor))underLineBlock;

/**************************************下标************************************/





#pragma mark ******* 字体缩放
/**
 字体放大
 */
@property (nonatomic, assign) BOOL isShowTitleScale;

/**
 字体缩放比例
 */
@property (nonatomic, assign) CGFloat titleScale;

// 一次性设置所有字体缩放属性
- (void)setUpTitleScale:(void(^)(BOOL *isShowTitleScale,CGFloat *titleScale))titleScaleBlock;

/**********************************字体缩放************************************/




#pragma mark ******* 颜色渐变

/**
 字体是否渐变
 */
@property (nonatomic, assign) BOOL isShowTitleGradient; //切换时文字是否允许渐变, YZTitleColorGradientStyle

/**
 颜色渐变样式
 */
@property (nonatomic, assign) YZTitleColorGradientStyle titleColorGradientStyle;

/**
 开始颜色,取值范围0~1
 */
@property (nonatomic, assign) CGFloat startR;

@property (nonatomic, assign) CGFloat startG;

@property (nonatomic, assign) CGFloat startB;

/**
 完成颜色,取值范围0~1
 */
@property (nonatomic, assign) CGFloat endR;

@property (nonatomic, assign) CGFloat endG;

@property (nonatomic, assign) CGFloat endB;

// 一次性设置所有颜色渐变属性
- (void)setUpTitleGradient:(void(^)(BOOL *isShowTitleGradient,YZTitleColorGradientStyle *titleColorGradientStyle,CGFloat *startR,CGFloat *startG,CGFloat *startB,CGFloat *endR,CGFloat *endG,CGFloat *endB))titleGradientBlock;

/**********************************颜色渐变************************************/




#pragma mark ******* 遮盖

/**
 是否显示遮盖
 */
@property (nonatomic, assign) BOOL isShowTitleCover;

/**
 遮盖颜色
 */
@property (nonatomic, strong) UIColor *coverColor;

/**
 遮盖圆角半径
 */
@property (nonatomic, assign) CGFloat coverCornerRadius;

// 一次性设置所有遮盖属性
- (void)setUpCoverEffect:(void(^)(BOOL *isShowTitleCover,UIColor **coverColor,CGFloat *coverCornerRadius))coverEffectBlock;

/**********************************遮盖************************************/


@end
