//
//  CycleMonitorController.m
//  FuturesReminder
//
//  Created by 刘阳 on 2018/1/2.
//  Copyright © 2018年 liuyang. All rights reserved.
//

#import "CycleMonitorController.h"
#import "NSDictionary+safe.h"
#import "NetWorking.h"
#import "NotificationManager.h"

@interface CycleMonitorController ()

@end

@implementation CycleMonitorController


static CycleMonitorController *_instance;
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_instance == nil) {
            _instance = [super allocWithZone:zone];
            [_instance repeat];
        }
    });
    return _instance;
}

// 为了使实例易于外界访问 我们一般提供一个类方法
// 类方法命名规范 share类名|default类名|类名
+(instancetype)shareCycleMonitorController
{
    //return _instance;
    // 最好用self 用Tools他的子类调用时会出现错误
    return [[self alloc]init];
}

// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
-(id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}


- (void)repeat{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:15.0
                                                 target:self
                                               selector:@selector(startLoad)
                                               userInfo:nil
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        // 启动子线程的运行循环，这句代码就是一个死循环！如果不停止运行循环，不会执行后续的任何代码
        CFRunLoopRun();
    });
}

- (void)startLoad{
    [self.symbols enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *symbol = obj;
        for (NSInteger i = 0; i<self.types.count; i++) {
            NSString *type = self.types[i];
            [self loadFuturesDataWithSymbol:symbol type:type futuyresType:type];
        }
    }];
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
    [NetWorking requestWithApi:urlStr  method:@"GET" param:params responseSerialization:serializer  thenSuccess:^(NSDictionary *responseObject) {
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
        [sortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx > (sortArray.count-5)) {
                NSDictionary *dic = obj;
                float open = [dic[@"o"] floatValue];
                float high = [dic[@"h"] floatValue];
                float low = [dic[@"l"] floatValue];
                float close = [dic[@"c"] floatValue];
                float shadowLineHeight = fabsf(high  - low);
                float entityLineHeight = fabsf(open - close);
                if (shadowLineHeight/entityLineHeight > 2.5) {
                    [[[NotificationManager alloc] init] creatLocalNotificationWithDate:dic[@"d"] Symbol:symbol type:type];
                }
            }
        }];
    } fail:^{
        // [[[UIAlertView alloc] initWithTitle:nil message:@"获取行情数据失败" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles: nil] show];
    }];
}

- (NSMutableArray *)symbols{
    if (!_symbols) {
        _symbols = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _symbols;
}

- (NSMutableArray *)types{
    if (!_types) {
        _types = [[NSMutableArray alloc] initWithCapacity:1];
        [_types addObject:kline5m];
        [_types addObject:kline15m];
        [_types addObject:kline30m];
        [_types addObject:kline60m];
//        [_types addObject:klineDay];
    }
    return _types;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
