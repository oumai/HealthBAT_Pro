//
//  BATSearchDieaseDetailController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSearchDieaseDetailController.h"
#import "BATNewsDetailViewController.h"
#import "BATSearchListViewController.h"
#import "BATDrugInfoDetailViewController.h"
//#import "BATHospitailInfoDetailViewController.h"
#import "BATNewHospitalInfoViewController.h"
#import "BATConsultationDoctorDetailViewController.h"
#import "BATNewConsultionDoctorDetailViewController.h"
//#import "BATDrKangViewController.h"
#import "BATNewDrKangViewController.h"
#import "BATDieaseSymptomDetailController.h"
#import "BATHomeMallViewController.h"

//第三方
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "SFHFKeychainUtils.h"
#import "BATDieaseDetailController.h"

//Cell
#import "BATSectionOneCell.h"
#import "BATSectionTwoCell.h"
#import "BATInformationViewCell.h"
#import "BATSectionThreeCell.h"
#import "BATMoreViewCell.h"

//Model
#import "BATSearchWithTypeModel.h"
#import "BATPerson.h"
#import "BATSymptomModel.h"
#import "BATDieaseDetailModel.h"

@interface BATSearchDieaseDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *dieaseTab;

@property (nonatomic,strong) BATSearchWithTypeModel *searchModel;

@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lon;

@property (nonatomic,strong) NSMutableArray *infoDataArry;

@property (nonatomic,strong) NSMutableArray *doctorDataArry;

@property (nonatomic,strong) NSMutableArray *hosptialDataArry;

@property (nonatomic,strong) NSMutableArray *drugDataArry;

@property (nonatomic,strong) NSMutableArray *doctor160Arry;

@property (nonatomic,strong) NSMutableArray *holeDataArray;


@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) UIView *bottomView;

@end

@implementation BATSearchDieaseDetailController

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLatAanLon:) name:@"USERLOCATION_INFO" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BEGIN_GET_LOCATION" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchRequest:) name:@"RELOADDIEASECOLLECTIONVIEWCELL" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToDetailController:) name:@"PUSHTODEATILCONTROLLER" object:nil];
    
    [self pageLayout];
    
    [self showProgressWithText:@"正在加载"];
    
    

    if (self.EntryCNName == nil || self.pathName == nil || self.resultDesc == nil) {
        
        if ([self.titleName isEqualToString:@"症状百科"]) {
            [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/Symptom/GetSymptomDetail?ID=%zd",self.DieaseID] parameters:nil type:kGET success:^(id responseObject) {
                //    NSLog(@"%@",responseObject);
                BATSymptomModel *model = [BATSymptomModel mj_objectWithKeyValues:responseObject];
                
                self.resultDesc = model.Data.BRIEFINTRO_CONTENT;
                self.title = model.Data.SYMPTOM_NAME;
                self.EntryCNName = model.Data.SYMPTOM_NAME;
                //资讯请求
                [self SearchInfoRequest];
                
                //医生请求
                [self SearchDoctorRequest];
                
            } failure:^(NSError *error) {
                [self showErrorWithText:error.localizedDescription];
                
            }];
        }else {
        
            [HTTPTool requestWithURLString:@"/api/Disease/GetDiseaseDetails" parameters:@{@"id":@(self.DieaseID)} type:kGET success:^(id responseObject) {
                
                
                BATDieaseDetailModel *model = [BATDieaseDetailModel mj_objectWithKeyValues:responseObject];
                self.resultDesc = model.Data.Briefintro_Content;
                self.title = model.Data.Disease_Name;
                self.EntryCNName = model.Data.Disease_Name;
                //资讯请求
                [self SearchInfoRequest];
                
                //医生请求
                [self SearchDoctorRequest];
                
                
            } failure:^(NSError *error) {
                [self showErrorWithText:error.localizedDescription];
            }];
        }

        
        
    }else {
    
        //资讯请求
        [self SearchInfoRequest];
        
        //医生请求
        [self SearchDoctorRequest];
    }
    
}

