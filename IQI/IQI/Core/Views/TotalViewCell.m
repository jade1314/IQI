//
//  TotalViewCell.m
//  IQI
//
//  Created by 王玉 on 2017/4/20.
//  Copyright © 2017年 orbyun. All rights reserved.
//

#import "TotalViewCell.h"
#define CELLHEIGHT self.contentView.height

@implementation TotalViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
        
    }
    return self;
    
}

- (void)createCell{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, CELLHEIGHT)];
    // 参数一: 直线的终点位置
    
    [path addLineToPoint:CGPointMake(0, CELLHEIGHT- arc4random()%20 )];
    [path addLineToPoint:CGPointMake(kScreenWidth,CELLHEIGHT - arc4random()%20)];
    [path addLineToPoint:CGPointMake(kScreenWidth, CELLHEIGHT)];
    [path fill];
    [path addCurveToPoint:CGPointMake(kScreenWidth/2, CELLHEIGHT) controlPoint1:CGPointMake(kScreenWidth/2, 0) controlPoint2:CGPointZero];
    [[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4] setFill];
    [path stroke];
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - CELLHEIGHT, CELLHEIGHT)];
    CAShapeLayer * _trackLayer = [CAShapeLayer new];
    [self.contentView.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = random_color.CGColor;
    _trackLayer.strokeColor=random_color.CGColor;
    _trackLayer.path = path.CGPath;
    [self.contentView addSubview:_nameLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAttributedForLabelWithStr:(NSArray *)strArr imageName:(NSString *)imageName{
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.contentMode = UIViewContentModeCenter;
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.numberOfLines = 2;
    NSTextAttachment *attch = [[NSTextAttachment alloc]init];
    if (imageName == nil) {
        attch.image = [UIImage imageNamed:[@(arc4random()%135 + 100000) stringValue]];
    }
    attch.bounds = CGRectMake(0, 0, 20, 20);
    
    NSAttributedString *attStr = [NSAttributedString attributedStringWithAttachment:attch];
    NSMutableAttributedString *mutAttStr = [[NSMutableAttributedString alloc]initWithAttributedString:attStr];
    
    NSMutableAttributedString *textString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@",strArr[0]]];
     NSMutableAttributedString *textString1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"---%@",strArr[1]]];
    [mutAttStr appendAttributedString:textString];
    [mutAttStr appendAttributedString:textString1];
    [mutAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, mutAttStr.length)];
    _nameLabel.attributedText = mutAttStr;
    
}

@end
