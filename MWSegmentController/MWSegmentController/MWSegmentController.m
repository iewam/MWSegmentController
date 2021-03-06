//
//  MWSegmentController.m
//  MWSegmentController
//
//  Created by caifeng on 2016/12/27.
//  Copyright © 2016年 facaishu. All rights reserved.
//

#import "MWSegmentController.h"
#import "MWSegmentControllerConst.h"
#import "MWFlowLayout.h"
#import "UIView+Frame.h"
#import "MWTitleLabel.h"

@interface MWSegmentController ()<UICollectionViewDataSource,UICollectionViewDelegate>

/** 整体内容View 包含标题好内容滚动视图 */
@property (nonatomic, weak) UIView *contentView;

/** 标题滚动视图 */
@property (nonatomic, weak) UIScrollView *titleScrollView;

/** 内容滚动视图 */
@property (nonatomic, weak) UICollectionView *contentScrollView;

/** 所有标题数组 */
@property (nonatomic, strong) NSMutableArray *titleLabels;

/** 所以标题宽度数组 */
@property (nonatomic, strong) NSMutableArray *titleWidths;

/** 下标视图 */
@property (nonatomic, weak) UIView *underLine;

/** 标题遮盖视图 */
@property (nonatomic, weak) UIView *coverView;

/** 记录上一次内容滚动视图偏移量 */
@property (nonatomic, assign) CGFloat lastOffsetX;

/** 记录是否点击 */
@property (nonatomic, assign) BOOL isClickTitle;

/** 记录是否在动画 */
@property (nonatomic, assign) BOOL isAniming;

/* 是否初始化 */
@property (nonatomic, assign) BOOL isInitial;

/** 计算上一次选中角标 */
@property (nonatomic, assign) NSInteger selIndex;

@end

@implementation MWSegmentController


- (instancetype)init {
    if (self = [super init]) {
        [self initial];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initial];
}

- (void)initial {
    // 初始化标题高度
    _titleHeight = MWTitleScrollViewHeight; //44, 赋初值
    _titleWidth = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setUp {
    if (_isShowTitleGradient && _titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
        
        // 初始化颜色渐变
        if (_endR == 0 && _endG == 0 && _endB == 0) {
            _endR = 1;
        }
    }
}


#pragma mark - 懒加载

- (UIFont *)titleFont {
    if (_titleFont == nil) {
        _titleFont = [UIFont systemFontOfSize:MWTitleLabelFont];
    }
    return _titleFont;
}


- (NSMutableArray *)titleWidths {
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}

- (UIColor *)norColor {
    if (_isShowTitleGradient && _titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
        _norColor = [UIColor colorWithRed:_startR green:_startG blue:_startB alpha:1];
    }
    
    if (_norColor == nil){
        _norColor = [UIColor blackColor];
    }
    
    
    return _norColor;
}

- (UIColor *)selColor {
    if (_isShowTitleGradient && _titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
        _selColor = [UIColor colorWithRed:_endR green:_endG blue:_endB alpha:1];
    }
    
    if (_selColor == nil) _selColor = [UIColor redColor];
    
    return _selColor;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        UIView *coverView = [[UIView alloc] init];
        
        coverView.backgroundColor = _coverColor ? _coverColor : [UIColor lightGrayColor];
        
        coverView.layer.cornerRadius = _coverCornerRadius;
        
        [self.titleScrollView insertSubview:coverView atIndex:0];
        
        _coverView = coverView;
    }
    return _isShowTitleCover ? _coverView : nil;
}

- (UIView *)underLine {
    if (_underLine == nil) {
        
        UIView *underLineView = [[UIView alloc] init];
        
        underLineView.backgroundColor = _underLineColor ? _underLineColor : [UIColor redColor];
        
        [self.titleScrollView addSubview:underLineView];
        _underLine = underLineView;
        
    }
    return _isShowUnderLine?_underLine : nil;
}

