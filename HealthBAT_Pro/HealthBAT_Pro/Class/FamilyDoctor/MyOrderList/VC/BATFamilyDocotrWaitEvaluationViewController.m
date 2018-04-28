//
//  BATFamilyDocotrWaitEvaluationViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDocotrWaitEvaluationViewController.h"

#import "BATContractDetailViewController.h"
#import "BATFamilyDoctorOrderDetailViewController.h"
#import "BATComplaintController.h"

#import "BATFamilyDoctotOrderCell.h"

#import "BATFamilyDoctorOrderModel.h"

static NSString *const OrderCell = @"BATFamilyDoctotOrderCell";

@interface BATFamilyDocotrWaitEvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BATDefaultView *defaultView;

@property (nonatomic,strong) UITableView *familyDoctorOrderListTableView;

/**
 *  数据源
 */
@property (nonatomic,strong) NSMutableArray *dataSource;

/**
 *  页码
 */
@property (nonatomic,assign) NSInteger pageIndex;
/**
 *  每页显示条数
 */
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation BATFamilyDocotrWaitEvaluationViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    self.familyDoctorOrderListTableView.delegate = nil;
    self.familyDoctorOrderListTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"FamilyDoctorEvaluationSuccess" object:nil];
    
    _dataSource = [[NSMutableArray alloc]init];
    _pageSize = 10;
    _pageIndex = 0;
    
    [self pagesLayout];
    
    [self.familyDoctorOrderListTableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.defaultView.hidden = YES;
    
    if(self.dataSource.count == 0){
        [self.familyDoctorOrderListTableView.mj_header beginRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData{
    
    [self requestWaitEvaulationOrderList];
}

#pragma mark - net
- (void)requestWaitEvaulationOrderList{
    
    [HTTPTool requestWithURLString:@"/api/Order/GetFamilyDoctorOrder" parameters:@{@"orderStatus":@(3),@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize)} type:kGET success:^(id responseObject) {
        
        [self.familyDoctorOrderListTableView.mj_footer endRefreshing];
        [self.familyDoctorOrderListTableView.mj_header endRefreshing];
        
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        BATFamilyDoctorOrderModel *familyDoctorOrderModel = [BATFamilyDoctorOrderModel mj_objectWithKeyValues:responseObject];
        
        [_dataSource addObjectsFromArray:familyDoctorOrderModel.Data];
        
        if (familyDoctorOrderModel.RecordsCount > 0) {
            self.familyDoctorOrderListTableView.mj_footer.hidden = NO;
        } else {
            self.familyDoctorOrderListTableView.mj_footer.hidden = YES;
        }
        
        if (_dataSource.count == familyDoctorOrderModel.RecordsCount) {
            [self.familyDoctorOrderListTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.familyDoctorOrderListTableView reloadData];
        
        if (_dataSource.count == 0) {
            [self.defaultView showDefaultView];
        }
        
    } failure:^(NSError *error) {
        [self.familyDoctorOrderListTableView.mj_footer endRefreshing];
        [self.familyDoctorOrderListTableView.mj_header endRefreshing];
        
        _pageIndex--;
        if (_pageIndex < 0) {
            _pageIndex = 0;
        }
        
        [self.defaultView showDefaultView];
    }];
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BATFamilyDoctotOrderCell *familyDoctotOrderCell = [tableView dequeueReusableCellWithIdentifier:OrderCell forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        
        BATFamilyDoctorOrderData *data = _dataSource[indexPath.row];
        
        [familyDoctotOrderCell cellWithData:data];
        
        [familyDoctotOrderCell setRequestBtnClickBlock:^{
            DDLogInfo(@"评价！");
            
            BATComplaintController *complaintVC = [[BATComplaintController alloc] init];
            complaintVC.OrderMSTID = data.OrderNo;
            complaintVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:complaintVC animated:YES];
        }];
        
        [familyDoctotOrderCell setContractDetailBtnClickBlock:^{
            //附件合同
            
            BATFamilyDoctorOrderData *data = _dataSource[indexPath.row];
            
            BATContractDetailViewController *contractDetail = [[BATContractDetailViewController alloc] init];
            
            contractDetail.orderNO = data.OrderNo;
            contractDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:contractDetail animated:YES];
        }];
        
        [familyDoctotOrderCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return familyDoctotOrderCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSource.count > 0) {
        
        BATFamilyDoctorOrderData *data = _dataSource[indexPath.row];
        
        BATFamilyDoctorOrderDetailViewController *orderDetail = [[BATFamilyDoctorOrderDetailViewController alloc] init];
        orderDetail.orderNo = data.OrderNo;
        orderDetail.OrderStateShow = data.OrderStatusShow;
        orderDetail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderDetail animated:YES];
    }
}

#pragma mark -pagesLayout
- (void)pagesLayout{
    
    WEAK_SELF(self);
    [self.view addSubview:self.familyDoctorOrderListTableView];
    [self.familyDoctorOrderListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -get&&set
- (UITableView *)familyDoctorOrderListTableView{
    if (!_familyDoctorOrderListTableView) {
        _familyDoctorOrderListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _familyDoctorOrderListTableView.delegate = self;
        _familyDoctorOrderListTableView.dataSource = self;
        _familyDoctorOrderListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _familyDoctorOrderListTableView.backgroundColor = UIColorFromHEX(0xf1f1f1, 1);
        
        [_familyDoctorOrderListTableView registerClass:[BATFamilyDoctotOrderCell class] forCellReuseIdentifier:OrderCell];
        
        WEAK_SELF(self);
        _familyDoctorOrderListTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"下拉刷新！");
            self.pageIndex = 0;
            [self.familyDoctorOrderListTableView.mj_footer resetNoMoreData];
            [self requestWaitEvaulationOrderList];
        }];
        _familyDoctorOrderListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestWaitEvaulationOrderList];
        }];
    }
    return _familyDoctorOrderListTableView;
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
            [self requestWaitEvaulationOrderList];
        }];
        
    }
    return _defaultView;
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
