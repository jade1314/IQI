//
//  HttpRequest.m
//  NetWorking
//  网络请求代理
//  Created by 王玉 on 16/4/19.
//  Copyright © 2016年 王玉. All rights reserved.
//

#import "HttpRequest.h"

static float num;

@interface HttpRequest ()

@property (nonatomic,strong) NSHTTPURLResponse * response;

@end

static AFHTTPSessionManager *manager = nil;

@implementation HttpRequest

//创建单利
+ (instancetype)getInstance {
    static HttpRequest *managerRe = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        managerRe = [self new];
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.requestSerializer.timeoutInterval = 10.f;
    });
    return managerRe;

}

/***************************转菊花样式*********************************/
- (MBProgressHUD *)hud{
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] init];
        _hud.labelText = @"加载中...";
        _hud.yOffset = -64;
        _hud.opacity = 0.5;
    }
    return _hud;
}

+ (void)showProgressHUD:(UIView *)view {
    HttpRequest *httpRequest = [HttpRequest getInstance];
    httpRequest.hud.center = view.center;
    [httpRequest.hud show:YES];
    [view addSubview:httpRequest.hud];
    [view bringSubviewToFront:httpRequest.hud];
}

+ (void)showProgressHUD {
    HttpRequest *httpRequest = [HttpRequest getInstance];
    [httpRequest.hud show:YES];
    httpRequest.hud.center = [UIApplication sharedApplication].keyWindow.rootViewController.view.center;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:httpRequest.hud];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view bringSubviewToFront:httpRequest.hud];
}
+ (void)showProgressHUDPri {
    HttpRequest *httpRequest = [HttpRequest getInstance];
    [httpRequest.hud show:YES];
    httpRequest.hud.center = [UIApplication sharedApplication].keyWindow.rootViewController.view.center;
    [[UIApplication sharedApplication].keyWindow addSubview:httpRequest.hud];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:httpRequest.hud];
}


+ (void)hideProgressHUD {
    HttpRequest *httpRequest = [HttpRequest getInstance];
    [httpRequest.hud hide:YES];
}

+ (void)showProgressHUDAfterDelay:(CGFloat)delay {
    HttpRequest *httpRequest = [HttpRequest getInstance];
    [httpRequest.hud show:YES];
    [httpRequest.hud hide:YES afterDelay:delay];
}

+ (void)showProgressHUDAfterDelay:(CGFloat)delay text:(NSString *)text {
    HttpRequest *httpRequest = [HttpRequest getInstance];
    httpRequest.hud.labelText = text;
    [httpRequest.hud show:YES];
    [httpRequest.hud hide:YES afterDelay:delay];
    httpRequest.hud.labelText = @"加载中...";
}

/**********************************网络请求参数设置**************************************/

-(void)dealloc{
    
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    
}

//网络状态
- (void)afnetworkingReachabilityChangeNotification:(void(^)(NSString *type))networkStatusBlock{
    
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                NSLog(@"未识别的网络");
//                
//                if (networkStatusBlock) {
//                    networkStatusBlock(@"AFNetworkReachabilityStatusUnknown");
//                }
//                
//                break;
//                
//            case AFNetworkReachabilityStatusNotReachable:
//                
//                NSLog(@"不可达的网络(未连接)");
//                if (networkStatusBlock) {
//                    networkStatusBlock(@"AFNetworkReachabilityStatusNotReachable");
//                }
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                
//                NSLog(@"2G,3G,4G...的网络");
//                if (networkStatusBlock) {
//                    networkStatusBlock(@"AFNetworkReachabilityStatusReachableViaWWAN");
//                }
//                break;
//                
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                
//                NSLog(@"wifi的网络");
//                if (networkStatusBlock) {
//                    networkStatusBlock(@"AFNetworkReachabilityStatusReachableViaWiFi");
//                }
//                break;
//            default:
//                break;
//        }
//        
//    }];
//    
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
}

#pragma mark -- GET请求 --
/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 
 */
- (NSURLSessionTask *)getWithURLString:(NSString *)URLString
                               headers:(NSDictionary *)headers
                            orbYunType:(OrbYuntSerializerType)type
                            parameters:(id)parameters
                               success:(void (^)(id, NSURLSessionTask *))success
                               failure:(void (^)(NSError *, NSURLSessionTask *))failure{
    
    NSURLSessionTask *sessionTask;
    @try{
        
        //设置请求头
        for (NSString * key in headers) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
       
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        //判断requestSerializer,responseSerializer请求和反馈类型
        if(type == 0) {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }else if(type == 1) {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 2){
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 3){
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }

        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                   @"text/json",
                                                                                   @"text/javascript",
                                                                                   @"text/html",
                                                                                   @"text/plain" ,
                                                                                   @"application/octet-stream",
                                                                                   @"multipart/form-data",
                                                                                   @"application/x-www-form-urlencoded",
                                                                                   @"text/json",
                                                                                   @"text/xml",
                                                                                   @"image/*"]];
        //发送Get请求
        sessionTask = [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功,返回数据
            if (success) {
                [self.hud hide:YES];
                _response = (NSHTTPURLResponse *)task.response;
                success(responseObject,task);
                
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //请求失败,返回错误信息
            [self.hud hide:YES];
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];

    }@catch(NSException *exception){
        [self.hud hide:YES];
        
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
        
    }
    @finally{
        return sessionTask;
    }
}

