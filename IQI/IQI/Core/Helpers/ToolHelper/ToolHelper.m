//
//  ToolHelper.m
//  xiangyunDemo
//
//  Created by 陈伟平 on 16/5/6.
//  Copyright © 2016年 陈伟平. All rights reserved.
//

#import "ToolHelper.h"
#import "vm_statistics.h"
#import "mach_host.h"
#import "mach_init.h"
#include <sys/mount.h>
#include <sys/param.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CommonCrypto/CommonDigest.h>

//年月日
#define YEAR_MONTH_DAY_RANGE        NSMakeRange(0, 10)
//30天
#define DAYNUMBERS                  30.0
//尺寸
#define kFullScreenSize            [UIScreen mainScreen].bounds.size
#define kFullScreenWidth           [UIScreen mainScreen].bounds.size.width
#define kFullScreenHeight          [UIScreen mainScreen].bounds.size.height
//获取物理屏幕的尺寸
#define kScreenHeight              ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth               ([UIScreen mainScreen].bounds.size.width)
//数据持久化
#define defaults                   [NSUserDefaults standardUserDefaults]
//文件管理
#define FILE_MANAGER               [NSFileManager defaultManager]
//存储时间
#define currentNowTime              @"currentNowTime"

@implementation ToolHelper

//去掉发表文字前的空格或者回车符
+(NSString *)DelbeforeBlankAndEnter:(NSString *)str1
{
    //    BOOL isStringtoSpace=YES;//是否是空格
    NSString *newstr = @"";
    NSString *strSpace =@" ";
    NSString *strEnter =@"\n";
    NSString *string;
    for(int i =0;i<[str1 length];i++)    {
        string = [str1 substringWithRange:NSMakeRange(i, 1)];//抽取子字符
        if((![string isEqualToString:strSpace])&&(![string isEqualToString:strEnter])){//判断是否为空格
            newstr = [str1 substringFromIndex:i];
            //            isStringtoSpace=NO; //如果是则改变 状态
            break;//结束循环
        }
    }
    return newstr;
    
}
//去掉发表文字后的空格或者回车符
+(NSString *)DelbehindEnterAndBlank:(NSString *)str2
{
    NSString *newstr = @"";
    NSString *newString = @" ";
    NSString *strEnter =@"\n";
    NSString *string;
    for(long i =[str2 length]-1;i>=0;i--)    {
        string = [str2 substringWithRange:NSMakeRange(i, 1)];//抽取子字符
        if((![string isEqualToString:strEnter])&&(![string isEqualToString:newString])){//判断是否为空格和回车
            newstr = [str2 substringToIndex:(i + 1)];
            break;//结束循环
        }
    }
    return newstr;
    
}

//去掉发表文字前的回车符
+(NSString *)DelbeforeEnter:(NSString *)str1
{
    //    BOOL isStringtoSpace=YES;//是否是空格
    NSString *newstr = @"";
    NSString *strEnter =@"\n";
    NSString *string;
    for(int i =0;i<[str1 length];i++)    {
        string = [str1 substringWithRange:NSMakeRange(i, 1)];//抽取子字符
        if(![string isEqualToString:strEnter]){//判断是否为空格
            newstr = [str1 substringFromIndex:i];
            //            isStringtoSpace=NO; //如果是则改变 状态
            break;//结束循环
        }
    }
    return newstr;
    
}
//去掉发表文字后的回车符
+(NSString *)DelbehindEnter:(NSString *)str2
{
    NSString *newstr = @"";
    NSString *strEnter =@"\n";
    NSString *string;
    for(long i =[str2 length]-1;i>=0;i--)    {
        string = [str2 substringWithRange:NSMakeRange(i, 1)];//抽取子字符
        if(![string isEqualToString:strEnter]){//判断是否为空格和回车
            newstr = [str2 substringToIndex:(i + 1)];
            break;//结束循环
        }
    }
    return newstr;
    
}

//股票6位转成8位
+(NSString *)judgeStockCode:(NSString *)code market:(NSString *)market {
    
    NSString *code_2 = [code substringToIndex:2];
    NSString *code_3 = [code substringToIndex:3];
    
    if ([market isEqualToString:@"1"]) {
        if ([code_2 isEqualToString:@"60"]) {
            return kString_Format(@"11%@", code); // 沪市A股
        } else if ([code_3 isEqualToString:@"900"]) {
            return kString_Format(@"12%@", code);// 沪市B股
        } else if ([code_3 isEqualToString:@"019"] || //
                   [code_3 isEqualToString:@"122"] || //
                   [code_3 isEqualToString:@"130"] || //
                   [code_3 isEqualToString:@"126"] || //
                   [code_3 isEqualToString:@"110"] || //
                   [code_3 isEqualToString:@"113"] ||
                   [code_3 isEqualToString:@"204"]) {
            return kString_Format(@"13%@", code); // 沪市债券
        } else if ([code_2 isEqualToString:@"51"] || [code_2 isEqualToString:@"50"]) {
            return kString_Format(@"15%@", code); // 沪市基金
        } else if ([code_2 isEqualToString:@"00"]) {
            return kString_Format(@"10%@", code); // 沪市指数
        } else {
            return kString_Format(@"16%@", code); // 其他
        }
    } else if ([market isEqualToString:@"2"]) {
        // 000xxx、002xxx、300xxx
        if ([code_2 isEqualToString:@"2"]) {
            return kString_Format(@"22%@", code); // 深市B股
        } else if ([code_2 isEqualToString:@"39"]) {
            return kString_Format(@"20%@", code); // 深市指数
        } else if ([code_3 isEqualToString:@"300"]) {
            return kString_Format(@"26%@", code); // 深市创业板
        } else if ([code_3 isEqualToString:@"002"]) {
            return kString_Format(@"27%@", code); // 深市中小板
        } else if ([code_2 isEqualToString:@"15"] || [code_2 isEqualToString:@"16"] || [code_2 isEqualToString:@"118"]) {
            return kString_Format(@"24%@", code); // 深市基金
        } else if ([code_2 isEqualToString:@"10"] || [code_2 isEqualToString:@"111"] ||
                   [code_2 isEqualToString:@"112"] || [code_2 isEqualToString:@"115"] ||
                   [code_2 isEqualToString:@"125"] || [code_2 isEqualToString:@"131"]) {
            return kString_Format(@"23%@", code); // 深市债券
        }else if ([code_2 isEqualToString:@"00"]) {
            return kString_Format(@"21%@", code);// 深市A股
        }else {
            return kString_Format(@"28%@", code);
        }
    }
    return nil;
}
//判断字体大小
+(CGRect)stringRectWithSize:(CGSize)size fontSize:(CGFloat)font withString:(NSString *)string{
    CGRect rect = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect;
}
//数据颜色
+(UIColor *)colorWithValue:(double)gains{
    
    if (gains > 0) {
        return WATER_RED;
    }else if (gains < 0) {
        return WATER_GREEN;
    }else {
        return COLOR_LIGHTGRAY;
    }
}
//处理格式
+(NSString *)getNumberStr:(NSString *)numberStr {
    
    return kString_Format(@"%.2f元", [numberStr floatValue]);
}

//处理数值(全部保留两位小数)
+(NSString *)getNumberLargeInTwo:(NSString *)numberStr{
    
    CGFloat number = [numberStr floatValue];
    
    if (number >= 0) {
        if (number >= 10000 && number < 100000000) {
            return kString_Format(@"%.2f万", number / 10000 );
        }else if (number > 100000000) {
            return kString_Format(@"%.2f亿", number / 100000000);
        }else {
            return kString_Format(@"%.2f", number);
        }
    }else {
        number = fabs(number);
        if (number >= 10000 && number < 100000000) {
            return kString_Format(@"-%.2f万", number / 10000);
        }else if (number > 100000000) {
            return kString_Format(@"-%.2f亿", number / 100000000);
        }else {
            return kString_Format(@"-%.2f", number);
        }
    }
}
//用于股票“量”的规范格式
+(NSString *)stockNumber:(NSString *)numberStr{
    
    CGFloat number = [numberStr floatValue];
    
    if (number >= 0) {
        // 从10万开始规范格式
        if (number >= 100000 && number < 100000000) {
            return kString_Format(@"%.2f万", number / 10000 );
        }else if (number > 100000000) {
            return kString_Format(@"%.2f亿", number / 100000000);
        }else {
            return kString_Format(@"%.f", number);
        }
    }else {
        number = fabs(number);
        // 从10万开始规范格式
        if (number >= 100000 && number < 100000000) {
            return kString_Format(@"-%.2f万", number / 10000);
        }else if (number > 100000000) {
            return kString_Format(@"-%.2f亿", number / 100000000);
        }else {
            return kString_Format(@"-%.f", number);
        }
    }
}

