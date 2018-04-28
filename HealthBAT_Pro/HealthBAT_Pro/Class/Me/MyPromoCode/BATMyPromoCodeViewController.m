//
//  BATMyPromoCodeViewController.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyPromoCodeViewController.h"

#import "BATMyPromoCodeCell.h"
#import "BATPromoCodeModel.h"

@interface BATMyPromoCodeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) BATDefaultView *defaultView;

@property (nonatomic,strong) UITableView *currentTableView;

@property (nonatomic,strong) BATPromoCodeModel *promoCodeModel;

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) NSInteger pageIndex;

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation BATMyPromoCodeViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    self.currentTableView.delegate = nil;
    self.currentTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _pageIndex = 0;
    _pageSize = 10;
    _dataSource = [NSMutableArray array];
    
    [self pagesLayout];
    
    [self.currentTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - net
- (void)requestForMyPromoCodeList{
    
    [HTTPTool requestWithURLString:@"/api/Account/GetCoupon" parameters:@{@"couponType":@(0),@"pageIndex":@(self.pageIndex),@"pageSize":@(self.pageSize)} type:kGET success:^(id responseObject) {
        
        WEAK_SELF(self);
        [self.currentTableView.mj_header endRefreshingWithCompletionBlock:^{
            STRONG_SELF(self);
            [self.currentTableView reloadData];
        }];
        [self.currentTableView.mj_footer endRefreshing];
        
        if (_pageIndex == 0) {
            [_dataSource removeAllObjects];
        }
        
        self.promoCodeModel = [BATPromoCodeModel mj_objectWithKeyValues:responseObject];
        if (self.promoCodeModel.Data == nil) {
            [self.defaultView showDefaultView];
        }
        
        [_dataSource addObjectsFromArray:self.promoCodeModel.Data];
        
        if (self.promoCodeModel.RecordsCount > 0) {
            self.currentTableView.mj_footer.hidden = NO;
        } else {
            self.currentTableView.mj_footer.hidden = YES;
        }

        if (_dataSource.count == self.promoCodeModel.RecordsCount) {
            self.currentTableView.mj_footer.hidden = YES;
        }
        
        [self.currentTableView reloadData];
    } failure:^(NSError *error) {

        [self.currentTableView.mj_header endRefreshing];
        [self.currentTableView.mj_footer endRefreshing];
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
    
    BATMyPromoCodeCell *myPromoCodeCell = [tableView dequeueReusableCellWithIdentifier:@"BATMyPromoCodeCell" forIndexPath:indexPath];
    
    [myPromoCodeCell setCellWithData:self.dataSource[indexPath.row]];
    
    [myPromoCodeCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return myPromoCodeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATPrommoCodeData *data = self.dataSource[indexPath.row];
    if(data.IsUser == 0){
        [self.tabBarController setSelectedIndex:3];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    }
}


#pragma mark -pagesLayout
- (void)pagesLayout{
    
    self.title = @"我的优惠码";
    
    WEAK_SELF(self);
    [self.view addSubview:self.currentTableView];
    [self.currentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
- (UITableView *)currentTableView{
    if (!_currentTableView) {
        _currentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _currentTableView.delegate = self;
        _currentTableView.dataSource = self;
        _currentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _currentTableView.backgroundColor = UIColorFromHEX(0xf1f1f1, 1);
        
        [_currentTableView registerClass:[BATMyPromoCodeCell class] forCellReuseIdentifier:@"BATMyPromoCodeCell"];
        
        WEAK_SELF(self);
        _currentTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"下拉刷新！");
            self.pageIndex = 0;
            [self.currentTableView.mj_footer resetNoMoreData];
            [self requestForMyPromoCodeList];
        }];
        
        _currentTableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"下拉刷新！");
            self.pageIndex++;
            [self requestForMyPromoCodeList];
        }];
        
        _currentTableView.mj_footer.hidden = YES;
    }
    return _currentTableView;
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
            [self requestForMyPromoCodeList];
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