- (NSMutableArray *)titleLabels {
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

// 懒加载标题滚动视图
- (UIScrollView *)titleScrollView
{
    if (_titleScrollView == nil) {
        
        UIScrollView *titleScrollView = [[UIScrollView alloc] init];
        
        titleScrollView.backgroundColor = _titleScrollViewColor ? _titleScrollViewColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        
        [self.contentView addSubview:titleScrollView];
        
        _titleScrollView = titleScrollView;
        
    }
    return _titleScrollView;
}

// 懒加载内容滚动视图
- (UICollectionView *)contentScrollView
{
    if (_contentScrollView == nil) {
        
        // 创建布局
        MWFlowLayout *flowLayout = [[MWFlowLayout alloc] init];
        
        UICollectionView *contentScrollView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _contentScrollView = contentScrollView;
        // 设置内容滚动视图
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        _contentScrollView.delegate = self;
        _contentScrollView.dataSource = self;
        [self.contentView insertSubview:contentScrollView belowSubview:self.titleScrollView];
        
    }
    
    return _contentScrollView;
}

// 懒加载整个内容view
- (UIView *)contentView
{
    if (_contentView == nil) {
        
        UIView *contentView = [[UIView alloc] init];
        _contentView = contentView;
        [self.view addSubview:contentView];
        
    }
    
    return _contentView;
}



#pragma mark - 属性setter方法
- (void)setIsShowTitleScale:(BOOL)isShowTitleScale {
    if (_isShowUnderLine) {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"YZDisplayViewControllerException" reason:@"字体放大效果和角标不能同时使用。" userInfo:nil];
        [excp raise];
    }
    
    _isShowTitleScale = isShowTitleScale;
}

- (void)setIsShowUnderLine:(BOOL)isShowUnderLine
{
    if (_isShowTitleScale) {
        // 抛异常
        NSException *excp = [NSException exceptionWithName:@"YZDisplayViewControllerException" reason:@"字体放大效果和角标不能同时使用。" userInfo:nil];
        [excp raise];
    }
    
    _isShowUnderLine = isShowUnderLine;
}

- (void)setTitleScrollViewColor:(UIColor *)titleScrollViewColor
{
    _titleScrollViewColor = titleScrollViewColor;
    
    self.titleScrollView.backgroundColor = titleScrollViewColor;
}

// 设置整体内容的尺寸
- (void)setUpContentViewFrame:(void (^)(UIView *))contentBlock {
    if (contentBlock) {
        contentBlock(self.contentView);
    }
}

// 一次性设置所有颜色渐变属性
- (void)setUpTitleGradient:(void (^)(BOOL *, YZTitleColorGradientStyle *, CGFloat *, CGFloat *, CGFloat *, CGFloat *, CGFloat *, CGFloat *))titleGradientBlock {
    if (titleGradientBlock) {
        titleGradientBlock(&_isShowTitleGradient,&_titleColorGradientStyle,&_startR,&_startG,&_startB,&_endR,&_endG,&_endB);
    }
}

// 一次性设置所有遮盖属性
- (void)setUpCoverEffect:(void (^)(BOOL *, UIColor **, CGFloat *))coverEffectBlock {
    UIColor *color;
    
    if (coverEffectBlock) {
        
        coverEffectBlock(&_isShowTitleCover,&color,&_coverCornerRadius);
        
        if (color) {
            _coverColor = color;
        }
        
    }
}

// 一次性设置所有字体缩放属性
- (void)setUpTitleScale:(void(^)(BOOL *isShowTitleScale,CGFloat *titleScale))titleScaleBlock {
    if (titleScaleBlock) {
        titleScaleBlock(&_isShowTitleScale,&_titleScale);
    }
}

// 一次性设置所有下标属性
- (void)setUpUnderLineEffect:(void(^)(BOOL *isShowUnderLine, BOOL *isDelayScroll, CGFloat *underLineH, CGFloat *underLineW, UIColor **underLineColor))underLineBlock
{
    UIColor *underLineColor;
    
    if (underLineBlock) {
        underLineBlock(&_isShowUnderLine, &_isDelayScroll, &_underLineH, &_underLineW, &underLineColor);
        
        _underLineColor = underLineColor;
    }
    
}