#pragma mark -- POST请求 --
/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */

- (NSURLSessionTask *)postWithURLString:(NSString *)URLString
                                headers:(NSDictionary *)headers
                             orbYunType:(OrbYuntSerializerType)type
                             parameters:(id)parameters
                                success:(void (^)(id, NSURLSessionTask *))success
                                failure:(void (^)(NSError *, NSURLSessionTask *))failure {
    NSURLSessionTask *sessionTask;
    @try{
        
        //判断requestSerializer,responseSerializer请求和反馈类型
        if (type == 0) {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }else if (type == 1) {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 2){
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 3){
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
        //设置请求头
        for (NSString * key in headers) {
            
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
            
        }
        
        //设置ContentType的格式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                   @"text/json",
                                                                                   @"text/javascript",
                                                                                   @"text/html",
                                                                                   @"text/plain" ,
                                                                                   @"multipart/form-data",
                                                                                   @"application/x-www-form-urlencoded",
                                                                                   @"text/json",
                                                                                   @"text/xml",
                                                                                   @"image/*"]];
        //发送Post请求
        sessionTask = [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.hud hide:YES];
            //请求成功,返回数据
            if (success) {
                num += task.countOfBytesReceived/1024;
                success(responseObject,task);
                
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self.hud hide:YES];
            
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];

    }@catch(NSException *exception){
        [self.hud hide:YES];
        
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
        
    }
    @finally{
        return sessionTask;
    }
    
    
}

#pragma mark -- 上传文件 --
/**
 *  上传文件
 *
 *  @param URLString   上传文件的网址字符串
 *  @param headers     设置请求头
 *  @param type        设置请求类型Http or JSON
 *  @param parameters  上传文件的参数
 *  @param uploadParam 上传文件的信息
 *  @param success     上传成功的回调
 *  @param failure     上传失败的回调
 *
 *  @return 返回请求任务对象
 */
- (NSURLSessionTask *)uploadWithURLString:(NSString *)URLString
                                  headers:(NSDictionary *)headers
                               orbYunType:(OrbYuntSerializerType)type
                               parameters:(id)parameters
                            blockprogress:(void (^)(NSProgress *))prograss
                              filePathUrl:(NSString *)pathUrl
                                  success:(void (^)(id, NSURLSessionTask *))success
                                  failure:(void (^)(NSError *, NSURLSessionTask *))failure{
    NSURLSessionTask *sessionTask;
    @try{
         
        //设置请求头
        for (NSString * key in headers) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        //判断requestSerializer,responseSerializer请求和反馈类型
        if (type == 0) {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }else if (type == 1) {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 2){
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 3){
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
        //进行上传文件请求
        [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //拼接请求数据
            NSURL * fileUrl = [NSURL fileURLWithPath:pathUrl];
            
            NSArray *arr = [pathUrl componentsSeparatedByString:@"/"];
            [formData appendPartWithFileURL:fileUrl name:[arr lastObject] error:nil];
        }progress:^(NSProgress * _Nonnull uploadProgress) {
            //下载进度
            if (prograss) {
                prograss(uploadProgress);
            }
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.hud hide:YES];
            //请求成功,返回数据
            if (success) {
                _response = (NSHTTPURLResponse *)task.response;
                success(responseObject,task);
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.hud hide:YES];
            //请求失败,返回错误信息
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];
        
        
    }@catch(NSException *exception){
        [self.hud hide:YES];
        
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
        
    }
    @finally{
        return sessionTask;
    }
}
#pragma mark -- 下载文件 --
/**
 *  下载文件
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */
-(NSURLSessionTask *)downLoadWithURLString:(NSString *)URLString
                                   headers:(NSDictionary *)headers
                                orbYunType:(OrbYuntSerializerType)type
                                parameters:(id)parameters
                             blockprogress:(void (^)(NSProgress *))prograss
                                   success:(void (^)(id, NSURLSessionTask *))success
                                   failure:(void (^)(NSError *, NSURLSessionTask *))failure{
    NSURLSessionTask *sessionTask;
    @try{
        
        //设置请求头
        for (NSString * key in headers) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        //判断requestSerializer,responseSerializer请求和反馈类型
        if (type == 0) {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }else if (type == 1) {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 2){
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 3){
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
        //进行下载Post请求
        sessionTask = [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            //下载进度
            if (prograss) {
                prograss(uploadProgress);
            }
        }success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.hud hide:YES];
            //请求成功,返回数据
            if (success) {
                _response = (NSHTTPURLResponse *)task.response;
                success(responseObject,task);
                //NSLog(@"%@%@",task,responseObject);
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.hud hide:YES];
            //请求失败,返回错误信息
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];
        
        
    }@catch(NSException *exception){
        [self.hud hide:YES];
        
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
        
    }
    @finally{
        return sessionTask;
    }
}

