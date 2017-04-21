#import <UIKit/UIKit.h>

@interface AnnotationModelRootClass : NSObject

@property (nonatomic, assign) NSInteger vacation;
@property (nonatomic, assign) BOOL yaoMoney;
@property (nonatomic, strong) NSString * city;
@property (nonatomic, strong) NSString * district;
@property (nonatomic, assign) NSInteger districtId;
@property (nonatomic, strong) NSString * endpointbd;
@property (nonatomic, strong) NSString * entaddress;
@property (nonatomic, assign) CGFloat entdistance;
@property (nonatomic, assign) NSInteger entid;
@property (nonatomic, strong) NSString * entimg;
@property (nonatomic, strong) NSString * entname;
@property (nonatomic, strong) NSString * entphone;
@property (nonatomic, strong) NSString * entpoint;
@property (nonatomic, strong) NSString * entprice;
@property (nonatomic, strong) NSString * entservice;
@property (nonatomic, strong) NSString * entworktime;
@property (nonatomic, assign) BOOL isBoutique;
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, assign) BOOL isSpecial;
@property (nonatomic, assign) NSInteger isfreeclean;
@property (nonatomic, strong) NSArray * label;
@property (nonatomic, assign) NSInteger ncommen;
@property (nonatomic, assign) NSInteger norder;
@property (nonatomic, assign) NSInteger npraise;
@property (nonatomic, strong) NSString * province;
@property (nonatomic, assign) double servicePrice;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)toDictionary;
@end