- (void)pushToDetailController:(NSNotification *)notice {

    NSDictionary *dict = [notice object];
    
    if ([dict[@"type"] isEqualToString:@"drug_info"]) {
        NSString *drugSource = dict[@"drugSource"];
        if ([drugSource isEqualToString:@"1"]) {
            BATHomeMallViewController *homeMallVC = [[BATHomeMallViewController alloc] init];
            homeMallVC.url = [NSString stringWithFormat:@"http://m.km1818.com/products/%@.html?kmCloud",dict[@"resultId"]];
            homeMallVC.title = dict[@"resultTitle"];
          //  homeMallVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:homeMallVC animated:YES];
        }else {
            //药品
            BATDrugInfoDetailViewController *drugVC = [[BATDrugInfoDetailViewController alloc] init];
            drugVC.drugID = dict[@"resultId"];
            drugVC.drugTitle = dict[@"resultTitle"];
            drugVC.pathName = dict[@"resultTitle"];
            [self.navigationController pushViewController:drugVC animated:YES];
        }
//        BATDrugInfoDetailViewController *drugVC = [[BATDrugInfoDetailViewController alloc] init];
//        drugVC.drugID = dict[@"resultId"];
//        drugVC.drugTitle = dict[@"resultTitle"];
//        drugVC.pathName = dict[@"resultTitle"];
//        [self.navigationController pushViewController:drugVC animated:YES];
    }else if ([dict[@"type"] isEqualToString:@"hospital_info"]) {
        BATNewHospitalInfoViewController *hospitalVC = [[BATNewHospitalInfoViewController alloc] init];
        hospitalVC.HospitailID = dict[@"resultId"];
        hospitalVC.HospitailTitle = dict[@"resultTitle"];
        hospitalVC.pathName = dict[@"resultTitle"];
        [self.navigationController pushViewController:hospitalVC animated:YES];
    }else if ([dict[@"type"] isEqualToString:@"doctor_info"] && [dict[@"dataType"] integerValue] == 0) {
        //医生
        NSInteger dateType = [dict[@"dataType"] integerValue];

        switch (dateType) {
            case 0:{
                //0 网络医院
                BATNewConsultionDoctorDetailViewController *doctorDetailVC = [[BATNewConsultionDoctorDetailViewController alloc] init];
                doctorDetailVC.hidesBottomBarWhenPushed = YES;
                doctorDetailVC.doctorID = dict[@"resultId"];
                doctorDetailVC.pathName = dict[@"resultTitle"];
                [self.navigationController pushViewController:doctorDetailVC animated:YES];
            }
                break;
            case 1:{
                //1 160的医生
                BATConsultationDoctorDetailViewController *doctorDetailCtl = [[BATConsultationDoctorDetailViewController alloc]init];
                doctorDetailCtl.doctorID = dict[@"resultId"];
                doctorDetailCtl.pathName = dict[@"resultTitle"];
                doctorDetailCtl.isKMDoctor = NO;
                
                [self.navigationController pushViewController:doctorDetailCtl animated:YES];
            }
                break;
            default:
                break;
        }
        
      
    }else{
        NSInteger dateType = [dict[@"dataType"] integerValue];

        switch (dateType) {
            case 0:{
                //0 网络医院
                BATNewConsultionDoctorDetailViewController *doctorDetailVC = [[BATNewConsultionDoctorDetailViewController alloc] init];
                doctorDetailVC.hidesBottomBarWhenPushed = YES;
                doctorDetailVC.doctorID = dict[@"resultId"];
                doctorDetailVC.pathName = dict[@"resultTitle"];
                [self.navigationController pushViewController:doctorDetailVC animated:YES];
            }
                break;
            case 1:{
                //1 160的医生
                BATConsultationDoctorDetailViewController *doctorDetailCtl = [[BATConsultationDoctorDetailViewController alloc]init];
                doctorDetailCtl.doctorID = dict[@"resultId"];
                doctorDetailCtl.pathName = dict[@"resultTitle"];
                doctorDetailCtl.isKMDoctor = NO;
                [self.navigationController pushViewController:doctorDetailCtl animated:YES];
            }
                break;
            default:
                break;
        }
    }
}


