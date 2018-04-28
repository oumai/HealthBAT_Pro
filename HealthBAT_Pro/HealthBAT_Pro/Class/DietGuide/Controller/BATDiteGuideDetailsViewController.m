//
//  BATDiteGuideDetailsViewController.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/25.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideDetailsViewController.h"
#import "BATHomeMallViewController.h"
#import "BATDiteGuideDetailsTableView.h"
#import "BATGraditorButton.h"
#import "BATPerson.h"
#import "UIAlertView+BATBlock.h"
@interface BATDiteGuideDetailsViewController ()
<
BATDiteGuideDetailsTableViewDelegate
>
@property (nonatomic ,weak)   BATDiteGuideDetailsTableView     *diteGuideDetailsTableView;
@property (nonatomic ,copy)   NSString                         *dataID;
@property (nonatomic ,assign) NSInteger                        accountID;
//@property (nonatomic ,strong) BATPerson                        *personModel;
@property (nonatomic ,assign) BOOL                             showDeleteBtn;
@end

@implementation BATDiteGuideDetailsViewController

- (instancetype)initWithDataID:(NSString *)dataID accountID:(NSInteger)accountID showDeleteBtn:(BOOL)show {
    if (self = [super init]) {
        _dataID = dataID;
        _accountID = accountID;
        _showDeleteBtn = show;
//        [self getPersonInfo];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];
    [self.diteGuideDetailsTableView.mj_header beginRefreshing];
}

#pragma mark -- private
- (void)setupNav {
    if (self.showDeleteBtn == YES) {
        BATGraditorButton *deleteBtn = [[BATGraditorButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [deleteBtn addTarget:self action:@selector(deleteBtnByClick:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleteBtn.enbleGraditor = YES;
        [deleteBtn setGradientColors:@[START_COLOR,END_COLOR]];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:deleteBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)setupUI {
    self.title = @"查看详情";
    BATDiteGuideDetailsTableView *diteGuideDetailsTableView = [[BATDiteGuideDetailsTableView alloc] initWithStyle:UITableViewStylePlain];
    diteGuideDetailsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    diteGuideDetailsTableView.bat_Delegate = self;
    [self.view addSubview:diteGuideDetailsTableView];
    self.diteGuideDetailsTableView = diteGuideDetailsTableView;
    [self.diteGuideDetailsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}

//- (void)getPersonInfo {
//    self.personModel = (BATPerson *)PERSON_INFO;
//}

- (void)setDataWithDiteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel {
    [self.diteGuideDetailsTableView setDataWithDiteGuideDetailModel:diteGuideDetailModel];
}

- (void)goBack {
    [[NSNotificationCenter defaultCenter] postNotificationName:BATDiteGuideDetailsDeleteNotification object:self.dataID];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- BATDiteGuideDetailsTableViewDelegate
- (void)diteGuideDetailsTableView:(BATDiteGuideDetailsTableView *)guideDetailsTableView diteGuideDetailModel:(BATDiteGuideDetailModel *)model {
    BATHomeMallViewController *homeMallVC = [[BATHomeMallViewController alloc] init];
    homeMallVC.url = [NSString stringWithFormat:@"http://m.km1818.com/products/%@.html?kmCloud",model.GenerationMeal.SKU_ID];
    homeMallVC.title = model.GenerationMeal.PRODUCT_NAME;
    [self.navigationController pushViewController:homeMallVC animated:YES];
}

- (void)diteGuideDetailsTableViewLoadData:(BATDiteGuideDetailsTableView *)guideDetailsTableView {
    [self diteGuideDetailsRequest];
}
#pragma mark -- network
- (void)diteGuideDetailsRequest {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params jk_setObj:self.dataID forKey:@"ID"];
    [HTTPTool requestWithURLString:@"/api/EatCircle/GetEatCircleDetail" parameters:params type:kGET success:^(id responseObject) {
        [self.diteGuideDetailsTableView.mj_header endRefreshing];
        BATDiteGuideDetailModel *diteGuideDetailModel = [BATDiteGuideDetailModel mj_objectWithKeyValues:[responseObject valueForKey:@"Data"]];
        [self setDataWithDiteGuideDetailModel:diteGuideDetailModel];
    } failure:^(NSError *error) {
        [self.diteGuideDetailsTableView.mj_header endRefreshing];
        [self showText:@"请检查您的网络" withInterval:2.0];
    }];
}

- (void)deleteDiteGuidePhotoRequest {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params jk_setObj:self.dataID forKey:@"ID"];
    [HTTPTool requestWithURLString:@"/api/EatCircle/DelEatCircle" parameters:params type:kGET success:^(id responseObject) {
        NSInteger resultCode = [[responseObject valueForKey:@"ResultCode"] integerValue];
        if (resultCode == 0) {
            [self goBack];
        }
    } failure:^(NSError *error) {
    }];
}
#pragma mark -- click
- (void)deleteBtnByClick:(UIButton *)sender {
    [UIAlertView bat_alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self deleteDiteGuidePhotoRequest];
        }
    } title:nil message:@"确定删除该帖子?"cancelButtonName:@"取消" otherButtonTitles:@"确定", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
