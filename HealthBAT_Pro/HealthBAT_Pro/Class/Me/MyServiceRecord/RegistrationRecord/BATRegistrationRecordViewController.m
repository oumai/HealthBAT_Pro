//
//  BATRegistrationRecordViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATRegistrationRecordViewController.h"
#import "BATRegistrationRecordTableViewCell.h"
#import "BATRegistrationRecordModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BATLoginModel.h"
#import "BATRegisterCancelModel.h"

@interface BATRegistrationRecordViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

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

@property (nonatomic,assign) NSInteger index;
@property (nonatomic,copy) NSString *yuyue_id;
@property (nonatomic,assign) BOOL isCompleteRequest;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATRegistrationRecordViewController

- (void)dealloc
{
    DDLogDebug(@"%@",self);
    _registrationRecordView.tableView.delegate = nil;
    _registrationRecordView.tableView.dataSource = nil;
    _registrationRecordView.tableView.emptyDataSetSource = nil;
    _registrationRecordView.tableView.emptyDataSetDelegate = nil;
}

- (void)loadView
{
    [super loadView];
    
    if (_registrationRecordView == nil) {
        _registrationRecordView = [[BATRegistrationRecordView alloc] init];
        _registrationRecordView.tableView.delegate = self;
        _registrationRecordView.tableView.dataSource = self;
        _registrationRecordView.tableView.emptyDataSetSource = self;
        _registrationRecordView.tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_registrationRecordView];
        
        WEAK_SELF(self);
        _registrationRecordView.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex = 0;
            [self.registrationRecordView.tableView.mj_footer resetNoMoreData];
            [self requestGetAllOrderList];
        }];
        
        _registrationRecordView.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.pageIndex++;
            [self requestGetAllOrderList];
        }];
        
        _registrationRecordView.tableView.mj_footer.hidden = YES;
        
        [_registrationRecordView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
             make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64));
        }];
        
        [self.view addSubview:self.defaultView];
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.top.equalTo(self.view);
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"挂号记录";
    
    [_registrationRecordView.tableView registerClass:[BATRegistrationRecordTableViewCell class] forCellReuseIdentifier:@"BATRegistrationRecordTableViewCell"];
    
    _dataSource = [[NSMutableArray alloc] init];
    _pageIndex = 0;
    _pageSize = 10;
    
    [_registrationRecordView.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATRegistrationRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATRegistrationRecordTableViewCell" forIndexPath:indexPath];
    cell.cancelButton.tag = indexPath.section;
    [cell.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_dataSource.count > 0) {
        BATRegistrationRecordData *model = _dataSource[indexPath.section];
        cell.nameLabel.text = [NSString stringWithFormat:@"就诊人：%@",model.TRUENAME];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@",[model.TO_DATE substringToIndex:10],model.BEGIN_TIME];
        cell.docNameLabel.text =[NSString stringWithFormat:@"就诊医生：%@",model.DOCTOR_NAME];
        cell.adressLabel.text = [NSString stringWithFormat:@"就诊位置：%@",model.UNIT_NAME];


        if (model.YUYUE_STATE == -1) {
            cell.cancelButton.hidden = YES;
            cell.registerState.hidden = NO;
            cell.registerState.text = @"已取消";
        }else if (model.YUYUE_STATE == 1) {
            cell.cancelButton.hidden = NO;
            cell.registerState.hidden = YES;
        }
        else if (model.YUYUE_STATE == 0) {
            cell.cancelButton.hidden = YES;
            cell.registerState.hidden = NO;
            cell.registerState.text = @"停诊";
        }
        else if (model.YUYUE_STATE == 2) {
            cell.cancelButton.hidden = YES;
            cell.registerState.hidden = NO;
            cell.registerState.text = @"已支付";
        }
        else if (model.YUYUE_STATE == 3) {
            cell.cancelButton.hidden = YES;
            cell.registerState.hidden = NO;
            cell.registerState.text = @"爽约";
        }
        else if (model.YUYUE_STATE == 4) {
            cell.cancelButton.hidden = YES;
            cell.registerState.hidden = NO;
            cell.registerState.text = @"取号";
        }
        else if (model.YUYUE_STATE == 5) {
            cell.cancelButton.hidden = YES;
            cell.registerState.hidden = NO;
            cell.registerState.text = @"已就诊";
        }


//        if (model.CAN_CANCEL) {
//            cell.cancelButton.hidden = NO;
//            cell.registerState.hidden = YES;
//        } else {
//            
//            cell.cancelButton.hidden = YES;
//            cell.registerState.hidden = NO;
//            
//            if (model.YUYUE_STATE == -1) {
//                cell.registerState.text = @"已取消";
//            }else if (model.YUYUE_STATE == 1) {
//                cell.cancelButton.hidden = NO;
//                cell.registerState.hidden = YES;
//            }
//            else if (model.YUYUE_STATE == 0) {
//                cell.registerState.text = @"停诊";
//            } else if (model.YUYUE_STATE == 2) {
//                cell.registerState.text = @"已支付";
//            } else if (model.YUYUE_STATE == 3) {
//                cell.registerState.text = @"爽约";
//            } else if (model.YUYUE_STATE == 4) {
//                cell.registerState.text = @"取号";
//            } else if (model.YUYUE_STATE == 5) {
//                cell.registerState.text = @"已就诊";
//            }
//        }
    }
    
//    cell.nameLabel.text = @"就诊人：张珊";
//    cell.timeLabel.text = @"2016-09-05 10:41";
//    cell.docNameLabel.text = @"就诊医生：陈医生";
//    cell.adressLabel.text = @"就诊位置：深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳深圳";
//    cell.registerState.text = @"已支付";
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogWarn(@"挂号记录");
}

