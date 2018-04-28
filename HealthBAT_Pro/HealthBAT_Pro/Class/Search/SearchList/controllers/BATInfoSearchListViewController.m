//
//  SearchListViewController.m
//  HealthBAT
//
//  Created by KM on 16/8/32016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATInfoSearchListViewController.h"
#import "BATSearchWithTypeModel.h"

#import "BATConditionCollectionViewCell.h"
#import "BATTreatmentCollectionViewCell.h"
#import "BATHospitalCollectionViewCell.h"
#import "BATDoctorCollectionViewCell.h"
#import "BATInformationCollectionViewCell.h"

#import "BATResultHeaderCollectionReusableView.h"
#import "BATDieaseDetailController.h"
#import "BATDrugInfoDetailViewController.h"
//#import "BATHospitailInfoDetailViewController.h"
#import "BATNewHospitalInfoViewController.h"
#import "BATConsultationDoctorDetailViewController.h"
#import "BATNewConsultionDoctorDetailViewController.h"
#import "BATNewsDetailViewController.h"
#import "BATGeracomiumController.h"
#import "BATDieaseSymptomDetailController.h"
#import "BATSearchDieaseDetailController.h"


#import "MJRefresh.h"
#import "BATHealthAssessmentViewController.h"

#import "SFHFKeychainUtils.h"

#import "BATSearchSimpleModel.h"

static  NSString * const CONDITION_CELL = @"ConditionCell";
static  NSString * const TREATMENT_CELL = @"TreatmentCell";
static  NSString * const HOSPITAL_CELL = @"HospitalCell";
static  NSString * const DOCTOR_CELL = @"DoctorCell";
static  NSString * const INFORMATION_CELL = @"InformationCell";
static  NSString * const RESULT_HEADER = @"ResultHeader";
static  NSString * const FOOTER = @"Footer";

@interface BATInfoSearchListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,BATDoctorCollectionViewCellDelegate>
@property (nonatomic,strong) BATSearchWithTypeModel *searchModel;
@property (nonatomic,copy) NSArray *typeArray;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) NSInteger contentOffsets;
@property (nonatomic,strong) UIButton *scrollBtn;
@property (nonatomic,strong) NSString *tempKey;
//默认图
@property (nonatomic,strong) BATDefaultView *defaultView;
@end

@implementation BATInfoSearchListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看更多";
    self.typeArray = @[@"",@"disease_info",@"symptom_info",@"drug_info",@"hospital_info",@"beadhouse_info",@"doctor_info",@"news_info"];
    self.dataArray = [NSMutableArray array];
    [self pagesLayout];
    //   [self.searchCollectionView.mj_header beginRefreshing];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataAction:) name:@"ROADTODESTION3" object:nil];
    
    [self controllerBtn];
}

- (void)setKey:(NSString *)key {
    
    _key = key;
    if (![key isEqualToString:self.tempKey]) {
        [self.searchCollectionView.mj_header beginRefreshing];
    }
    self.tempKey = key;
}

- (void)reloadDataAction:(NSNotification *)sender {
    
    BATSearchSimpleModel *model = (BATSearchSimpleModel *)sender.object;
    self.key = model.key;
    self.lat = model.lat;
    self.lon = model.lon;
    self.type = model.type;
    self.searchUserID = model.searchUserID;
    self.keySourceType = model.keySourceType;
    [self searchRequest];
}

- (void)controllerBtn {
    
    self.scrollBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70, SCREEN_HEIGHT - 70 - 64 - 44, 50, 50)];
    self.scrollBtn.alpha = 0;
    [self.scrollBtn addTarget:self action:@selector(scrollToTop) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollBtn setImage:[UIImage imageNamed:@"ic-zd"] forState:UIControlStateNormal];
    [self.view addSubview:self.scrollBtn];
    
}

