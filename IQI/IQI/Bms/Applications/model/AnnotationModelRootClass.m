//
//	AnnotationModelRootClass.m
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport



#import "AnnotationModelRootClass.h"

NSString *const kAnnotationModelRootClassVacation = @"Vacation";
NSString *const kAnnotationModelRootClassYaoMoney = @"YaoMoney";
NSString *const kAnnotationModelRootClassCity = @"city";
NSString *const kAnnotationModelRootClassDistrict = @"district";
NSString *const kAnnotationModelRootClassDistrictId = @"district_id";
NSString *const kAnnotationModelRootClassEndpointbd = @"endpointbd";
NSString *const kAnnotationModelRootClassEntaddress = @"entaddress";
NSString *const kAnnotationModelRootClassEntdistance = @"entdistance";
NSString *const kAnnotationModelRootClassEntid = @"entid";
NSString *const kAnnotationModelRootClassEntimg = @"entimg";
NSString *const kAnnotationModelRootClassEntname = @"entname";
NSString *const kAnnotationModelRootClassEntphone = @"entphone";
NSString *const kAnnotationModelRootClassEntpoint = @"entpoint";
NSString *const kAnnotationModelRootClassEntprice = @"entprice";
NSString *const kAnnotationModelRootClassEntservice = @"entservice";
NSString *const kAnnotationModelRootClassEntworktime = @"entworktime";
NSString *const kAnnotationModelRootClassIsBoutique = @"isBoutique";
NSString *const kAnnotationModelRootClassIsRecommend = @"isRecommend";
NSString *const kAnnotationModelRootClassIsSpecial = @"isSpecial";
NSString *const kAnnotationModelRootClassIsfreeclean = @"isfreeclean";
NSString *const kAnnotationModelRootClassLabel = @"label";
NSString *const kAnnotationModelRootClassNcommen = @"ncommen";
NSString *const kAnnotationModelRootClassNorder = @"norder";
NSString *const kAnnotationModelRootClassNpraise = @"npraise";
NSString *const kAnnotationModelRootClassProvince = @"province";
NSString *const kAnnotationModelRootClassServicePrice = @"service_price";

@interface AnnotationModelRootClass ()
@end
@implementation AnnotationModelRootClass




