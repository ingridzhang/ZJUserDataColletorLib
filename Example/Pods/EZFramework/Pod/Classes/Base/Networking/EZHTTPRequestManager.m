//
//  HTTPRequestManager.m
//  EasyJieApp
//
//  Created by sun on 15/8/25.
//  Copyright (c) 2015年 easyjie. All rights reserved.
//

#import "EZHTTPRequestManager.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@implementation EZHTTPRequestManager

+ (AFHTTPSessionManager *)managerWithHeader:(NSDictionary *)header {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    [configuration setHTTPAdditionalHeaders:header];
    [configuration setTimeoutIntervalForRequest:20.0f];
    [configuration setTimeoutIntervalForResource:20.0f];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    return manager;
}

+ (NSURLSessionDataTask *)requestWithRequest:(NSURLRequest *)request
                    header:(NSDictionary *)header
                completion:(void(^)(NSDictionary *responseDic))completion
                   failure:(void(^)(NSError *error, long responseCode))failure {
    AFHTTPSessionManager *manager = [self managerWithHeader:header];
    NSURLSessionDataTask *sessionDataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error) {
            completion(responseObject);
        } else {
            failure(error, httpResponse.statusCode);
        }

    }];
    [sessionDataTask resume];
    return sessionDataTask;
}

+ (NSURLSessionDataTask *)POST:(NSString *)url
     headers:(NSDictionary *)header
        body:(id)body
  completion:(void(^)(NSDictionary *responseDic))completion
     failure:(void(^)(NSError *error, long responseCode))failure {
    NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    [mutableURLRequest setHTTPMethod:@"POST"];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestBySerializingRequest:mutableURLRequest withParameters:body error:nil];
    return [self requestWithRequest:request header:header completion:^(NSDictionary *responseDic) {
        completion(responseDic);
    } failure:^(NSError *error, long responseCode) {
        failure(error, responseCode);
    }];
}

+ (NSURLSessionDataTask *)GET:(NSString *)url
 parameters:(NSDictionary *)parameters
    headers:(NSDictionary *)header
 completion:(void(^)(NSDictionary *responseDic))completion
    failure:(void(^)(NSError *error, long responseCode))failure {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    [mutableURLRequest setHTTPMethod:@"GET"];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestBySerializingRequest:mutableURLRequest
                                                                               withParameters:parameters
                                                                                        error:nil];
    return [self requestWithRequest:request header:header completion:^(NSDictionary *responseDic) {
        completion(responseDic);
    } failure:^(NSError *error, long responseCode) {
        failure(error, responseCode);
    }];
}

+ (NSURLSessionDataTask *)DELETE:(NSString *)url
    parameters:(NSDictionary *)parameters
       headers:(NSDictionary *)header
    completion:(void(^)(NSDictionary *responseDic))completion
       failure:(void(^)(NSError *error, long responseCode))failure {
    NSMutableURLRequest *mutableURLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
    [mutableURLRequest setHTTPMethod:@"DELETE"];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestBySerializingRequest:mutableURLRequest
                                                                               withParameters:parameters
                                                                                        error:nil];
    return [self requestWithRequest:request header:header completion:^(NSDictionary *responseDic) {
        completion(responseDic);
    } failure:^(NSError *error, long responseCode) {
        failure(error, responseCode);
    }];
}

+ (NSURLSessionDataTask *)uploadImagesWithHeader:(NSDictionary *)header
                                             url:(NSString *)url
                                      Parameters:(nullable id)parameters
                                          images:(NSArray<UIImage *> *)images
                                         success:(nullable void (^)(id _Nullable))success
                                         failure:(nullable void (^)(NSError * _Nonnull))failure {
    AFHTTPSessionManager *manager = [self managerWithHeader:header];
    NSURLSessionDataTask *sessionDataTask = [manager POST:url
                                               parameters:parameters
                                constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                    int i = 0;
                                    for (UIImage *image in images) {
                                        NSData *data = UIImageJPEGRepresentation(image, 0.1);
                                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                        // 设置时间格式
                                        formatter.dateFormat = @"yyyyMMddHHmmss";
                                        NSString *str = [formatter stringFromDate:[NSDate date]];
                                        NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", str,[@(i) stringValue]];
                                        NSString *keyString = [NSString stringWithFormat:@"image[%@]",[@(i) stringValue]];
                                        [formData appendPartWithFileData:data name:keyString fileName:fileName mimeType:@"image/png"];
                                        ++i;
                                    }
                                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    success(responseObject);
                                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    failure(error);
                                }];
    [sessionDataTask resume];
    return sessionDataTask;
}

@end
