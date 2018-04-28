//
//  BATTraditionSecondViewController.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTraditionSecondViewController.h"
#import "BATSecondTableViewCell.h"
#import "BATTraditionNextFooter.h"

#import "BATTraditionThirdViewController.h"

static  NSString * const SECOND_CELL = @"BATSecondTableViewCell";

@interface BATTraditionSecondViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIButton *popBtn;
@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) NSMutableArray *desArray;

@end

@implementation BATTraditionSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataArray = @[
                       @{@"日常健身":@[@"从不",@"偶尔",@"经常",]},
                       @{@"睡眠质量":@[@"失眠多梦",@"正常",@"困倦嗜睡",]},
                       @{@"饮食状况":@[@"食欲不振",@"三餐正常",@"饮食不规律",]},
                       @{@"精神状况":@[@"低落",@"轻松",@"烦躁",]},
                       @{@"工作状态":@[@"拖沓犹豫",@"按部就班",@"雷厉风行"]},
                       ];

    NSArray *tmpArray = @[@{@"title":@"日常健身"},@{@"title":@"睡眠质量"},@{@"title":@"饮食状况"},@{@"title":@"精神情绪"},@{@"title":@"工作状态"}];
    self.desArray = [NSMutableArray arrayWithArray:tmpArray];

    [self layoutPages];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BATSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SECOND_CELL forIndexPath:indexPath];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    cell.titleLabel.text = dic.allKeys.firstObject;
    NSArray *titleArray = dic[dic.allKeys.firstObject];
    for (NSString *title in titleArray) {
        [cell.segment insertSegmentWithTitle:title atIndex:[titleArray indexOfObject:title] animated:YES];
    }
    
    [cell.segment mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH-125);
    }];
    
    [cell layoutIfNeeded];

    [cell setSegmentClick:^(NSInteger selectedIndex) {

        NSDictionary *tmpDic = self.desArray[indexPath.row];
        NSMutableDictionary *tmpDicM = [NSMutableDictionary dictionaryWithDictionary:tmpDic];

        NSArray *titleArray = dic[dic.allKeys.firstObject];
        NSString *key = @"desc";
        [tmpDicM setObject:titleArray[selectedIndex] forKey:key];

        [self.desArray replaceObjectAtIndex:indexPath.row withObject:tmpDicM];

    }];

    return cell;
}

- (void)layoutPages {
    
    WEAK_SELF(self);
    
    [self.view addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT));
    }];

    [self.view addSubview:self.popBtn];
    [self.popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@30);
    }];

    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.popBtn.mas_bottom).offset(15);
    }];
    
    [self.view addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];

    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(@0);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(@0);
    }];


}


#pragma mark - getter
- (UIButton *)popBtn {
    
    if (!_popBtn) {
        _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_popBtn setImage:[UIImage imageNamed:@"back-icon-w"] forState:UIControlStateNormal];
        [_popBtn bk_whenTapped:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _popBtn;
}


- (UIImageView *)backgroundView {
    
    if (!_backgroundView) {
        
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guoyiguan-back"]];
        
    }
    return _backgroundView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont boldSystemFontOfSize:24] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        _titleLabel.text = @"您近期的身体怎么样";
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0xffffff, 1) textAlignment:NSTextAlignmentCenter];
        _detailLabel.text = @"这些进阶数据直接反应您的健康状况";
    }
    return _detailLabel;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        [_tableView registerClass:[BATSecondTableViewCell class] forCellReuseIdentifier:SECOND_CELL];
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 65;
        _tableView.scrollEnabled = NO;

        BATTraditionNextFooter *footer = [[BATTraditionNextFooter alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
        WEAK_SELF(self);
        [footer.nextBtn bk_whenTapped:^{
            STRONG_SELF(self);
            BATTraditionThirdViewController *thirdVC = [[BATTraditionThirdViewController alloc] init];

            NSString *BodyStatus = [Tools dataTojsonString:self.desArray];
            self.model.BodyStatus = BodyStatus;
            thirdVC.model = self.model;
            [self.navigationController pushViewController:thirdVC animated:YES];
        }];
        _tableView.tableFooterView = footer;

        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
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