// 一次性设置所有标题属性
- (void)setUpTitleEffect:(void(^)(UIColor **titleScrollViewColor,UIColor **norColor,UIColor **selColor,UIFont **titleFont,CGFloat *titleHeight, CGFloat *titleWidth))titleEffectBlock {
    
    UIColor *titleScrollViewColor;
    UIColor *norColor;
    UIColor *selColor;
    UIFont *titleFont;
    if (titleEffectBlock) {
        titleEffectBlock(&titleScrollViewColor, &norColor, &selColor, &titleFont, &_titleHeight, &_titleWidth);
        _norColor = norColor;
        _selColor = selColor;
        _titleScrollViewColor = titleScrollViewColor;
        _titleFont = titleFont;
        _underLineW = _titleWidth ? _titleWidth : 0;
    }
}

#pragma mark - 控制器view生命周期方法

//在这里设置contentView, titleScrollView, contentScrollView的frame
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat contentY = self.navigationController ? MWNavBarHeight : [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat contentW = MW_ScreenWidth;
    CGFloat contentH = MW_ScreenHeight - contentY;
    // 设置整个内容的尺寸
    if (self.contentView.height == 0) {
        // 没有设置内容尺寸，才需要设置内容尺寸 setIsfullScreen/setUpContentViewFrame 可以设置
        self.contentView.frame = CGRectMake(0, contentY, contentW, contentH);
    }
    
    // 设置标题滚动视图frame
    // 计算尺寸
    CGFloat titleH = _titleHeight ? _titleHeight : MWTitleScrollViewHeight;
    CGFloat titleY = 0;
    self.titleScrollView.frame = CGRectMake(0, titleY, contentW, titleH);
    
    // 设置内容滚动视图frame
    CGFloat contentScrollY = CGRectGetMaxY(self.titleScrollView.frame);
    self.contentScrollView.frame = CGRectMake(0, contentScrollY, contentW, self.contentView.height - contentScrollY);
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_isInitial == NO) {
        
        _isInitial = YES;
        
        // 注册cell
        [self.contentScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MWContentCollectionCellID];
        self.contentScrollView.backgroundColor = self.view.backgroundColor;
        
        // 初始化
        [self setUp];
        
        // 没有子控制器，不需要设置标题
        if (self.childViewControllers.count == 0) return;
        
        [self setUpTitleWidth];
        
        [self setUpAllTitle];
        
    }
    
    
}

#pragma mark - 添加标题方法
// 计算所有标题宽度, 存入titleWidths 和 标题间的间隙
- (void)setUpTitleWidth
{
    // 判断是否能占据整个屏幕
    NSUInteger count = self.childViewControllers.count;
    
    NSArray *titles = [self.childViewControllers valueForKeyPath:@"title"];
    
    CGFloat totalWidth = 0;
    
    for (NSString *title in titles) {
        
        if ([title isKindOfClass:[NSNull class]]) {
            // 抛异常
            NSException *excp = [NSException exceptionWithName:@"YZDisplayViewControllerException" reason:@"没有设置Controller.title属性，应该把子标题保存到对应子控制器中" userInfo:nil];
            [excp raise];
            
        }
        
        CGRect titleBounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
        
        //如果有指定宽度用指定宽度
        CGFloat width = self.titleWidth ? self.titleWidth : titleBounds.size.width;
        
        [self.titleWidths addObject:@(width)];
        
        totalWidth += width;
    }
    
    
    if (totalWidth > MW_ScreenWidth) {  //总宽度大于屏幕,
        
        //        _titleMargin =  margin;
        if (!_titleMargin) { //如果没有指定margin,
            _titleMargin = _titleWidth ? 0 : MWTitleLabelMargin;
        }
        
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
        
    } else {
        //如果所有View的label宽度还不到屏幕宽度, 算每个间隙多宽, 要是不到20用20, 大于20均分
        CGFloat titleMargin = (MW_ScreenWidth - totalWidth) / (count + 1);
        
        if (_titleWidth) {
            if (_underLineW == _titleWidth) {
                _underLineW = MW_ScreenWidth/count;
            }
            _titleMargin = 0;
            _titleWidth = MW_ScreenWidth/count;
            [self.titleWidths removeAllObjects];
            for (NSInteger i = 0; i < count; i++) {
                [self.titleWidths addObject:@(_titleWidth)];
            }
            
            return;
        }
        
        if (!_titleMargin) {
            if (titleMargin < MWTitleLabelMargin) {
                _titleMargin = MWTitleLabelMargin;
            } else {
                if (_underLineW == _titleWidth) {
                    _underLineW = MW_ScreenWidth/count;
                }
                _titleMargin = 0;
                _titleWidth = MW_ScreenWidth/count;
                [self.titleWidths removeAllObjects];
                for (NSInteger i = 0; i < count; i++) {
                    [self.titleWidths addObject:@(_titleWidth)];
                }
                
            }
            
            _titleMargin = _titleWidth ? 0 : _titleMargin;
        }
        
        self.titleScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, _titleMargin);
    }
    
    
}


