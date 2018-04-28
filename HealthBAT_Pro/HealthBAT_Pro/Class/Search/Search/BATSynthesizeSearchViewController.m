//
//  SearchViewController.m
//  HealthBAT
//
//  Created by 梁寒冰 on 16/3/9.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSynthesizeSearchViewController.h"
//第三方
#import "UIScrollView+EmptyDataSet.h"
#import "YCXMenu.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "SFHFKeychainUtils.h"
//子视图
#import "BATTopSearchView.h"
#import "BATHotKeyCollectionViewCell.h"
#import "BATSearchHistoryCollectionViewCell.h"
#import "BATConditionCollectionViewCell.h"
#import "BATTreatmentCollectionViewCell.h"
#import "BATHospitalCollectionViewCell.h"
#import "BATDoctorCollectionViewCell.h"
#import "BATInformationCollectionViewCell.h"
#import "BATRelateWordCollectionViewCell.h"
#import "BATSearchHeaderCollectionReusableView.h"
#import "BATResultHeaderCollectionReusableView.h"
#import "BATSearchDieaseDetailController.h"
//model
#import "BATSearchResultModel.h"
#import "BATSearchWithTypeModel.h"
#import "BATRelateWordModel.h"
#import "BATHotKeyModel.h"
#import "BATPerson.h"
#import "BATSearchSimpleModel.h"
//跳转页面
#import "BATHomeMallViewController.h"
#import "BATDrugInfoDetailViewController.h"
#import "BATDieaseDetailController.h"
#import "BATSearchListViewController.h"
#import "BATHealthAssessmentViewController.h"
//#import "BATHospitailInfoDetailViewController.h"
#import "BATNewHospitalInfoViewController.h"
#import "BATNewsDetailViewController.h"
#import "BATConsultationDoctorDetailViewController.h"
#import "BATNewConsultionDoctorDetailViewController.h"
#import "BATGeracomiumController.h"
#import "BATDieaseSymptomDetailController.h"
//获取ip头文件
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>

#import "UINavigationController+FDFullscreenPopGesture.h"

#import "LLSegmentBarVC.h"

static  NSString * const HOT_KEY_CELL = @"HotKeyCell";
static  NSString * const SEARCH_HISTORY_CELL = @"SearchHistoryCell";
static  NSString * const CONDITION_CELL = @"ConditionCell";
static  NSString * const TREATMENT_CELL = @"TreatmentCell";
static  NSString * const HOSPITAL_CELL = @"HospitalCell";
static  NSString * const DOCTOR_CELL = @"DoctorCell";
static  NSString * const INFORMATION_CELL = @"InformationCell";
static  NSString * const RELATE_CELL = @"RelateCell";

static  NSString * const SEARCH_HEADER = @"SearchHeader";
static  NSString * const RESULT_HEADER = @"ResultHeader";
static  NSString * const FOOTER = @"Footer";
static  NSString * const SEARCH_HISTORY = @"SearchHistory";


@interface BATSynthesizeSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,BATDoctorCollectionViewCellDelegate>

@property (nonatomic,strong) BATTopSearchView *topView;

@property (nonatomic,assign) kSearchType type;
@property (nonatomic,strong) NSArray *typeArray;
@property (nonatomic,strong) NSString *key;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL isSlider;
//搜索结果展示数据源

@property (nonatomic,strong) BATRelateWordModel *relateWordModel;
@property (nonatomic,strong) NSMutableArray *searchWithTypeDaraArray;
//搜索热门词汇数据源
@property (nonatomic,strong) BATHotKeyModel *hotKeyModel;
//定位经纬度
@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,assign) double lat;
@property (nonatomic,assign) double lon;
//关键字来源
@property (nonatomic,assign) NSInteger keywordSource;
@property (nonatomic,assign) BOOL isClikc;
@property (nonatomic,strong) NSString *recordWord;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATSynthesizeSearchViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"搜索";
    self.typeArray = @[@"",@"disease_info",@"symptom_info",@"drug_info",@"hospital_info",@"beadhouse_info",@"doctor_info",@"news_info"];
    self.type = kSearchAll;
    self.currentPage = 0;
    self.isSlider = YES;
    self.searchWithTypeDaraArray = [NSMutableArray array];
    [self pagesLayout];
   // [self hotKeyRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLatAanLon:) name:@"USERLOCATION_INFO" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSythnesize:) name:@"SYNTHESIZE_INFO" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BEGIN_GET_LOCATION" object:nil];
    
