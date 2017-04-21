//
//  HQCollectionReusableView.m
//  PanGu
//
//  Created by 王玉 on 2016/10/28.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "HQCollectionReusableView.h"

@implementation HQCollectionReusableView


-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor=[UIColor greenColor];
        [self createBasicView];
    }
    return self;
    
}

- (void)createBasicView{
    
}

- (void)jumpDetailPage:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(jumpDetailPage:)]) {
        [self.delegate jumpDetailPage:sender];
    }
}
@end
