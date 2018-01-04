//
//  ContractListViewController.m
//  FuturesReminder
//
//  Created by 刘阳 on 2017/12/29.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "ContractListViewController.h"
#import "NetWorking.h"
#import "Y_StockChartViewController.h"
#import "NSDictionary+safe.h"
#import "SymbolCell.h"
#import "CycleMonitorController.h"

@interface ContractListViewController ()<SymbolCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *datasource;
//@property (nonatomic, strong) Y_StockChartViewController *stockCharVC;
@end

@implementation ContractListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _datasource = [NSArray array];
    [self contarctList];
}

#pragma mark SymbolCellDelegate
-(void)symbolSwitchWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath) {
        NSDictionary *dic = [_datasource objectAtIndex:indexPath.row];
        NSString *symbol = [dic objectForKey:@"symbol"];
        if (symbol.length > 0) {
            CycleMonitorController *cycleMonitorVC = [CycleMonitorController shareCycleMonitorController];
            [cycleMonitorVC.symbols addObject:symbol];
        }
    }
}

//- (Y_StockChartViewController *)stockCharVC{
//
//    if (!_stockCharVC) {
//        _stockCharVC = [[Y_StockChartViewController alloc] init];
//        _stockCharVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    }
//    return _stockCharVC;
//}

//https://gu.sina.cn/hq/api/openapi.php/FuturesService.getInnerDetail?page=1&num=100&source=app&symbol=RB0
- (void)contarctList{

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:1];
    [param safeValue:@"1" forKey:@"page"];
    [param safeValue:@"100" forKey:@"num"];
    [param safeValue:@"app" forKey:@"source"];
    [param safeValue:self.futuresType forKey:@"symbol"];
    [NetWorking requestWithApi:ContractList method:@"GET" param:param responseSerialization:[AFJSONResponseSerializer serializer] thenSuccess:^(NSDictionary *responseObject) {
        NSDictionary *result = [responseObject objectForKey:@"result"];
        NSArray *arr = [[result objectForKey:@"data"] objectForKey:@"inner_detail"];
        if ([arr isKindOfClass:[NSArray class]]) {
            self.datasource = [NSArray arrayWithArray:arr];
            [self.tableView reloadData];
        }
    } fail:^{
        
    }];
}


#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasource ? _datasource.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    SymbolCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell =[[[NSBundle mainBundle] loadNibNamed:@"SymbolCell" owner:nil options:nil] firstObject];
    }
    cell.delegate = self;
    cell.indexPath = indexPath;
    NSDictionary *dic = [_datasource objectAtIndex:indexPath.row];
    cell.symbolLabel.text = [dic objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_datasource objectAtIndex:indexPath.row];
    NSString *symbol = [dic objectForKey:@"symbol"];
    Y_StockChartViewController *stockCharVC = [[Y_StockChartViewController alloc] init];
    stockCharVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    stockCharVC.symbol = symbol;
    [self presentViewController:stockCharVC animated:YES completion:nil];
    //[self.navigationController pushViewController:self.stockCharVC animated:YES];
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
