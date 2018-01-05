//
//  NotificationManager.m
//  BTC-Kline
//
//  Created by liuyang on 2017/7/24.
//  Copyright © 2017年 yate1996. All rights reserved.
//

#import "NotificationManager.h"
#import <UIKit/UIKit.h>

@interface NotificationManager()
@property (nonatomic, assign) BOOL needReminder;

@property (nonatomic, strong) NSMutableArray *noReminderElements;

@end

@implementation NotificationManager

static NotificationManager *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            _instance.needReminder = YES;
            _instance.noReminderElements = [[NSMutableArray alloc] initWithCapacity:1];
        }
    });
    return _instance;
}

- (void)creatLocalNotificationWithDate:(NSString *)date Symbol:(NSString *)symbol type:(NSString *)type
{
    [self.noReminderElements enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:date]) {
            _needReminder = NO;
        }
    }];

    if([NotificationManager runningInBackground] && self.needReminder){
        [self postLocalNotificationWithDate:date Symbol:symbol type:type];
    }else if ([NotificationManager runningInForeground] && self.needReminder){
        [self showAlertViewWithDate:date Symbol:symbol type:type];
    }
    
    self.needReminder = YES;
}

- (void)showAlertViewWithDate:(NSString *)date Symbol:(NSString *)symbol type:(NSString *)type{
    NSString *message = [NSString stringWithFormat:@"Date:%@\nsymbol:%@\nklineType:%@",date,symbol,type];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"不再提醒" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.noReminderElements addObject:date];
    }];
    [alertVC addAction:action];
    [alertVC addAction:cancelAction];
    [[self currentViewController] presentViewController:alertVC animated:YES completion:nil];
//    [[[UIAlertView alloc] initWithTitle:@"提醒" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

- (void)postLocalNotificationWithDate:(NSString *)date Symbol:(NSString *)symbol type:(NSString *)type{
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


//获取Window当前显示的ViewController
- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
@end
