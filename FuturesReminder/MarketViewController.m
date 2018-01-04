//
//  ViewController.m
//  FuturesReminder
//
//  Created by liuyang on 2017/7/22.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "MarketViewController.h"
#import "Y_KLineGroupModel.h"
#import "NetWorking.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "ContractListViewController.h"
#import "UIColor+Y_StockChart.h"

@interface MarketViewController ()<UITableViewDataSource,UITableViewDelegate,UITabBarDelegate>
@property (strong,  nonatomic) UITableView *tableView;
@property (strong,  nonatomic) NSArray *datasource;
@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行情";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    // Do any additional setup after loading the view, typically from a nib.
    _datasource = @[@"沥青",@"白银",@"黄金",@"热卷"];
}

- (IBAction)present:(id)sender {
   
}

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSString *text = [_datasource objectAtIndex:indexPath.row];
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      ContractListViewController *contractVC = [[ContractListViewController alloc] initWithNibName:@"ContractListViewController" bundle:nil];
    switch (indexPath.row) {
        case 0:
        {
            contractVC.futuresType = @"BU0";
        }
            
            break;
        case 1:
        {
            contractVC.futuresType = @"AG0";
        }
            
            break;
        case 2:
        {
            contractVC.futuresType = @"AU0";
        }
            
            break;
        case 3:
        {
            contractVC.futuresType = @"HCM";
        }
            
            break;
        default:
            break;
    }
  
    [self.navigationController pushViewController:contractVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
