//
//  AppDelegate.h
//  FuturesReminder
//
//  Created by liuyang on 2017/7/22.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ACTIVITE  = 1,
    BACKGROUD = 2,
}APPSTATE;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, assign) BOOL isEable;

@property (nonatomic, assign) APPSTATE appState;

@end

