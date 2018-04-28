//
//  BATEatSearchViewController.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATEatSearchViewController.h"
#import "BATEatSearchTableViewCell.h"
#import "BATEatSerachHeadView.h"
#import "BATEatSearchAlert.h"
#import "UIButton+ImagePosition.h"
#import "BATTrainStudioSearchListViewController.h"
#import "BATEatSearchTwiceViewController.h"
#import "BATHealthyInfoViewController.h"
#import "BATHealthyReportViewController.h"
static NSString *ID = @"BATEatSearchTableViewCell";

@interface BATEatSearchViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *searchBgView;
@property (strong, nonatomic) BATEatSearchAlert *alertView;

/** 顶部搜索 View */
@property (nonatomic, strong) UIView *topSearchView;
@end

@implementation BATEatSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"食物录入";
    
    [self.view addSubview:self.topSearchView];
    [self.view addSubview:self.tableView];
    

}
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    
    [self.topSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topSearchView.mas_bottom);
    }];
    
    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate.window addSubview:self.alertView];
    WEAK_SELF(appDelegate);
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(appDelegate);
        make.top.equalTo(appDelegate.window.mas_top).offset(SCREEN_HEIGHT);
        make.left.right.equalTo(appDelegate.window);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
}



#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        

        [_tableView registerNib:[UINib nibWithNibName:@"BATEatSearchTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        _tableView.rowHeight = 50;
//        _tableView.scrollEnabled = NO;
//        _tableView.allowsSelection = NO;
        [_tableView setSeparatorColor:[UIColor clearColor]];
        

//        BATEatSerachHeadView *headerView = [[BATEatSerachHeadView alloc] init];
//        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//
//        UIView *view = [[UIView alloc] init];
//        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//        [view addSubview:headerView];
//        _tableView.tableHeaderView = view;
        
        
        
    }
    return  _tableView;
    
}
- (BATEatSearchAlert *)alertView {
    
    if (!_alertView) {
        BATEatSearchAlert *view = [[BATEatSearchAlert alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        WEAK_SELF(self);
        
        view.cancleBlock = ^{
            STRONG_SELF(self);
            [self showNewContentView:NO];
        };
        
        view.comfirmBlock = ^{
          
            STRONG_SELF(self);
            [self showNewContentView:NO];
        };
        
        _alertView = view;
        
    }
    return _alertView;
}
- (UIView *)topSearchView{
    
    if (!_topSearchView) {
        _topSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _topSearchView.backgroundColor = [UIColor whiteColor];
        
        UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
        [searchButton setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateNormal];
        [searchButton setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateHighlighted];
        searchButton.backgroundColor = BASE_BACKGROUND_COLOR;
        searchButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        searchButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [searchButton setImage:[UIImage imageNamed:@"ic-search"] forState:UIControlStateNormal];
        [searchButton setTitle:@"搜索护理课程~" forState:UIControlStateNormal];
        [searchButton setTitle:@"搜索护理课程~" forState:UIControlStateHighlighted];
        searchButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        
        //设置图片与文字之间的间距
        [searchButton setImagePosition:ImagePositionLeft spacing:5];
        
        [searchButton addTarget:self action:@selector(pushSearchViewController) forControlEvents:UIControlEventTouchUpInside];
        
        [_topSearchView addSubview:searchButton];
        
    }
    return _topSearchView;
}
#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    
    BATEatSearchTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    if (indexPath.row == 0) {
        
        BATHealthyInfoViewController *vc = [[BATHealthyInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else{
        BATHealthyReportViewController *vc = [[BATHealthyReportViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
//      [self showNewContentView:YES];
    
}
#pragma mark - custom
- (void)showNewContentView:(BOOL)isShow {
    
    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    
    WEAK_SELF(appDelegate);
    [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(appDelegate);
        if (isShow) {
            make.top.equalTo(appDelegate.window.mas_top);
        } else {
            make.top.equalTo(appDelegate.window.mas_top).offset(SCREEN_HEIGHT);
        }
    }];
    
    [UIView animateWithDuration:0.5f animations:^{
        [appDelegate.window setNeedsLayout];
        [appDelegate.window layoutIfNeeded];
    }];
    
    
}
/**
 跳转搜索界面
 */
- (void)pushSearchViewController{
    
//    BATTrainStudioSearchListViewController *searchListVc = [[BATTrainStudioSearchListViewController alloc]init];
//    [self.navigationController pushViewController:searchListVc animated:YES];
    

    BATEatSearchTwiceViewController *searchListVc = [[BATEatSearchTwiceViewController alloc]init];
    [self.navigationController pushViewController:searchListVc animated:YES];
    
}
@end
