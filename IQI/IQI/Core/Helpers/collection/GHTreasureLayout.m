//
//  GHTreasureLayout.m
//  TimerCells
//
//  Created by JunhuaShao on 14/11/21.
//  Copyright (c) 2014年 JunhuaShao. All rights reserved.
//

#import "GHTreasureLayout.h"

@implementation GHTreasureLayout
- (void)prepareLayout
{
    [super prepareLayout];
}

// collectionView 显示范围
- (CGSize)collectionViewContentSize{
    
    if ([self.dataSource respondsToSelector:@selector(collectionViewContentSize:)]) {
        
        return [self.dataSource collectionViewContentSize:self];
    } else {
        return CGSizeZero;
    }
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        attribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        attribute.frame = CGRectMake(0, 0, kHeaderWidth, kHeaderHeight);
    }
    
    return attribute;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //修改 每个cell的attribute
    UICollectionViewLayoutAttributes *attribue = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if ([self.dataSource respondsToSelector:@selector(treasureLayout:eachFrameForItemAtIndexPath:)]) {
        attribue.frame = [self.dataSource treasureLayout:self eachFrameForItemAtIndexPath:indexPath];
    }
    return attribue;
}

//设置 每个cell 的attribute
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    for (int j = 0; j < [self.collectionView numberOfSections]; j++) {
        
        NSIndexPath *HeaderIndexPath = [NSIndexPath indexPathForRow:0 inSection:j];
        
        if (self.haveCoverFlow) {
            [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:HeaderIndexPath]];
        }
        
        for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:j]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:j];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    
    return attributes;
}


@end
