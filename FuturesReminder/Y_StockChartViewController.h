//
//  YStockChartViewController.h
//  BTC-Kline
//
//  Created by yate1996 on 16/4/27.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Y_StockChartView.h"

typedef NS_ENUM(NSInteger,FuturesType){
    BU0 = 0,    //沥青
    AG0 = 1,     //白银
    AU0 = 2,       //黄金
    HCM = 3   //热卷
};

@interface Y_StockChartViewController : UIViewController
@property (nonatomic, strong) Y_StockChartView *stockChartView;
@property (nonatomic, assign) FuturesType futuresType;
@property (nonatomic, copy) NSString *contractNum;//合约号
@property (nonatomic, copy) NSString *symbol;//合约
- (void)loadFuturesDataWithSymbol:(NSString *)symbol type:(NSString *)type futuyresType:(NSString *)futuresType;
- (id) stockDatasWithIndex:(NSInteger)index;
@end
