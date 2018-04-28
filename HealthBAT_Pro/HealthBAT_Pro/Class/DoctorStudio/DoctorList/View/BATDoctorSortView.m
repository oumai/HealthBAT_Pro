//
//  BATDoctorSortView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorSortView.h"
#import "BATDoctorSortTableViewCell.h"

@interface BATDoctorSortView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation BATDoctorSortView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self pageLayout];
        
        [self.tableView registerClass:[BATDoctorSortTableViewCell class] forCellReuseIdentifier:@"BATDoctorSortTableViewCell"];
        
        _dataSource = [NSMutableArray arrayWithObjects:@"综合排序",@"咨询人次",@"评价最高", nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATDoctorSortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorSortTableViewCell" forIndexPath:indexPath];
    
    [cell.titleLabel setTitle:_dataSource[indexPath.row] forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //综合排序
        self.doctorSort = BATDoctorSort_Integrated;
    } else if (indexPath.row == 1) {
        //咨询人次
        self.doctorSort = BATDoctorSort_Consultations;
    } else if (indexPath.row == 2) {
        //评价最高
        self.doctorSort = BATDoctorSort_Commnet;
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.tableView];
    
    WEAK_SELF(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        if (iPhoneX) {
            if (@available(iOS 11.0, *)) {
                make.edges.equalTo(self).insets(UIEdgeInsetsMake(20 + 30, 0, 0, 0));
            }
        } else {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(20, 0, 0, 0));
        }
        
    }];
}

#pragma mark - get & set
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.doctorSortFooterView;
    }
    return _tableView;
}

- (BATDoctorSortFooterView *)doctorSortFooterView
{
    if (_doctorSortFooterView == nil) {
        _doctorSortFooterView = [[BATDoctorSortFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    return _doctorSortFooterView;
}

@end