//    BATSearchResultModel
}

- (void)getSythnesize:(NSNotification *)object {


    BATSearchResultModel *model = (BATSearchResultModel *)object.object;
    self.searchResultModel = model;
    [self.searchCollectionView reloadData];
    NSLog(@"%@",model);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
   // [TalkingData trackPageBegin:@"搜索"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    //    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
    
   // [TalkingData trackPageEnd:@"搜索"];
}

#pragma mark - UICollectionDataSource && UICollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    //4种情况，下同
    if (self.searchResultModel) {
        //全文搜索界面
        return 7;
    }
    
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.searchResultModel) {
        SearchResultdata *searchResult = self.searchResultModel.resultData[section];
        return searchResult.content.count;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchResultModel) {
        
        SearchResultdata *searchResultData = self.searchResultModel.resultData[indexPath.section];
        SearchContent *searchContent = searchResultData.content[indexPath.row];
        
        switch (indexPath.section) {
            case 0:
            {
                //疾病
                BATConditionCollectionViewCell * conditionCell = [collectionView dequeueReusableCellWithReuseIdentifier:CONDITION_CELL forIndexPath:indexPath];
                conditionCell.nameLabel.text = searchContent.resultTitle;
                return conditionCell;
            }
                break;
            case 1:
            {
                //病症
                BATConditionCollectionViewCell * conditionCell = [collectionView dequeueReusableCellWithReuseIdentifier:CONDITION_CELL forIndexPath:indexPath];
                conditionCell.nameLabel.text = searchContent.resultTitle;
                return conditionCell;
            }
                break;
            case 2:
            {
                //药
                BATTreatmentCollectionViewCell * treatmentCell = [collectionView dequeueReusableCellWithReuseIdentifier:TREATMENT_CELL forIndexPath:indexPath];
                [treatmentCell.treatmentImageView sd_setImageWithURL:[NSURL URLWithString:searchContent.pictureUrl] placeholderImage:[UIImage imageNamed:@"默认图"]];
                treatmentCell.nameLabel.text = searchContent.resultTitle;
                if ([searchContent.price isEqualToString:@""]) {
                    treatmentCell.facturerLbel.text = @"暂无";
                }else {
                    treatmentCell.facturerLbel.text = [NSString stringWithFormat:@"¥ %@",searchContent.price];
                }
                
                return treatmentCell;
            }
                break;
            case 3:
            {
                
                //医院
                BATHospitalCollectionViewCell * hospitalCell = [collectionView dequeueReusableCellWithReuseIdentifier:HOSPITAL_CELL forIndexPath:indexPath];
                [hospitalCell.hospitalImageView sd_setImageWithURL:[NSURL URLWithString:searchContent.pictureUrl] placeholderImage:[UIImage imageNamed:@"默认图"]];
                NSDictionary * nameAttDic = @{NSForegroundColorAttributeName:UIColorFromHEX(0x333333, 1),NSFontAttributeName:[UIFont systemFontOfSize:15]};
                NSDictionary * gradeAttDic = @{NSForegroundColorAttributeName:UIColorFromHEX(0xfc9f26, 1),NSFontAttributeName:[UIFont systemFontOfSize:9]};
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
                
                if (searchContent.resultTitle.length > 0) {
                    NSMutableAttributedString * grade = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]",levelName] attributes:gradeAttDic];
                    [name appendAttributedString:grade];
                }
                hospitalCell.nameLabel.attributedText = name;
                //                hospitalCell.addressLabel.text = searchContent.address;
                hospitalCell.titleAddressLabel.text = [NSString stringWithFormat:@"地址:  %@",searchContent.address];
                hospitalCell.titlePhoneLabel.text = [NSString stringWithFormat:@"电话:  %@",[searchContent.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                return hospitalCell;
            }
                break;
            case 4:
            {
                
                //养老院
                BATHospitalCollectionViewCell * hospitalCell = [collectionView dequeueReusableCellWithReuseIdentifier:HOSPITAL_CELL forIndexPath:indexPath];
                [hospitalCell.hospitalImageView sd_setImageWithURL:[NSURL URLWithString:searchContent.pictureUrl] placeholderImage:[UIImage imageNamed:@"默认图"]];
                NSDictionary * nameAttDic = @{NSForegroundColorAttributeName:UIColorFromHEX(0x333333, 1),NSFontAttributeName:[UIFont systemFontOfSize:15]};
                NSMutableAttributedString * name = [[NSMutableAttributedString alloc] initWithString:searchContent.resultTitle attributes:nameAttDic];
                
                hospitalCell.nameLabel.attributedText = name;
                //                hospitalCell.addressLabel.text = searchContent.addressArea;
                hospitalCell.titleAddressLabel.text = [NSString stringWithFormat:@"地址:  %@",searchContent.addressArea];
                if ([searchContent.telPhone isEqualToString:@" "]) {
                    hospitalCell.titlePhoneLabel.text = @"电话:  暂无电话";
                }else {
                    hospitalCell.titlePhoneLabel.text = [NSString stringWithFormat:@"电话:  %@",[searchContent.telPhone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                }
                return hospitalCell;
            }
                break;
            case 5:
            {
                
                //医生
                BATDoctorCollectionViewCell * doctorCell = [collectionView dequeueReusableCellWithReuseIdentifier:DOCTOR_CELL forIndexPath:indexPath];
                doctorCell.indexPath = indexPath;
                doctorCell.delegate = self;
                if ([searchContent.titleName isEqualToString:@""]||searchContent.titleName == nil) {
                    doctorCell.nameLabel.text = searchContent.resultTitle;
                }else {
                    doctorCell.nameLabel.text = [NSString stringWithFormat:@"%@[%@]",searchContent.resultTitle,searchContent.titleName];
                }
                //                NSString *holderName = nil;
                //                if ([searchContent.sex isEqualToString:@"男"]) {
                //                    holderName = @"img-nys";
                //                }else {
                //                    holderName = @"img-ysv";
                //                }
                
                if (searchContent.dataType == 0) {
                    doctorCell.tipsLb.hidden = NO;
                }else {
                    doctorCell.tipsLb.hidden = YES;
                }
                
                [doctorCell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:searchContent.pictureUrl]placeholderImage:[UIImage imageNamed:@"医生"]];
                doctorCell.departmentLabel.text = searchContent.deptName;
                if ([searchContent.resultDesc isEqualToString:@""]||searchContent.resultDesc == nil) {
                    doctorCell.skilfulLabel.text = @"简介:暂无信息";
                }else {
                    doctorCell.skilfulLabel.text = [NSString stringWithFormat:@"简介:%@",[searchContent.resultDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                }
                return doctorCell;
            }
                break;
            case 6:
            {
                
                //资讯
                BATInformationCollectionViewCell * informationCell = [collectionView dequeueReusableCellWithReuseIdentifier:INFORMATION_CELL forIndexPath:indexPath];
                [informationCell.inforImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.mainImage]] placeholderImage:[UIImage imageNamed:@"默认图"]];
                informationCell.nameLabel.text = searchContent.resultTitle;
                informationCell.descriptionLabel.text = [searchContent.resultDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                return informationCell;
            }
                break;
        }
    }
    return nil;
}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    //footer
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOOTER forIndexPath:indexPath];
        footer.backgroundColor = BASE_BACKGROUND_COLOR;
        return footer;
    }

    
    if (self.searchResultModel) {
        if (kind == UICollectionElementKindSectionHeader) {
            BATResultHeaderCollectionReusableView * resultHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:RESULT_HEADER forIndexPath:indexPath];
            
            SearchResultdata *searchResult = self.searchResultModel.resultData[indexPath.section];
            
            
            resultHeader.moreButton.hidden = searchResult.totalElements<=3;
            
            
            
            switch (indexPath.section) {
                case 0:
                {
                    resultHeader.titleLabel.text = @"疾病百科";
                    resultHeader.type = kSearchCondition;
                    resultHeader.subTitleLabel.text = searchResult.totalElements>3?[NSString stringWithFormat:@"(%zd)",searchResult.totalElements]:@"";
                    
                }
                    break;
                case 1:
                {
                    resultHeader.titleLabel.text = @"症状百科";
                    resultHeader.type = kSearchSymptom;
                    resultHeader.subTitleLabel.text = searchResult.totalElements>3?[NSString stringWithFormat:@"(%zd)",searchResult.totalElements]:@"";
                }
                    break;
                case 2:
                {
                    resultHeader.titleLabel.text = @"药品百科";
                    resultHeader.type = kSearchTreatment;
                    resultHeader.subTitleLabel.text = searchResult.totalElements>3?[NSString stringWithFormat:@"(%zd)",searchResult.totalElements]:@"";
                }
                    break;
                case 3:
                {
                    resultHeader.moreButton.hidden = NO;
                    NSInteger count = 0;
                    if (searchResult.totalElements<=3) {
                        count = 20;
                    }else {
                        count = searchResult.totalElements;
                    }
                    resultHeader.titleLabel.text = @"相关医院";
                    resultHeader.type = kSearchHospital;
                    resultHeader.subTitleLabel.text = searchResult.totalElements>3?[NSString stringWithFormat:@"(%zd)",searchResult.totalElements]:@"";
                }
                    break;
                case 4:
                {
                    resultHeader.titleLabel.text =@"相关养老院";
                    resultHeader.type = kSearchGeracomium;
                    resultHeader.subTitleLabel.text = searchResult.totalElements>3?[NSString stringWithFormat:@"(%zd)",searchResult.totalElements]:@"";
                }
                    break;
                case 5:
                {
                    resultHeader.moreButton.hidden = NO;
                    NSInteger count = 0;
                    if (searchResult.totalElements<=3) {
                        count = 20;
                    }else {
                        count = searchResult.totalElements;
                    }
                    
                    resultHeader.titleLabel.text = @"医生推荐";
                    resultHeader.type = kSearchDoctor;
                    resultHeader.subTitleLabel.text = searchResult.totalElements>3?[NSString stringWithFormat:@"(%zd)",searchResult.totalElements]:@"";
                }
                    break;
                case 6:
                {
                    resultHeader.titleLabel.text = @"相关资讯";
                    resultHeader.type = kSearchInformation;
                    resultHeader.subTitleLabel.text = searchResult.totalElements>3?[NSString stringWithFormat:@"(%zd)",searchResult.totalElements]:@"";
                    
                }
                    break;
                default:
                    break;
            }
            WEAK_SELF(self);
            [resultHeader setMoreBlock:^(NSString * title, kSearchType type) {
                
                STRONG_SELF(self);
                [self showMoreWithTitle:title Type:type];
            }];
            
            return resultHeader;
        }
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    CGSize size = CGSizeZero;
    //默认情况
    
    if (self.searchResultModel) {
        switch (section) {
            case 0:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 40);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 1:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 40);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 2:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 40);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 3:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 40);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 4:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 40);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 5:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 40);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 6:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 40);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            default:
                break;
        }
        //循环数据，如果有一个有值，就跳出
        //        for (SearchResultdata *data in self.searchResultModel.resultData) {
        //            if (data.numberOfElements > 0) {
        //                size = CGSizeMake(SCREEN_WIDTH, 40);
        //                break;
        //            }
        //        }
    }
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    CGSize size = CGSizeZero;
    
    if (self.searchResultModel) {
        
        //循环数据，如果有一个有值，就跳出
        //        for (SearchResultdata *data in self.searchResultModel.resultData) {
        //            if (data.numberOfElements > 0) {
        //                size = CGSizeMake(SCREEN_WIDTH, 10);
        //                break;
        //            }
        //        }
        switch (section) {
            case 0:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 10);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 1:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 10);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 2:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 10);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 3:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 10);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 4:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 10);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 5:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 10);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            case 6:
                if (self.searchResultModel.resultData[section].content.count>0) {
                    size = CGSizeMake(SCREEN_WIDTH, 40);
                    return size;
                }else {
                    return CGSizeMake(SCREEN_WIDTH, 0);
                }
                break;
            default:
                break;
        }
    }
    return size;
}



