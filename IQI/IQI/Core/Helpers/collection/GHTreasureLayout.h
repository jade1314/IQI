//
//  GHTreasureLayout.h
//  TimerCells
//
//  Created by JunhuaShao on 14/11/21.
//  Copyright (c) 2014年 JunhuaShao. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kTreasureWidth = 145;
static const CGFloat kTreasureHeight = 225;

static const CGFloat kBannerWidth = 320;
static const CGFloat kBannerHeight = 181.5;

static const CGFloat kHeaderWidth = 320;
static const CGFloat kHeaderHeight = 210;

@class GHTreasureLayout;
@protocol GHTreasureLayoutDataSource <NSObject>

- (CGRect)treasureLayout:(GHTreasureLayout *)layout eachFrameForItemAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)collectionViewContentSize:(GHTreasureLayout *)layout;
@end

@interface GHTreasureLayout : UICollectionViewFlowLayout
@property (weak, nonatomic) id<GHTreasureLayoutDataSource> dataSource;
// 是否有滚动banner
@property (assign, nonatomic) BOOL haveCoverFlow;


@end
