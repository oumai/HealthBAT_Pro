//
//  BATDoctorOfficeDetailController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorOfficeDetailController.h"

//vc
#import "BATWriteSymptomController.h"
#import "BATEvaluateListController.h"
#import "BATNewPayViewController.h"

//VIEW
#import "BATDoctorServiceBottomView.h"

//Cell
#import "BATDoctorOfficeHeadCell.h"
#import "BATConsultCountCell.h"
#import "BATDoctorOfficeIntroduceCell.h"
#import "BATTopicTableViewCell.h"
#import "BATCourseCommentTableViewCell.h"
#import "BATDoctorServiceCell.h"


//Model
#import "BATTopicRecordModel.h"
#import "BATDoctorOfficeModel.h"

@interface BATDoctorOfficeDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BATDoctorServiceBottomView *bottomView;

@property (nonatomic,strong) UITableView *severTab;

@property (nonatomic,strong) BATDefaultView *defaultView;

@property (nonatomic,strong) BATTopicRecordModel *CommentsModel;

@property (nonatomic,strong) BATDoctorOfficeModel *detailModel;

@property (nonatomic,assign) BATDoctorStudioOrderType type;

@end

@implementation BATDoctorOfficeDetailController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self pageLayout];
    
    
    [self GetDetailRequest];
    
    [self GetCommentsListRequest];
}

