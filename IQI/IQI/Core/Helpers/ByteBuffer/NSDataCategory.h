//
//  NSDataCategory.h
//  PanGu
//
//  Created by 陈伟平 on 16/7/29.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(DataParser)

//************************************
//读取数据流中的单精度(4个字节的数据)
-(float)readFloatAt:(NSInteger)startIndex;

//************************************
//读取数据流中双精度(8个字节的数据)
-(double)readDoubleAt:(NSInteger)startIndex;

//************************************
//读取数据流中的整型数据(4个字节的数据)
-(int)readIntAt:(NSInteger)startIndex;

//************************************
//读取数据流中的整型数据(8个字节的数据)
-(int64_t)readInt64At:(NSInteger)startIndex;

//************************************
//读取数据流中的短整型数据(2个字节的数据)
-(short)readshortAt:(NSInteger)startIndex;

//************************************
//读取数据流中的短整型数据(1个字节的数据)
-(short)readByteAt:(NSInteger)startIndex;

//************************************
//读取数据流中压缩整型数据(字节数不定)
-(NSInteger) readCompressIntAt:(NSNumber **)startIndex;

//************************************
//读取数据流中压缩long型数据(字节数不定)
-(int64_t) readCompressLongAt:(NSNumber **)startIndex;

//************************************
//读取数据流中压缩日期数据(4个字节的数据)
-(int64_t) readCompressDateTimeAt:(NSInteger)startIndex;

@end
