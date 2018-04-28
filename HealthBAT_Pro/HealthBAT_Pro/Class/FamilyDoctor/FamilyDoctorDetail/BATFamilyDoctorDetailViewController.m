//
//  BATFamilyDoctorDetailViewController.m
//  HealthBAT_Pro
//
//  Created by four on 17/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorDetailViewController.h"
//MODEL
#import "BATFamilyDoctorModel.h"
#import "BATTopicRecordModel.h"
//VIEW
#import "BATAlertOrderInfoView.h"
//CELL
//#import "BATFamilyDoctorSvericeCell.h"
#import "BATFamilyDoctorSkillCell.h"
#import "BATDoctorOfficeHeadCell.h"
#import "BATConsultCountCell.h"
#import "BATFamilyDoctorServiceTypeCell.h"
#import "BATCourseCommentTableViewCell.h"
#import "BATFamilyDoctorPackageCell.h"
//VC
#import "BATOrderRequestViewController.h"
#import "BATEvaluateListController.h"
//CLASS
#import "BATGraditorButton.h"

static NSString *const SKILL_CELL = @"BATFamilyDoctorSkillCell";
static NSString *const SVERICE_CELL = @"BATFamilyDoctorPackageCell";

@interface BATFamilyDoctorDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) BATFamilyDoctorModel       *familyDoctorModel;
@property (nonatomic,strong) BATTopicRecordModel *CommentsModel;

@property (nonatomic,strong) BATDefaultView             *defaultView;

@property (nonatomic,strong) BATAlertOrderInfoView *alertOrderInfoView;

@property (nonatomic,strong) UITableView                *familyDoctorDetailTableView;

@property (nonatomic,strong) BATGraditorButton          *buyButton;

@property (nonatomic,assign) CGFloat                    evaluationHeight;

@property (nonatomic,assign) BOOL                       isPushToThisVC;

@property (nonatomic,assign) CGFloat                    currnetPayCost;
@property (nonatomic,assign) NSInteger                  currnetChooseMonth;
@property (nonatomic,assign) BOOL                       isLoginStateShowAlert;

@end

@implementation BATFamilyDoctorDetailViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    self.familyDoctorDetailTableView.delegate = nil;
    self.familyDoctorDetailTableView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currnetPayCost = 0;
    _currnetChooseMonth = 0;
    _isLoginStateShowAlert = NO;
    
    [self pagesLayout];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_isPushToThisVC == NO) {
        
        _isPushToThisVC = YES;
        
        [self.familyDoctorDetailTableView.mj_header beginRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (void)reloadData{
    [self.familyDoctorDetailTableView reloadData];
}

- (void)reloadAleatView{
    [self.alertOrderInfoView loadFamilyDoctorDetail:self.familyDoctorModel];
}

- (void)ToJudgewhetherTheDataCorrectly{
    
    [self.view endEditing: YES];
    //判断输入框是否为空。(即无输入)
    if (self.alertOrderInfoView.buyerTextfiled.text.length == 0) {
        [self showText:@"请输入姓名"];
        return;
    }
    if (self.alertOrderInfoView.phoneTextfiled.text.length == 0) {
        [self showText:@"请输入正确的身份证号"];
        return;
    }
    if (self.alertOrderInfoView.adressTextfiled.text.length == 0) {
        [self showText:@"请输入地址"];
        return;
    }
    
    
    [self requestBuyFamilyDoctorService];
}



#pragma mark - net
- (void)requuestFamilyDoctorInfo{
    
    [HTTPTool requestWithURLString:@"/api/FamilyDoctor/GetFamilyDoctorDetail" parameters:@{@"doctorId":self.familyDoctroID} type:kGET success:^(id responseObject) {
        
        [self.familyDoctorDetailTableView.mj_footer endRefreshing];
        [self.familyDoctorDetailTableView.mj_header endRefreshing];
        
        self.familyDoctorModel = [BATFamilyDoctorModel mj_objectWithKeyValues:responseObject];
        
        if(self.familyDoctorModel.Data.ThisTime != nil){
            DDLogInfo(@"服务器时间====%@",self.familyDoctorModel.Data.ThisTime);
            if(self.familyDoctorModel.Data.ThisTime.length >= 10){
                NSString *timeStr =  [self.familyDoctorModel.Data.ThisTime substringToIndex:10];
                [[NSUserDefaults standardUserDefaults] setObject:timeStr forKey:@"CurrentServiceTime"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        
        [self reloadData];
        
        
        if (_isLoginStateShowAlert == YES) {
            [self reloadAleatView];
            self.alertOrderInfoView.hidden = NO;
        }
        
    } failure:^(NSError *error) {
        [self.familyDoctorDetailTableView.mj_footer endRefreshing];
        [self.familyDoctorDetailTableView.mj_header endRefreshing];
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - 生成订单
//OrderServerTime   订单服务时间 1  3  6 12 单位月
//OrderType         订单类型： 1视频咨询 ， 2语音咨询 ，3图文咨询，11家庭医生
- (void)requestBuyFamilyDoctorService{
    NSDictionary *dict = @{@"DoctorID":self.familyDoctroID,@"OrderType":@(11),@"OrderMoneys":@(_currnetPayCost),@"OrderServerTime":@(_currnetChooseMonth),@"TrueName":self.alertOrderInfoView.buyerTextfiled.text,@"IDNumber":self.alertOrderInfoView.phoneTextfiled.text,@"ContactAddress":self.alertOrderInfoView.adressTextfiled.text};
    
    DDLogInfo(@"%@",dict);
    
    [HTTPTool requestWithURLString:@"/api/Order/BuyFamilyDoctorService" parameters:dict type:kPOST success:^(id responseObject) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.alertOrderInfoView.hidden = YES;
        });
        
        BATOrderRequestViewController *orderRequestVC = [[BATOrderRequestViewController alloc] init];
        orderRequestVC.orderNO = [responseObject objectForKey:@"Data"];
        orderRequestVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderRequestVC animated:YES];
        
    } failure:^(NSError *error) {
        
        [self showText:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    }];
    
}


#pragma mark - 获取回复列表
- (void)GetCommentsListRequest {
    
    [HTTPTool requestWithURLString:@"/api/OrderEvaluate/GetEvaluateList" parameters:@{@"doctorID":self.familyDoctroID,@"pageIndex":@"0",@"pageSize":@"10"}  type:kGET success:^(id responseObject) {
        
        [_familyDoctorDetailTableView.mj_header endRefreshing];
        [_familyDoctorDetailTableView.mj_footer endRefreshing];

        self.CommentsModel = [BATTopicRecordModel mj_objectWithKeyValues:responseObject];
        
        for (TopicReplyData *data in self.CommentsModel.Data) {
            data.ReplyContent = data.Comment;
            data.CreatedTime = data.EvaluateTime;
            for (secondReplyData *secData in data.secondReplyList) {
                secData.ReplyContent = secData.Comment;
            }
        }

        if (self.CommentsModel.Data.count == [self.CommentsModel.RecordsCount integerValue]) {
            [self.familyDoctorDetailTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [_familyDoctorDetailTableView reloadData];
    } failure:^(NSError *error) {
        
        [_familyDoctorDetailTableView.mj_header endRefreshing];
        [_familyDoctorDetailTableView.mj_footer endRefreshing];

    }];
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //服务时间和服务套餐合二为一
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            if (self.CommentsModel.Data.count >0) {
                return 1;
            }else {
                return 0;
            }
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section== 0 && indexPath.row == 1) {
        return 40;
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       switch (indexPath.section) {
           case 0:
           {
               if (indexPath.row == 0) {
                   BATDoctorOfficeHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorOfficeHeadCell"];
                   [headCell.headImage sd_setImageWithURL:[NSURL URLWithString:self.familyDoctorModel.Data.DoctorPic] placeholderImage:[UIImage imageNamed:@"医生"]];
                   headCell.nameLb.text = self.familyDoctorModel ? [NSString stringWithFormat:@"%@ [%@]",self.familyDoctorModel.Data.DoctorName,self.familyDoctorModel.Data.DoctorTitle] : @"姓名 职称";
                   headCell.hosptialLb.text = self.familyDoctorModel ? [NSString stringWithFormat:@"%@  %@",self.familyDoctorModel.Data.HospitalName,self.familyDoctorModel.Data.DepartmentName] : @"医院 科室";
                   [headCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                   return headCell;
                   
               }else if (indexPath.row == 1){
                   BATConsultCountCell *consultCell = [tableView dequeueReusableCellWithIdentifier:@"BATConsultCountCell"];
                   consultCell.ConsultConuntLb.text = self.familyDoctorModel ? [NSString stringWithFormat:@"%@次",self.familyDoctorModel.Data.ConsultNum] : @"0";
                   consultCell.EvaluateLb.text = self.familyDoctorModel ? [NSString stringWithFormat:@"%0.2f%%",[self.familyDoctorModel.Data.EvaluateRate floatValue]] : @"";
                   [consultCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                   return consultCell;
               }else{
                   BATFamilyDoctorServiceTypeCell *skillCell = [tableView dequeueReusableCellWithIdentifier:@"BATFamilyDoctorServiceTypeCell" forIndexPath:indexPath];
                   
                   [skillCell setCellWithModel:self.familyDoctorModel];
                   
                   [skillCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                   return skillCell;
               }
               
           }
               break;
           case 1:
           {
               BATFamilyDoctorPackageCell *svericeCell = [tableView dequeueReusableCellWithIdentifier:SVERICE_CELL forIndexPath:indexPath];
               
               [svericeCell setCellWithModel:self.familyDoctorModel];
               
               [svericeCell setOneMothSeviceBlock:^{
                   _currnetPayCost = [self.familyDoctorModel.Data.FamilyDoctorCost[0].TValue floatValue];
                   _currnetChooseMonth = [self.familyDoctorModel.Data.FamilyDoctorCost[0].TKey integerValue];;
                   [self reloadAleatView];
               }];
               [svericeCell setThreeMothSeviceBlock:^{
                   _currnetPayCost = [self.familyDoctorModel.Data.FamilyDoctorCost[1].TValue floatValue];;
                   _currnetChooseMonth = [self.familyDoctorModel.Data.FamilyDoctorCost[1].TKey integerValue];;
                   [self reloadAleatView];
               }];
               [svericeCell setSixMothSeviceBlock:^{
                   _currnetPayCost = [self.familyDoctorModel.Data.FamilyDoctorCost[2].TValue floatValue];;
                   _currnetChooseMonth = [self.familyDoctorModel.Data.FamilyDoctorCost[2].TKey integerValue];;
                   [self reloadAleatView];
               }];
               [svericeCell setTwelveMothSeviceBlock:^{
                   _currnetPayCost = [self.familyDoctorModel.Data.FamilyDoctorCost[3].TValue floatValue];;
                   _currnetChooseMonth = [self.familyDoctorModel.Data.FamilyDoctorCost[3].TKey integerValue];
                   [self reloadAleatView];
               }];
               
               
               [svericeCell setSelectionStyle:UITableViewCellSelectionStyleNone];
               
               return svericeCell;
           }
               break;
           case 2:
           {
               BATFamilyDoctorSkillCell *skillCell = [tableView dequeueReusableCellWithIdentifier:SKILL_CELL forIndexPath:indexPath];
               
               skillCell.titleLable.text = @"擅长";
               skillCell.descLable.text = self.familyDoctorModel.Data.GoodAt;
               [skillCell setSelectionStyle:UITableViewCellSelectionStyleNone];
               return skillCell;
               
           }
               break;
           case 3:
           {
               BATFamilyDoctorSkillCell *skillCell = [tableView dequeueReusableCellWithIdentifier:SKILL_CELL forIndexPath:indexPath];
               skillCell.titleLable.text = @"简介";
               skillCell.descLable.text = self.familyDoctorModel.Data.DoctorDesc;
               [skillCell setSelectionStyle:UITableViewCellSelectionStyleNone];
               return skillCell;
               
           }
               break;
           case 4: {
               BATCourseCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseCommentTableViewCell"];
               [cell configTopicData:self.CommentsModel.Data[indexPath.row]];
               cell.commnetButton.hidden = YES;
               cell.commentCountLabel.hidden = YES;
               cell.likeCountLabel.hidden = YES;
               cell.likeButton.hidden = YES;
               return cell;
               
               break;
           }
           default:
               break;
    }
    return nil;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 4) {
        UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        sectionView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLb = [[UILabel alloc]init];
        titleLb.textColor = UIColorFromHEX(0X333333, 1);
        titleLb.text = @"患者评价";
        titleLb.font = [UIFont systemFontOfSize:15];
        
        [sectionView addSubview:titleLb];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(sectionView).offset(10);
            make.centerY.equalTo(sectionView.mas_centerY);
            
        }];
        
        
        UILabel *titleCount = [[UILabel alloc]init];
        titleCount.font = [UIFont systemFontOfSize:12];
        titleCount.textColor = UIColorFromHEX(0X999999, 1);
        titleCount.text = self.CommentsModel ? [NSString stringWithFormat:@"(%@)",self.CommentsModel.RecordsCount] : @"(0)";
        [sectionView addSubview:titleCount];
        [titleCount mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(titleLb.mas_right).offset(10);
            make.centerY.equalTo(sectionView.mas_centerY);
            
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = BASE_BACKGROUND_COLOR;
        
        [sectionView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(sectionView).offset(0);
            make.height.mas_equalTo(1);
            
        }];
        
        UIButton *arrowBtn = [[UIButton alloc]init];
        
        [sectionView addSubview:arrowBtn];
        [arrowBtn setImage:[UIImage imageNamed:@"icon_arrow_right"] forState:UIControlStateNormal];
        [arrowBtn bk_whenTapped:^{
            
            BATEvaluateListController *listVC = [[BATEvaluateListController alloc]init];
            listVC.doctorid = self.familyDoctroID;
            [self.navigationController pushViewController:listVC animated:YES];
        }];
        
        [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.top.bottom.equalTo(sectionView).offset(0);
            make.width.height.mas_equalTo(40);
            
        }];
        
        
        return sectionView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else  if (section == 1) {
        return 10;
    }else  if (section == 2) {
        return 10;
    }else  if (section == 3) {
        return 2;
    }else  if (section == 4) {
        return 40;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 10;
    }
    
    return CGFLOAT_MIN;
}


#pragma mark -pagesLayout
- (void)pagesLayout{
    self.title = @"医生详情";
    WEAK_SELF(self);
    [self.view addSubview:self.familyDoctorDetailTableView];
    [self.familyDoctorDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.buyButton];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.alertOrderInfoView];
}

#pragma mark -get&&set
- (UITableView *)familyDoctorDetailTableView{
    if (!_familyDoctorDetailTableView) {
        _familyDoctorDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _familyDoctorDetailTableView.rowHeight = UITableViewAutomaticDimension;
        _familyDoctorDetailTableView.estimatedRowHeight = 100;
        _familyDoctorDetailTableView.delegate = self;
        _familyDoctorDetailTableView.dataSource = self;
        _familyDoctorDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _familyDoctorDetailTableView.backgroundColor = UIColorFromHEX(0xf1f1f1, 1);
        
        [_familyDoctorDetailTableView registerClass:[BATFamilyDoctorServiceTypeCell class] forCellReuseIdentifier:@"BATFamilyDoctorServiceTypeCell"];
        [_familyDoctorDetailTableView registerClass:[BATFamilyDoctorPackageCell class] forCellReuseIdentifier:SVERICE_CELL];
        [_familyDoctorDetailTableView registerClass:[BATFamilyDoctorSkillCell class] forCellReuseIdentifier:SKILL_CELL];
        [_familyDoctorDetailTableView registerNib:[UINib nibWithNibName:@"BATDoctorOfficeHeadCell" bundle:nil] forCellReuseIdentifier:@"BATDoctorOfficeHeadCell"];
         [_familyDoctorDetailTableView registerNib:[UINib nibWithNibName:@"BATConsultCountCell" bundle:nil] forCellReuseIdentifier:@"BATConsultCountCell"];
         [_familyDoctorDetailTableView registerClass:[BATCourseCommentTableViewCell class] forCellReuseIdentifier:@"BATCourseCommentTableViewCell"];

        WEAK_SELF(self);
        _familyDoctorDetailTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"下拉刷新！");
            [self requuestFamilyDoctorInfo];
            [self GetCommentsListRequest];
        }];
        _familyDoctorDetailTableView.mj_footer.hidden = YES;
        
    }
    return _familyDoctorDetailTableView;
}

- (BATGraditorButton *)buyButton{

    if (!_buyButton) {
        _buyButton = [[BATGraditorButton alloc] initWithFrame:CGRectZero];
        [_buyButton setTitle:@"购买" forState:UIControlStateNormal] ;
        _buyButton.enablehollowOut = YES;
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _buyButton.titleColor = [UIColor whiteColor];
        [_buyButton setGradientColors:@[START_COLOR,END_COLOR]];
        [_buyButton bk_whenTapped:^{
            
            DDLogInfo(@"购买服务！");
            if(!LOGIN_STATION){
                PRESENT_LOGIN_VC;
                return ;
            }else if (self.currnetPayCost == 0 && self.currnetChooseMonth == 0){
                
                _currnetPayCost = [self.familyDoctorModel.Data.FamilyDoctorCost[0].TValue floatValue];
                _currnetChooseMonth = [self.familyDoctorModel.Data.FamilyDoctorCost[0].TKey integerValue];;
                
                _isLoginStateShowAlert = YES;
                [self requuestFamilyDoctorInfo];
            }else{
                _isLoginStateShowAlert = YES;
                [self requuestFamilyDoctorInfo];
            }
        }];
    }
    return _buyButton;
}

- (BATAlertOrderInfoView *)alertOrderInfoView{
    if (!_alertOrderInfoView) {
        _alertOrderInfoView = [[BATAlertOrderInfoView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.alertOrderInfoView.hidden = YES;
        WEAK_SELF(self);
        [_alertOrderInfoView setClickBigBGViewBlock:^{
            STRONG_SELF(self);

            [self.view endEditing:YES];
            self.alertOrderInfoView.hidden = YES;
            self.buyButton.hidden = NO;
            
        }];
        
        [_alertOrderInfoView setSureButtonBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"请求购买！");
            
            [self ToJudgewhetherTheDataCorrectly];
            
        }];
    }
    return _alertOrderInfoView;
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
            [self requuestFamilyDoctorInfo];
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