// 设置所有标题 及 titleScrollView.contentSize / contentScrollView.
- (void)setUpAllTitle
{
    
    // 遍历所有的子控制器
    NSUInteger count = self.childViewControllers.count;
    
    // 添加所有的标题
    CGFloat viewW = 0;
    CGFloat viewH = self.titleHeight;
    CGFloat viewX = 0;
    CGFloat viewY = 0;
    
    for (int i = 0; i < count; i++) {
        
        UIViewController *vc = self.childViewControllers[i];
        
        UILabel *label = [[MWTitleLabel alloc] init];
        
        //            label.backgroundColor = [UIColor colorWithRed:random()%255/255.0 green:random()%255/255.0 blue:random()%255/255.0 alpha:1];
        
        label.tag = i;
        
        // 设置按钮的文字颜色
        label.textColor = self.norColor;
        
        label.font = self.titleFont;
        
        // 设置按钮标题
        label.text = vc.title;
        
        viewW = [self.titleWidths[i] floatValue];
        
        // 设置按钮位置
        UILabel *lastLabel = [self.titleLabels lastObject];
        
        viewX = _titleMargin + CGRectGetMaxX(lastLabel.frame);
        
        label.frame = CGRectMake(viewX, viewY, viewW, viewH);
        
        // 监听标题的点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewClick:)];
        [label addGestureRecognizer:tap];
        
        // 保存到数组
        [self.titleLabels addObject:label];
        [self.titleScrollView addSubview:label];
        [self.titleScrollView insertSubview:label belowSubview:self.underLine];
        
        if (i == _selectIndex) {
            [self titleViewClick:tap];
        }
        
        // 设置标题滚动视图的内容范围
        if (i == count - 1) {
            _titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(label.frame), 0);
            _titleScrollView.showsHorizontalScrollIndicator = NO;
            _contentScrollView.contentSize = CGSizeMake(count * MW_ScreenWidth, 0);
        }
    }
    
}