- (void)searchRequest:(NSNotification *)notice {

    NSInteger page = [notice.object integerValue];
    NSString *type = nil;
    NSInteger doctorType = 0;
    switch (page) {
        case 0: {
            type = @"doctor_info";
             self.page = page;
            if (self.doctorDataArry.count >0) {
                [self.dieaseTab  reloadData];
                return;
            }
        }
            break;
        case 1: {
            type = @"hospital_info";
             self.page = page;
            if (self.hosptialDataArry.count >0) {
                [self.dieaseTab  reloadData];
                return;
            }
        }
            break;
        case 2: {
             type = @"drug_info";
             self.page = page;
            if (self.drugDataArry.count >0) {
                [self.dieaseTab  reloadData];
                return;
            }
        }
            break;
        case 3: {
            type = @"doctor_info";
            doctorType = 1;
             self.page = page;
            if (self.doctor160Arry.count >0) {
                [self.dieaseTab  reloadData];
                return;
            }
        }
            break;
            
            
        default:
            break;
    }
    
    [self SearchHoleRequesetWithType:type doctorType:doctorType success:^{
        [self.dieaseTab reloadData];
    } failure:^{
        
    }];
    
}

#pragma mark - PageLayout
- (void)pageLayout {
   
    self.title = self.EntryCNName;
    
    self.infoDataArry = [NSMutableArray array];
    
    self.doctorDataArry = [NSMutableArray array];
    
    self.doctor160Arry = [NSMutableArray array];
    
    self.hosptialDataArry = [NSMutableArray array];
    
    self.drugDataArry = [NSMutableArray array];
    
    self.holeDataArray = [NSMutableArray array];
    
    [self.holeDataArray addObject:self.doctorDataArry];
    
    [self.holeDataArray addObject:self.hosptialDataArry];
    
    [self.holeDataArray addObject:self.drugDataArry];
    
    [self.holeDataArray addObject:self.doctor160Arry];
    

    
    [self.view addSubview:self.dieaseTab];

    
    [self.view addSubview:self.bottomView];
    
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 44;
        }
        if (indexPath.row ==1) {
            return 330;
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 45;
        }else {
        return 110;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return self.infoDataArry.count + 1;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        BATSectionOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionOneCell"];
//        cell.contentLb.text = self.resultDesc;
        cell.contentString = self.resultDesc;
        cell.titleLb.text = self.titleName;
        return cell;

    }else if(indexPath.section == 1) {
    
        if (indexPath.row == 0) {
            BATSectionTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionTwoCell"];
            
            WEAK_SELF(self);
            cell.sectionTwoBlockAction = ^(NSInteger type) {
                
                STRONG_SELF(self);
                self.page = type;
                
                BATSectionThreeCell *sectionThreeCell = (BATSectionThreeCell *)[self.dieaseTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                
                
             //   NSLog(@"%zd",type);
                switch (type) {
                    case 0: {
                        if (self.doctorDataArry.count > 0) {
                            
                            [self.dieaseTab reloadData];
                            [sectionThreeCell.searchCollection setContentOffset:CGPointMake(0, 0)];
                        
                            return;
                        }else {
                            
                                [sectionThreeCell.searchCollection setContentOffset:CGPointMake(0, 0)];
                            [self SearchHoleRequesetWithType:@"doctor_info" doctorType:0 success:^{
                                
                                 [self.dieaseTab reloadData];
                            

                            } failure:^{
                                
                            }];
                        }
                    }
                        break;
                    case 1: {
                        if (self.hosptialDataArry.count >0) {
                            
                               [self.dieaseTab reloadData];
                            [sectionThreeCell.searchCollection setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
                         

                            return;
                        }else {
                            
                                  [sectionThreeCell.searchCollection setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
                            [self SearchHoleRequesetWithType:@"hospital_info" doctorType:0 success:^{
                                
                                 [self.dieaseTab reloadData];

                            } failure:^{
                                
                            }];
                        }
                    }
                        break;
                    case 2: {
                        if (self.drugDataArry.count >0) {
                            
                            [self.dieaseTab reloadData];
                            [sectionThreeCell.searchCollection setContentOffset:CGPointMake(SCREEN_WIDTH *2, 0)];

                            return;
                        }else {
                            
                            [sectionThreeCell.searchCollection setContentOffset:CGPointMake(SCREEN_WIDTH *2, 0)];
                            [self SearchHoleRequesetWithType:@"drug_info" doctorType:0 success:^{
                                
                                [self.dieaseTab reloadData];


                            } failure:^{
                                
                            }];
                        }
                    }
                        break;
                    case 3: {
                        if (self.doctor160Arry.count >0) {
                            
                            
                            [self.dieaseTab reloadData];
                            [sectionThreeCell.searchCollection setContentOffset:CGPointMake(SCREEN_WIDTH *3, 0)];

                            return;
                        }else {
                            
                            [sectionThreeCell.searchCollection setContentOffset:CGPointMake(SCREEN_WIDTH *3, 0)];
                            [self SearchHoleRequesetWithType:@"doctor_info" doctorType:1 success:^{
                                 [self.dieaseTab reloadData];
                            

                            } failure:^{
                                
                            }];
                        }
                    }
                        break;
                    default:
                        break;
                }
                
                NSLog(@"%@",NSStringFromCGPoint(sectionThreeCell.searchCollection.contentOffset));
                
            };
            
            return cell;
        }else {
            BATSectionThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATSectionThreeCell"];
            
            if ([self.holeDataArray[0] count]>0) {
                if ([self.holeDataArray[self.page] count] >0) {
                    cell.typModelArray = self.holeDataArray[self.page][0];
                }
            
            }
            return cell;
        }
    }else {
        
        if (indexPath.row == 0) {
            BATMoreViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:@"BATMoreViewCell"];
            [moreCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return moreCell;
        }else {
            SearchWithTypeContent *searchContent = self.infoDataArry[indexPath.row - 1];
            BATInformationViewCell *informationCell = [tableView dequeueReusableCellWithIdentifier:@"BATInformationViewCell"];
            [informationCell.inforImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.mainImage]] placeholderImage:[UIImage imageNamed:@"默认图"]];
            informationCell.nameLabel.text = searchContent.resultTitle;
            informationCell.descriptionLabel.text = [searchContent.resultDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            return informationCell;
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (section == 1) {
        UIView *footer  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        footer.backgroundColor = [UIColor whiteColor];
        
        
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        [btn setTitle:@"查看更多" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:UIColorFromHEX(0X666666, 1) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pushToTypeController) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:btn];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 30, 18,7.5, 7.5)];
        img.image = [UIImage imageNamed:@"icon_arrow_right"];
        
        [footer addSubview:img];
        
        return footer;
    }
    return nil;
    
}

