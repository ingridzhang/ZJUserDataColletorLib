//
//  NetworkTools.m
//  MyNewBlog
//
//  Created by apple on 15/8/19.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import "NetworkTools.h"

@interface NetworkTools()
@property (nonatomic,strong) NSError *error;
@end

@implementation NetworkTools

#pragma mark 单例
+ (instancetype)sharedInstanceWithUrl:(NSString *)baseURLString {
    
    static NetworkTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:baseURLString];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        instance = [[self alloc] initWithBaseURL:url sessionConfiguration:config];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    });
    return instance;
}

#pragma mark 封装AFN
- (void)requestMethod:(NSString *)method url:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *result,NSError *error))completion {
    
    // 定义成功的block
    void (^successCallBack)(NSURLSessionDataTask *task, NSDictionary *dic) = ^(NSURLSessionDataTask *task, NSDictionary *result){
        if (result != nil) {
            completion(result,nil);
        }else {
            _error = [NSError errorWithDomain:@"NetworkTools.error" code:0 userInfo:@{@"error:":@"没有数据"}];
            completion(nil,self.error);
        }
    };
    // 定义失败的block
    void (^failedCallBack)(NSURLSessionDataTask *task,NSError *error) = ^(NSURLSessionDataTask *task,NSError *error){
        NSLog(@"%@",error);
        completion(nil, error);
    };    
    // 调用方法
    if ([method isEqualToString:@"GET"]){
        [self GET:urlString parameters:params progress:nil success:successCallBack failure:failedCallBack];
    }else {
        [self POST:urlString parameters:params progress:nil success:successCallBack failure:failedCallBack];
    }
}
// 上传图片
- (void)uploadImage:(UIImage *)image url:(NSString *)urlString params:(NSDictionary *)params completion:(void (^)(NSDictionary *result,NSError *error))completion {
    // 定义成功的block
    void (^successCallBack)(NSURLSessionDataTask *task, NSDictionary *dic) = ^(NSURLSessionDataTask *task, NSDictionary *result){
        
        if (result != nil) {
            completion(result,nil);
        }else {
            completion(nil,self.error);
        }
    };
    // 定义失败的block
    void (^failedCallBack)(NSURLSessionDataTask *task,NSError *error) = ^(NSURLSessionDataTask *task,NSError *error){
        
        NSLog(@"%@",error);
        completion(nil, error);
    };
    // AFN上传图片方法
    [self POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         NSData *data = UIImagePNGRepresentation(image);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"xxx" mimeType:@"application/octet-stream"];
    } progress:nil success:successCallBack failure:failedCallBack];
}

@end
