//
//  BATChooseTreatmentPersonController.m
//  TableViewTest
//
//  Created by kmcompany on 16/9/23.
//  Copyright © 2016年 sword. All rights reserved.
//

#import "BATChooseTreatmentPersonController.h"
#import "BATAddTreatmentController.h"
#import "ChooseTreatmentCell.h"
#import "ChooseTreatmentModel.h"
#import "addTreatmentCell.h"
#import "BATChooseEntiyModel.h"
@interface BATChooseTreatmentPersonController ()<UITableViewDelegate,UITableViewDataSource,ChooseTreatmentCellDelegate>
@property (nonatomic,strong) UITableView *myTab;
@property (nonatomic,strong) NSMutableArray *dataArry;
@property (nonatomic,strong) UIView *tableFooterView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,assign) BOOL isPopAction;
@end

@implementation BATChooseTreatmentPersonController

static NSString *const chooseCell = @"CHOOSECELL";
static NSString *const addTeatment = @"ADDTREATMENTCELL";

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.currentPage = 1;
//    [self IntreatmentRequest];
    
    [self laoutPages];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.currentPage = 1;
    [self.myTab.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isPopAction) {
        if (self.pathName) {
            [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:self.pathName moduleId:3 beginTime:self.beginTime];
        }else {
            [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"个人中心-就诊人管理" moduleId:4 beginTime:self.beginTime];
        }
        
    }
}

#pragma mark -UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArry.count + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArry.count>0) {
        if (indexPath.section<=self.dataArry.count-1) {
            return 145+7;
        }else {
            return 45;
        }
    }else {
        return 45;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArry.count>0) {
        if (indexPath.section<=self.dataArry.count-1) {
            ChooseTreatmentCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseCell];
            if (cell == nil) {
                cell = [[ChooseTreatmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chooseCell isCanSelect:self.isShow];
            }
            cell.delegate = self;
            cell.rowPath = indexPath;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell cellConfigWithModel:self.dataArry[indexPath.section]];
            return cell;
        }else {
            addTreatmentCell *cell = [tableView dequeueReusableCellWithIdentifier:addTeatment];
            if (cell == nil) {
                cell = [[addTreatmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addTeatment];
            }
            return cell;
        }
    }else {
        addTreatmentCell *cell = [tableView dequeueReusableCellWithIdentifier:addTeatment];
        if (cell == nil) {
            cell = [[addTreatmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addTeatment];
        }
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.dataArry.count) {
        self.isPopAction = NO;
        BATAddTreatmentController *treatMentCtl = [BATAddTreatmentController new];
        treatMentCtl.isAdd = YES;
        [self.navigationController pushViewController:treatMentCtl animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else {
        if (self.isShow) {
            
            for (ChooseTreatmentModel *model in self.dataArry) {
                if ([model.CommPersonID isEqualToString:model.memberID]) {
                    model.CommPersonID = @"";
                    break;
                }
            }
             [self ChooseTreatmentCellSelectActionWithRow:indexPath];
           
        }
       
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    headerView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    return headerView;
}

#pragma  mark - Action
-(void)confirmAction {
    
    BOOL flages = NO;
    
    ChooseTreatmentModel *sendModel = [[ChooseTreatmentModel alloc]init];
    
    for (ChooseTreatmentModel *model in self.dataArry) {
        if (model.isSelect==YES) {
            flages = YES;
            sendModel = model;
        }
    }
    
    if (flages) {
        if (self.ChooseBlock) {
            self.ChooseBlock(sendModel);
        }
         [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self showText:@"您好,请选择就诊人!"];
    }
    
   
}

#pragma mark -layouPages
-(void)laoutPages {
    self.isPopAction = YES;
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if (!self.isShow) {
        self.title = @"就诊人信息";
    }else {
    self.title = @"选择就诊人";
    }
}

#pragma mark -CellDelegateAction
//编辑事件
-(void)ChooseTreatmentCellEditActionWithRow:(NSIndexPath *)pathRow {
    BATAddTreatmentController *treatMentCtl = [BATAddTreatmentController new];
    treatMentCtl.editModel = self.dataArry[pathRow.section];
    [self.navigationController pushViewController:treatMentCtl animated:YES];
}

//删除事件
-(void)ChooseTreatmentCellDeleteActionWithRow:(NSIndexPath *)pathRow {

    
    NSString *memberID = [self.dataArry[pathRow.section] memberID];
    
    NSString *relatShipString = [self.dataArry[pathRow.section] relateship];
    
    if ([relatShipString isEqualToString:@"本人"]) {
        [self showText:@"就诊人关系是本人,暂不能删除!"];
    }else {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除就诊人信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:memberID forKey:@"ID"];
            [HTTPTool requestWithURLString:@"/api/NetworkMedical/DeleteUserMember" parameters:dict type:kGET success:^(id responseObject) {

                [self showText:responseObject[@"ResultMessage"]];
                self.currentPage = 1;
                [self.myTab.mj_header beginRefreshing];
            } failure:^(NSError *error) {
                
            }];
        }];

        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

//选择事件
-(void)ChooseTreatmentCellSelectActionWithRow:(NSIndexPath *)pathRow {
    for (int i =0; i<self.dataArry.count; i++) {
        ChooseTreatmentModel *model = self.dataArry[i];
        if (i==pathRow.section) {
             model.isSelect = !model.isSelect;
        }else {
            model.isSelect = NO;
        }
    }
    
    
    [self.myTab reloadData];
}

//默认成员事件
-(void)ChooseTreatmentCellDefaultActionWithRow:(NSIndexPath *)pathRow {
    for (int i =0; i<self.dataArry.count; i++) {
        ChooseTreatmentModel *model = self.dataArry[i];
        if (i==pathRow.section) {
            if (model.isDefault) {
                model.isDefault = YES;
            }else {
                [self isDefaultRequestWithMember:model];
            }
        }else {
            model.isDefault = NO;
        }
    }
    [self.myTab reloadData];
}

#pragma mark -NET
//默认成员事件请求
-(void)isDefaultRequestWithMember:(ChooseTreatmentModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.memberID forKey:@"MemberID"];
   [HTTPTool requestWithURLString:@"/api/NetworkMedical/SetDetaultUserMember" parameters:dict type:kGET success:^(id responseObject) {
       NSLog(@"%@",responseObject);
       model.isDefault = !model.isDefault;
       [self.myTab reloadData];
   } failure:^(NSError *error) {
       
   }];
}

//请求数据
-(void)IntreatmentRequest {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetUserMembers" parameters:dict type:kGET success:^(id responseObject) {

        [self.myTab.mj_header endRefreshing];
      //  [self.myTab.mj_footer endRefreshing];
        
        if (self.currentPage == 1) {
            [self.dataArry removeAllObjects];
        }
        

        BATChooseEntiyModel *model = [BATChooseEntiyModel mj_objectWithKeyValues:responseObject];
        for (MyResData *dataModel in model.Data) {
            ChooseTreatmentModel *model = [ChooseTreatmentModel new];
            model.name = dataModel.MemberName;
            switch (dataModel.Relation) {
                case 0:
                model.relateship = @"本人";
                    break;
                case 1:
                model.relateship = @"配偶";
                    break;
                case 2:
                model.relateship = @"父亲";
                    break;
                case 3:
                model.relateship = @"母亲";
                    break;
                case 4:
                model.relateship = @"儿子";
                    break;
                case 5:
                model.relateship = @"女儿";
                    break;
                case 6:
                model.relateship = @"其他";
                    break;
                default:
                    break;
            }
            model.phoneNumber = dataModel.Mobile;
            model.personID = dataModel.IDNumber;
            model.isDefault = dataModel.IsDefault;
            model.memberID = dataModel.MemberID;
            model.userID = dataModel.UserID;
            if (self.memberID) {
            model.CommPersonID = self.memberID;
            }
            [self.dataArry addObject:model];
        }
        
        [self.myTab reloadData];
    } failure:^(NSError *error) {
        [self.myTab.mj_header endRefreshing];
        [self.myTab.mj_footer endRefreshing];
    }];
}

