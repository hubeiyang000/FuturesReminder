//
//  YStockChartViewController.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/27.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartViewController.h"
#import "Masonry.h"
#import "NetWorking.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "NSDictionary+safe.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import <Foundation/Foundation.h>

@interface Y_StockChartViewController ()<Y_StockChartViewDataSource>



@property (nonatomic, strong) Y_KLineGroupModel *groupModel;

@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;


@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, copy) NSString *type;

@end

@implementation Y_StockChartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentIndex = 4;
    if (!self.symbol)self.symbol = @"BU0";
#pragma mark stockChartView
    self.stockChartView.backgroundColor = [UIColor backgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lineTypeChanged:) name:LineTypeChanged object:nil];
}

- (void)lineTypeChanged:(NSNotification *)notification{
    if ([notification.object isKindOfClass:[NSNumber class]]) {
        NSInteger index = [notification.object integerValue];
        [self stockDatasWithIndex:index];
    }
    
    NSLog(@"%@",notification);
}

- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of  nmthat can be recreated.
}

-(id)stockDatasWithIndex:(NSInteger)index
{
    NSString *type;
    switch (index) {
        case 1:
        {//分时
            return nil;
            //type = @"getInnerFuturesMiniKLine15m";
        }
            break;
        case 2:
        {//5分钟
            type = kline5m;
        }
            break;
        case 3:
        {//15分钟
            type = kline15m;
        }
            break;
        case 4:
        {//30分钟
            type = kline30m;
        }
            break;
        case 5:
        {//60分钟
            type = kline60m;
        }
            break;
        case 6:
        {//日线
            type = klineDay;
        }
            break;
        case 7:
        {//周线
            return nil;
            //type = @"getInnerFuturesMiniKLine15m";
        }
            break;
            
        default:
            break;
    }
    
    self.currentIndex = index;
    self.type = type;
    if(![self.modelsDict objectForKey:type])
    {
        [self reloadData];
    } else {
        NSArray *models = [NSArray arrayWithArray:[self.modelsDict objectForKey:type].models];
        [self.modelsDict removeObjectForKey:type];
        return models;
    }
    return nil;
}

- (void)setSymbol:(NSString *)symbol{
    _symbol = symbol;
    self.title = _symbol;
}

- (void)reloadData
{
    [self loadFuturesDataWithSymbol:self.symbol type:self.type futuyresType:self.type];
}

- (void)loadFuturesDataWithSymbol:(NSString *)symbol type:(NSString *)type futuyresType:(NSString *)futuresType{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params safeValue:symbol forKey:@"symbol"];
    [params safeValue:type forKey:@"type"];
    NSString *urlStr = baseUrl;
    urlStr = [urlStr stringByAppendingString:symbol];
    urlStr = [urlStr stringByAppendingString:@"_"];
    urlStr = [urlStr stringByAppendingString:type];
    urlStr = [urlStr stringByAppendingString:@"_"];
    NSInteger timeSp = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue];
    urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"%ld",timeSp]];
    urlStr = [urlStr stringByAppendingString:minLine];

    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    [NetWorking requestWithApi:urlStr  method:@"GET" param:params responseSerialization:serializer thenSuccess:^(NSDictionary *responseObject) {
        NSArray *jsonArr;
        if ([responseObject isKindOfClass:[NSArray class]]) {
            jsonArr = (NSArray *)responseObject;
     
        }else if([responseObject isKindOfClass:[NSData class]]){
            NSData *data = (NSData *)responseObject;
            NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *receiveStr = [[str componentsSeparatedByString:@"="] lastObject];
            receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@"o" withString:@"\"o\""];
            receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@"h" withString:@"\"h\""];
            receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@"l" withString:@"\"l\""];
            receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@"c" withString:@"\"c\""];
            receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@"d" withString:@"\"d\""];
            receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@"v" withString:@"\"v\""];
            receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@"(" withString:@""];
            receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@")" withString:@""];
            receiveStr = [receiveStr stringByReplacingOccurrencesOfString:@";" withString:@""];
            NSData * receiveData = [receiveStr dataUsingEncoding:NSUTF8StringEncoding];
            
            jsonArr = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
        }
        //拿到排序后的数据
        NSArray *sortArray = [jsonArr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDictionary *dic1 = obj1;
            NSDictionary *dic2 = obj2;
            NSComparisonResult result = [[dic1 objectForKey:@"d"] compare:[dic2 objectForKey:@"d"]];
            return result == NSOrderedDescending;
        }];
        if (self.groupModel) {
            [self.groupModel.models removeAllObjects];
            self.groupModel.models = nil;
        }
        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:sortArray withFuturesType:futuresType];
        self.groupModel = groupModel;
        [self.modelsDict setObject:groupModel forKey:type];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.stockChartView reloadDataWithIndex:self.currentIndex];
        });
        
    } fail:^{
        // [[[UIAlertView alloc] initWithTitle:nil message:@"获取行情数据失败" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles: nil] show];
    }];
}


- (Y_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [Y_StockChartView new];
        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"指标" type:Y_StockChartcenterViewTypeOther],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"分时" type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"5分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"15分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"30分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"60分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"日线" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"周线" type:Y_StockChartcenterViewTypeKline],
 
                                       ];
        _stockChartView.backgroundColor = [UIColor orangeColor];
        _stockChartView.dataSource = self;
        [self.view addSubview:_stockChartView];
        [_stockChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        tap.numberOfTapsRequired = 2;
        [self.view addGestureRecognizer:tap];
    }
    return _stockChartView;
}
- (void)dismiss
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isEable = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate
{
    return NO;
}
@end