- (void)pageLayout {
    
    WEAK_SELF(self);
    
    [self.view addSubview:self.severTab];
    [self.severTab mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];

    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.bottom.equalTo(self.view).offset(0);
        if (iPhoneX) {
            if (@available(iOS 11.0, *)) {
                make.height.mas_equalTo(50+34);
            }
        } else {
            make.height.mas_equalTo(50);
        }
        
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return 3;
            break;
         case 1:
            return 2;
            break;
        case 2:
            if (self.CommentsModel.Data.count >0) {
                return 1;
            }else {
                return 0;
            }
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
       switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                BATDoctorOfficeHeadCell *headCell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorOfficeHeadCell"];
                [headCell.headImage sd_setImageWithURL:[NSURL URLWithString:self.detailModel.Data.DoctorPic] placeholderImage:[UIImage imageNamed:@"医生"]];
                headCell.nameLb.text = self.detailModel ? [NSString stringWithFormat:@"%@ [%@]",self.detailModel.Data.DoctorName,self.detailModel.Data.DoctorTitle] : @"姓名 职称";
                headCell.hosptialLb.text = self.detailModel ? [NSString stringWithFormat:@"%@  %@",self.detailModel.Data.HospitalName,self.detailModel.Data.DepartmentName] : @"医院 科室";
                [headCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return headCell;
                
            }else if(indexPath.row == 1) {
            
                BATConsultCountCell *consultCell = [tableView dequeueReusableCellWithIdentifier:@"BATConsultCountCell"];
                consultCell.ConsultConuntLb.text = self.detailModel ? [NSString stringWithFormat:@"%@次",self.detailModel.Data.ConsultNum] : @"";
                consultCell.EvaluateLb.text = self.detailModel ? [NSString stringWithFormat:@"%0.2f%%",[self.detailModel.Data.EvaluateRate floatValue]] : @"";
                [consultCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return consultCell;
            
            }else if(indexPath.row == 2){
                
                BATDoctorServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorServiceCell"];
                
                if (self.detailModel.Data.DoctorService.IsWordConsult) {
                    [cell.chatImage setImage:[UIImage imageNamed:@"ic-Picture-consulting"]];
                    [cell.chatContentLb setTitle:[NSString stringWithFormat:@"%@元/次",self.detailModel.Data.DoctorService.WordConsultCost] forState:UIControlStateNormal] ;
                    
                }else {
                    [cell.chatImage setImage:[UIImage imageNamed:@"ic-Picture-consulting-s"]];
                    [cell.chatContentLb setTitle:@"暂未开通" forState:UIControlStateNormal] ;
                }
                
                if (self.detailModel.Data.DoctorService.IsVoiceConsult) {
                    [cell.audioimage setImage:[UIImage imageNamed:@"ic-Voice"]];
                    [cell.AudioContentLb setTitle:[NSString stringWithFormat:@"%@元/次",self.detailModel.Data.DoctorService.VoiceConsultCost] forState:UIControlStateNormal];
                    
                }else {
                    [cell.audioimage setImage:[UIImage imageNamed:@"ic-Voice-s"]];
                    [cell.AudioContentLb setTitle:@"暂未开通" forState:UIControlStateNormal] ;
                    
                }
                //暂时没做，屏蔽掉
//                if (self.detailModel.Data.DoctorService.IsVideoConsult) {
//                    [cell.videoImage setImage:[UIImage imageNamed:@"ic-video"]];
//                    [cell.ViedoContentLb setTitle:[NSString stringWithFormat:@"%@元/次",self.detailModel.Data.DoctorService.VideoConsultCost] forState:UIControlStateNormal];
//                    
//                }else {
                    [cell.videoImage setImage:[UIImage imageNamed:@"ic-video-s"]];
                    [cell.ViedoContentLb setTitle:@"暂未开通" forState:UIControlStateNormal] ;
                    
//                }

                
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

                cell.SeverTapBlock = ^(NSInteger tag) {
                    
                    switch (tag) {
                        case 1230: {
                            
                            if (self.detailModel.Data.DoctorService.IsWordConsult) {
                                [self.bottomView.severStartBtn setTitle:[NSString stringWithFormat:@"图文咨询(%@元/次)",self.detailModel.Data.DoctorService.WordConsultCost]  forState:UIControlStateNormal];
                            }else {
                                [self.bottomView.severStartBtn setTitle:@"暂未开通"  forState:UIControlStateNormal];
                            }
                            
                            self.type = BATDoctorStudioOrderType_TextAndImage;
                            break;
                        }
                        case 1231: {
                            
                            if (self.detailModel.Data.DoctorService.IsVoiceConsult) {
                                 [self.bottomView.severStartBtn setTitle:[NSString stringWithFormat:@"语音咨询(%@元/次)",self.detailModel.Data.DoctorService.VoiceConsultCost]  forState:UIControlStateNormal];
                            }else {
                                [self.bottomView.severStartBtn setTitle:@"暂未开通"  forState:UIControlStateNormal];
                            }
                            
                            self.type = BATDoctorStudioOrderType_Audio;
                            break;
                        }
                        case 1232: {
                            
//                            if (self.detailModel.Data.DoctorService.IsVideoConsult) {
//                                 [self.bottomView.severStartBtn setTitle:[NSString stringWithFormat:@"视频咨询(%@元/次)",self.detailModel.Data.DoctorService.VideoConsultCost]  forState:UIControlStateNormal];
//                            }else {
                               [self.bottomView.severStartBtn setTitle:@"暂未开通"  forState:UIControlStateNormal];
//                            }
                            
                            self.type = BATDoctorStudioOrderType_Video;
                            break;
                        }
                        default:
                            break;
                    }
                };
                return cell;
            }
            break;
        }
        case 1: {
            if(indexPath.row == 0){
                BATDoctorOfficeIntroduceCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorOfficeIntroduceCell"];
                contentCell.IntroduceLb.text = @"擅长";
                contentCell.IntroduceContent.text= self.detailModel.Data.GoodAt;
                [contentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return contentCell;
            }else {
                BATDoctorOfficeIntroduceCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"BATDoctorOfficeIntroduceCell"];
                contentCell.IntroduceLb.text = @"简介";
                contentCell.IntroduceContent.text = self.detailModel.Data.DoctorDesc;
                [contentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return contentCell;
            }
            break;
        }
        case 2: {
            BATCourseCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseCommentTableViewCell"];
            [cell configTopicData:self.CommentsModel.Data[indexPath.row]];
            cell.commnetButton.hidden = YES;
            cell.commentCountLabel.hidden = YES;
            cell.likeCountLabel.hidden = YES;
            cell.likeButton.hidden = YES;
            
            if ([self.CommentsModel.Data[indexPath.row] IsComplaint]) {
                cell.rightUpBtn.hidden = NO;
            }else {
                cell.rightUpBtn.hidden = YES;
            }
            return cell;

            break;
        }
        default:
            break;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                 return UITableViewAutomaticDimension;
            }else if(indexPath.row == 1) {
                return 40;
            }else {
                return 132;
            }
            break;
        case 1:
            return UITableViewAutomaticDimension;
            break;
        case 2:
            return UITableViewAutomaticDimension;
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (section != 2) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        footerView.backgroundColor = BASE_BACKGROUND_COLOR;
        return footerView;
    }
    return nil;
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 2) {
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
            listVC.doctorid = self.doctorid;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    if (section == 2) {
        return 40;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section != 2) {
        return 10;
    }
    return 0.01;
}

#pragma mark - NET

