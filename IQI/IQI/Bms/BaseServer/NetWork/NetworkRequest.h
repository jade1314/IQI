//
//  NetworkRequest.h
//  PanGu
//
//  Created by 吴肖利 on 16/7/3.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successRequestBlock)(id responseObject);
typedef void(^failureRequestBlock)(NSError *error);

@interface NetworkRequest : NSObject

//Get
+ (void)getRequestUrlString:(NSString *)url params:(NSDictionary *)params success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;
//POST
+ (void)postRequestUrlString:(NSString *)url params:(NSDictionary *)params success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;
//by------cwp
+ (void)postHeadersRequestUrlString:(NSString *)url params:(NSDictionary *)params andHeaders:(NSDictionary *)headers success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;
//交易POST
+ (void)postRequestUrlString:(NSString *)url params:(NSDictionary *)params interfaceID:(NSString *)interfaceID token:(NSString *)token success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;

//GzipPOST
+ (void)postGzipRequestUrlString:(NSString *)url params:(NSDictionary *)params success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock;

@end
