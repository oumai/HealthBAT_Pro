//
//  BATHealthyReportContentTableViewCell.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthyReportContentTableViewCell.h"

@implementation BATHealthyReportContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self layoutView];
    }
    return self;
}
- (void)layoutView {
    
    [self.contentView addSubview:self.titelLab];
  
    
    
    [self.titelLab mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.bottom.mas_equalTo(self.contentView);
    }];
}
- (UILabel *)titelLab {
    
    if (!_titelLab) {
        
        _titelLab = [[UILabel alloc] init];
        _titelLab.textAlignment = NSTextAlignmentRight;
        _titelLab.numberOfLines = 0;
        _titelLab.text = @"交流jjaflsdjlajsdlfjasljflasjflasjflsajfljaslfjalsjflasjlfsajlfjsaljflsjflasjflsajfljaslfjalsjflasjlfsajlfjsaljflsjflasjflsajfljaslfjalsjflasjlfsajlfjsaljflsjflasjflsajfljaslfjalsjflasjlfsajlfjsaljflsjflasjflsajfljaslfjalsjflasjlfsajlfjsaljflsjflasjflsajfljaslfjalsjflasjlfsajlfjsaljflsjflasjflsajfljaslfjalsjflasjlfsajlfjsaljflsjflasjflsajfljaslfjalsjflasjlfsajlfjsaljflasjflsajflsajlfjsalfjlsajflsajflas";
        _titelLab.font = [UIFont systemFontOfSize:15];
        
        
    }
    return _titelLab;
    
}
@end