#pragma mark - 获取工作室详情
- (void)GetDetailRequest {
    
    [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/doctor/detail/%@",self.doctorid] parameters:nil type:kGET success:^(id responseObject) {
        
        [_severTab.mj_header endRefreshing];
        [_severTab.mj_footer endRefreshing];
        
        self.detailModel = [BATDoctorOfficeModel mj_objectWithKeyValues:responseObject];
        
        if (self.detailModel.Data.DoctorService.IsWordConsult) {
            [self.bottomView.severStartBtn setTitle:[NSString stringWithFormat:@"图文咨询(%@元/次)",self.detailModel.Data.DoctorService.WordConsultCost]  forState:UIControlStateNormal];
        }else {
             [self.bottomView.severStartBtn setTitle:@"暂未开通" forState:UIControlStateNormal];
        }
        
        self.type = BATDoctorStudioOrderType_TextAndImage;

        self.title = [NSString stringWithFormat:@"%@的工作室",self.detailModel.Data.DoctorName];
        
        [_severTab reloadData];
    } failure:^(NSError *error) {
        
        [_severTab.mj_header endRefreshing];
        [_severTab.mj_footer endRefreshing];
        
        [self.defaultView showDefaultView];
    }];
}

#pragma mark - 获取回复列表
- (void)GetCommentsListRequest {
    
     [HTTPTool requestWithURLString:@"/api/OrderEvaluate/GetEvaluateList" parameters:@{@"doctorID":self.doctorid,@"pageIndex":@"0",@"pageSize":@"10"}  type:kGET success:^(id responseObject) {
        
        [_severTab.mj_header endRefreshing];
        [_severTab.mj_footer endRefreshing];
        
        _severTab.mj_footer.hidden = NO;
        
        self.CommentsModel = [BATTopicRecordModel mj_objectWithKeyValues:responseObject];
        
        for (TopicReplyData *data in self.CommentsModel.Data) {
            data.ReplyContent = data.Comment;
            data.CreatedTime = data.EvaluateTime;
            for (secondReplyData *secData in data.secondReplyList) {
                secData.ReplyContent = secData.Comment;
            }
        }
        
        
        if (self.CommentsModel.Data.count == [self.CommentsModel.RecordsCount integerValue]) {
            [self.severTab.mj_footer endRefreshingWithNoMoreData];
        }
        [_severTab reloadData];
    } failure:^(NSError *error) {
        
        [_severTab.mj_header endRefreshing];
        [_severTab.mj_footer endRefreshing];
        
        
    }];
}


- (void)creatOrderRequest:(BATDoctorStudioOrderType)type   orderMoney:(NSString *)OrderMoney{
//    
//    NSDictionary *param = @{@"DoctorID":self.detailModel.Data.ID,
//                            @"OrderType":@(type),
//                            @"OrderMoney":OrderMoney,
//                            @"IllnessDescription":@"",
//                            @"Images":@""};
//    
//    [HTTPTool requestWithURLString:@"/api/order/CreateConsultOrder" parameters:param type:kPOST success:^(id responseObject) {
//        
//        
//        BATDoctorStudioCreateOrderModel *model = [BATDoctorStudioCreateOrderModel mj_objectWithKeyValues:responseObject];
//        if (model.ResultCode == 0) {
//            [self showSuccessWithText:responseObject[@"ResultMessage"]];
//            
//            //去支付页面
//            BATNewPayViewController *payVC = [[BATNewPayViewController alloc] init];
//            payVC.type = type;
//            payVC.momey = OrderMoney;
//            payVC.doctorName = self.detailModel.Data.DoctorName;
//            payVC.doctorPhotoPath = self.detailModel.Data.DoctorPic;
//            payVC.dept = self.detailModel.Data.DepartmentName;
////            payVC.orderNo = responseObject[@"Data"];
//            payVC.doctorID = self.detailModel.Data.ID;
//            payVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:payVC animated:YES];
//        }
//        else {
//            
//            [self showErrorWithText:model.ResultMessage];
//        }
//    } failure:^(NSError *error) {
//        
//        [self showErrorWithText:error.localizedDescription];
// 
//    }];

}

