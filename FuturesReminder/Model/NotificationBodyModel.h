//
//  NotificationBodyModel.h
//  FuturesReminder
//
//  Created by 刘阳 on 2017/12/14.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationBodyModel : NSObject

@property (nonatomic, copy) NSString *futuresType;//期货类型
@property (nonatomic, copy) NSString *time;       //时间
@property (nonatomic, copy) NSString *kLineType;  //K线类型
@property (nonatomic, copy) NSString *closePrice; //收盘价格
@end