- (void)pushToTypeController {
    
    NSString *searchType = nil;
    NSInteger doctorType = 0;
    kSearchType type = 0;
    switch (self.page) {
        case 0:
            searchType = @"doctor_info";
            type = kSearchDoctor;
            break;
        case 1:
            searchType = @"hospital_info";
            type = kSearchHospital;
            break;
        case 2:
            searchType = @"drug_info";
            type = kSearchTreatment;
            break;
        case 3:
            searchType = @"doctor_info";
            doctorType = 1;
            type = kSearchDoctor;
            break;
        default:
            break;
    }
    
    if ([self.holeDataArray[self.page] count] >0) {
        if ([self.holeDataArray[self.page][0] count] == 0) {
            [self showText:@"暂无更多内容"];
            return;
        }
    }
    
    BATSearchListViewController * searchListVC = [BATSearchListViewController new];
    searchListVC.searchType = searchType;
    searchListVC.isNewAPI = YES;
    searchListVC.key = self.EntryCNName;
    searchListVC.lat = self.lat;
    searchListVC.lon = self.lon;
    searchListVC.type = type;
    searchListVC.doctorType = doctorType;
    [self.navigationController pushViewController:searchListVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 45;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 1 || section == 2) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = BASE_BACKGROUND_COLOR;
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 1 || section == 2) {
        return 10;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if ([self.titleName isEqualToString:@"疾病百科"]) {
            BATDieaseDetailController *searchDieaseCtl = [[BATDieaseDetailController alloc]init];
            searchDieaseCtl.DieaseID = self.DieaseID;
            searchDieaseCtl.EntryCNName = self.EntryCNName;
            searchDieaseCtl.pathName = self.EntryCNName;
            [self.navigationController pushViewController:searchDieaseCtl animated:YES];
        }else {
            BATDieaseSymptomDetailController *searchDieaseCtl = [[BATDieaseSymptomDetailController alloc]init];
            searchDieaseCtl.ID = self.DieaseID;
//            searchDieaseCtl.EntryCNName = self.EntryCNName;
//            searchDieaseCtl.pathName = self.EntryCNName;
            [self.navigationController pushViewController:searchDieaseCtl animated:YES];
        }
        
    }
    
    if (indexPath.section == 2) {
        
        
        if (indexPath.row == 0) {
            
            BATSearchListViewController * searchListVC = [BATSearchListViewController new];
            searchListVC.searchType = @"news_info";
            searchListVC.isNewAPI = YES;
            searchListVC.key = self.EntryCNName;
            searchListVC.lat = self.lat;
            searchListVC.lon = self.lon;
            searchListVC.type = kSearchInformation;
            searchListVC.doctorType = 0;
            [self.navigationController pushViewController:searchListVC animated:YES];
            return;
        }
        

        SearchWithTypeContent *searchContent = self.infoDataArry[indexPath.row - 1];
        
        BATNewsDetailViewController *webView = [[BATNewsDetailViewController alloc]init];
        webView.titleStr = searchContent.resultTitle;
        webView.newsID = searchContent.resultId;
        webView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webView animated:YES];
    }
    