//处理数值(全部保留两位小数)
+(NSString *)getNumberLargeInTwoYuan:(NSString *)numberStr{
    
    CGFloat number = [numberStr floatValue];
    
    if (number >= 0) {
        if (number >= 10000 && number < 100000000) {
            return kString_Format(@"%.2f万元", number / 10000 );
        }else if (number > 100000000) {
            return kString_Format(@"%.2f亿元", number / 100000000);
        }else {
            return kString_Format(@"%.2f元", number);
        }
    }else {
        number = fabs(number);
        if (number >= 10000 && number < 100000000) {
            return kString_Format(@"-%.2f万元", number / 10000);
        }else if (number > 100000000) {
            return kString_Format(@"-%.2f亿元", number / 100000000);
        }else {
            return kString_Format(@"-%.2f元", number);
        }
    }
}

//处理数值
+(NSString *)getNumberLarge:(NSString *)numberStr {
    
    CGFloat number = [numberStr floatValue];
    if (number >= 0) {
        if (number >= 10000 && number < 100000000) {
            return kString_Format(@"%.2f万", number / 10000 );
        }else if (number > 100000000) {
            return kString_Format(@"%.2f亿", number / 100000000);
        }else {
            return kString_Format(@"%.0f", number);
        }
    }else {
        number = fabs(number);
        if (number >= 10000 && number < 100000000) {
            return kString_Format(@"-%.2f万", number / 10000);
        }else if (number > 100000000) {
            return kString_Format(@"-%.2f亿", number / 100000000);
        }else {
            return kString_Format(@"-%.0f", number);
        }
    }
}
//处理数值
+(NSString *)getFundNumberLarge:(NSString *)numberStr {
    
    CGFloat number = [numberStr floatValue];
    if (number >= 0) {
        if (number >= 10000 && number < 100000000) {
            return kString_Format(@"%.f万", number / 10000 );
        }else if (number > 100000000) {
            return kString_Format(@"%.2f亿", number / 100000000);
        }else {
            return numberStr;
        }
    }else {
        number = fabs(number);
        if (number >= 10000 && number < 100000000) {
            return kString_Format(@"-%.f万", number / 10000);
        }else if (number > 100000000) {
            return kString_Format(@"-%.2f亿", number / 100000000);
        }else {
            return kString_Format(@"-%@", numberStr);
        }
    }
}
//取固定值
+(NSString *)nineClockInNow:(NSString *)str{
    
    if (str.length >=16) {
        str = [str substringWithRange:NSMakeRange(11, 4)];
    }
    return str;

}
//固定时间格式
+(NSString *)timeFormatProcessing:(NSString *)str {
    
    NSMutableString *tempStr = [str mutableCopy];
    if (tempStr.length >= 6) {
        [tempStr insertString:@"-" atIndex:6];
        [tempStr insertString:@"-" atIndex:4];
    }
    return tempStr;
}

+(NSString *)minutesFormatProcessing:(NSString *)str {
    
    if (str.length == 5) {
        str = [@"0" stringByAppendingString:str];
    }
    
    NSMutableString *tempStr = [str mutableCopy];
    if (tempStr.length >= 5) {
        [tempStr insertString:@":" atIndex:2];
        [tempStr insertString:@":" atIndex:5];
    }
    return tempStr;
}
+(NSString *)timeAndMinutesFormatProcessing:(NSString *)str{
    
    //除掉字符中的空字符串 和特定字符
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"：" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSMutableString *tempStr = [str mutableCopy];
    if (tempStr.length >= 14) {
        [tempStr insertString:@"-" atIndex:4];
        [tempStr insertString:@"-" atIndex:7];
        [tempStr insertString:@" " atIndex:10];
        [tempStr insertString:@":" atIndex:13];
        [tempStr insertString:@":" atIndex:16];
    }
    return tempStr;
}




//判断是属于哪一年那一日
+(NSString *)judgeQuarterly:(NSString *)date{
    NSString *newDate;
    NSArray *dateArr = [date componentsSeparatedByString:@"-"];
    if (dateArr.count < 2) {
        return @"季报";
    }
    newDate = [NSString stringWithFormat:@"%@",dateArr[1]];
    
    if ([newDate intValue] == 1 || [newDate intValue] == 2 || [newDate intValue] == 3 ) {
        newDate = [[NSString stringWithFormat:@"%@",dateArr[0]] stringByAppendingString:@" 一季报"];
    }else if ([newDate intValue] == 4 || [newDate intValue] == 5 || [newDate intValue] == 6 ){
        newDate = [[NSString stringWithFormat:@"%@",dateArr[0]] stringByAppendingString:@" 二季报"];
    }else if ([newDate intValue] == 7 || [newDate intValue] == 8 || [newDate intValue] == 9 ){
        newDate = [[NSString stringWithFormat:@"%@",dateArr[0]] stringByAppendingString:@" 三季报"];
    }else if ([newDate intValue] == 10 || [newDate intValue] == 11 || [newDate intValue] == 12 ){
        newDate = [[NSString stringWithFormat:@"%@",dateArr[0]] stringByAppendingString:@" 四季报"];
    }else{
        newDate = @"季报";
    }
    return newDate;
}
//获得分时x轴的241个点
+(NSArray *)setSomeDayXValsData {
    
    int timeHour = 9;
    int timeMinutes = 30;
    NSString *timeH;
    NSString *timeM;
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i <= 240; i++) {
        
        timeH = kString_Format(@"%d", timeHour);
        timeM = kString_Format(@"%d", timeMinutes);
        if (timeM.length < 2) {
            [tempArr addObject:[NSString stringWithFormat:@"%d0%@", timeHour, timeM]];
        }else {
            [tempArr addObject:[NSString stringWithFormat:@"%@%d", kString_Format(@"%d", timeHour).length == 1 ? kString_Format(@"0%d", timeHour) : kString_Format(@"%d", timeHour), timeMinutes]];
        }
        timeMinutes ++;
        if (timeMinutes == 60) {
            timeHour ++;
            timeMinutes = 0;
        }
        if (timeMinutes == 31 && timeHour == 11) {
            timeHour = 13;
            timeMinutes = 01;
        }
    }
    return tempArr;
}

//返回距 1970年到现在的秒数
+(NSString *) getNowTimeWithLongType{
    return [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
}

//返回距 1970年到现在的秒数
+(UInt64) getSecondsFromTimeString:(NSString *)_str{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date =  [formatter dateFromString:_str];
    return  [date timeIntervalSince1970];
}
//返回距 1970年到现在的秒数
+(UInt64) getSecondsFromTime:(NSDate *)_date{
    return  [_date timeIntervalSince1970];
}
//返回距 1970年到xx时间的的毫秒数
+(NSString *) getGiveTimeWithLongType:(NSDate *)timer{
    
    return [NSString stringWithFormat:@"%ld000", (long)[timer timeIntervalSince1970]];
}

//返回距 1970年到xx时间的的毫秒数
+(NSString *) getGiveTimeWithLongType1:(NSDate *)timer{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSString *date =  [formatter stringFromDate:timer];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    return timeLocal;
}
//返回1970年到当前时间的的毫秒数
+(UInt64) getCurrentMilliSecondsTime{
    return [[NSDate date] timeIntervalSince1970]*1000;
}


+ (NSString *)getNowDate:(TimeFormat)timeFormat {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (timeFormat == yyyy_MM_dd) {
        [dateFormatter setDateFormat:@"yyyyMMdd"];
    }else if (timeFormat == HH_mm_ss) {
        [dateFormatter setDateFormat:@"HHmmss"];
    }
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}
+ (NSString *)getNowDate {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}



//毫秒转换成日期时间
+(NSDate *)longTimeChangeToDate:(NSString *)longTime
{
    //     [[NSDate date] timeIntervalSince1970] 是可以获取到后面的毫秒 微秒的 ，只是在保存的时候省略掉了， 如一个时间戳不省略的情况下为 1395399556.862046 ，省略掉后为一般所见 1395399556 。所以想取得毫秒时用获取到的时间戳 *1000 ，想取得微秒时 用取到的时间戳 * 1000 * 1000 。
    double d = [longTime doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:d/1000];//这里传入秒数;
}


//根据类型返回时间
+(NSString *) getStringTimeWithDataTime:(NSDate*)_date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dataString = [dateFormatter stringFromDate:_date];
    return dataString;
}