#pragma mark - Lazy Load
- (UITableView *)severTab {

    if (!_severTab) {
        _severTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStyleGrouped];
        _severTab.delegate = self;
        _severTab.dataSource = self;
        _severTab.estimatedRowHeight = 200;
        _severTab.backgroundColor = BASE_BACKGROUND_COLOR;
        _severTab.rowHeight = UITableViewAutomaticDimension;
        [_severTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_severTab registerNib:[UINib nibWithNibName:@"BATDoctorOfficeHeadCell" bundle:nil] forCellReuseIdentifier:@"BATDoctorOfficeHeadCell"];
        [_severTab registerNib:[UINib nibWithNibName:@"BATConsultCountCell" bundle:nil] forCellReuseIdentifier:@"BATConsultCountCell"];
        [_severTab registerNib:[UINib nibWithNibName:@"BATDoctorOfficeIntroduceCell" bundle:nil] forCellReuseIdentifier:@"BATDoctorOfficeIntroduceCell"];
        [_severTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"123"];
        [_severTab registerClass:[BATCourseCommentTableViewCell class] forCellReuseIdentifier:@"BATCourseCommentTableViewCell"];
        [_severTab registerClass:[BATDoctorServiceCell class] forCellReuseIdentifier:@"BATDoctorServiceCell"];
        
        WEAK_SELF(self);
        _severTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            [self GetDetailRequest];
        }];
        
//        _severTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
//            STRONG_SELF(self);
//            self.currentPage ++;
//            [self GetCommentsListRequest];
//        }];
        
        _severTab.mj_footer.hidden = YES;

    }
    return _severTab;
}

- (BATDoctorServiceBottomView *)bottomView {

    if (!_bottomView) {
//        _bottomView  = [[[NSBundle mainBundle] loadNibNamed:@"BATDoctorOfficeBottomView" owner:nil options:nil] lastObject];
        _bottomView = [[BATDoctorServiceBottomView alloc]init];
        
        WEAK_SELF(self);
        _bottomView.startSeverTap = ^() {

            STRONG_SELF(self);
            switch (self.type) {
                case BATDoctorStudioOrderType_TextAndImage: {
                    
                    if (!self.detailModel) {
                        return;
                    }
                    
                    if (self.detailModel.Data.DoctorService.IsWordConsult) {
                        
                        BATWriteSymptomController *wirteSymptomVC = [[BATWriteSymptomController alloc]init];
                        wirteSymptomVC.DoctorID = self.detailModel.Data.ID;
                        wirteSymptomVC.OrderType = self.type;
                        wirteSymptomVC.doctorName = self.detailModel.Data.DoctorName;
                        wirteSymptomVC.OrderMoney = self.detailModel.Data.DoctorService.WordConsultCost;
                        
                        wirteSymptomVC.dept = self.detailModel.Data.DepartmentName;
                        wirteSymptomVC.doctorPhotoPath = self.detailModel.Data.DoctorPic;
                        wirteSymptomVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:wirteSymptomVC animated:YES];
                    }
                }
                    break;
                case BATDoctorStudioOrderType_Video:{
                
//                    if (self.detailModel.Data.DoctorService.IsVideoConsult) {
//                        //去支付页面
//                        BATNewPayViewController *payVC = [[BATNewPayViewController alloc] init];
//                        payVC.type = BATDoctorStudioOrderType_Video;
//                        payVC.momey = self.detailModel.Data.DoctorService.VideoConsultCost;
//                        payVC.isTheNormalProcess = YES;
//                        payVC.doctorName = self.detailModel.Data.DoctorName;
//                        payVC.doctorPhotoPath = self.detailModel.Data.DoctorPic;
//                        payVC.dept = self.detailModel.Data.DepartmentName;
//                        //            payVC.orderNo = responseObject[@"Data"];
//                        payVC.doctorID = self.detailModel.Data.ID;
//                        payVC.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:payVC animated:YES];
//                        
//                    }
                }
                    break;
                case BATDoctorStudioOrderType_Audio:{
                    
                    if (self.detailModel.Data.DoctorService.IsVoiceConsult) {
                        
                        //去支付页面
                        BATNewPayViewController *payVC = [[BATNewPayViewController alloc] init];
                        payVC.type = BATDoctorStudioOrderType_Audio;
                        payVC.momey = self.detailModel.Data.DoctorService.VoiceConsultCost;
                        payVC.isTheNormalProcess = YES;
                        payVC.doctorName = self.detailModel.Data.DoctorName;
                        payVC.doctorPhotoPath = self.detailModel.Data.DoctorPic;
                        payVC.dept = self.detailModel.Data.DepartmentName;
                        //            payVC.orderNo = responseObject[@"Data"];
                        payVC.doctorID = self.detailModel.Data.ID;
                        payVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:payVC animated:YES];
                    }
                  
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _bottomView;
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
            //获取咨询的医生的数据
            [self GetDetailRequest];
        }];
    }
    return _defaultView;
}


@end