#pragma mark - 标题效果渐变方法(滑动中调用)
// 设置标题颜色渐变
- (void)setUpTitleColorGradientWithOffset:(CGFloat)offsetX rightLabel:(MWTitleLabel *)rightLabel leftLabel:(MWTitleLabel *)leftLabel
{
    if (_isShowTitleGradient == NO) return;
    
    // 获取右边缩放
    CGFloat rightSacle = offsetX / MW_ScreenWidth - leftLabel.tag;
    
    // 获取左边缩放比例
    CGFloat leftScale = 1 - rightSacle;
    
    // RGB渐变
    if (_titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
        
        CGFloat r = _endR - _startR;
        CGFloat g = _endG - _startG;
        CGFloat b = _endB - _startB;
        
        // rightColor
        // 1 0 0
        UIColor *rightColor = [UIColor colorWithRed:_startR + r * rightSacle green:_startG + g * rightSacle blue:_startB + b * rightSacle alpha:1];
        
        // 0.3 0 0
        // 1 -> 0.3
        // leftColor
        UIColor *leftColor = [UIColor colorWithRed:_startR +  r * leftScale  green:_startG +  g * leftScale  blue:_startB +  b * leftScale alpha:1];
        
        // 右边颜色
        rightLabel.textColor = rightColor;
        
        // 左边颜色
        leftLabel.textColor = leftColor;
        
        return;
    }
    
    // 填充渐变
    if (_titleColorGradientStyle == YZTitleColorGradientStyleFill) {
        
        // 获取移动距离
        CGFloat offsetDelta = offsetX - _lastOffsetX;
        
        if (offsetDelta > 0) { // 往右边
            
            
            rightLabel.fillColor = self.selColor;
            rightLabel.blendSacle = rightSacle;
            
            leftLabel.fillColor = self.norColor;
            leftLabel.blendSacle = rightSacle;
            
        } else if(offsetDelta < 0){ // 往左边
            
            rightLabel.textColor = self.norColor;
            rightLabel.fillColor = self.selColor;
            rightLabel.blendSacle = rightSacle;
            
            leftLabel.textColor = self.selColor;
            leftLabel.fillColor = self.norColor;
            leftLabel.blendSacle = rightSacle;
            
        }
    }
}

// 标题缩放
- (void)setUpTitleScaleWithOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    if (_isShowTitleScale == NO) return;
    
    // 获取右边缩放
    CGFloat rightSacle = offsetX / MW_ScreenWidth - leftLabel.tag;
    
    CGFloat leftScale = 1 - rightSacle;
    
    CGFloat scaleTransform = _titleScale?_titleScale:MWTitleLabelScale;
    
    scaleTransform -= 1;
    
    // 缩放按钮
    leftLabel.transform = CGAffineTransformMakeScale(leftScale * scaleTransform + 1, leftScale * scaleTransform + 1);
    
    // 1 ~ 1.3
    rightLabel.transform = CGAffineTransformMakeScale(rightSacle * scaleTransform + 1, rightSacle * scaleTransform + 1);
}