- (void)scrollToTop {
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.searchCollectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    switch (self.type) {
        case kSearchAll: {
            
            break;
        }
        case kSearchCondition: {
            
            self.contentOffsets = 40 * 2 + 10;
            break;
        }
        case kSearchSymptom: {
            
            self.contentOffsets = 40 *2 + 10;
            break;
        }
        case kSearchTreatment: {
            
            self.contentOffsets = 100 * 2;
            break;
        }
        case kSearchHospital: {
            
            self.contentOffsets = 110 * 2;
            break;
        }
        case kSearchGeracomium: {
            
            self.contentOffsets = 110 * 2;
            break;
        }
        case kSearchDoctor: {
            
            self.contentOffsets = 87 * 2;
            break;
        }
        case kSearchInformation: {
            
            self.contentOffsets = 84 * 2;
            break;
        }
    }
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    if (currentOffset > self.contentOffsets) {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollBtn.alpha = 1;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.scrollBtn.alpha = 0;
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionDataSource && UICollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchWithTypeContent *searchContent = self.dataArray[indexPath.row];
    switch (self.type) {
            
        case kSearchAll: {
            
            break;
        }
        case kSearchCondition: {
            
            //疾病
            BATConditionCollectionViewCell * conditionCell = [collectionView dequeueReusableCellWithReuseIdentifier:CONDITION_CELL forIndexPath:indexPath];
            conditionCell.nameLabel.text = searchContent.resultTitle;
            return conditionCell;
            
            break;
        }
        case kSearchSymptom: {
            
            //症状
            BATConditionCollectionViewCell * conditionCell = [collectionView dequeueReusableCellWithReuseIdentifier:CONDITION_CELL forIndexPath:indexPath];
            conditionCell.nameLabel.text = searchContent.resultTitle;
            return conditionCell;
            
            break;
        }
        case kSearchTreatment: {
            
            //药
            BATTreatmentCollectionViewCell * treatmentCell = [collectionView dequeueReusableCellWithReuseIdentifier:TREATMENT_CELL forIndexPath:indexPath];
            [treatmentCell.treatmentImageView sd_setImageWithURL:[NSURL URLWithString:searchContent.pictureUrl] placeholderImage:[UIImage imageNamed:@"默认图"]];
            treatmentCell.nameLabel.text = searchContent.resultTitle;
            treatmentCell.facturerLbel.text = searchContent.manufactorName;
            return treatmentCell;
            
            break;
        }
        case kSearchHospital: {
            
            //医院
            BATHospitalCollectionViewCell * hospitalCell = [collectionView dequeueReusableCellWithReuseIdentifier:HOSPITAL_CELL forIndexPath:indexPath];
            [hospitalCell.hospitalImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.pictureUrl]] placeholderImage:[UIImage imageNamed:@"默认图"]];
            NSDictionary * nameAttDic = @{NSForegroundColorAttributeName:UIColorFromHEX(0x333333, 1),NSFontAttributeName:[UIFont systemFontOfSize:16]};
            NSDictionary * gradeAttDic = @{NSForegroundColorAttributeName:UIColorFromHEX(0xfc9f26, 1),NSFontAttributeName:[UIFont systemFontOfSize:8]};
            NSMutableAttributedString * name = [[NSMutableAttributedString alloc] initWithString:searchContent.resultTitle attributes:nameAttDic];
            
            NSInteger level = [searchContent.hospitalLevel integerValue];
            NSString *levelName = nil;
            switch (level) {
                case 1:
                    levelName = @"特等医院";
                    break;
                case 2:
                    levelName = @"三级甲等";
                    break;
                case 3:
                    levelName = @"三级乙等";
                    break;
                case 4:
                    levelName = @"三级丙等";
                    break;
                case 5:
                    levelName = @"二级甲等";
                    break;
                case 6:
                    levelName = @"二级乙等";
                    break;
                case 7:
                    levelName = @"二级丙等";
                    break;
                case 8:
                    levelName = @"一级甲等";
                    break;
                case 9:
                    levelName = @"一级乙等";
                    break;
                case 10:
                    levelName = @"一级丙等";
                    break;
                case 11:
                    levelName = @"其他";
                    break;
                default:
                    break;
            }
            if (searchContent.hospitalLevel.length > 0) {
                NSMutableAttributedString * grade = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]",levelName] attributes:gradeAttDic];
                [name appendAttributedString:grade];
            }
            hospitalCell.nameLabel.attributedText = name;
            hospitalCell.titleAddressLabel.text = [NSString stringWithFormat:@"地址:  %@",searchContent.address];
            hospitalCell.titlePhoneLabel.text = [NSString stringWithFormat:@"电话:  %@",[searchContent.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            return hospitalCell;
            break;
        }
        case kSearchGeracomium: {
            
            //养老院
            BATHospitalCollectionViewCell * hospitalCell = [collectionView dequeueReusableCellWithReuseIdentifier:HOSPITAL_CELL forIndexPath:indexPath];
            [hospitalCell.hospitalImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.pictureUrl]] placeholderImage:[UIImage imageNamed:@"默认图"]];
            NSDictionary * nameAttDic = @{NSForegroundColorAttributeName:UIColorFromHEX(0x333333, 1),NSFontAttributeName:[UIFont systemFontOfSize:16]};
            NSMutableAttributedString * name = [[NSMutableAttributedString alloc] initWithString:searchContent.resultTitle attributes:nameAttDic];
            
            hospitalCell.nameLabel.attributedText = name;
            hospitalCell.titleAddressLabel.text = [NSString stringWithFormat:@"地址:  %@",searchContent.addressArea];
            if ([searchContent.telPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
                hospitalCell.titlePhoneLabel.text = @"电话:  暂无电话";
            }else {
                hospitalCell.titlePhoneLabel.text = [NSString stringWithFormat:@"电话:  %@",[searchContent.telPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            }
            return hospitalCell;
            break;
        }
        case kSearchDoctor: {
            
            //医生
            BATDoctorCollectionViewCell * doctorCell = [collectionView dequeueReusableCellWithReuseIdentifier:DOCTOR_CELL forIndexPath:indexPath];
            doctorCell.indexPath = indexPath;
            doctorCell.delegate = self;
            if ([searchContent.titleName isEqualToString:@""]||searchContent.titleName == nil) {
                doctorCell.nameLabel.text = searchContent.resultTitle;
            }else {
                doctorCell.nameLabel.text = [NSString stringWithFormat:@"%@[%@]",searchContent.resultTitle,searchContent.titleName];
            }
            //            NSString *holderName = nil;
            //            if ([searchContent.sex isEqualToString:@"男"]) {
            //                holderName = @"img-nys";
            //            }else {
            //                holderName = @"img-ysv";
            //            }
            
            if (searchContent.dataType == 0) {
                doctorCell.tipsLb.hidden = NO;
            }else {
                doctorCell.tipsLb.hidden = YES;
            }
            
            
            [doctorCell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.pictureUrl]] placeholderImage:[UIImage imageNamed:@"医生"]];
            doctorCell.departmentLabel.text = searchContent.deptName;
            if ([searchContent.resultDesc isEqualToString:@""]||searchContent.resultDesc == nil) {
                doctorCell.skilfulLabel.text = @"简介:暂无信息";
            }else {
                doctorCell.skilfulLabel.text = [NSString stringWithFormat:@"简介:%@",[searchContent.resultDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            }
            return doctorCell;
            break;
        }
        case kSearchInformation: {
            
            //资讯
            BATInformationCollectionViewCell * informationCell = [collectionView dequeueReusableCellWithReuseIdentifier:INFORMATION_CELL forIndexPath:indexPath];
            [informationCell.inforImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.mainImage]] placeholderImage:[UIImage imageNamed:@"默认图"]];
            informationCell.nameLabel.text = searchContent.resultTitle;
            informationCell.descriptionLabel.text = searchContent.resultDesc;
            return informationCell;
            break;
        }
    }
    return nil;
}