/**
 * Instantiate the instance using the passed dictionary values to set the properties values
 */

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if(![dictionary[kAnnotationModelRootClassVacation] isKindOfClass:[NSNull class]]){
		self.vacation = [dictionary[kAnnotationModelRootClassVacation] integerValue];
	}

	if(![dictionary[kAnnotationModelRootClassYaoMoney] isKindOfClass:[NSNull class]]){
		self.yaoMoney = [dictionary[kAnnotationModelRootClassYaoMoney] boolValue];
	}

	if(![dictionary[kAnnotationModelRootClassCity] isKindOfClass:[NSNull class]]){
		self.city = dictionary[kAnnotationModelRootClassCity];
	}	
	if(![dictionary[kAnnotationModelRootClassDistrict] isKindOfClass:[NSNull class]]){
		self.district = dictionary[kAnnotationModelRootClassDistrict];
	}	
	if(![dictionary[kAnnotationModelRootClassDistrictId] isKindOfClass:[NSNull class]]){
		self.districtId = [dictionary[kAnnotationModelRootClassDistrictId] integerValue];
	}

	if(![dictionary[kAnnotationModelRootClassEndpointbd] isKindOfClass:[NSNull class]]){
		self.endpointbd = dictionary[kAnnotationModelRootClassEndpointbd];
	}	
	if(![dictionary[kAnnotationModelRootClassEntaddress] isKindOfClass:[NSNull class]]){
		self.entaddress = dictionary[kAnnotationModelRootClassEntaddress];
	}	
	if(![dictionary[kAnnotationModelRootClassEntdistance] isKindOfClass:[NSNull class]]){
		self.entdistance = [dictionary[kAnnotationModelRootClassEntdistance] floatValue];
	}

	if(![dictionary[kAnnotationModelRootClassEntid] isKindOfClass:[NSNull class]]){
		self.entid = [dictionary[kAnnotationModelRootClassEntid] integerValue];
	}

	if(![dictionary[kAnnotationModelRootClassEntimg] isKindOfClass:[NSNull class]]){
		self.entimg = dictionary[kAnnotationModelRootClassEntimg];
	}	
	if(![dictionary[kAnnotationModelRootClassEntname] isKindOfClass:[NSNull class]]){
		self.entname = dictionary[kAnnotationModelRootClassEntname];
	}	
	if(![dictionary[kAnnotationModelRootClassEntphone] isKindOfClass:[NSNull class]]){
		self.entphone = dictionary[kAnnotationModelRootClassEntphone];
	}	
	if(![dictionary[kAnnotationModelRootClassEntpoint] isKindOfClass:[NSNull class]]){
		self.entpoint = dictionary[kAnnotationModelRootClassEntpoint];
	}	
	if(![dictionary[kAnnotationModelRootClassEntprice] isKindOfClass:[NSNull class]]){
		self.entprice = dictionary[kAnnotationModelRootClassEntprice];
	}	
	if(![dictionary[kAnnotationModelRootClassEntservice] isKindOfClass:[NSNull class]]){
		self.entservice = dictionary[kAnnotationModelRootClassEntservice];
	}	
	if(![dictionary[kAnnotationModelRootClassEntworktime] isKindOfClass:[NSNull class]]){
		self.entworktime = dictionary[kAnnotationModelRootClassEntworktime];
	}	
	if(![dictionary[kAnnotationModelRootClassIsBoutique] isKindOfClass:[NSNull class]]){
		self.isBoutique = [dictionary[kAnnotationModelRootClassIsBoutique] boolValue];
	}

	if(![dictionary[kAnnotationModelRootClassIsRecommend] isKindOfClass:[NSNull class]]){
		self.isRecommend = [dictionary[kAnnotationModelRootClassIsRecommend] boolValue];
	}

	if(![dictionary[kAnnotationModelRootClassIsSpecial] isKindOfClass:[NSNull class]]){
		self.isSpecial = [dictionary[kAnnotationModelRootClassIsSpecial] boolValue];
	}

	if(![dictionary[kAnnotationModelRootClassIsfreeclean] isKindOfClass:[NSNull class]]){
		self.isfreeclean = [dictionary[kAnnotationModelRootClassIsfreeclean] integerValue];
	}

	if(![dictionary[kAnnotationModelRootClassLabel] isKindOfClass:[NSNull class]]){
		self.label = dictionary[kAnnotationModelRootClassLabel];
	}	
	if(![dictionary[kAnnotationModelRootClassNcommen] isKindOfClass:[NSNull class]]){
		self.ncommen = [dictionary[kAnnotationModelRootClassNcommen] integerValue];
	}

	if(![dictionary[kAnnotationModelRootClassNorder] isKindOfClass:[NSNull class]]){
		self.norder = [dictionary[kAnnotationModelRootClassNorder] integerValue];
	}

	if(![dictionary[kAnnotationModelRootClassNpraise] isKindOfClass:[NSNull class]]){
		self.npraise = [dictionary[kAnnotationModelRootClassNpraise] integerValue];
	}

	if(![dictionary[kAnnotationModelRootClassProvince] isKindOfClass:[NSNull class]]){
		self.province = dictionary[kAnnotationModelRootClassProvince];
	}	
	if(![dictionary[kAnnotationModelRootClassServicePrice] isKindOfClass:[NSNull class]]){
		self.servicePrice = [dictionary[kAnnotationModelRootClassServicePrice] doubleValue];
	}

	return self;
}


