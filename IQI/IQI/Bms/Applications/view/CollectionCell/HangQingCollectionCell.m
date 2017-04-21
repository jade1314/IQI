//
//  HangQingCollectionCell.m
//  PanGu
//
//  Created by 王玉 on 16/6/26.
//  strongright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "HangQingCollectionCell.h"


@implementation HangQingCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.textColor = [UIColor blackColor];
        [self.contentView addSubview:_name];
    }
    return self;
}

- (void)drawCollectionSixCell{
    
}

- (void)drawColeectionThreeCell{

}

- (void)drawCellRect{
    
}

@end