#pragma mark SETTER - GETTER
-(UITableView *)myTab {
    if (!_myTab) {
        _myTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
        _myTab.delegate = self;
        _myTab.dataSource = self;
        _myTab.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [_myTab registerClass:[ChooseTreatmentCell class] forCellReuseIdentifier:chooseCell];
        [_myTab registerClass:[addTreatmentCell class] forCellReuseIdentifier:addTeatment];
        _myTab.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        
        if (self.isShow) {
             _myTab.tableFooterView = self.tableFooterView;
        }
       
        WEAK_SELF(self)
        _myTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 1;
            [self IntreatmentRequest];
        }];
        
        /*
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++ ;
            [self IntreatmentRequest];

        }];
        footer.refreshingTitleHidden = YES;
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        _myTab.mj_footer = footer;
         */

        [self.view addSubview:_myTab];
    }
    return _myTab;
}

-(NSMutableArray *)dataArry {
    if(!_dataArry) {
        _dataArry = [NSMutableArray array];
    }
    return _dataArry;
}

-(UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
        _tableFooterView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 35, SCREEN_WIDTH-20, 40)];
        confirmBtn.clipsToBounds = YES;
        confirmBtn.layer.borderColor = BASE_COLOR.CGColor;
        confirmBtn.layer.borderWidth = 1;
        confirmBtn.layer.cornerRadius = 5;
        confirmBtn.backgroundColor = BASE_COLOR;
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        [_tableFooterView addSubview:confirmBtn];
    }
    return _tableFooterView;
}

@end