//    if (indexPath.row == 0) {
//        
//    }else {
//        SearchWithTypeContent *searchContent = self.infoDataArry[indexPath.row - 1];
//        
//        BATNewsDetailViewController *webView = [[BATNewsDetailViewController alloc]init];
//        webView.titleStr = searchContent.resultTitle;
//        webView.newsID = searchContent.resultId;
//        webView.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:webView animated:YES];
//    }
    
}

#pragma mark - NET
- (void)SearchInfoRequest {
    
   
    [HTTPTool requestWithSearchURLString:@"/elasticsearch/searchapp/searchByDiseaseAndSymptom"
                          parameters:@{
                                       @"keyword":self.EntryCNName,
                                       @"devicetype":@"ios",
                                       @"lat":@(self.lat),
                                       @"lon":@(self.lon),
                                       @"types":@"news_info",
                                       @"page":@(0),
                                       @"pageSize":@(5),
                                       @"doctorSource":@"0"
                                       }
                             success:^(id responseObject) {
                                 
                                 _dieaseTab.mj_footer.hidden = NO;
                                 [self.dieaseTab.mj_header endRefreshing];
                                 [self.dieaseTab.mj_footer endRefreshing];
                                 
                                 BATSearchWithTypeModel *searchWithTypeModel = [BATSearchWithTypeModel mj_objectWithKeyValues:responseObject];
                                 
                                 
                                 [self.infoDataArry addObjectsFromArray:searchWithTypeModel.resultData.content];
                                 if (self.infoDataArry.count >= searchWithTypeModel.resultData.totalElements) {
                                     
                                     [self.dieaseTab.mj_footer endRefreshingWithNoMoreData];
                                 }
                                 
                                 if (searchWithTypeModel.resultData.totalElements == 0) {
                                     
                                     //没有数据
                                     self.dieaseTab.mj_footer.hidden = YES;
                                 }
                                 
                                 [self.dieaseTab reloadData];
                             } failure:^(NSError *error) {
                                 [self.dieaseTab.mj_header endRefreshing];
                                 [self.dieaseTab.mj_footer endRefreshing];
                             }];
}

