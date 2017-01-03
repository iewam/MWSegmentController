//
//  MWTitleLabel.m
//  MWSegmentController
//
//  Created by caifeng on 2016/12/27.
//  Copyright © 2016年 facaishu. All rights reserved.
//

#import "MWTitleLabel.h"

@implementation MWTitleLabel

- (void)drawRect:(CGRect)rect {

    [super drawRect:rect];
    [_fillColor set];
    rect.size.width = rect.size.width * _blendSacle;
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}


- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void)setBlendSacle:(CGFloat)blendSacle {

    _blendSacle = blendSacle;
    [self setNeedsDisplay];
}

@end
