//
//  BATHealthThreeSecondsDateCell.m
//  HealthBAT_Pro
//
//  Created by KM_MAC on 2017/12/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsDateCell.h"
#import "BATHealthThreeSecondsTopChangeDateView.h"

@implementation BATHealthThreeSecondsDateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.topChangeDateView];
    }
    return self;
}
- (BATHealthThreeSecondsTopChangeDateView *)topChangeDateView{
    
    if (!_topChangeDateView) {
        _topChangeDateView = [[BATHealthThreeSecondsTopChangeDateView alloc]init];
    }
    return _topChangeDateView;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topChangeDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
}

@end