//每个item 的视图的宽高  只有宽高，没有frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    SearchWithTypeContent *searchContent = self.dataArray[indexPath.row];
    switch (self.type) {
        case kSearchAll: {
            
            break;
        }
        case kSearchCondition: {
            
            CGSize textSize = [searchContent.resultTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            CGFloat height = textSize.height + 20 > 40 ? textSize.height + 20 : 40;
            size = CGSizeMake(SCREEN_WIDTH-20, height);
            break;
        }
        case kSearchSymptom: {
            
            CGSize textSize = [searchContent.resultTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            CGFloat height = textSize.height + 20 > 40 ? textSize.height + 20 : 40;
            size = CGSizeMake(SCREEN_WIDTH-20, height);
            break;
        }
        case kSearchTreatment: {
            
            size = CGSizeMake(SCREEN_WIDTH, 100);
            break;
        }
        case kSearchHospital: {
            
            size = CGSizeMake(SCREEN_WIDTH, 110);
            break;
        }
        case kSearchGeracomium: {
            
            size = CGSizeMake(SCREEN_WIDTH, 110);
            break;
        }
        case kSearchDoctor: {
            
            size = CGSizeMake(SCREEN_WIDTH, 87);
            break;
        }
        case kSearchInformation: {
            
            size = CGSizeMake(SCREEN_WIDTH, 84);
            break;
        }
    }
    
    return size;
}

//上下间距 每个section items上下行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.type == kSearchCondition || self.type == kSearchSymptom) {
        return 10;
    }
    return 1;
}
//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets edge = UIEdgeInsetsZero;
    if (self.type == kSearchCondition || self.type == kSearchSymptom) {
        edge = UIEdgeInsetsMake(10, 10, 0, 10);
    }
    return edge;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchWithTypeContent *searchContent  = self.dataArray[indexPath.row];
    switch (self.type) {
        case kSearchAll: {
            break;
        }
        case kSearchCondition: {
            BATSearchDieaseDetailController *searchDieaseCtl = [[BATSearchDieaseDetailController alloc]init];
            searchDieaseCtl.titleName = @"疾病百科";
            searchDieaseCtl.DieaseID = [searchContent.resultId intValue];
            searchDieaseCtl.EntryCNName = searchContent.resultTitle;
            searchDieaseCtl.resultDesc = searchContent.resultDesc;
            [self.navigationController pushViewController:searchDieaseCtl animated:YES];
            break;
        }
        case kSearchSymptom: {
            BATSearchDieaseDetailController *searchDieaseCtl = [[BATSearchDieaseDetailController alloc]init];
            searchDieaseCtl.titleName = @"症状百科";
            searchDieaseCtl.DieaseID = [searchContent.resultId intValue];
            searchDieaseCtl.EntryCNName = searchContent.resultTitle;
            searchDieaseCtl.resultDesc = searchContent.resultDesc;
            [self.navigationController pushViewController:searchDieaseCtl animated:YES];
            break;
        }
        case kSearchTreatment: {
            BATDrugInfoDetailViewController *drugVC = [[BATDrugInfoDetailViewController alloc] init];
            drugVC.drugID = searchContent.resultId;
            drugVC.drugTitle = searchContent.resultTitle;
            [self.navigationController pushViewController:drugVC animated:YES];
            break;
        }
        case kSearchHospital: {
            BATNewHospitalInfoViewController *hospitalVC = [[BATNewHospitalInfoViewController alloc] init];
            hospitalVC.HospitailID = searchContent.resultId;
            hospitalVC.HospitailTitle = searchContent.resultTitle;
            [self.navigationController pushViewController:hospitalVC animated:YES];
            break;
        }
        case kSearchGeracomium: {
            BATGeracomiumController *geracomiumVC = [[BATGeracomiumController alloc]init];
            geracomiumVC.gerID = searchContent.resultId;
            geracomiumVC.titleName = searchContent.resultTitle;
            [self.navigationController pushViewController:geracomiumVC animated:YES];
            break;
        }
        case kSearchDoctor: {
            
            switch (searchContent.dataType) {
                case 0:{
                    //0 网络医院
                    BATNewConsultionDoctorDetailViewController *doctorDetailVC = [[BATNewConsultionDoctorDetailViewController alloc] init];
                    doctorDetailVC.hidesBottomBarWhenPushed = YES;
                    doctorDetailVC.doctorID = searchContent.resultId;
                    doctorDetailVC.pathName = searchContent.resultTitle;
                    [self.navigationController pushViewController:doctorDetailVC animated:YES];
                }
                    break;
                case 1:{
                    //1 160的医生
                    BATConsultationDoctorDetailViewController *doctorDetailCtl = [[BATConsultationDoctorDetailViewController alloc]init];
                    doctorDetailCtl.doctorID = searchContent.resultId;
                    doctorDetailCtl.pathName = searchContent.resultTitle;;
                    doctorDetailCtl.isKMDoctor = NO;
                    [self.navigationController pushViewController:doctorDetailCtl animated:YES];
                }
                    break;
                default:
                    break;
            }
            break;
        }
        case kSearchInformation: {
            
            if ([searchContent.categoryName isEqualToString:@"康健专题"]) {
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC
                    return;
                }
            }
            
            BATNewsDetailViewController *webView = [[BATNewsDetailViewController alloc]init];
            //                webView.url = [NSURL URLWithString:urlString];
            webView.titleStr = searchContent.resultTitle;
            webView.newsID = searchContent.resultId;
            //            webView.title = searchContent.resultTitle;
            webView.categoryName = searchContent.categoryName;
            webView.categoryId = searchContent.categoryId;
            webView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webView animated:YES];
            
            NSArray *behavourArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"Behavour"];
            NSMutableArray *array = [NSMutableArray arrayWithArray:behavourArray];
            
            [array insertObject:searchContent.category atIndex:0];
            
            if (array.count > 7) {
                [array removeLastObject];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"Behavour"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            break;
        }
    }
}
#pragma mark -Action
//医生Cell头像和名字的点击效果
- (void)moveToDoctorInfoDetailActionWith:(NSIndexPath *)indexPath {
    //   NSLog(@"%zd   %zd",indexPath.section,indexPath.row);
}

