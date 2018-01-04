//
//  SymbolCell.m
//  FuturesReminder
//
//  Created by 刘阳 on 2018/1/2.
//  Copyright © 2018年 liuyang. All rights reserved.
//

#import "SymbolCell.h"


@interface SymbolCell()
@property (weak, nonatomic) IBOutlet UISwitch *symbolSwitch;

@end



@implementation SymbolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)switchAction:(id)sender {
    UISwitch *symbolSwitch = (UISwitch *)sender;
    if (symbolSwitch.on && self.indexPath) {
        [self.delegate symbolSwitchWithIndexPath:self.indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