//计算流逝的时间 参数为一个标准格式的时间字符串
+(NSString *) calulatePassTime:(NSString *) timeText
{
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * d= [date dateFromString:timeText];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    NSTimeInterval now=[[NSDate date] timeIntervalSince1970]*1;
    
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    if (cha < 60) {
        timeString= @"刚刚";
    }else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }  else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }  else if (cha/86400>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        
        if ([timeString compare:@"1"] == NSOrderedSame)  {
            return @"昨天";
        }else if ([timeString compare:@"2"] == NSOrderedSame) {
            return @"前天";
        } else {
            return [timeText substringWithRange:NSMakeRange(5,5)];
        }
    }
    return timeString;
}
/*
 下拉刷新时间显示
 0分钟00秒-0分钟59秒   1分钟前；
 1分钟00秒-1分钟59秒   1分钟前；
 ⋯⋯                  ⋯⋯
 58分钟00秒-58分钟59秒 59分钟前；
 59分钟00秒-59分钟59秒 1小时前；
 1小时00分00秒-1小时59分钟59秒  2小时前；
 ⋯⋯
 22小时00分00秒-22小时59分钟59秒 23小时前；
 23小时00分00秒-23小时59分钟59秒 1天前；
 1天00小时00分00秒-1天23小时59分59秒 2天前
 （n-1）天00小时00分00秒-（n-1）天23小时59分59秒 N天前
 */
//计算流逝的时间 参数为一个标准格式的时间字符串2
+(NSString *) calulatePassTime2:(NSDate *)timeDate toTime:(NSDate *)timeDate2
{
    NSTimeInterval late=[timeDate2 timeIntervalSince1970]*1;
    NSTimeInterval now=[timeDate timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    if (cha<120) {
        timeString = @"1分钟前";
    }  else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }  else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }  else if (cha/86400>1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
    }
    return timeString;
}

/*
 信息广场时间显示
 0分钟00秒-0分钟59秒   1分钟前；
 1分钟00秒-1分钟59秒   1分钟前；
 ⋯⋯                  ⋯⋯
 58分钟00秒-58分钟59秒 59分钟前；
 59分00秒-23小时59分钟59秒 今天 HH：MM
 之后时间                  MM-DD HH：MM
 */
//计算流逝的时间 参数为一个标准格式的时间字符串2
+(NSString *) calulatePassTime3:(NSString *) timeText
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * d = [date dateFromString:timeText];
    NSTimeInterval late = [d timeIntervalSince1970];
    NSTimeInterval now =[[NSDate date] timeIntervalSince1970];
    NSString *currentStr = [date stringFromDate:[NSDate date]];
    NSString *todayStr = [NSString stringWithFormat:@"%@00:00:00",[currentStr substringWithRange:NSMakeRange(0, 11)]];
    NSDate *todayDate= [date dateFromString:todayStr];
    NSTimeInterval todaySecond = [todayDate timeIntervalSince1970];
    NSString *timeString=@"";
    NSTimeInterval cha = now-late;
    if (cha<120) {
        timeString = @"1分钟前";
    }  else if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
    }  else if (cha/3600>1&&cha/86400<1) {
        if (late > todaySecond) {
            //            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            timeString = [NSString stringWithFormat:@"今天 %@",[timeText substringWithRange:NSMakeRange(11,5)]];
        }else{
            //            timeString = [NSString stringWithFormat:@"%f", cha/3600];
            timeString = [NSString stringWithFormat:@"昨天 %@",[timeText substringWithRange:NSMakeRange(11,5)]];
        }
    }  else if (cha/86400>1) {
        //        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeText substringWithRange:NSMakeRange(5,11)];;
    }
    return timeString;
}

/*
 0小时0分钟00秒- 23小时59分钟59秒 今天HH:MM
 之后时间  几月几日 HH:MM
 */
+(NSString *) calulatePassTime5:(NSString *) timeText;
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *releaseDate= [dateFormatter dateFromString:timeText];
    // NSString *currentStr = [dateFormatter stringFromDate:[NSDate date]];
    // NSString *todayStr = [NSString stringWithFormat:@"%@00:00:00",[currentStr substringWithRange:NSMakeRange(0, 11)]];
    // NSDate *todayDate= [dateFormatter dateFromString:todayStr];
    
    NSInteger TimeDifference =  3600 * 24 - ([[timeText substringWithRange:NSMakeRange(11, 2)] integerValue] * 3600 + [[timeText substringWithRange:NSMakeRange(14, 2)] integerValue] * 60 + [[timeText substringWithRange:NSMakeRange(17, 2)] integerValue]);
    NSTimeInterval cha = [[NSDate date] timeIntervalSinceDate:releaseDate];
    //    NSTimeInterval todaySecond = [todayDate timeIntervalSince1970];
    //    NSTimeInterval releaseSecond = [releaseDate timeIntervalSince1970];
    NSString* timeString = @"";
    if (cha < TimeDifference) {
        timeString = [NSString stringWithFormat:@"今天%@", [timeText substringWithRange:NSMakeRange(11, 5)]];
    }else if (cha >= TimeDifference)
    {
        timeString = [NSString stringWithFormat:@"%@月%@日%@", [timeText substringWithRange:NSMakeRange(5, 2)], [timeText substringWithRange:NSMakeRange(8, 2)], [timeText substringWithRange:NSMakeRange(11, 5)]];
        NSString * str = [NSString stringWithFormat:@"%@", [timeString substringWithRange:NSMakeRange( 0, 2)]];
        if ([str intValue] < 10) {
            timeString = [NSString stringWithFormat:@"%@", [timeString substringWithRange:NSMakeRange( 1, [timeString length] - 1)]];
        }
    }
    return timeString;
}


/*
 - 0分钟00秒-0分钟59秒   1分钟前；
 - 1分钟00秒-1分钟59秒   1分钟前；
 - ⋯⋯                  ⋯⋯
 - 59分钟00秒-59分钟59秒 59分钟前；
 - 1小时0分00秒-23小时59分钟59秒 今天 HH：MM
 - 之后时间                  MM-DD HH：MM
 */
+(NSString *) caculateRuleTime:(NSString *) timeText
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *releaseDate= [dateFormatter dateFromString:timeText];
    NSString *currentStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *todayStr = [NSString stringWithFormat:@"%@00:00:00",[currentStr substringWithRange:NSMakeRange(0, 11)]];
    NSDate *todayDate= [dateFormatter dateFromString:todayStr];
    NSTimeInterval cha = [[NSDate date] timeIntervalSinceDate:releaseDate];
    NSTimeInterval todaySecond = [todayDate timeIntervalSince1970];
    NSTimeInterval releaseSecond = [releaseDate timeIntervalSince1970];
    NSString* timeString = @"";
    if (cha < 3600) {
        int minite = (int)cha;
        minite = minite/60;
        if (0 >= minite) {
            minite = 1;
        }
        timeString= [NSString stringWithFormat:@"%d分钟前",minite];
    } else if (cha>=3600 && releaseSecond > todaySecond) {
        timeString=[NSString stringWithFormat:@"今天 %@", [timeText substringWithRange:NSMakeRange(11, 5)]];
    } else {
        timeString = [timeText substringWithRange:NSMakeRange(5, 11)];
    }
    return timeString;
}

