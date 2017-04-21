//
//  NetworkRequest.m
//  PanGu
//
//  Created by 吴肖利 on 16/7/3.
//  Copyright © 2016年 Security Pacific Corporation. All rights reserved.
//

#import "NetworkRequest.h"
#import "ParamsRequest.h"

@implementation NetworkRequest

//GET
+ (void)getRequestUrlString:(NSString *)url params:(NSDictionary *)params success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock {
    [[HttpRequest getInstance]getWithURLString:url headers:nil orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {

        successBlock(responseObject);
    } failure:^(NSError *error, NSURLSessionTask *task) {
        failureBlock(error);
    }];
}

//POST
+ (void)postRequestUrlString:(NSString *)url params:(NSDictionary *)params success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock {
    [[HttpRequest getInstance]postWithURLString:url headers:nil orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            successBlock(data);
        }
        successBlock(responseObject);
    } failure:^(NSError *error, NSURLSessionTask *task) {
        failureBlock(error);
    }];
}

+ (void)postHeadersRequestUrlString:(NSString *)url params:(NSDictionary *)params andHeaders:(NSDictionary *)headers success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock {
    [[HttpRequest getInstance]postWithURLString:url headers:headers orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {
        successBlock(responseObject);
    } failure:^(NSError *error, NSURLSessionTask *task) {
        failureBlock(error);
    }];
}

//交易POST
+ (void)postRequestUrlString:(NSString *)url params:(NSDictionary *)params interfaceID:(NSString *)interfaceID token:(NSString *)token success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock {
    [[ParamsRequest getInstance] postWithURLString:url headers:nil orbYunType:3 interfaceID:interfaceID marker:token parameters:params success:^(id responseObject, NSURLSessionTask *task) {
        successBlock(responseObject);
    } failure:^(NSError *error, NSURLSessionTask *task) {
        failureBlock(error);
    }];
    
}

//GzipPost
+ (void)postGzipRequestUrlString:(NSString *)url params:(NSDictionary *)params success:(successRequestBlock)successBlock failure:(failureRequestBlock)failureBlock {
    [[HttpRequest getInstance]postGzipWithURLString:url headers:nil orbYunType:3 parameters:params success:^(id responseObject, NSURLSessionTask *task) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            successBlock(data);
        }
        successBlock(responseObject);
    } failure:^(NSError *error, NSURLSessionTask *task) {
        failureBlock(error);
    }];
}


@end
