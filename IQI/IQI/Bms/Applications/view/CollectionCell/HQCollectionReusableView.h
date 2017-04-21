//
//  HQCollectionReusableView.h
//  PanGu
//
//  Created by 王玉 on 2016/10/28.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQCollectionReusableViewDelegate <NSObject>

- (void)jumpDetailPage:(id)sender;

@end

@interface HQCollectionReusableView : UICollectionReusableView
@property (nonatomic,weak) id <HQCollectionReusableViewDelegate> delegate;




@end
