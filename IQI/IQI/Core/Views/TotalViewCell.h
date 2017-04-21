//
//  TotalViewCell.h
//  IQI
//
//  Created by 王玉 on 2017/4/20.
//  Copyright © 2017年 orbyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TotalViewCell : UITableViewCell
@property (nonatomic,strong) UILabel * nameLabel;

- (void)setAttributedForLabelWithStr:(NSArray *)strArr imageName:(NSString *)imageName;
@end