/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
-(NSDictionary *)toDictionary
{
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	dictionary[kAnnotationModelRootClassVacation] = @(self.vacation);
	dictionary[kAnnotationModelRootClassYaoMoney] = @(self.yaoMoney);
	if(self.city != nil){
		dictionary[kAnnotationModelRootClassCity] = self.city;
	}
	if(self.district != nil){
		dictionary[kAnnotationModelRootClassDistrict] = self.district;
	}
	dictionary[kAnnotationModelRootClassDistrictId] = @(self.districtId);
	if(self.endpointbd != nil){
		dictionary[kAnnotationModelRootClassEndpointbd] = self.endpointbd;
	}
	if(self.entaddress != nil){
		dictionary[kAnnotationModelRootClassEntaddress] = self.entaddress;
	}
	dictionary[kAnnotationModelRootClassEntdistance] = @(self.entdistance);
	dictionary[kAnnotationModelRootClassEntid] = @(self.entid);
	if(self.entimg != nil){
		dictionary[kAnnotationModelRootClassEntimg] = self.entimg;
	}
	if(self.entname != nil){
		dictionary[kAnnotationModelRootClassEntname] = self.entname;
	}
	if(self.entphone != nil){
		dictionary[kAnnotationModelRootClassEntphone] = self.entphone;
	}
	if(self.entpoint != nil){
		dictionary[kAnnotationModelRootClassEntpoint] = self.entpoint;
	}
	if(self.entprice != nil){
		dictionary[kAnnotationModelRootClassEntprice] = self.entprice;
	}
	if(self.entservice != nil){
		dictionary[kAnnotationModelRootClassEntservice] = self.entservice;
	}
	if(self.entworktime != nil){
		dictionary[kAnnotationModelRootClassEntworktime] = self.entworktime;
	}
	dictionary[kAnnotationModelRootClassIsBoutique] = @(self.isBoutique);
	dictionary[kAnnotationModelRootClassIsRecommend] = @(self.isRecommend);
	dictionary[kAnnotationModelRootClassIsSpecial] = @(self.isSpecial);
	dictionary[kAnnotationModelRootClassIsfreeclean] = @(self.isfreeclean);
	if(self.label != nil){
		dictionary[kAnnotationModelRootClassLabel] = self.label;
	}
	dictionary[kAnnotationModelRootClassNcommen] = @(self.ncommen);
	dictionary[kAnnotationModelRootClassNorder] = @(self.norder);
	dictionary[kAnnotationModelRootClassNpraise] = @(self.npraise);
	if(self.province != nil){
		dictionary[kAnnotationModelRootClassProvince] = self.province;
	}
	dictionary[kAnnotationModelRootClassServicePrice] = @(self.servicePrice);
	return dictionary;

}

/**
 * Implementation of NSCoding encoding method
 */
