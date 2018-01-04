//
//  NetWorking.h
//  btc123
//
//  Created by jarze on 16/1/18.
//  Copyright © 2016年 btc123. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetWorking : NSObject

+(void)requestWithApi:(NSString *)url method:(NSString *)method param:(NSMutableDictionary *)param responseSerialization:(AFHTTPResponseSerializer *)responseSerialization thenSuccess:(void (^)(NSDictionary *responseObject))success fail:(void (^)(void))fail;

@end
