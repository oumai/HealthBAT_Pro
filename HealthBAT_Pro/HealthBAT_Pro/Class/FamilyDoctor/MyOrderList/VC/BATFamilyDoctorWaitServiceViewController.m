//
//  BATFamilyDoctorWaitServiceViewController.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/11.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorWaitServiceViewController.h"

#import "BATContractDetailViewController.h"
#import "BATFamilyDoctorOrderDetailViewController.h"
#import "BATFamilyDoctorChatViewController.h"

#import "BATFamilyDoctotOrderCell.h"

#import "BATFamilyDoctorOrderModel.h"

#import "BATCallViewController.h"

static NSString *const OrderCell = @"BATFamilyDoctotOrderCell";

@interface BATFamilyDoctorWaitServiceViewController ()<UITableViewDelegate,UITableViewDataSource>

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

/**
 *  咨询按钮显示数据
 */
@property (nonatomic,assign) BOOL isShowText;
@property (nonatomic,assign) BOOL isShowVoice;
@property (nonatomic,assign) BOOL isShowVedio;

@end

@implementation BATFamilyDoctorWaitServiceViewController


- (void)dealloc
{
    DDLogWarn(@"%@",self);
    self.familyDoctorOrderListTableView.delegate = nil;
    self.familyDoctorOrderListTableView.dataSource = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataSource = [[NSMutableArray alloc]init];
    _pageSize = 10;
    _pageIndex = 0;
    _isShowText = NO;
    _isShowVedio = NO;
    _isShowVoice = NO;
    
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

#pragma mark - action
- (void)moreAction:(NSIndexPath *)indexPath
{
    BATFamilyDoctorOrderData *data = _dataSource[indexPath.row];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF(self);
    UIAlertAction *texttAction = [UIAlertAction actionWithTitle:@"图文咨询" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF(self);
        DDLogInfo(@"图文咨询!");
        
        BATFamilyDoctorChatViewController *chatVC = [[BATFamilyDoctorChatViewController alloc] initWithConversationType:ConversationType_GROUP targetId:data.RoomID];
        chatVC.title = @"图文咨询";
        chatVC.DoctorName = data.DoctorName;
        chatVC.DoctorPhotoPath = data.DoctorPic;
        chatVC.DoctorId = data.DoctorID;
        chatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
    }];
    
    UIAlertAction *voiceAction = [UIAlertAction actionWithTitle:@"语音咨询" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DDLogInfo(@"语音咨询!");
        //进入诊室
        BATCallViewController *callRoomVC = [[BATCallViewController alloc] init];
        callRoomVC.doctorName = data.DoctorName;
        callRoomVC.doctorPic = data.DoctorPic;
        callRoomVC.roomID = data.RoomID;
        callRoomVC.doctorID = data.DoctorID;
        callRoomVC.callState = BATCallState_Call;//呼叫状态
        callRoomVC.orderNo = data.OrderNo;
        callRoomVC.departmentName = data.DepartmentName;//呼叫状态
        callRoomVC.doctorTitle = data.DoctorTitle;
        callRoomVC.hospitalName = data.HospitalName;
        [self presentViewController:callRoomVC animated:YES completion:nil];
    }];
    
    
    UIAlertAction *vedioAction = [UIAlertAction actionWithTitle:@"视频咨询" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DDLogInfo(@"视频咨询!");
        //进入诊室
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    if(self.isShowText == YES){
        [alertController addAction:texttAction];
    }
    if(self.isShowVoice == YES){
        [alertController addAction:voiceAction];
    }
    if(self.isShowVedio == YES){
        [alertController addAction:vedioAction];
    }
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)judgeOrderServerTypeWithString:(BATFamilyDoctorOrderData *)data{
    
    self.isShowText = NO;
    self.isShowVoice = NO;
    self.isShowVedio = NO;
    
    NSArray *array = [data.OrderServerType componentsSeparatedByString:@","];
    if ([array containsObject:@"1"]) {
        self.isShowVedio = YES;
    }
    if ([array containsObject:@"2"]) {
        self.isShowVoice = YES;
    }
    if ([array containsObject:@"3"]) {
        self.isShowText = YES;
    }
}



#pragma mark - net
- (void)requestWaitServerOrderList{
    
    [HTTPTool requestWithURLString:@"/api/Order/GetFamilyDoctorOrder" parameters:@{@"orderStatus":@(4),@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize)} type:kGET success:^(id responseObject) {
        
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
        
        [familyDoctotOrderCell setContractDetailBtnClickBlock:^{
            DDLogInfo(@"附件合同");
            BATFamilyDoctorOrderData *data = _dataSource[indexPath.row];
            
            BATContractDetailViewController *contractDetail = [[BATContractDetailViewController alloc] init];
            
            contractDetail.orderNO = data.OrderNo;
            contractDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:contractDetail animated:YES];
        }];
        
        [familyDoctotOrderCell setConsultBtnClickBlock:^{
            DDLogInfo(@"开始咨询");
            
            [self judgeOrderServerTypeWithString:data];
            
            [self moreAction:indexPath];
        }];
        
        [familyDoctotOrderCell setGoHomeBtnClickBlock:^{
            
            NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",data.PhoneNumber];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
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
            [self requestWaitServerOrderList];
        }];
        _familyDoctorOrderListTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestWaitServerOrderList];
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
            [self requestWaitServerOrderList];
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
