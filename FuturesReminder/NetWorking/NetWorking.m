//
//  NetWorking.m
//  btc123
//
//  Created by jarze on 16/1/18.
//  Copyright © 2016年 btc123. All rights reserved.
//

#import "NetWorking.h"

@implementation NetWorking

static AFHTTPSessionManager *manager;

//https://gu.sina.cn/hq/api/openapi.php/FuturesService.getInnerDetail?page=1&num=100&source=app&symbol=RB0
+(void)requestWithApi:(NSString *)url method:(NSString *)method param:(NSMutableDictionary *)param responseSerialization:(AFHTTPResponseSerializer *)responseSerialization thenSuccess:(void (^)(NSDictionary *responseObject))success fail:(void (^)(void))fail
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    //申明返回的结果类型
    manager.responseSerializer = responseSerialization;
    /** 设置请求秒数*/
    manager.requestSerializer.timeoutInterval = 10;
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    if ([method isEqualToString:@"POST"]) {
        
        [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                !success ? : success(responseObject);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                !fail ? : fail();
            });
        }];
    }else if ([method isEqualToString:@"GET"]){
        [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"111");
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !success ? : success(responseObject);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"Error: %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                !fail ? : fail();
            });
        }];
    }
}
@end
