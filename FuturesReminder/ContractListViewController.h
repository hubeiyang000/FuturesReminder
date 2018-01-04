//
//  ContractListViewController.h
//  FuturesReminder
//
//  Created by 刘阳 on 2017/12/29.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

//新浪接口
//https://gu.sina.cn/hq/api/openapi.php/FuturesService.getInnerDetail?page=1&num=100&source=app&symbol=RB0
//合约列表
@interface ContractListViewController : UIViewController

@property (nonatomic, strong) NSString *futuresType;

@end
