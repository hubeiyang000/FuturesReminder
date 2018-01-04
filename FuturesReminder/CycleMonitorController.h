//
//  CycleMonitorController.h
//  FuturesReminder
//
//  Created by 刘阳 on 2018/1/2.
//  Copyright © 2018年 liuyang. All rights reserved.
//

#import "Y_StockChartViewController.h"

@interface CycleMonitorController : Y_StockChartViewController
@property (nonatomic, strong) NSMutableArray *symbols;
@property (nonatomic, strong) NSMutableArray *types;
+(instancetype)shareCycleMonitorController;

@end