#pragma mark - NET
- (void)searchRequest {
    
    //获取ip
    NSString *ipString = [Tools get4GorWIFIAddress];
    if (ipString == nil) {
        ipString = @"";
    }
    
    
    if (!_isNewAPI) {
        //类型搜索
        [HTTPTool requestWithSearchURLString:@"/elasticsearch/commonsearch/advancedquerywithtypes"
                                  parameters:@{
                                               @"keyword":self.key,
                                               @"devicetype":@"ios",
                                               @"lat":@(self.lat),
                                               @"lon":@(self.lon),
                                               @"types":self.typeArray[self.type],
                                               @"page":@(self.currentPage),
                                               @"userIp":ipString,
                                               @"userDeviceId":[self getPostUUID],
                                               @"searchUserId":self.searchUserID,
                                               @"keywordSource":@(self.keySourceType),
                                               }
                                     success:^(id responseObject) {
                                         
                                         _searchCollectionView.mj_footer.hidden = NO;
                                         [self.searchCollectionView.mj_header endRefreshing];
                                         [self.searchCollectionView.mj_footer endRefreshing];
                                         
                                         BATSearchWithTypeModel *searchWithTypeModel = [BATSearchWithTypeModel mj_objectWithKeyValues:responseObject];
                                         if (self.currentPage == 0) {
                                             
                                             [self.dataArray removeAllObjects];
                                         }
                                         
                                         [self.dataArray addObjectsFromArray:searchWithTypeModel.resultData.content];
                                         if (self.dataArray.count >= searchWithTypeModel.resultData.totalElements) {
                                             
                                             [self.searchCollectionView.mj_footer endRefreshingWithNoMoreData];
                                         }
                                         
                                         if (self.dataArray.count == 0) {
                                             self.defaultView.hidden = NO;
                                         }else {
                                             self.defaultView.hidden = YES;
                                         }
                                         
                                         if (searchWithTypeModel.resultData.totalElements == 0) {
                                             
                                             //没有数据
                                             self.searchCollectionView.mj_footer.hidden = YES;
                                         }
                                         
                                         [self.searchCollectionView reloadData];
                                     } failure:^(NSError *error) {
                                         self.currentPage --;
                                         [self.searchCollectionView.mj_header endRefreshing];
                                         [self.searchCollectionView.mj_footer endRefreshing];
                                     }];
    }else {
        
        
        [HTTPTool requestWithSearchURLString:@"/elasticsearch/searchapp/searchByDiseaseAndSymptom"
                                  parameters:@{
                                               @"keyword":self.key,
                                               @"devicetype":@"ios",
                                               @"lat":@(self.lat),
                                               @"lon":@(self.lon),
                                               @"types":self.searchType,
                                               @"page":@(self.currentPage),
                                               @"pageSize":@(10),
                                               @"doctorSource":@(self.doctorType)
                                               }
                                     success:^(id responseObject) {
                                         
                                         _searchCollectionView.mj_footer.hidden = NO;
                                         [self.searchCollectionView.mj_header endRefreshing];
                                         [self.searchCollectionView.mj_footer endRefreshing];
                                         
                                         BATSearchWithTypeModel *searchWithTypeModel = [BATSearchWithTypeModel mj_objectWithKeyValues:responseObject];
                                         if (self.currentPage == 0) {
                                             
                                             [self.dataArray removeAllObjects];
                                         }
                                         
                                         [self.dataArray addObjectsFromArray:searchWithTypeModel.resultData.content];
                                         if (self.dataArray.count >= searchWithTypeModel.resultData.totalElements) {
                                             
                                             [self.searchCollectionView.mj_footer endRefreshingWithNoMoreData];
                                         }
                                         
                                         if (searchWithTypeModel.resultData.totalElements == 0) {
                                             
                                             //没有数据
                                             self.searchCollectionView.mj_footer.hidden = YES;
                                         }
                                         
                                         [self.searchCollectionView reloadData];
                                     } failure:^(NSError *error) {
                                         self.currentPage --;
                                         [self.searchCollectionView.mj_header endRefreshing];
                                         [self.searchCollectionView.mj_footer endRefreshing];
                                     }];
        
    }
    
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        BOOL netState = [Tools checkNetWorkIsOk];
        [_defaultView changeDefaultStyleOfShowReloadButtonForNoNet:!netState andRequsetStateError:YES];
        _defaultView.reloadButton.hidden = YES;
    }
    return _defaultView;
}


