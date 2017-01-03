//
//  MWSegmentControllerConst.h
//  MWSegmentController
//
//  Created by caifeng on 2016/12/27.
//  Copyright © 2016年 facaishu. All rights reserved.
//

#ifndef MWSegmentControllerConst_h
#define MWSegmentControllerConst_h

// 屏幕尺寸
#define MW_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define MW_ScreenHeight [UIScreen mainScreen].bounds.size.height

// 文字Size
#define MW_TextSize(text,font) [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) \
                                options:NSStringDrawingUsesLineFragmentOrigin attributes:      \
                                @{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size

const static CGFloat MWNavBarHeight = 64;

// 标题栏常量
const static CGFloat MWTitleScrollViewHeight = 40.0;/**<title的高度*/
const static CGFloat MWTitleLabelMargin = 20.0;/**<title的间距*/
const static CGFloat MWTitleLabelFont = 17.0;/**<title的字体大小*/
const static CGFloat MWTitleLabelScale = 1.2;

// 下划线常量
const static CGFloat MWUnderLineViewHeight = 2.0;/**<下划线的高度*/



NSString * const MWContentCollectionCellID = @"CollectionViewCell";

#endif /* MWSegmentControllerConst_h */