#pragma mark -- GET请求 --
/**
 *  发送get请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 
 */
- (NSURLSessionTask *)getNewWithURLString:(NSString *)URLString
                               headers:(NSDictionary *)headers
                            orbYunType:(OrbYuntSerializerType)type
                            parameters:(id)parameters
                               success:(void (^)(id, NSURLSessionTask *))success
                               failure:(void (^)(NSError *, NSURLSessionTask *))failure{
    
    NSURLSessionTask *sessionTask;
    @try{
         
        //        设置请求头
        for (NSString * key in headers) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        //判断requestSerializer,responseSerializer请求和反馈类型
        if(type == 0) {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }else if(type == 1) {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 2){
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 3){
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }

        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                   @"text/json",
                                                                                   @"text/javascript",
                                                                                   @"text/html",
                                                                                   @"text/plain" ,
                                                                                   @"application/octet-stream",
                                                                                   @"multipart/form-data",
                                                                                   @"application/x-www-form-urlencoded",
                                                                                   @"text/json",
                                                                                   @"text/xml",
                                                                                   @"image/*"]];
        

        //发送Get请求
        sessionTask = [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.hud hide:YES];
            //请求成功,返回数据
            if (success) {
                _response = (NSHTTPURLResponse *)task.response;
                success(responseObject,task);
                
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self.hud hide:YES];
            //请求失败,返回错误信息
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];

    }@catch(NSException *exception){
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
        
    }
    @finally{
        return sessionTask;
    }
}

/**
 *  发送post请求 含上传进度的
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */

- (NSURLSessionTask *)postProgressWithURLString:(NSString *)URLString headers:(NSDictionary *)headers orbYunType:(OrbYuntSerializerType)type parameters:(id)parameters progress:(void (^)(float))progress success:(void (^)(id, NSURLSessionTask *))success failure:(void (^)(NSError *, NSURLSessionTask *))failure {
    
    NSURLSessionTask *sessionTask;
    
    @try{
         
        //判断requestSerializer,responseSerializer请求和反馈类型
        if (type == 0) {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }else if (type == 1) {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 2){
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 3){
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
        //设置请求头
        for (NSString * key in headers) {
            
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
            
        }
        //设置ContentType的格式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                   @"text/json",
                                                                                   @"text/javascript",
                                                                                   @"text/html",
                                                                                   @"text/plain" ,
                                                                                   @"multipart/form-data",
                                                                                   @"application/x-www-form-urlencoded",
                                                                                   @"text/json",
                                                                                   @"text/xml",
                                                                                   @"image/*"]];
        //发送Post请求
        sessionTask = [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            //返回上传进度
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [self.hud hide:YES];
            //请求成功,返回数据
            if (success) {
                num += task.countOfBytesReceived/1024;
                success(responseObject,task);
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self.hud hide:YES];
            
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
            
        }];
        
    }@catch(NSException *exception){
        [self.hud hide:YES];
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
        
    }
    @finally{
        return sessionTask;
    }
}


/**
 *  发送Gzippost请求
 *
 *  @param URLString  请求的网址字符串
 *  @param headers    设置请求头
 *  @param type       设置请求类型Http or JSON
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回请求任务对象
 */

- (NSURLSessionTask *)postGzipWithURLString:(NSString *)URLString
                                headers:(NSDictionary *)headers
                             orbYunType:(OrbYuntSerializerType)type
                             parameters:(id)parameters
                                success:(void (^)(id, NSURLSessionTask *))success
                                failure:(void (^)(NSError *, NSURLSessionTask *))failure {
    NSURLSessionTask *sessionTask;
    @try{
        
        //判断requestSerializer,responseSerializer请求和反馈类型
        if (type == 0) {
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }else if (type == 1) {
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 2){
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
        }else if(type == 3){
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
        //设置请求头
        for (NSString * key in headers) {
            
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
            
        }
        
        //设置ContentType的格式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                   @"text/json",
                                                                                   @"text/javascript",
                                                                                   @"text/html",
                                                                                   @"text/plain" ,
                                                                                   @"multipart/form-data",
                                                                                   @"application/x-www-form-urlencoded",
                                                                                   @"text/json",
                                                                                   @"text/xml",
                                                                                   @"image/*"]];
        
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
        
        //发送Post请求
        sessionTask = [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self.hud hide:YES];
            //请求成功,返回数据
            if (success) {
                num += task.countOfBytesReceived/1024;
                success(responseObject,task);
                
            }
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self.hud hide:YES];
            if (failure) {
                _response = (NSHTTPURLResponse *)task.response;
                failure(error,task);
            }
        }];

    }@catch(NSException *exception){
        [self.hud hide:YES];
        
        NSLog(@"NSURLSessionTask: 下载数据失败%@",[exception reason]);
        
    }
    @finally{
        return sessionTask;
    }
}
//取消请求
- (void)cancel{

    [manager.operationQueue cancelAllOperations];

}

@end