//每个item 的视图的宽高  只有宽高，没有frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeZero;
    
    if (self.searchResultModel) {
        
        if (indexPath.section == 0) {
            
            //疾病
            SearchResultdata *searchResultData = self.searchResultModel.resultData[indexPath.section];
            SearchContent *searchContent = searchResultData.content[indexPath.row];
            CGSize textSize = [searchContent.resultTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            CGFloat height = textSize.height + 20 > 40 ? textSize.height + 20 : 40;
            size = CGSizeMake(SCREEN_WIDTH-20, height);
            
        }else if (indexPath.section == 1) {
            
            //病症
            SearchResultdata *searchResultData = self.searchResultModel.resultData[indexPath.section];
            SearchContent *searchContent = searchResultData.content[indexPath.row];
            CGSize textSize = [searchContent.resultTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            CGFloat height = textSize.height + 20 > 40 ? textSize.height + 20 : 40;
            size = CGSizeMake(SCREEN_WIDTH-20, height);
        }
        else if (indexPath.section == 2) {
            
            //药
            size = CGSizeMake(SCREEN_WIDTH, 100);
        }
        else if (indexPath.section == 3) {
            
            //医院
            size = CGSizeMake(SCREEN_WIDTH, 110);
        }
        else if (indexPath.section == 4) {
            
            //养老院
            size = CGSizeMake(SCREEN_WIDTH, 110);
        }
        else if (indexPath.section == 5) {
            
            //医生
            size = CGSizeMake(SCREEN_WIDTH, 87);
        }
        else if (indexPath.section == 6) {
            
            //资讯
            size = CGSizeMake(SCREEN_WIDTH, 80);
        }
        return size;
    }
    return size;
}

//上下间距 每个section items上下行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    if (self.searchResultModel) {
        
        if (section == 0 || section == 1) {
            
            //疾病
            return 5;
        }
        return 1;
    }
    
    return CGFLOAT_MIN;
}
//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    UIEdgeInsets edge = UIEdgeInsetsZero;
    
    if (self.searchResultModel) {
        
        if (section == 0) {
            
            //疾病
            if (self.searchResultModel.resultData[0].content.count == 0||self.searchResultModel.resultData[1].content.count == 0) {
                return UIEdgeInsetsMake(0, 0, 0, 0);
            }else {
                return UIEdgeInsetsMake(10, 10, 0, 10);
            }
        }
    }
    
    return edge;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //刷新纪录词
    self.recordWord = self.key;
    
    if (self.searchResultModel) {
        
        //判断是否点击
        self.isClikc = YES;
        
        SearchResultdata *searchResultData = self.searchResultModel.resultData[indexPath.section];
        SearchContent *searchContent = searchResultData.content[indexPath.row];
        //全文搜索
        switch (indexPath.section) {
            case 0:
            {
                //疾病
                BATSearchDieaseDetailController *searchDieaseCtl = [[BATSearchDieaseDetailController alloc]init];
                searchDieaseCtl.resultDesc = searchContent.resultDesc;
                searchDieaseCtl.DieaseID = [searchContent.resultId intValue];
                searchDieaseCtl.EntryCNName = searchContent.resultTitle;
                searchDieaseCtl.pathName = self.key;
                searchDieaseCtl.titleName = @"疾病百科";
                [self.navigationController pushViewController:searchDieaseCtl animated:YES];
                
            }
                break;
            case 1:
            {
                //病症
                BATSearchDieaseDetailController *symptomVC = [[BATSearchDieaseDetailController alloc]init];
                symptomVC.resultDesc = searchContent.resultDesc;
                symptomVC.DieaseID = [searchContent.resultId intValue];
                symptomVC.EntryCNName = searchContent.resultTitle;
                symptomVC.pathName = self.key;
                symptomVC.titleName = @"症状百科";
                [self.navigationController pushViewController:symptomVC animated:YES];
                
            }
                break;
            case 2:
            {
                if ([searchContent.drugSource isEqualToString:@"1"]) {
                    BATHomeMallViewController *homeMallVC = [[BATHomeMallViewController alloc] init];
                    homeMallVC.url = [NSString stringWithFormat:@"http://m.km1818.com/products/%@.html?kmCloud",searchContent.resultId];
                    homeMallVC.title = searchContent.resultTitle;
                    homeMallVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:homeMallVC animated:YES];
                }else {
                    //药品
                    BATDrugInfoDetailViewController *drugVC = [[BATDrugInfoDetailViewController alloc] init];
                    drugVC.drugID = searchContent.resultId;
                    drugVC.drugTitle = searchContent.resultTitle;
                    drugVC.pathName = self.key;
                    [self.navigationController pushViewController:drugVC animated:YES];
                }
               
               
                
            }
                break;
                
            case 3:
            {
                //医院
                BATNewHospitalInfoViewController *hospitalVC = [[BATNewHospitalInfoViewController alloc] init];
                hospitalVC.HospitailID = searchContent.resultId;
                hospitalVC.HospitailTitle = searchContent.resultTitle;
                hospitalVC.pathName = self.key;
                [self.navigationController pushViewController:hospitalVC animated:YES];
            }
                break;
                
            case 4:
            {
                //养老院
                BATGeracomiumController *geracomiumVC = [[BATGeracomiumController alloc]init];
                geracomiumVC.gerID = searchContent.resultId;
                geracomiumVC.titleName = searchContent.resultTitle;
                geracomiumVC.pathName = self.key;
                [self.navigationController pushViewController:geracomiumVC animated:YES];
            }
                break;
                
            case 5:
            {
                
                //医生
                switch (searchContent.dataType) {
                    case 0:{
                        //0 网络医院
                        BATNewConsultionDoctorDetailViewController *doctorDetailVC = [[BATNewConsultionDoctorDetailViewController alloc] init];
                        doctorDetailVC.hidesBottomBarWhenPushed = YES;
                        doctorDetailVC.doctorID = searchContent.resultId;
                        doctorDetailVC.pathName = self.key;
                        [self.navigationController pushViewController:doctorDetailVC animated:YES];
                    }
                        break;
                    case 1:{
                        //1 160的医生
                        BATConsultationDoctorDetailViewController *doctorDetailCtl = [[BATConsultationDoctorDetailViewController alloc]init];
                        doctorDetailCtl.doctorID = searchContent.resultId;
                        doctorDetailCtl.pathName = self.key;
                        doctorDetailCtl.isKMDoctor = NO;
                        [self.navigationController pushViewController:doctorDetailCtl animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
                
            case 6:
            {
                //资讯
                //                NSString *ipString = [[NSUserDefaults standardUserDefaults] objectForKey:@"appdominUrl"];
                //                NSString * urlString = [NSString stringWithFormat:@"%@/App/NewsDetail/%@",ipString,searchContent.resultId];
                if ([searchContent.categoryName isEqualToString:@"康健专题"]) {
                    if (!LOGIN_STATION) {
                        PRESENT_LOGIN_VC
                        return;
                    }
                }
                
                BATNewsDetailViewController *webView = [[BATNewsDetailViewController alloc]init];
                webView.titleStr = searchContent.resultTitle;
                webView.newsID = searchContent.resultId;
                webView.pathName = self.key;
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
            }
                break;
            default:
                break;
        }
        return;
    }
    
    return;
}







#pragma mark - DZNEmptyDataSetSource
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//
//    return -50;
//}
////返回标题文字
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
//
//    if (self.key.length > 0) {
//
//        if (self.relateWordModel && self.relateWordModel.resultData.count == 0) {
//
//            return nil;
//        }
//        NSString *searchKey = self.key;
//        if (self.key.length > 9) {
//
//            searchKey = [NSString stringWithFormat:@"%@...",[self.key substringToIndex:9]];
//        }
//        NSString *text = [NSString stringWithFormat:@"没有搜索到“%@”相关内容",searchKey];
//        NSDictionary *outAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName: UIColorFromHEX(0x666666, 1)};
//        NSDictionary *contentAtributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName: [UIColor redColor]};
//        NSRange range;
//        range.length = searchKey.length;
//        range.location = 6;
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:outAttributes];
//        [string setAttributes:contentAtributes range:range];
//        return string;
//    }
//    return nil;
//}
//
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//
//    if (self.key.length > 0) {
//
//        if (self.relateWordModel && self.relateWordModel.resultData.count == 0) {
//
//            return nil;
//        }
//        return [UIImage imageNamed:@"无搜索"];
//    }
//    return nil;
//}

#pragma mark - action
//搜索医生头像及名字点击效果
- (void)moveToDoctorInfoDetailActionWith:(NSIndexPath *)indexPath {
    //    NSLog(@"%zd   %zd",indexPath.section,indexPath.row);
}
//导航栏－取消按钮
- (void)cancelSearch {
    
    //取消执行的操作：1、有搜索数据：类型不改变，关键词置空，恢复默认界面。2:无搜索数据：返回首页
    
    [self.topView.searchTF resignFirstResponder];//关闭键盘
    self.key = @"";//清空关键词
    if (self.topView.searchTF.text.length == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    
    self.topView.searchTF.text = @"";
    [self.searchCollectionView reloadData];
}

//点击更多
- (void)showMoreWithTitle:(NSString *)title Type:(kSearchType)type {
    
    BATSearchSimpleModel *model = [BATSearchSimpleModel new];
    model.title = title;
    model.type = type;
    model.key = self.searchResultModel.key;
    model.lat = self.lat;
    model.lon = self.lon;
    model.keySourceType = self.keywordSource;
    model.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ROADTODESTION" object:model];
    
    //更改为已操作状态
//    self.isClikc = YES;
//    
//    BATSearchListViewController * searchListVC = [BATSearchListViewController new];
//    searchListVC.title = title;
//    searchListVC.type = type;
//    searchListVC.key = self.searchResultModel.key;
//    searchListVC.lat = self.lat;
//    searchListVC.lon = self.lon;
//    searchListVC.keySourceType = self.keywordSource;
//    searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
//    [self.navigationController pushViewController:searchListVC animated:YES];
}

//键盘弹起
- (void)textFieldShow:(NSNotification *)noti {
    self.isShow = NO;
    [YCXMenu dismissMenu];
}

-(void)isClikcAction {
    [BATUserPortrayTools saveUserBrowseRequestWithURL:@"/kmStatistical-sync/saveUserBrowse" moduleName:@"" moduleId:@"0" beginTime:[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"] browsePage:self.key];
}

-(void)isSearchAction {
    [BATUserPortrayTools saveUserBrowseRequestWithURL:@"/kmStatistical-sync/saveUserBrowse" moduleName:@"" moduleId:@"0" beginTime:[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"] browsePage:self.recordWord];
}

#pragma mark - layout
- (void)pagesLayout {
    [self.view addSubview:self.searchCollectionView];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.titleView = self.topView;
    
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UICollectionView *)searchCollectionView {
    if (!_searchCollectionView) {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        _searchCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64 - 45) collectionViewLayout:flow];
        _searchCollectionView.backgroundColor = [UIColor whiteColor];
        _searchCollectionView.delegate = self;
        _searchCollectionView.dataSource = self;
        _searchCollectionView.showsVerticalScrollIndicator = NO;
        _searchCollectionView.alwaysBounceVertical = YES;
        _searchCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _searchCollectionView.emptyDataSetSource = self;
        _searchCollectionView.emptyDataSetDelegate = self;
        
        [_searchCollectionView registerClass:[BATHotKeyCollectionViewCell class] forCellWithReuseIdentifier:HOT_KEY_CELL];
        [_searchCollectionView registerClass:[BATSearchHistoryCollectionViewCell class] forCellWithReuseIdentifier:SEARCH_HISTORY_CELL];
        
        [_searchCollectionView registerClass:[BATRelateWordCollectionViewCell class] forCellWithReuseIdentifier:RELATE_CELL];
        
        [_searchCollectionView registerClass:[BATConditionCollectionViewCell class] forCellWithReuseIdentifier:CONDITION_CELL];
        [_searchCollectionView registerClass:[BATTreatmentCollectionViewCell class] forCellWithReuseIdentifier:TREATMENT_CELL];
        [_searchCollectionView registerClass:[BATHospitalCollectionViewCell class] forCellWithReuseIdentifier:HOSPITAL_CELL];
        [_searchCollectionView registerClass:[BATDoctorCollectionViewCell class] forCellWithReuseIdentifier:DOCTOR_CELL];
        [_searchCollectionView registerClass:[BATInformationCollectionViewCell class] forCellWithReuseIdentifier:INFORMATION_CELL];
        
        [_searchCollectionView registerClass:[BATSearchHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SEARCH_HEADER];
        [_searchCollectionView registerClass:[BATResultHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:RESULT_HEADER];
        [_searchCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOOTER];
        
    }
    return _searchCollectionView;
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
         //   [self searchResult];
        }];
        
    }
    return _defaultView;
}

- (NSArray *)items {
    if (!_items) {
        _items = @[
                   
                   [YCXMenuItem menuItem:@"全部"
                                   image:nil
                                     tag:100
                                userInfo:@{@"type":@0}],
                   [YCXMenuItem menuItem:@"疾病"
                                   image:nil
                                     tag:102
                                userInfo:@{@"type":@1}],
                   [YCXMenuItem menuItem:@"症状"
                                   image:nil
                                     tag:102
                                userInfo:@{@"type":@2}],
                   [YCXMenuItem menuItem:@"药品"
                                   image:nil
                                     tag:102
                                userInfo:@{@"type":@3}],
                   [YCXMenuItem menuItem:@"医院"
                                   image:nil
                                     tag:102
                                userInfo:@{@"type":@4}],
                   [YCXMenuItem menuItem:@"养老院"
                                   image:nil
                                     tag:102
                                userInfo:@{@"type":@5}],
                   [YCXMenuItem menuItem:@"医生"
                                   image:nil
                                     tag:102
                                userInfo:@{@"type":@6}],
                   [YCXMenuItem menuItem:@"资讯"
                                   image:nil
                                     tag:102
                                userInfo:@{@"type":@7}]
                   ];
    }
    return _items;
}

//获取经纬度
- (void)getLatAanLon:(NSNotification *)sender {
    BMKUserLocation *location = sender.object;
    _lon = location.location.coordinate.longitude;
    _lat = location.location.coordinate.latitude;
}
//获取当前用户id
- (NSString *)getCurrentID {
    BATPerson *model = PERSON_INFO;
    return [NSString stringWithFormat:@"%zd",model.Data.AccountID];
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
@end
