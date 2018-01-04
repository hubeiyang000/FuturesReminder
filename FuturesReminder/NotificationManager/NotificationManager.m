//
//  NotificationManager.m
//  BTC-Kline
//
//  Created by liuyang on 2017/7/24.
//  Copyright © 2017年 yate1996. All rights reserved.
//

#import "NotificationManager.h"
#import <UIKit/UIKit.h>

@implementation NotificationManager


- (void)creatLocalNotificationWithDate:(NSString *)date Symbol:(NSString *)symbol type:(NSString *)type
{
    if([NotificationManager runningInBackground]){
        [NotificationManager postLocalNotificationWithDate:date Symbol:symbol type:type];
    }else if ([NotificationManager runningInForeground]){
        [NotificationManager showAlertViewWithDate:date Symbol:symbol type:type];
    }
}

+ (void)showAlertViewWithDate:(NSString *)date Symbol:(NSString *)symbol type:(NSString *)type{
    NSString *message = [NSString stringWithFormat:@"Date:%@\nsymbol:%@\nklineType:%@",date,symbol,type];
    [[[UIAlertView alloc] initWithTitle:@"提醒" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

+ (void)postLocalNotificationWithDate:(NSString *)date Symbol:(NSString *)symbol type:(NSString *)type{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate           = [NSDate dateWithTimeIntervalSinceNow:10];
    notification.alertBody          = [NSString stringWithFormat:@"Date:%@\nsymbol:%@\nklineType:%@",date,symbol,type];
    notification.alertLaunchImage   = @"icon.png";
    
    //如果通知提醒样式为横幅则alertAction属性无显示 样式为提醒的时候alertAction显示为UIAlertView的右侧按钮
    notification.alertAction        = @"alertAction";
    
    //提示音
    notification.soundName          = UILocalNotificationDefaultSoundName;
    //时区
    notification.timeZone           = [NSTimeZone defaultTimeZone];
    
    //0表示不重复,这里可以设置成每天,每小时等等
    notification.repeatInterval     = 0;
    
    //userInfo用来存储一些信息,比如用于区别其他通知的id等等
    notification.userInfo           = [NSDictionary dictionaryWithObjectsAndKeys:@"tag", @"id",nil];
    notification.applicationIconBadgeNumber = 1;
    
    //生效时间根据fireDate确定
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //立即生效的通知,与fireDate无关
    //[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
    //取消通知可以用下面的方法
    //[[UIApplication sharedApplication] cancelLocalNotification:notification];
    //取消全部到本地通知
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //通过userInfo来区分不同的通知
    /*
     for (UILocalNotification *notification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
     NSString *indentiString = [notification.userInfo objectForKey:@"id"];
     if ([indentiString isEqualToString:@"tag"] == YES) {
     [[UIApplication sharedApplication] cancelLocalNotification:notification];
     }
     }
     */
}

+(BOOL) runningInBackground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateBackground);
    
    return result;
}

+(BOOL) runningInForeground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateActive);
    
    return result;
}

@end