#pragma mark - layout
- (void)pagesLayout {
    [self.view addSubview:self.searchCollectionView];
    
    WEAK_SELF(self);
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - setter && getter
- (UICollectionView *)searchCollectionView {
    if (!_searchCollectionView) {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        _searchCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64 - 45) collectionViewLayout:flow];
        _searchCollectionView.backgroundColor = [UIColor clearColor];
        _searchCollectionView.delegate = self;
        _searchCollectionView.dataSource = self;
        _searchCollectionView.showsVerticalScrollIndicator = NO;
        _searchCollectionView.alwaysBounceVertical = YES;
        _searchCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [_searchCollectionView registerClass:[BATConditionCollectionViewCell class] forCellWithReuseIdentifier:CONDITION_CELL];
        [_searchCollectionView registerClass:[BATTreatmentCollectionViewCell class] forCellWithReuseIdentifier:TREATMENT_CELL];
        [_searchCollectionView registerClass:[BATHospitalCollectionViewCell class] forCellWithReuseIdentifier:HOSPITAL_CELL];
        [_searchCollectionView registerClass:[BATDoctorCollectionViewCell class] forCellWithReuseIdentifier:DOCTOR_CELL];
        [_searchCollectionView registerClass:[BATInformationCollectionViewCell class] forCellWithReuseIdentifier:INFORMATION_CELL];
        
        WEAK_SELF(self);
        _searchCollectionView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self.searchCollectionView.mj_footer resetNoMoreData];
            [self searchRequest];
        }];
        
        _searchCollectionView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self searchRequest];
        }];
        
        _searchCollectionView.mj_footer.hidden = YES;
        
    }
    return _searchCollectionView;
}


//获取UUID
- (NSString *)getPostUUID {
    //保存UUID
    NSError *uuidError;
    NSString * uuidString = [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:ServiceName error:&uuidError];
    if (!uuidString) {
        BOOL saved = [SFHFKeychainUtils storeUsername:@"UUID" andPassword:[Tools getUUID] forServiceName:ServiceName updateExisting:YES error:&uuidError];
        if (!saved) {
            DDLogDebug(@"获取UUID失败");
        }
        uuidString = [SFHFKeychainUtils getPasswordForUsername:@"UUID" andServiceName:ServiceName error:&uuidError];
    }
    return uuidString;
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
