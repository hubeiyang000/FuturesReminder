//
//  SymbolCell.h
//  FuturesReminder
//
//  Created by 刘阳 on 2018/1/2.
//  Copyright © 2018年 liuyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SymbolCellDelegate

-(void)symbolSwitchWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface SymbolCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<SymbolCellDelegate> delegate;
@end