// 获取两个标题按钮宽度差值
- (CGFloat)widthDeltaWithRightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel {
    
    CGRect titleBoundsR = [rightLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    CGRect titleBoundsL = [leftLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    return titleBoundsR.size.width - titleBoundsL.size.width;
}

// 设置下标偏移
- (void)setUpUnderLineOffset:(CGFloat)offsetX rightLabel:(UIView *)rightLabel leftLabel:(UIView *)leftLabel
{
    if (_isClickTitle) return;
    
    // 获取两个标题中心点距离
    CGFloat xDelta = _titleWidth ? _titleWidth + _titleMargin : rightLabel.x - leftLabel.x;
    
    // 标题宽度差值
    CGFloat widthDelta = [self widthDeltaWithRightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel];

    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    
    // 计算当前下划线偏移量, offsetX将要移动一个屏幕宽度, 上面的标题下标只会移动centerDelta, 即两个标题中心的距离, 要计算屏幕移动的同时下标移动多少, 先算出centerDelta / MW_ScreenWidth, 将centerDelta拆成屏幕宽度份(320份), 乘以屏幕移动的offsetDelta
    CGFloat underLineTransformX = xDelta / MW_ScreenWidth * offsetDelta;
    
    // 宽度递增偏移量
    CGFloat underLineWidth = _underLineW ? 0 : widthDelta / MW_ScreenWidth * offsetDelta;
    
    self.underLine.width += underLineWidth;
    self.underLine.center = CGPointMake(self.underLine.center.x + underLineTransformX, self.underLine.center.y);
    
    //    self.underLine.x += underLineTransformX;
}

// 设置遮盖偏移
- (void)setUpCoverOffset:(CGFloat)offsetX rightLabel:(UILabel *)rightLabel leftLabel:(UILabel *)leftLabel
{
    if (_isClickTitle) return;
    
    // 获取两个标题中心点距离
    CGFloat centerDelta = rightLabel.x - leftLabel.x;
    
    // 标题宽度差值
    CGFloat widthDelta = [self widthDeltaWithRightLabel:rightLabel leftLabel:leftLabel];
    
    // 获取移动距离
    CGFloat offsetDelta = offsetX - _lastOffsetX;
    
    // 计算当前下划线偏移量
    CGFloat coverTransformX = offsetDelta * centerDelta / MW_ScreenWidth;
    
    // 宽度递增偏移量
    CGFloat coverWidth = offsetDelta * widthDelta / MW_ScreenWidth;
    
    self.coverView.width += coverWidth;
    self.coverView.x += coverTransformX;
    
}

#pragma mark - 标题点击处理
- (void)setSelectIndex:(NSInteger )selectIndex
{
    _selectIndex = selectIndex;
    if (self.titleLabels.count) {
        
        UILabel *label = self.titleLabels[selectIndex];
        
        [self titleViewClick:[label.gestureRecognizers lastObject]];
    }
}

// 标题按钮点击 (可能是Label或者View)
- (void)titleViewClick:(UITapGestureRecognizer *)tap
{
    // 记录是否点击标题
    _isClickTitle = YES;
    
    // 获取对应标题label
    UIView *titleView = (UIView *)tap.view;
    
    // 获取当前角标
    NSInteger i = titleView.tag;
    
    // 选中label
    [self selectTitleView:titleView];
    
    // 内容滚动视图滚动到对应位置
    CGFloat offsetX = i * MW_ScreenWidth;
    
    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:_scrollAnimation];
    
    // 记录上一次偏移量,因为点击的时候不会调用scrollView代理记录，因此需要主动记录
    _lastOffsetX = offsetX;
    
    _selIndex = i;
    
    // 点击事件处理完成
    _isClickTitle = NO;
}

- (void)selectTitleView:(UIView *)view
{
    
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *realLabel = (UILabel *)view;
        
        for (MWTitleLabel *labelView in self.titleLabels) {
            
            if (realLabel == labelView) continue;
            
            if (_isShowTitleGradient && _titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
                
                labelView.transform = CGAffineTransformIdentity;
            }
            
            labelView.textColor = self.norColor;
            
            if (_isShowTitleGradient && _titleColorGradientStyle == YZTitleColorGradientStyleFill) {
                
                labelView.fillColor = self.norColor;
                
                labelView.blendSacle = 1;
            }
            
        }
        
        // 标题缩放
        if (_isShowTitleScale && _titleColorGradientStyle == YZTitleColorGradientStyleRGB) {
            
            CGFloat scaleTransform = _titleScale ? _titleScale: MWTitleLabelScale;
            
            realLabel.transform = CGAffineTransformMakeScale(scaleTransform, scaleTransform);
        }
        
        // 修改标题选中颜色
        realLabel.textColor = self.selColor;
        
        // 设置标题居中
        [self setLabelTitleCenter:realLabel];
        
        // 设置下标的位置
        [self setUpUnderLine:realLabel];
        
        // 设置cover
        [self setUpCoverView:realLabel];
        
    } else {
        
        // 设置标题居中
        [self setLabelTitleCenter:view];
        
        // 设置下标的位置
        [self setUpUnderLine:view];
    }
    
}

// 设置蒙版
- (void)setUpCoverView:(UILabel *)label
{
    // 获取文字尺寸
    CGRect titleBounds = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    
    CGFloat border = 5;
    CGFloat coverH = titleBounds.size.height + 2 * border;
    CGFloat coverW = titleBounds.size.width + 2 * border;
    
    self.coverView.y = (label.height - coverH) * 0.5;
    self.coverView.height = coverH;
    
    
    // 最开始不需要动画
    if (self.coverView.x == 0) {
        self.coverView.width = coverW;
        
        self.coverView.x = label.x - border;
        return;
    }
    
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.width = coverW;
        
        self.coverView.x = label.x - border;
    }];
    
    
    
}