#pragma mark - DZNEmptyDataSetSource
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//
//    return -50;
//}
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//
//    if (!self.isCompleteRequest) {
//        return nil;
//    }
//    return [UIImage imageNamed:@"暂无咨询记录"];
//}
//
////返回标题文字
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//    NSString *text = @"";
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//
////返回详情文字
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
//
//
//    if (!self.isCompleteRequest) {
//        return nil;
//    }
//
//    NSString *text = @"暂无挂号记录";
//
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f], NSForegroundColorAttributeName:UIColorFromHEX(0x666666, 1), NSParagraphStyleAttributeName: paragraph};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

#pragma mark - Action

#pragma mark - 取消挂号
-(void)cancelButtonAction:(UIButton *)button
{
    DDLogWarn(@"准备取消");
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定取消挂号么？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    WEAK_SELF(self);
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF(self);
        [self requestCancelRegietration:self.dataSource[button.tag]];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:confirmAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - NET

#pragma mark - 获取挂号订单
- (void)requestGetAllOrderList
{
    [HTTPTool requestWithURLString:@"/api/AppointmentDoctor/GetAllOrderList"
                        parameters:@{@"page":@(_pageIndex),@"page_size":@(_pageSize)}
                              type:kGET
                           success:^(id responseObject) {
                               
                               [_registrationRecordView.tableView.mj_header endRefreshingWithCompletionBlock:^{
                                   self.isCompleteRequest = YES;
                                   [self.registrationRecordView.tableView reloadData];
                               }];
                               [_registrationRecordView.tableView.mj_footer endRefreshing];
                               
                               if (_pageIndex == 0) {
                                   [_dataSource removeAllObjects];
                               }
                               
                               BATRegistrationRecordModel *registrationRecordModel = [BATRegistrationRecordModel mj_objectWithKeyValues:responseObject];
                               
                               [_dataSource addObjectsFromArray:registrationRecordModel.Data];
                               
                               if (registrationRecordModel.RecordsCount > 0) {
                                   _registrationRecordView.tableView.mj_footer.hidden = NO;
                               } else {
                                   _registrationRecordView.tableView.mj_footer.hidden = YES;
                               }
                               
                               if (_dataSource.count == registrationRecordModel.RecordsCount) {
                                   [_registrationRecordView.tableView.mj_footer endRefreshingWithNoMoreData];
                               }
                               
                               if(_dataSource.count == 0){
                                   [self.defaultView showDefaultView];
                               }
                               
                               [_registrationRecordView.tableView reloadData];
                               
                           } failure:^(NSError *error) {
                               [_registrationRecordView.tableView.mj_header endRefreshingWithCompletionBlock:^{
                                   self.isCompleteRequest = YES;
                                   [self.registrationRecordView.tableView reloadData];
                               }];
                               [_registrationRecordView.tableView.mj_footer endRefreshing];
                               _pageIndex--;
                               if (_pageIndex < 0) {
                                   _pageIndex = 0;
                               }
                               
                               [self.defaultView showDefaultView];
                           }];
    
}

#pragma mark - 取消挂号
- (void)requestCancelRegietration:(BATRegistrationRecordData *)model
{
    
    [self showProgress];

 //   BATLoginModel *login = LOGIN_INFO;


    [HTTPTool requestWithURLString:@"/api/AppointmentDoctor/CancelRegister" parameters:@{@"yuyueid":@(model.YUYUE_ID)} type:kPOST success:^(id responseObject) {

        BATRegisterCancelModel *cancelModel = [BATRegisterCancelModel mj_objectWithKeyValues:responseObject];
        if (cancelModel.Data.ResultCode == 1) {
            [self showSuccessWithText:@"取消成功"];
            [self.registrationRecordView.tableView.mj_header beginRefreshing];
        }
        else {
            [self showErrorWithText:cancelModel.Data.ResultMessage];

        }

    } failure:^(NSError *error) {
        [self showErrorWithText:@"取消失败"];
    }];




//    AFHTTPSessionManager *manager = [HTTPTool managerWithBaseURL:nil sessionConfiguration:NO];
//    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    [params setObject:@(model.YUYUE_ID) forKey:@"yuyue_id"];
//
//
//
//    [manager POST:@"http://mis.kmt518.com/kmt_DI/cancelRegister" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        [self dismissProgress];
//        id resultDic = [HTTPTool responseConfiguration:responseObject];
//
//        DDLogWarn(@"取消挂号resultDic == %@",resultDic);
//        NSInteger resultCode = [[resultDic objectForKey:@"code"] integerValue];
//        if (resultCode == 1) {
//            
//            DDLogWarn(@"%@",[[resultDic objectForKey:@"message"] objectForKey:@"msg"]);
//
//            
//            [self showText:[[resultDic objectForKey:@"message"] objectForKey:@"msg"]];
//            
//            //取消完成了，刷新UI
//            [_dataSource removeAllObjects];
//            [_registrationRecordView.tableView.mj_header beginRefreshing];
//            
//        }else{
//            DDLogWarn(@"接口返回错误");
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        DDLogWarn(@"请求失败 getOrderDetail error --- %@",error);
//        [self dismissProgress];
//    }];

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
            
            [self.registrationRecordView.tableView.mj_header beginRefreshing];
        }];
        
    }
    return _defaultView;
}

@end
