//
//  WriteSingleDiseaseView.m
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATWriteSingleDiseaseView.h"
#import "Masonry.h"

@implementation BATWriteSingleDiseaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [self addSubview:_tableView];
        
        [self setupConstraints];
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        
        _footerView = [[BATWriteSingleDiseaseFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.0f)];
        _tableView.tableFooterView = _footerView;
        
        [_footerView.consultBtn addTarget:self action:@selector(consultBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
        
    }];
}

#pragma mark Action
- (void)consultBtnAction:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(consultBtnClickedAction)]) {
        [_delegate consultBtnClickedAction];
    }
}

@end