// 设置下标的位置
- (void)setUpUnderLine:(UIView *)label
{
    // 获取文字尺寸
    CGRect titleBounds;
    if ([label isKindOfClass:[UILabel class]]) {
        UILabel *realLabel = (UILabel *)label;
        titleBounds = [realLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titleFont} context:nil];
    }
    
    CGFloat underLineH = _underLineH ? _underLineH : MWUnderLineViewHeight;
    
    CGFloat underLineW;
    
    underLineW = _underLineW ? _underLineW : titleBounds.size.width;
    
    self.underLine.y = label.height - underLineH;
    self.underLine.height = underLineH;
    
    
    // 最开始不需要动画
    if (self.underLine.x == 0) {
        self.underLine.width = underLineW;
        self.underLine.center = CGPointMake(label.centerX, self.underLine.center.y);
        //        self.underLine.x = label.x;
        return;
    }
    
    // 点击时候需要动画
    [UIView animateWithDuration:0.25 animations:^{
        self.underLine.width = underLineW;
        self.underLine.center = CGPointMake(label.centerX, self.underLine.center.y);
        //        self.underLine.x = label.x;
    }];
    
}

// 让选中的按钮居中显示
- (void)setLabelTitleCenter:(UIView *)label
{
    
    // 设置标题滚动区域的偏移量, 如果点击的label超过屏幕一般的位置, 要把它移动到中间, 即为偏移量
    CGFloat offsetX = label.center.x - MW_ScreenWidth * 0.5;
    
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.titleScrollView.contentSize.width - MW_ScreenWidth + _titleMargin;
    
    if (maxOffsetX < 0) {
        maxOffsetX = 0;
    }
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    // 滚动区域
    [self.titleScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MWContentCollectionCellID forIndexPath:indexPath];
    
    // 移除之前的子控件
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 添加控制器
    UIViewController *vc = self.childViewControllers[indexPath.row];
    
    vc.view.frame = CGRectMake(0, 0, self.contentScrollView.width, self.contentScrollView.height);
    
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

// 减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger offsetXInt = offsetX;
    NSInteger screenWInt = MW_ScreenWidth;
    
    NSInteger extre = offsetXInt % screenWInt;
    if (extre > MW_ScreenWidth * 0.5) {
        // 往右边移动
        offsetX = offsetX + (MW_ScreenWidth - extre);
        _isAniming = YES;
        [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else if (extre < MW_ScreenWidth * 0.5 && extre > 0){
        _isAniming = YES;
        // 往左边移动
        offsetX =  offsetX - extre;
        [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    
    // 获取角标
    NSInteger i = offsetX / MW_ScreenWidth;
    
    [self selectTitleView:self.titleLabels[i]];
    
}


// 监听滚动动画是否完成
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _isAniming = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 点击和动画的时候不需要设置
    NSInteger count = self.titleLabels.count;

    if (_isAniming || count == 0) return;
    
    // 获取偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 获取左边角标
    NSInteger leftIndex = offsetX / MW_ScreenWidth;
    // 右边角标
    NSInteger rightIndex = leftIndex + 1;
    
    // 左边按钮
    MWTitleLabel *leftLabel = self.titleLabels[leftIndex];
    
    // 右边按钮
    MWTitleLabel *rightLabel = nil;
    
    if (rightIndex < self.titleLabels.count) {
        rightLabel = self.titleLabels[rightIndex];
    }
    
    // 字体放大
    [self setUpTitleScaleWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 设置下标偏移
    if (_isDelayScroll == NO) { // 延迟滚动，不需要移动下标
        
        [self setUpUnderLineOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    }
    
    // 设置遮盖偏移
    [self setUpCoverOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 设置标题渐变
    [self setUpTitleColorGradientWithOffset:offsetX rightLabel:rightLabel leftLabel:leftLabel];
    
    // 记录上一次的偏移量
    _lastOffsetX = offsetX;
}

@end
