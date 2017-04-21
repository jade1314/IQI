//
//  HangQingCollectionTwoCell.m
//  PanGu
//
//  Created by 王玉 on 2016/12/15.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "HangQingCollectionTwoCell.h"
//#import "SingleStockModel.h"
//#import "GetCategoryPriceListModel.h"
#define KCollHeight 162/2

@implementation HangQingCollectionTwoCell
- (void )setStockData:(id)stockData{
//    _stockData = stockData;
//    if ([stockData isKindOfClass:[SingleStockModel class]]) {
//        
//    }else if ([stockData isKindOfClass:[GetCategoryPriceListModel class]]){
//        GetCategoryPriceListModel *data = stockData;
//        _nameLabel.text =  data.name;//行业名称
//        //    _code = [_data.code substringFromIndex:2];
//        CGFloat rate = [data.riseFall floatValue];
//        _priceLabel.text = [NSString stringWithFormat:@"%.2f%@",rate *100,@"%"];//行业涨跌幅
//        _rateLabel.text =  data.stockName;
//        _persentLabel.text = [NSString stringWithFormat:@"%.2f  %.2f%@",[data.stockPrice floatValue],[data.stockRiseFall floatValue] * 100,@"%"];//股票现价及涨跌幅
//        _priceLabel.textColor = rate < 0 ? COLOR_GREEN : (rate> 0? COLOR_RED:COLOR_LIGHTGRAY);
//        
//    }
    
    
}

- (void)createCell{
    
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.textColor = [UIColor blackColor];
        [self.contentView addSubview:_name];

    }
    return self;
}



@end