/**
 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:@(self.vacation) forKey:kAnnotationModelRootClassVacation];	[aCoder encodeObject:@(self.yaoMoney) forKey:kAnnotationModelRootClassYaoMoney];	if(self.city != nil){
		[aCoder encodeObject:self.city forKey:kAnnotationModelRootClassCity];
	}
	if(self.district != nil){
		[aCoder encodeObject:self.district forKey:kAnnotationModelRootClassDistrict];
	}
	[aCoder encodeObject:@(self.districtId) forKey:kAnnotationModelRootClassDistrictId];	if(self.endpointbd != nil){
		[aCoder encodeObject:self.endpointbd forKey:kAnnotationModelRootClassEndpointbd];
	}
	if(self.entaddress != nil){
		[aCoder encodeObject:self.entaddress forKey:kAnnotationModelRootClassEntaddress];
	}
	[aCoder encodeObject:@(self.entdistance) forKey:kAnnotationModelRootClassEntdistance];	[aCoder encodeObject:@(self.entid) forKey:kAnnotationModelRootClassEntid];	if(self.entimg != nil){
		[aCoder encodeObject:self.entimg forKey:kAnnotationModelRootClassEntimg];
	}
	if(self.entname != nil){
		[aCoder encodeObject:self.entname forKey:kAnnotationModelRootClassEntname];
	}
	if(self.entphone != nil){
		[aCoder encodeObject:self.entphone forKey:kAnnotationModelRootClassEntphone];
	}
	if(self.entpoint != nil){
		[aCoder encodeObject:self.entpoint forKey:kAnnotationModelRootClassEntpoint];
	}
	if(self.entprice != nil){
		[aCoder encodeObject:self.entprice forKey:kAnnotationModelRootClassEntprice];
	}
	if(self.entservice != nil){
		[aCoder encodeObject:self.entservice forKey:kAnnotationModelRootClassEntservice];
	}
	if(self.entworktime != nil){
		[aCoder encodeObject:self.entworktime forKey:kAnnotationModelRootClassEntworktime];
	}
	[aCoder encodeObject:@(self.isBoutique) forKey:kAnnotationModelRootClassIsBoutique];	[aCoder encodeObject:@(self.isRecommend) forKey:kAnnotationModelRootClassIsRecommend];	[aCoder encodeObject:@(self.isSpecial) forKey:kAnnotationModelRootClassIsSpecial];	[aCoder encodeObject:@(self.isfreeclean) forKey:kAnnotationModelRootClassIsfreeclean];	if(self.label != nil){
		[aCoder encodeObject:self.label forKey:kAnnotationModelRootClassLabel];
	}
	[aCoder encodeObject:@(self.ncommen) forKey:kAnnotationModelRootClassNcommen];	[aCoder encodeObject:@(self.norder) forKey:kAnnotationModelRootClassNorder];	[aCoder encodeObject:@(self.npraise) forKey:kAnnotationModelRootClassNpraise];	if(self.province != nil){
		[aCoder encodeObject:self.province forKey:kAnnotationModelRootClassProvince];
	}
	[aCoder encodeObject:@(self.servicePrice) forKey:kAnnotationModelRootClassServicePrice];
}

/**
 * Implementation of NSCoding initWithCoder: method
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
	self.vacation = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassVacation] integerValue];
	self.yaoMoney = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassYaoMoney] boolValue];
	self.city = [aDecoder decodeObjectForKey:kAnnotationModelRootClassCity];
	self.district = [aDecoder decodeObjectForKey:kAnnotationModelRootClassDistrict];
	self.districtId = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassDistrictId] integerValue];
	self.endpointbd = [aDecoder decodeObjectForKey:kAnnotationModelRootClassEndpointbd];
	self.entaddress = [aDecoder decodeObjectForKey:kAnnotationModelRootClassEntaddress];
	self.entdistance = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassEntdistance] floatValue];
	self.entid = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassEntid] integerValue];
	self.entimg = [aDecoder decodeObjectForKey:kAnnotationModelRootClassEntimg];
	self.entname = [aDecoder decodeObjectForKey:kAnnotationModelRootClassEntname];
	self.entphone = [aDecoder decodeObjectForKey:kAnnotationModelRootClassEntphone];
	self.entpoint = [aDecoder decodeObjectForKey:kAnnotationModelRootClassEntpoint];
	self.entprice = [aDecoder decodeObjectForKey:kAnnotationModelRootClassEntprice];
	self.entservice = [aDecoder decodeObjectForKey:kAnnotationModelRootClassEntservice];
	self.entworktime = [aDecoder decodeObjectForKey:kAnnotationModelRootClassEntworktime];
	self.isBoutique = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassIsBoutique] boolValue];
	self.isRecommend = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassIsRecommend] boolValue];
	self.isSpecial = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassIsSpecial] boolValue];
	self.isfreeclean = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassIsfreeclean] integerValue];
	self.label = [aDecoder decodeObjectForKey:kAnnotationModelRootClassLabel];
	self.ncommen = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassNcommen] integerValue];
	self.norder = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassNorder] integerValue];
	self.npraise = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassNpraise] integerValue];
	self.province = [aDecoder decodeObjectForKey:kAnnotationModelRootClassProvince];
	self.servicePrice = [[aDecoder decodeObjectForKey:kAnnotationModelRootClassServicePrice] doubleValue];
	return self;

}

/**
 * Implementation of NSCopying copyWithZone: method
 */
- (instancetype)copyWithZone:(NSZone *)zone
{
	AnnotationModelRootClass *copy = [AnnotationModelRootClass new];

	copy.vacation = self.vacation;
	copy.yaoMoney = self.yaoMoney;
	copy.city = [self.city copy];
	copy.district = [self.district copy];
	copy.districtId = self.districtId;
	copy.endpointbd = [self.endpointbd copy];
	copy.entaddress = [self.entaddress copy];
	copy.entdistance = self.entdistance;
	copy.entid = self.entid;
	copy.entimg = [self.entimg copy];
	copy.entname = [self.entname copy];
	copy.entphone = [self.entphone copy];
	copy.entpoint = [self.entpoint copy];
	copy.entprice = [self.entprice copy];
	copy.entservice = [self.entservice copy];
	copy.entworktime = [self.entworktime copy];
	copy.isBoutique = self.isBoutique;
	copy.isRecommend = self.isRecommend;
	copy.isSpecial = self.isSpecial;
	copy.isfreeclean = self.isfreeclean;
	copy.label = [self.label copy];
	copy.ncommen = self.ncommen;
	copy.norder = self.norder;
	copy.npraise = self.npraise;
	copy.province = [self.province copy];
	copy.servicePrice = self.servicePrice;

	return copy;
}
@end