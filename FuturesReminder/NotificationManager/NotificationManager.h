//
//  NotificationManager.h
//  BTC-Kline
//
//  Created by liuyang on 2017/7/24.
//  Copyright © 2017年 yate1996. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Y_KLineModel.h"

@interface NotificationManager : NSObject

- (void)creatLocalNotificationWithDate:(NSString *)date Symbol:(NSString *)symbol type:(NSString *)type;

@end
