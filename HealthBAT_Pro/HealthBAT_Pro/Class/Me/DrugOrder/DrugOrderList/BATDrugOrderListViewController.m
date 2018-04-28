//
//  BATDrugOrderListViewController.m
//  HealthBAT_Pro
//
//  Created by wct on 2017/12/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrugOrderListViewController.h"
#import "BATDrugOrderAddressInfoViewController.h"
#import "BATDrugOrderInfoViewController.h"
#import "BATBuyOTCViewController.h"

//view
#import "BATDrugOrderTableViewCell.h"
//model
#import "BATDrugOrderListModel.h"

static NSString *const DrugOrder_Cell = @"BATDrugOrderTableViewCell";

@interface BATDrugOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATDrugOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutPages];
    
    self.pageIndex = 1;
    self.dataArray = [NSMutableArray array];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATDrugOrderListDataModel *data = self.dataArray[indexPath.section];
    
    BATDrugOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DrugOrder_Cell forIndexPath:indexPath];
    
    [cell cellReloadWithModel:data];
    
    [cell setClickBaseBtn:^{
        switch (data.Order.OrderState) {
            case -1:
            {
                //付款
                DDLogInfo(@"付款");
                BATBuyOTCViewController *buyOTCVC = [[BATBuyOTCViewController alloc] init];
                buyOTCVC.OrderNo = data.Order.OrderNo;
//                buyOTCVC.RecipeFileID = data.RecipeFiles[0].RecipeFileID;
//                buyOTCVC.RecipeNo = data.RecipeFiles[0].RecipeNo;
//                buyOTCVC.RecipeName = data.RecipeFiles[0].RecipeName;
//                buyOTCVC.Amount = [NSString decimalNumberWithDouble:data.RecipeFiles[0].Amount];
                [self.navigationController pushViewController:buyOTCVC animated:YES];
            }
                break;
            case 0:
            {
                //付款
                DDLogInfo(@"付款");
                BATBuyOTCViewController *buyOTCVC = [[BATBuyOTCViewController alloc] init];
                buyOTCVC.OrderNo = data.Order.OrderNo;
//                buyOTCVC.RecipeFileID = data.RecipeFiles[0].RecipeFileID;
//                buyOTCVC.RecipeNo = data.RecipeFiles[0].RecipeNo;
//                buyOTCVC.RecipeName = data.RecipeFiles[0].RecipeName;
//                buyOTCVC.Amount = [NSString decimalNumberWithDouble:data.RecipeFiles[0].Amount];
                [self.navigationController pushViewController:buyOTCVC animated:YES];
            }
                break;
            case 1:
            {
                //查看物流
                DDLogInfo(@"查看物流（已付款，未发货，查看物流操作）");
                
                BATDrugOrderAddressInfoViewController *addressInfoVC = [[BATDrugOrderAddressInfoViewController alloc]init];
                addressInfoVC.data = data;
                addressInfoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addressInfoVC animated:YES];
            }
                break;
            case 2:
            {
                //已完成 查看物流
                DDLogInfo(@"查看物流（已经完成，查看物流操作）");

                BATDrugOrderAddressInfoViewController *addressInfoVC = [[BATDrugOrderAddressInfoViewController alloc]init];
                addressInfoVC.data = data;
                addressInfoVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:addressInfoVC animated:YES];
            }
                break;
            case 3:
            {
                //已取消
                DDLogInfo(@"已取消");
            }
                break;
            default:
                break;
        }
    }];
    
    [cell setClickOtherBtn:^{
        //只有在付款后未发货才会显示此按钮，对应唯一的取消（取消订单，退款操作）
        DDLogInfo(@"取消（取消订单，退款操作）");
        [self requsetCancelOrderWithOrderNo:data.Order.OrderNo];
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//
//    return nil;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//
//    return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BATDrugOrderListDataModel *data = self.dataArray[indexPath.section];
    BATDrugOrderInfoViewController *drugOrderInfoVC = [[BATDrugOrderInfoViewController alloc]init];
    drugOrderInfoVC.hidesBottomBarWhenPushed = YES;
    drugOrderInfoVC.data = data;
    [self.navigationController pushViewController:drugOrderInfoVC animated:YES];
}

#pragma mark - net
- (void)requsetDrugOrderList {

    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/UserRecipeOrders" parameters:@{@"CurrentPage":@(self.pageIndex),@"PageSize":@"100"} type:kGET success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        BATDrugOrderListModel *drugOrderListModel = [BATDrugOrderListModel mj_objectWithKeyValues:responseObject];
        
        [self.dataArray addObjectsFromArray:drugOrderListModel.Data];
        
        if (self.dataArray.count >= drugOrderListModel.Total) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (self.dataArray.count == 0) {
            [self.defaultView showDefaultView];
            self.defaultView.reloadButton.hidden = YES;
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.pageIndex--;
        if (_pageIndex < 1) {
            _pageIndex = 1;
        }
        
        [self.defaultView showDefaultView];
    }];
}

- (void)requsetCancelOrderWithOrderNo:(NSString *)orderNo {
    
    [HTTPTool requestWithKmWlyyBaseApiURLString:[NSString stringWithFormat:@"/Orders/Cancel?OrderNo=%@",orderNo] parameters:nil type:kPOST success:^(id responseObject) {
        
        [self showSuccessWithText:@"取消成功"];
        [self.tableView.mj_header beginRefreshing];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - layout
- (void)layoutPages {
    
    self.title = @"药品订单";
    self.view.backgroundColor = BASE_BACKGROUND_COLOR;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - setter&getter
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 185;
        
        [_tableView registerClass:[BATDrugOrderTableViewCell class] forCellReuseIdentifier:DrugOrder_Cell];

        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];

        _tableView.tableFooterView = [[UIView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        WEAK_SELF(self);
        _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 1;
            [self.tableView.mj_footer resetNoMoreData];
            [self.dataArray removeAllObjects];
            [self requsetDrugOrderList];
        }];
        
        _tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex ++;
            [self requsetDrugOrderList];
        }];
    }
    return _tableView;
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
            self.defaultView.hidden = YES;
            
            [self.tableView.mj_header beginRefreshing];
            
        }];
        
    }
    return _defaultView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