- (void)SearchDoctorRequest {

    [HTTPTool requestWithSearchURLString:@"/elasticsearch/searchapp/searchByDiseaseAndSymptom"
                              parameters:@{
                                           @"keyword":self.EntryCNName,
                                           @"devicetype":@"ios",
                                           @"lat":@(self.lat),
                                           @"lon":@(self.lon),
                                           @"types":@"doctor_info",
                                           @"page":@(0),
                                           @"pageSize":@(3),
                                           @"doctorSource":@"0"
                                           }
                                 success:^(id responseObject) {
                                     [self dismissProgress];
                                     _dieaseTab.mj_footer.hidden = NO;
                                     [self.dieaseTab.mj_header endRefreshing];
                                     [self.dieaseTab.mj_footer endRefreshing];
                                     
                                     BATSearchWithTypeModel *searchWithTypeModel = [BATSearchWithTypeModel mj_objectWithKeyValues:responseObject];
                                     
                                     
                                     [self.doctorDataArry addObject:searchWithTypeModel.resultData.content];
                                    
                                  //   [self.holeDataArray addObject:self.doctorDataArry];
                                     
                                     
                                     [self.dieaseTab reloadData];
                                 } failure:^(NSError *error) {
                                       [self dismissProgress];
                                     [self.dieaseTab.mj_header endRefreshing];
                                     [self.dieaseTab.mj_footer endRefreshing];
                                 }];
    
}

- (void)SearchHoleRequesetWithType:(NSString *)type doctorType:(NSInteger)doctorType success:(void (^)(void))success failure:(void (^)(void))failure {
    
    [HTTPTool requestWithSearchURLString:@"/elasticsearch/searchapp/searchByDiseaseAndSymptom"
                              parameters:@{
                                           @"keyword":self.EntryCNName,
                                           @"devicetype":@"ios",
                                           @"lat":@(self.lat),
                                           @"lon":@(self.lon),
                                           @"types":type,
                                           @"page":@(0),
                                           @"pageSize":@(3),
                                           @"doctorSource":@(doctorType)
                                           }
                                 success:^(id responseObject) {
                                     
                                     _dieaseTab.mj_footer.hidden = NO;
                                     [self.dieaseTab.mj_header endRefreshing];
                                     [self.dieaseTab.mj_footer endRefreshing];
                                     
                                     BATSearchWithTypeModel *searchWithTypeModel = [BATSearchWithTypeModel mj_objectWithKeyValues:responseObject];
                                     
                                     
                                     if(searchWithTypeModel.resultData.content.count >0) {
                                         
                        
                                         
                                         if ([[searchWithTypeModel.resultData.content[0] resultType] isEqualToString:@"drug_info"
                                              ]) {
                                             [self.drugDataArry addObject:searchWithTypeModel.resultData.content];
                                         }
                                         
                                         if([[searchWithTypeModel.resultData.content[0] resultType] isEqualToString:@"hospital_info"
                                             ]) {
                                             
                                             [self.hosptialDataArry addObject:searchWithTypeModel.resultData.content];
                                             
                                         }
                                         
                                         if([[searchWithTypeModel.resultData.content[0] resultType] isEqualToString:@"doctor_info"
                                             ] && [searchWithTypeModel.resultData.content[0] dataType] == 1){
                                             
                                             [self.doctor160Arry addObject:searchWithTypeModel.resultData.content];
                                             
                                         }
                                     }else {
                                         
//                                         if([[searchWithTypeModel.resultData.content[0] resultType] isEqualToString:@"doctor_info"
//                                             ] && [searchWithTypeModel.resultData.content[0] dataType] == 1){
//
//                                             [self.doctor160Arry addObject:@[]];
//
//                                         }
                                         
                                    // [self.drugDataArry addObject:@[]];
                                         if (doctorType == 1) {
                                              [self.doctor160Arry addObject:@[]];
                                         }
                                    
                                         if ([type isEqualToString:@"drug_info"]) {
                                             [self.drugDataArry addObject:@[]];
                                         }
                                         
                                         if ([type isEqualToString:@"hospital_info"]) {
                                             [self.hosptialDataArry addObject:@[]];
                                         }
                                         
                                     }
                                    
                                     
                                     if (success) {
                                         success();
                                     }
                                     
                                     
                                  //   [self.dieaseTab reloadData];
                                 } failure:^(NSError *error) {
                                     if (failure) {
                                         failure();
                                     }
                                     [self.dieaseTab.mj_header endRefreshing];
                                     [self.dieaseTab.mj_footer endRefreshing];
                                 }];
    
}


