//
//  UICollectionView+Addition.m
//  BeautifulTimes
//
//  Created by 邓永豪 on 16/3/25.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "UICollectionView+Addition.h"

@implementation UICollectionView (Addition)

- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

@end
