//
//  MWFlowLayout.m
//  MWSegmentController
//
//  Created by caifeng on 2016/12/27.
//  Copyright © 2016年 facaishu. All rights reserved.
//

#import "MWFlowLayout.h"

@implementation MWFlowLayout

- (void)prepareLayout {

    [super prepareLayout];
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    
    if (self.collectionView.bounds.size.height) {
        self.itemSize = self.collectionView.bounds.size;
    }
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