#pragma mark - private math
//获取经纬度
- (void)getLatAanLon:(NSNotification *)sender {
    BMKUserLocation *location = sender.object;
    _lon = location.location.coordinate.longitude;
    _lat = location.location.coordinate.latitude;
}



#pragma mark - Lazy load
- (UITableView *)dieaseTab {
    if (!_dieaseTab) {
        _dieaseTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 51) style:UITableViewStyleGrouped];
        _dieaseTab.delegate = self;
        _dieaseTab.dataSource = self;
        _dieaseTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dieaseTab.estimatedRowHeight = 250;
        _dieaseTab.rowHeight = UITableViewAutomaticDimension;
        _dieaseTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_dieaseTab registerClass:[BATSectionOneCell class] forCellReuseIdentifier:@"SectionOneCell"];
        [_dieaseTab registerClass:[BATSectionTwoCell class] forCellReuseIdentifier:@"SectionTwoCell"];
        [_dieaseTab registerClass:[BATSectionThreeCell class] forCellReuseIdentifier:@"BATSectionThreeCell"];
        [_dieaseTab registerClass:[BATInformationViewCell class] forCellReuseIdentifier:@"BATInformationViewCell"];
        [_dieaseTab registerNib:[UINib nibWithNibName:@"BATMoreViewCell" bundle:nil] forCellReuseIdentifier:@"BATMoreViewCell"];
        
            
        _dieaseTab.mj_footer.hidden = YES;
    }
    return _dieaseTab;
}

- (UIView *)bottomView {

    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - 64, SCREEN_WIDTH, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        BATGraditorButton *btn = [[BATGraditorButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [btn setImage:[UIImage imageNamed:@"boshi"] forState:UIControlStateNormal];
        btn.enbleGraditor = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.imageRect = CGRectMake(SCREEN_WIDTH/2 - 10 - 18 - 10, 15, 18, 20);
        btn.titleRect = CGRectMake(SCREEN_WIDTH/2 - 10, 11, 150, 30);
        [btn setTitle:@"找康博士" forState:UIControlStateNormal];
        [btn setGradientColors:@[START_COLOR,END_COLOR]];
        
        [btn addTarget:self action:@selector(pushToDocot) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];

    }
    return _bottomView;
}

- (void)pushToDocot {
 
//    BATDrKangViewController *kangdoctorVC = [[BATDrKangViewController alloc]init];
//    [self.navigationController pushViewController:kangdoctorVC animated:YES];

    BATNewDrKangViewController *kangdoctorVC = [[BATNewDrKangViewController alloc]init];
    [self.navigationController pushViewController:kangdoctorVC animated:YES];
}
@end