+ (NSInteger)compareStartTime:(NSString *)startTim endTime:(NSString *)endTim
{
    NSDateFormatter* format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate=[format dateFromString:startTim];
    NSDate *endDate=[format dateFromString:endTim];
    return [startDate compare:endDate];
}

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)img
{
    UIImage *newImage = nil;
    CGSize imageSize = img.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [img drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
//还原图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
// 修改图片旋转问题
+(UIImage *) fixOrientationWithImage:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch ((int)image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch ((int)image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//获取设备系统版本
+(NSString *) getSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

//当前手机系统版本
+ (NSString *) getIOSVersion
{
    return [NSString stringWithFormat:@"%.2f",[[[UIDevice currentDevice] systemVersion] floatValue]];
}
+ (float)getCurrentIOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
//当前手机类型
+(NSString *)getDeviceModel
{
    return [[UIDevice currentDevice] model];
}
+ (NSString *)getDeviceUUID
{
    //    NSString *uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_UUID];
    //    if(uuidStr && [uuidStr length])
    //    {
    //        return uuidStr;
    //    }
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid);
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    //    [[NSUserDefaults standardUserDefaults] setObject:result forKey:DEVICE_UUID];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
/**
 *获取设备名称 如：iPhone6   iPhone6s...
 */
+(NSString*) deviceName {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        
        deviceNamesByCode = @{@"i386"      :@"Simulator",
                              @"x86_64"    :@"Simulator",
                              @"iPod1,1"   :@"iPod Touch",      // (Original)
                              @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                              @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                              @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                              @"iPod7,1"   :@"iPod Touch",      // (6th Generation)
                              @"iPhone1,1" :@"iPhone",          // (Original)
                              @"iPhone1,2" :@"iPhone",          // (3G)
                              @"iPhone2,1" :@"iPhone",          // (3GS)
                              @"iPad1,1"   :@"iPad",            // (Original)
                              @"iPad2,1"   :@"iPad 2",          //
                              @"iPad3,1"   :@"iPad",            // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",        // (GSM)
                              @"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",       //
                              @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                              @"iPad3,4"   :@"iPad",            // (4th Generation)
                              @"iPad2,5"   :@"iPad Mini",       // (Original)
                              @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",   //
                              @"iPhone7,2" :@"iPhone 6",        //
                              @"iPhone8,1" :@"iPhone 6S",       //
                              @"iPhone8,2" :@"iPhone 6S Plus",  //
                              @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5"   :@"iPad Mini",       // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7"   :@"iPad Mini"        // (3rd Generation iPad Mini - Wifi (model A1599))
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found on database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    return deviceName;
}
/**
 * 剩余内存
 */
+(NSUInteger) freeMemory
{
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics");
    
    natural_t   mem_free = vm_stat.free_count * (unsigned int)pagesize;
    
    return mem_free;
}
//总磁盘空间
+(NSString *)getTotalDiskSpace{
    
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    
    return [self formattedFileSize:freeSpace];
}
//剩余磁盘空间
+(NSString *)getFreeDiskSpace{
    
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    
    return [self formattedFileSize:freeSpace];
}

#pragma mark - platform information  获取平台信息
+ (NSUInteger)getAvailableMemory  //iphone下获取可用的内存大小
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if(kernReturn != KERN_SUCCESS)
        return NSNotFound;
    return (vm_page_size * vmStats.free_count / 1024.0) / 1024.0;
}



//键盘音效
+(void) playKeyBordSound
{
    AudioServicesPlaySystemSound(1306);
}

+(void) playVibrateSound
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
}

+(void) playVibrateAndNoticeAlertSound
{
    AudioServicesPlaySystemSound(1007);//提醒加震动
}
static void completionCallback(SystemSoundID sound_id, void* user_data){
    AudioServicesDisposeSystemSoundID(sound_id);
    CFRelease (user_data);    //CFURLCreateWithFileSystemPath()创建的需释放
    CFRunLoopStop (CFRunLoopGetCurrent());
}
+(void) playNoticeAlertSound
{
    SystemSoundID soundFileObject;
    CFBundleRef mainBundle;
    mainBundle = CFBundleGetMainBundle ();
    
    // Get the URL to the sound file to play
    CFURLRef soundFileURLRef  = CFBundleCopyResourceURL (
                                                         mainBundle,
                                                         CFSTR ("msgTritone"),
                                                         CFSTR ("caf"),
                                                         NULL
                                                         );
    // Create a system sound object representing the sound file
    AudioServicesCreateSystemSoundID (
                                      soundFileURLRef,
                                      &soundFileObject
                                      );
    // Add sound completion callback
    AudioServicesAddSystemSoundCompletion (soundFileObject, NULL, NULL,completionCallback,(void*)soundFileURLRef);
    // Play the audio
    AudioServicesPlaySystemSound(soundFileObject);
    
    
    //      AudioServicesPlayAlertSound(1007);//提醒声音
}

#if 0
//与设置模块声音/震动/活动通知 业务相关
+(void) playSettingSound{
    if (![defaults boolForKey:USER_BROTHER_TIME_STAUTS]) {
        if ([defaults boolForKey:USER_NOTICE_VOICE_STAUTS] && [defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]) {
            [ToolHelper playVibrateAndNoticeAlertSound];
        }else if([defaults boolForKey:USER_NOTICE_VOICE_STAUTS]){
            [ToolHelper playNoticeAlertSound];
        }else if([defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]){
            [ToolHelper playVibrateSound];
        }
    }else{
        NSInteger form = [defaults integerForKey:USER_BROTHER_TIME_FORM];
        NSInteger to = [defaults integerForKey:USER_BROTHER_TIME_TO];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString * dataString = [dateFormatter stringFromDate:[NSDate date]];
        NSInteger time = [[dataString substringWithRange:NSMakeRange(11, 2)] integerValue];
        [dateFormatter release];
        
        if (form < to) {//9-11点
            if (time>=form && time<to) {//勿扰时段   11-24｜0-9 可扰 9-11勿扰
            }else{
                if ([defaults boolForKey:USER_NOTICE_VOICE_STAUTS] && [defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]) {
                    [ToolHelper playVibrateAndNoticeAlertSound];
                }else if([defaults boolForKey:USER_NOTICE_VOICE_STAUTS]){
                    [ToolHelper playNoticeAlertSound];
                }else if([defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]){
                    [ToolHelper playVibrateSound];
                }
            }
        }else {//11-9点
            if (time<form && time>=to) { //勿扰时段   11-24｜0-9 勿扰  9-11可扰
                if ([defaults boolForKey:USER_NOTICE_VOICE_STAUTS] && [defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]) {
                    [ToolHelper playVibrateAndNoticeAlertSound];
                }else if([defaults boolForKey:USER_NOTICE_VOICE_STAUTS]){
                    [ToolHelper playNoticeAlertSound];
                }else if([defaults boolForKey:USER_NOTICE_VIBRATE_STATUS]){
                    [ToolHelper playVibrateSound];
                }
            }
        }
    }
}
#endif
//判断字符串是否为空
+(NSString *)strIsEmpty:(NSString *)str {
    if (str == nil || str == NULL || str.class == [NSNull class]) {
        return @"0";
    }else {
        return str;
    }
}
//判断字符串是否为空
+(BOOL)isEmptyString:(NSString*)string{
    BOOL bRet=NO;
    NSString * newString;
    @try {
        newString = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if(nil == string
           || string.length ==0
           || [string isEqualToString:@""]
           || [string isEqualToString:@"<null>"]
           || [string isEqualToString:@"(null)"]
           || [string isEqualToString:@"null"]
           || newString.length ==0
           || [newString isEqualToString:@""]
           || [newString isEqualToString:@"<null>"]
           || [newString isEqualToString:@"(null)"]
           || [newString isEqualToString:@"null"]
           ){
            bRet=YES;
        }else{
            bRet=NO;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"失败 %@: %@", [exception name], [exception reason]);
        
    } @finally {
        return bRet;
    }
}

//字符串判空
+(BOOL) isBlankString:(NSString *)string {
    
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqual:[NSNull null]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    //    if (string.length==0) {
    //        return YES;
    //    }
    return NO;
}

+ (int)textLength:(NSString *)text//计算字符串长度
{
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
    {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            number++;
        } else {
            number = number + 0.5;
        }
    }
    return ceil(number);
}

#pragma mark 计算字符串大小
+ (CGSize)sizeForNoticeTitle:(NSString*)text font:(UIFont*)font{
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat maxWidth = screen.size.width;
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    
    CGSize textSize = CGSizeZero;
    // iOS7以后使用boundingRectWithSize，之前使用sizeWithFont
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // 多行必需使用NSStringDrawingUsesLineFragmentOrigin，网上有人说不是用NSStringDrawingUsesFontLeading计算结果不对
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        
        CGRect rect = [text boundingRectWithSize:maxSize
                                         options:opts
                                      attributes:attributes
                                         context:nil];
        textSize = rect.size;
    }
    else{
        textSize = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return textSize;
}

#pragma mark 计算字符串大小
+ (CGFloat)heightForText:(NSString*)text font:(UIFont*)font{
    CGSize maxSize = CGSizeMake(kScreenWidth - 40, CGFLOAT_MAX);
    CGSize textSize = CGSizeZero;
    // iOS7以后使用boundingRectWithSize，之前使用sizeWithFont
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // 多行必需使用NSStringDrawingUsesLineFragmentOrigin，网上有人说不是用NSStringDrawingUsesFontLeading计算结果不对
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        
        CGRect rect = [text.length > 23 * 10 ? [text substringFromIndex:23  * 10]:text boundingRectWithSize:maxSize
                                         options:opts
                                      attributes:attributes
                                         context:nil];
        textSize = rect.size;
    }
    else{
        textSize = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return textSize.height + 111;
}

#pragma mark - 判断字符串中是否存emoji在表情
+ (BOOL)judgeEmoji:(NSString *)text
{
    __block BOOL isEomji = NO;
    [text enumerateSubstringsInRange:NSMakeRange(0, [text length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}

+ (UIImage *)imageToExtent:(UIImage *)img  withTop:(CGFloat) top withBottom:(CGFloat) bottom
                  withLeft:(CGFloat) left withRight:(CGFloat) right{
    if ([img respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        // 指定为拉伸模式，伸缩后重新赋值
        img = [img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
    }
    return img;
}

//_imageSize 为CGSizeZero时,原图大小
//图片压缩比_size小
//写入到 tmp 文件夹中
//返回图片路径
+(NSString *) image:(UIImage *)_img changeToSize:(CGSize)_imageSize size:(int)_size
{
    NSString *tmpDic = NSTemporaryDirectory();
    
    //以时间命名图片
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init] ;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ;
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    
    NSString *_image_Path  =  [tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    CGFloat image_small_v = 1.0;
    
    if (CGSizeEqualToSize(_imageSize,CGSizeZero)) {
        
        if (_img.size.width>120 || _img.size.height > 120) {
            image_small_v = 0.6f;
        }
        
        NSData *imageData = UIImageJPEGRepresentation(_img, image_small_v);
        
        if (imageData.length>668328 && imageData.length<=868328) {
            image_small_v = 0.1;
        }else if(imageData.length>868328){
            image_small_v = 0.01;
        }else if (imageData.length<=668328 && imageData.length>468328){
            image_small_v = 0.3;
        } else if(imageData.length<468328 && imageData.length > 330844 ){
            image_small_v = 0.4;
        }
        while (imageData.length > _size  && image_small_v >=0.001f) {
            NSLog(@"imagesize: %lu, %f",(unsigned long)imageData.length,image_small_v);
            imageData =  UIImageJPEGRepresentation(_img, image_small_v);
            image_small_v -= 0.1f;
        }
        [imageData writeToFile:_image_Path atomically:YES];
        
    }else{
        
        UIImage *_image_s = [ToolHelper imageByScalingAndCroppingForSize:_imageSize image:_img];
        
        NSData *imageData = UIImageJPEGRepresentation(_image_s, image_small_v);
        
        while (imageData.length > _size  && image_small_v >0.01f) {
            image_small_v -= 0.1f;
            if (image_small_v<0.001f) {
                image_small_v = 0.001f;
            }
            imageData =  UIImageJPEGRepresentation(_image_s, image_small_v);
        }
        
        [imageData writeToFile:_image_Path atomically:YES];
    }
    //    });
    return _image_Path;
}




+(NSString *) imageToPost:(UIImage *)_img imagePlanSize:(CGFloat)_imagePlanSize imageContentSize:(int)_contentSize
{
    if (_imagePlanSize < 0.000001) {
        return nil;
    }
    
    NSString *tmpDic = NSTemporaryDirectory();
    
    //以时间命名图片
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    
    NSString *_image_Path  =  [tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
    CGFloat image_small_v = 0.8;
    UIImage *_image_s =  nil;
    
    if (_img.size.height*_img.size.width < _imagePlanSize) {//518400.0f = 720*720
        _image_s = _img;
    }else {
        
        CGSize _imageSize = CGSizeMake(720, 720);
        CGFloat lv = sqrt(_img.size.width*_img.size.height/_imagePlanSize);
        _imageSize.width = _img.size.width/lv ;
        _imageSize.height = _img.size.height/lv ;
        
        UIGraphicsBeginImageContext(_imageSize); // this will crop
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = CGPointMake(0, 0);
        thumbnailRect.size.width= _imageSize.width + 10;
        thumbnailRect.size.height = _imageSize.height + 10;
        [_img drawInRect:thumbnailRect];
        _image_s = UIGraphicsGetImageFromCurrentImageContext();
        if(_image_s == nil)
            NSLog(@"could not scale image");
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    }
    NSData *imageData = UIImageJPEGRepresentation(_image_s, image_small_v);
    while (imageData.length > _contentSize  && image_small_v >0.01f) {
        CGFloat s = ((imageData.length/_contentSize) - 1.0f);
        if (s < 0.1f) {
            s = 0.1f;
        }else if( s < 0.5f && s > 0.1f){
            s = 0.2f;
        }else if( s > 0.5f && s < 1.0f){
            s = 0.4f;
        }else if(s > 1.0f){
            s = 0.6f;
        }
        image_small_v -= s;
        if (image_small_v < 0.001f) {
            image_small_v = 0.001f;
        }
        imageData =  UIImageJPEGRepresentation(_image_s, image_small_v);
    }
    [imageData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;
}

+(UIImage *)imageToPost:(UIImage *)img imageContentSize:(int)contentSize{
    CGFloat image_small_v = 0.8;
    NSData *imageData = UIImageJPEGRepresentation(img, image_small_v);
    while (imageData.length > contentSize  && image_small_v >0.01f) {
        CGFloat s = ((imageData.length/contentSize) - 1.0f);
        if (s < 0.1f) {
            s = 0.1f;
        }else if( s < 0.5f && s > 0.1f){
            s = 0.2f;
        }else if( s > 0.5f && s < 1.0f){
            s = 0.4f;
        }else if(s > 1.0f){
            s = 0.6f;
        }
        image_small_v -= s;
        if (image_small_v < 0.001f) {
            image_small_v = 0.001f;
        }
        imageData =  UIImageJPEGRepresentation(img, image_small_v);
        
    }
    
    return [UIImage imageWithData:imageData];
    
}
+(NSString *)imageNewMethodToMake:(UIImage *)_img{
    
    if (_img == nil || _img == NULL) {
        return nil;
    }
    NSString *tmpDic = NSTemporaryDirectory();
    
    //以时间命名图片
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    
    NSString *_image_Path  =  [tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    if (_img.size.width > 640.0f) {
        
        CGSize size = CGSizeMake(640.0f, (_img.size.height/(_img.size.width/640.0f)));
        
        UIGraphicsBeginImageContext(size); // this will crop
        CGRect thumbnailRect = CGRectZero;
        thumbnailRect.origin = CGPointMake(0, 0);
        thumbnailRect.size.width= size.width + 10;
        thumbnailRect.size.height = size.height + 10;
        [_img drawInRect:thumbnailRect];
        UIImage *_image_s = UIGraphicsGetImageFromCurrentImageContext();
        if(_image_s == nil)
            NSLog(@"could not scale image");
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
    }
    NSData *imageData = UIImageJPEGRepresentation(_img, 1.0);
    if (imageData.length > 80*1024) {
        NSData *imageData_S = UIImageJPEGRepresentation(_img, 0.3);
        [imageData_S writeToFile:_image_Path atomically:YES];
    }else{
        [imageData writeToFile:_image_Path atomically:YES];
    }
    return _image_Path;
}

+ (NSString *)fileOfImage:(UIImage *)image
{
    NSString *tmpDic = NSTemporaryDirectory();
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    NSData *imageDataJPG = UIImageJPEGRepresentation(image, 1.0);
    [imageDataJPG writeToFile:_image_Path atomically:YES];
    return _image_Path;
}
+ (NSString *)fileOfPressedImage:(UIImage *)image{
    NSString *tmpDic = NSTemporaryDirectory();
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    CGSize imageSize = image.size;
    if (imageSize.width>640) {
        imageSize.height = imageSize.height/(imageSize.width/640);
        imageSize.width = 640;
        UIGraphicsBeginImageContext(imageSize);
        [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *pressSizeData = UIImageJPEGRepresentation(image, 0.9);
        if (pressSizeData.length>80*1024){
            pressSizeData = UIImageJPEGRepresentation(scaledImage, 0.3);
        }
        [pressSizeData writeToFile:_image_Path atomically:YES];
        return _image_Path;
    }
    NSData *pressSizeData = UIImageJPEGRepresentation(image, 0.9);
    if (pressSizeData.length>80*1024){
        pressSizeData = UIImageJPEGRepresentation(image, 0.3);
    }
    [pressSizeData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;
}

//白色填充
+ (NSString *)fileOfImgInSquareFillBlankWithWhiteBgAndPressedImage:(UIImage *)image
{
    NSLog(@"%@", NSStringFromCGSize(image.size));
    NSString *tmpDic = NSTemporaryDirectory();
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    CGSize imageSize;
    imageSize.height = kFullScreenWidth;
    imageSize.width = kFullScreenWidth;
    
    UIGraphicsBeginImageContext(imageSize);
    UIBezierPath* p = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,kFullScreenWidth,kFullScreenWidth)];
    [[UIColor whiteColor] setFill];
    [p fill];
    
    NSLog(@"%f,%f",kFullScreenSize.width,kFullScreenSize.height);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImage *imageHavePress = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *pressSizeData = UIImageJPEGRepresentation(imageHavePress, 1.0);
    NSLog(@"%f", pressSizeData.length / 1024.0);
    [pressSizeData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;
    
}
//将图像的中心放在正方形区域的中心，图形未填充的区域用黑色填充，并压缩到80－100k，
+ (NSString *)fileOfImgInSquareFillBlankWithBlackBgAndPressedImage:(UIImage *)image{
    NSLog(@"%@", NSStringFromCGSize(image.size));
    NSString *tmpDic = NSTemporaryDirectory();
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    
    CGSize imageSize;
    imageSize.height = kFullScreenWidth;
    imageSize.width = kFullScreenWidth;
    
    UIGraphicsBeginImageContext(imageSize);
    UIBezierPath* p = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,kFullScreenWidth,kFullScreenWidth)];
    [[UIColor blackColor] setFill];
    [p fill];
    
    //    CGFloat xOriginImgInRect = 0.0;
    //    CGFloat yOriginImgInRect = 0.0;
    //    xOriginImgInRect = (kFullScreenWidth-image.size.width/2)/2;
    //    if (xOriginImgInRect<0.0) {
    //        xOriginImgInRect = 0.0;
    //    }
    //    yOriginImgInRect = (kFullScreenWidth-image.size.height/2)/2;
    //    if (yOriginImgInRect<0.0) {
    //        yOriginImgInRect = 0.0;
    //    }
    
    NSLog(@"%f,%f",kFullScreenSize.width,kFullScreenSize.height);
    
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImage *imageHavePress = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *pressSizeData = UIImageJPEGRepresentation(imageHavePress, 1.0);
    if (pressSizeData.length>80*1024){
        pressSizeData = UIImageJPEGRepresentation(imageHavePress, 0.8);
    }
    [pressSizeData writeToFile:_image_Path atomically:YES];
    
    return _image_Path;
    
    //
    //    NSInteger ratioScale = 1;
    //    while (pressSizeData.length>100*1024) {
    //        ratioScale++;
    //        if (ratioScale==10) {
    //            pressSizeData = UIImageJPEGRepresentation(imageHavePress, 0.05);
    //            break;
    //        }else{
    //            pressSizeData = UIImageJPEGRepresentation(imageHavePress, 1-ratioScale*0.1);
    //        }
    //    }
    //
    //    [pressSizeData writeToFile:_image_Path atomically:YES];
    //    [formatDate release];
    //    [locale release];
    //
    //    return _image_Path;
}

+ (NSString *)fileOfImageData:(NSData *)imageData
{
    NSString *tmpDic = NSTemporaryDirectory();
    NSDate *date = [NSDate date];
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatDate setLocale:locale];
    [formatDate setDateFormat:@"yyyyMMddHHmmss"];
    NSString* dateStr = [formatDate stringFromDate:date];
    NSString *imagelocalName_s = [NSString stringWithFormat:@"%@_s.jpg", dateStr];
    NSString *_image_Path=[tmpDic stringByAppendingPathComponent:imagelocalName_s];
    [imageData writeToFile:_image_Path atomically:YES];
    return _image_Path;
}
+(NSString *) age:(NSString *)_birthday
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *_date= [dateFormat dateFromString:_birthday];
    [dateFormat setDateFormat:@"yyyy"];
    NSString *birthYear = [dateFormat stringFromDate:_date];
    NSDate *current = [NSDate date];
    NSString *currentYear = [dateFormat stringFromDate:current];
    [dateFormat setDateFormat:@"MM"];
    NSString *birthMonth = [dateFormat stringFromDate:_date];
    NSString *currentMonth = [dateFormat stringFromDate:current];
    [dateFormat setDateFormat:@"dd"];
    NSString *birthDay = [dateFormat stringFromDate:_date];
    NSString *currentDay = [dateFormat stringFromDate:current];
    
    int aboutAge = [currentYear intValue]-[birthYear intValue];
    if (aboutAge>0) {
        if ([birthMonth intValue]>[currentMonth intValue]) {
            aboutAge--;
        }else if ([birthDay intValue]>[currentDay intValue] && [birthMonth intValue]==[currentMonth intValue]){
            aboutAge--;
        }
    }
    NSString *age = [NSString stringWithFormat:@"%d",aboutAge];
    return age;
}
+(NSString *) xingzuoToString:(NSString *)_str{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *_date= [dateFormat dateFromString:_str];
    
    NSString *_xingzuo = [ToolHelper xingzuoToDate:_date];
    
    return _xingzuo;
}
+(NSString *) xingzuoToDate:(NSDate *)_date{
    
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"MMdd"];
    
    NSString *timeString= [dateFormat stringFromDate:_date];
    
    long _month = [[timeString substringToIndex:2] integerValue];
    long _day = [[timeString substringFromIndex:2] integerValue];
    
    NSString *_xingzuo = @"";
    
    switch (_month) {
        case 1: {
            if (_day <=19) {
                _xingzuo =  @"摩羯座";
            }else{
                _xingzuo = @"水瓶座";
            } }
            break;
        case 2:{
            if (_day <=18) {
                _xingzuo =  @"水瓶座";
            }else{
                _xingzuo = @"双鱼座";
            } }
            break;
        case 3:{
            if (_day <=20) {
                _xingzuo =  @"双鱼座";
            }else{
                _xingzuo = @"白羊座";
            } }
            break;
        case 4:{
            if (_day <=19) {
                _xingzuo =  @"白羊座";
            }else{
                _xingzuo = @"金牛座";
            } }
            break;
        case 5:{
            if (_day <=20) {
                _xingzuo =  @"金牛座";
            }else{
                _xingzuo = @"双子座";
            } }
            break;
        case 6:{
            if (_day <=21) {
                _xingzuo =  @"双子座";
            }else{
                _xingzuo = @"巨蟹座";
            } }
            break;
        case 7:{
            if (_day <=22) {
                _xingzuo =  @"巨蟹座";
            }else{
                _xingzuo = @"狮子座";
            } }
            
            break;
        case 8:{
            if (_day <=22) {
                _xingzuo =  @"狮子座";
            }else{
                _xingzuo = @"处女座";
            } }
            break;
        case 9:{
            if (_day <=22) {
                _xingzuo =  @"处女座";
            }else{
                _xingzuo = @"天枰座";
            } }
            break;
        case 10:{
            if (_day <=23) {
                _xingzuo =  @"天枰座";
            }else{
                _xingzuo = @"天蝎座";
            } }
            break;
        case 11:{
            if (_day <=22) {
                _xingzuo =  @"天蝎座";
            }else{
                _xingzuo = @"射手座";
            } }
            break;
        case 12:{
            if (_day <=21) {
                _xingzuo =  @"射手座";
            }else{
                _xingzuo = @"摩羯座";
            } }
            break;
        default:
            break;
    }
    return _xingzuo;
}

//创建路径文件夹
+(BOOL) createFolderByPath:(NSString *)_folderPath
{
    NSFileManager * _fileManager = FILE_MANAGER;
    
    if(![_fileManager fileExistsAtPath:_folderPath])
    {
        return [_fileManager createDirectoryAtPath:_folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

//读取文件路径
+(NSString *)getConfigFile:(NSString *)fileName
{
    //读取documents路径:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);//得到documents的路径，为当前应用程序独享
    NSString *documentD = [paths objectAtIndex:0];
    NSString *configFile = [documentD stringByAppendingPathComponent:fileName]; //得到documents目录下fileName文件的路径
    return configFile;
}

//获取app自带资源路径
+ (NSString*) pathForResource:(NSString*)resourcepath
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    path = [path stringByAppendingPathComponent:resourcepath];
    return path;
}
//计算文件大小
+(NSString *)getFileSizeWithPath:(NSString *)fileURLString{
    NSString *size;
    @try {
        if (nil == fileURLString) {
            return nil;
        }
        NSError *error;
        //文件
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileURLString error:&error];
        //大小
        NSInteger fileSize = [[fileAttributes objectForKey:NSFileSize] intValue];
        //文本描述
        size = [NSString stringWithFormat:@"%@",[self formattedFileSize:fileSize]];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        return size;
    }
}
//计算大小算法（以bytes、KB、MB、GB）结尾 ，增强可读性
+ (NSString *)formattedFileSize:(unsigned long long)size
{
    
    NSString *formattedStr = nil;
    @try {
        if (size == 0)
            formattedStr = @"Empty";
        else
            if (size > 0 && size < 1024)
                formattedStr = [NSString stringWithFormat:@"%qu bytes", size];
            else
                if (size >= 1024 && size < pow(1024, 2))
                    formattedStr = [NSString stringWithFormat:@"%.1f KB", (size / 1024.)];
                else
                    if (size >= pow(1024, 2) && size < pow(1024, 3))
                        formattedStr = [NSString stringWithFormat:@"%.2f MB", (size / pow(1024, 2))];
                    else
                        if (size >= pow(1024, 3))
                            formattedStr = [NSString stringWithFormat:@"%.3f GB", (size / pow(1024, 3))];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        return formattedStr;
    }
    
}


#if 0
+ (void)updateSoftwareWithLoading:(BOOL)loading withResult:(CheckVersionCallBack)callBack
{
    DLog(@"检查更新中......");
    if (loading) {
        [MBProgressHUD showInScreen:YES];
    }
    NSMutableDictionary *_dic = [NSMutableDictionary dictionary];
    [_dic setObject:[defaults objectForKey:USER_ID] forKey:@"userId"];
    
    [_dic setObject:@"ios" forKey:@"app_type"];
    [_dic setObject:@"241" forKey:@"version"];
    [_dic setObject:@"xsq" forKey:@"product"];
    if ([defaults objectForKey:USCHOOL_ID]) {
        [_dic setObject:[defaults objectForKey:USCHOOL_ID] forKey:@"schoolId"];
    }
    MKNetworkEngine *engine = [NetworkEngine shareVersionEngine];
    MKNetworkOperation *op = [engine operationWithPath:pUpdateSoftware params:_dic httpMethod:@"POST"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        DLog(@"[completedOperation responseString]-->%@",[completedOperation responseString]);
        callBack([completedOperation responseString]);
        if (loading) {
            [MBProgressHUD disappearFromScreen];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        if (loading) {
            [OMGToast showWithText:@"网络请求失败，请稍后重试" topOffset:kTipsTopOffset duration:2.0];
            [MBProgressHUD disappearFromScreen];
        }
    }];
    [engine enqueueOperation:op];
}
#endif
#if 0
+ (BOOL)locationServiceEnable{
    return  [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied;
    
    //    if ([MyCLController sharedInstance].locationManager.locationServicesEnabled==FALSE) ｛//dosomething;｝
    //        来判断定位服务的设置是否开启，现在问题又来了，
    //        就是如何才能在自己的程序里跳转到 “设置”－>“定位服务”的那个系统页面呢？
    //
    //    - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
    //    {
    //        if (error.code == kCLErrorDenied){
    //            // User denied access to location service
    //        }
    //    }
    //    // ios 5.0及其一下版本，可以直接跳转到设置界面进行定位设置
    //    NSURL*url=[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
    //    [[UIApplication sharedApplication] openURL:url];
}
#endif
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
+(UIColor *)colorWithHex:(NSString *)hexColor alpha:(float)alpha{
    //删除空格
    NSString *colorStr = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([colorStr length] < 6||[colorStr length]>7)
    {
        return [UIColor clearColor];
    }
    //
    if ([colorStr hasPrefix:@"#"])
    {
        colorStr = [colorStr substringFromIndex:1];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    //red
    NSString *redString = [colorStr substringWithRange:range];
    //green
    range.location = 2;
    NSString *greenString = [colorStr substringWithRange:range];
    //blue
    range.location = 4;
    NSString *blueString= [colorStr substringWithRange:range];
    
    // Scan values
    unsigned int red, green, blue;
    [[NSScanner scannerWithString:redString] scanHexInt:&red];
    [[NSScanner scannerWithString:greenString] scanHexInt:&green];
    [[NSScanner scannerWithString:blueString] scanHexInt:&blue];
    return [UIColor colorWithRed:((float)red/ 255.0f) green:((float)green/ 255.0f) blue:((float)blue/ 255.0f) alpha:alpha];
}
/**
 *  截图
 *
 *  @param theView 所截图像所在view
 *  @param r       截图范围
 *
 *  @return 所得图片
 */
+ (UIImage *)imageFromView: (UIView *)theView atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@", NSStringFromCGSize(theImage.size));
    
    //    2、生成指定大小图片
    //    CGFloat height = 0;
    //    if (iOS7OrLater) {
    //        height = 20;
    //    }
    //        CGSize size = {kScreenWidth, (667 + 44 + height) * (kScreenWidth / 375)};
    CGSize size = {kScreenWidth,kScreenHeight};
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [theImage drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"%@", NSStringFromCGSize(compressedImg.size));
    
    return compressedImg;
    
    
    
}

+ (UIImage *)imageViewFromView:(UIView *)imageView atFrame:(CGRect)rect
{
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * newImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(newImg.CGImage, rect);
    UIImage * compressedImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return compressedImg;
    
    
}

/**
 * 获取分辨率
 */
+ (NSDictionary *) getScreenResolution {
    
    
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGSize size_screen = rect_screen.size;
    float width = size_screen.width * scale_screen;
    float height = size_screen.height * scale_screen;
    int iWidth = (int)floorf(width);
    int iHeight = (int)floorf(height);
    NSString *strWidth =[NSString stringWithFormat:@"%d",iWidth];
    NSString *strHeight =[NSString stringWithFormat:@"%d",iHeight];
    //顺序添加对象和键值来创建一个字典，注意结尾是nil
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:strWidth,@"width",strHeight,@"height",nil];
    return dictionary;
}
/**
 * 判断指定的内容是否是数字
 */
+ (BOOL) isNumber:(NSString *)strNumber {
    BOOL bRet = NO;
    NSString *NUMBERS = @"0123456789\n";
    NSCharacterSet *cs;
    NSString *filtered=nil;
    if (nil == strNumber || [strNumber length] == 0) {
        return bRet;
    }
    // 返回一个字符集包含一个给定的字符串中的字符
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    //将字符串拆分
    filtered = [[strNumber componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    bRet = [strNumber isEqualToString:filtered];
    return bRet;
}

/**
 *  字典转换字符串
 */

+(NSString *)lxlcustomDictionaryToString:(id)dic{
    NSError *dataParseErr=nil;
    if (dic && ![dic isKindOfClass:[NSNull class]]) {
        return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&dataParseErr] encoding:NSUTF8StringEncoding];
    }else{
        return @"";
    }
    
}

/**
 *  返回值的含义：
 *      100 表示 大于10s 101表示大于1天  102表示大于3天   103表示大于5天
 *      104 表示 大于10天    105表示大于20天  106表示大于30天  10000表示nil
 *      以上表示 大于10s、大于30天已经实现，其它目前没有扩展
 */
+(NSString *)getTimeRange:(id)timeParameter{
    BOOL bRet=NO;
    NSString *bRetStr;
    //当前时间
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[NSDate date];
    NSTimeZone *timeZone=[NSTimeZone systemTimeZone];
    NSInteger index=[timeZone secondsFromGMTForDate:date];
    NSDate *today=[date dateByAddingTimeInterval:index];
    NSDate *beforeDate=nil;
    NSDate *currentDate=nil;
    //    传入时间
    if ([timeParameter isKindOfClass:[NSString class]]) {
        
        beforeDate=[dateFormatter dateFromString:timeParameter];
        
        if (!timeParameter) {
            bRet=NO;
            bRetStr=@"10000";
        }else{
            if ([timeParameter isEqualToString:@""]) {
                NSLog(@"time0:%@",[defaults objectForKey:currentNowTime]);
                NSString *str=[NSString stringWithFormat:@"%@",[defaults objectForKey:currentNowTime]];
                if (!str) {
                    return  bRetStr=@"10000";
                }
                NSArray *arr=[str componentsSeparatedByString:@" "];
                NSMutableString *strstr=[[NSMutableString alloc] init];
                for (int i=0;i<[arr count]-1;i++) {
                    if (i%2) {
                        [strstr appendString:@" "];
                        [strstr appendString:arr[i]];
                    }else{
                        [strstr appendString:arr[i]];
                    }
                }
                
                currentDate=[dateFormatter dateFromString:strstr];
                NSInteger index=[timeZone secondsFromGMTForDate:currentDate];
                NSDate *newDate=[currentDate dateByAddingTimeInterval:index];
                
                
                NSTimeInterval timeInt=[today timeIntervalSinceDate:newDate];
                NSString *todayStr=[NSString stringWithFormat:@"%@",today];
                [defaults setObject:todayStr forKey:currentNowTime];
                NSLog(@"time1:%@",[defaults objectForKey:currentNowTime]);
                if (timeInt>10.0) {
                    bRetStr=@"100";
                }else{
                    bRetStr=@"10000";
                }
                NSLog(@"timeInt vlaue is %f",timeInt);
            }else{
                NSTimeInterval timeInt=[today timeIntervalSinceDate:beforeDate];
                
                double dayNumbers=timeInt/(24*60*60);
                NSLog(@"间隔天数：%f",dayNumbers);
                if (dayNumbers >DAYNUMBERS) {
                    bRet=YES;
                    bRetStr=@"106";
                }else{
                    bRet=NO;
                    bRetStr=@"10000";
                }
            }
        }
    }
    else {
        bRetStr=@"10000";
    }
    
    
    return bRetStr;
    
}


- (NSString*)getIp:(NSString*)address
{
    if ([address hasPrefix:@"http://"]) {
        
        address = [address substringFromIndex:[@"http://" length]];
    }
    NSRange range = [address rangeOfString:@":" options:NSBackwardsSearch];
    
    if (range.length==0) {
        return address;
    }else{
        
        if (range.location < 5) {
            NSLog(@"Error Alive Address:%@",address);
            return address;
        }else{
            return [address substringToIndex:range.location];
        }
    }
}

- (NSString*)getPort:(NSString*)address
{
    NSRange range = [address rangeOfString:@":" options:NSBackwardsSearch];
    if (range.location < 5) {
        NSLog(@"Error Alive Address:%@", address);
        address=@"80";
        return address;
    }else{
        
        return [address substringFromIndex:range.location + 1];
    }
}
#pragma mark 获取应用内存情况
// 获取当前设备可用内存(单位：MB）
+ (double)getFacilityAvailableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0+((vm_page_size *vmStats.inactive_count) / 1024.0) / 1024.0;
    //    struct statfs buf;
    //    long long freespace = -1;
    //    if(statfs("/var", &buf) >= 0){
    //        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    //    }
    //    return freespace/1024/1024;
}

// 获取当前任务所占用的内存（单位：MB）
+ (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

/**
 * 字符串转换成字典
 */
+(NSMutableDictionary *)lxlcustomDataToDic:(id)dic{
    NSData *data=nil;
    
    if (!dic) {
        return nil;
    }
    
    if ([dic isKindOfClass:[NSData class]]) {
        data=dic;
    }else if([dic isKindOfClass:[NSString class]]){
        data=[dic dataUsingEncoding:NSUTF8StringEncoding];
        
    }else{
        
        return nil;
        
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
}

//获取时间戳
+(NSString *)getTimestamp{

    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
    return timeString;
}

//MD5加密
+ (NSString *)MD5ByAStr:(NSString *)aSourceStr{
    //转换成utf-8
    const char* cStr = [aSourceStr UTF8String];
    //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     
     */
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);

    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

//获取当前应用的版本号
+(NSString *)getAppVersion
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];      //获取项目版本号
    return version;
}
/*----------------------颜色---------------------*/
//生成随机色
+(UIColor *)getarc4random_color{
    
    float red = arc4random_uniform(255)/255.0f;
    float green = arc4random_uniform(255)/255.0f;
    float blue = arc4random_uniform(255)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}
//手机号正则
+(BOOL)validateMobile:(NSString *)mobile
{//@"^((13[0-9])|(14[5,7])|(15[^4,\\D])|(17[0,6-8])|(18[0-9]))\\d{8}$"
    //@"^1(3[0-9]|4[579]|5[0-35-9]|7[0135-8]|8[0-9])\\d{8}$"
    NSString *phoneRegex = @"^1(3[0-9]|4[579]|5[0-35-9]|7[0135-8]|8[0-9])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

//密码不能有3个相同或顺序的数字
+(BOOL)judgepassWorld:(NSString *)pass{
    BOOL res;
    res=NO;
    for (int i=0; i<6; i++) {
        if (i<4) {
            NSRange bankRang = NSMakeRange(i, 3);
            NSString *strThree=[pass substringWithRange:bankRang];
            NSLog(@"strThree==%@",strThree);
            int a;
            int b;
            int c;
            a=0;b=0;c=0;
            for (int j = 0; j<[strThree length]; j++) {
                //截取字符串中的每一个字符
                NSString *s = [strThree substringWithRange:NSMakeRange(j, 1)];
                if (j==0) {
                    a=[s intValue];
                }else if (j==1) {
                    b=[s intValue];
                }else if (j==2) {
                    c=[s intValue];
                }
            }
            if (a==b&&b==c) {
                res=YES;
//                [DLLoading DLToolTipInWindow:@"密码不能有3个相同的数字"];
            }
            if (a+1==b&&b+1==c) {
                res=YES;
//                [DLLoading DLToolTipInWindow:@"密码不能有3个连续的数字"];
            }
        }
    }
    
    return res;
}
//资金账号与密码比较
+(BOOL)fundCardNumber:(NSString *)fundString{
    BOOL res;
    res=NO;
    NSString *fundStr=@"130201130";//[HQ_QueryAgent tradeFundScno];
    if (![ToolHelper isBlankString:fundStr]) {
        for (int i=0; i<[fundStr length]; i++) {
            if (i<=([fundStr length]-6)) {
                NSRange bankRang = NSMakeRange(i, 6);
                NSString *strSix=[fundStr substringWithRange:bankRang];
                if ([strSix isEqualToString:fundString]) {
                    res=YES;
//                    [DLLoading DLToolTipInWindow:@"密码不能与资金账号连续6位相同"];
                }
            }
        }
    }
    return res;
}

//密码只能是数字判断
+ (BOOL)validateNumber:(NSString *) textString{
    NSString* number=@"^[0-9]{6}$";//@"^[0-9]+$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:textString];
}
//判断手机型号
+ (NSString *)iphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}

@end
