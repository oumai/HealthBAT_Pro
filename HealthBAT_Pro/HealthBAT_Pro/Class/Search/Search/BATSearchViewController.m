//
//  SearchViewController.m
//  HealthBAT
//
//  Created by 梁寒冰 on 16/3/9.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSearchViewController.h"
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
#import "BATSynthesizeSearchViewController.h"
#import "BATSearchDieaseListViewController.h"
#import "BATSearchSymptomListViewController.h"
#import "BATDrugSearchListViewController.h"
#import "BATHosptialSearchListViewController.h"
#import "BATDoctorSearchListViewController.h"
#import "BATInfoSearchListViewController.h"
#import "BATGeracomiumSearchListViewController.h"

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


@interface BATSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,BATDoctorCollectionViewCellDelegate,LLSegmentBarVCDelegate>

@property (nonatomic,strong) BATTopSearchView *topView;
@property (nonatomic,strong) UICollectionView *searchCollectionView;
@property (nonatomic,assign) kSearchType type;
@property (nonatomic,strong) NSArray *typeArray;

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) BOOL isSlider;

@property (nonatomic,copy) NSArray *nameArray;
@property (nonatomic,copy) NSArray *nameArrayNoGeracomium;
@property (nonatomic,strong) BATSynthesizeSearchViewController *synthesizeVC;
@property (nonatomic,strong) BATSearchDieaseListViewController *dieaseListVC;
@property (nonatomic,strong) BATSearchSymptomListViewController *symptomListVC;
@property (nonatomic,strong) BATDrugSearchListViewController *drugListVC;
@property (nonatomic,strong) BATHosptialSearchListViewController *hosptialListVC;
@property (nonatomic,strong) BATGeracomiumSearchListViewController *geracomiumListVC;
@property (nonatomic,strong) BATDoctorSearchListViewController *doctorListVC;
@property (nonatomic,strong) BATInfoSearchListViewController *infoListVC;

//搜索结果展示数据源
@property (nonatomic,strong) BATSearchResultModel *searchResultModel;
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

@property (nonatomic, weak) LLSegmentBarVC *segContentVC;

@property (nonatomic,assign) NSInteger count;

@end

@implementation BATSearchViewController

// lazy init
- (LLSegmentBarVC *)segContentVC{
    if (!_segContentVC) {
        LLSegmentBarVC *contentVC = [[LLSegmentBarVC alloc]init];
        [self addChildViewController:contentVC];
        _segContentVC = contentVC;
        _segContentVC.delegate = self;
    }
    return _segContentVC;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLatAanLon:) name:@"USERLOCATION_INFO" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(roadToDestion:) name:@"ROADTODESTION" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BEGIN_GET_LOCATION" object:nil];
    
    self.lon = [[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] floatValue];
    self.lat = [[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] floatValue];
    
    //  设置控制器V的frame
    self.segContentVC.view.frame = CGRectMake(0, -64, self.view.bounds.size.width, SCREEN_HEIGHT + 64);
    [self.view addSubview:self.segContentVC.view];
    self.nameArray = @[@"综合",@"疾病",@"症状",@"药品",@"医院",@"养老院",@"医生",@"资讯"];
    self.nameArrayNoGeracomium = @[@"综合",@"疾病",@"症状",@"药品",@"医院",@"医生",@"资讯"];
    //创建childVC
    
    self.synthesizeVC = [BATSynthesizeSearchViewController new];
    
    self.dieaseListVC = [BATSearchDieaseListViewController new];
    self.dieaseListVC.type = kSearchCondition;
    
    self.symptomListVC = [BATSearchSymptomListViewController new];
    self.symptomListVC.type = kSearchSymptom;
    
    self.drugListVC = [BATDrugSearchListViewController new];
    self.drugListVC.type = kSearchTreatment;
    
    self.hosptialListVC = [BATHosptialSearchListViewController new];
    self.hosptialListVC.type = kSearchHospital;
    
    self.geracomiumListVC = [BATGeracomiumSearchListViewController new];
    self.geracomiumListVC.type = kSearchGeracomium;
    
    self.doctorListVC = [BATDoctorSearchListViewController new];
    self.doctorListVC.type = kSearchDoctor;
    
    self.infoListVC = [BATInfoSearchListViewController new];
    self.infoListVC.type = kSearchInformation;
    
    //  添加
    [self addSegItemsWithNameArray:self.nameArray];
    
    
    //<------------------------------------------------------------------------------------------------->

    self.title = @"搜索";
    self.typeArray = @[@"",@"disease_info",@"symptom_info",@"drug_info",@"hospital_info",@"beadhouse_info",@"doctor_info",@"news_info"];
    self.type = kSearchAll;
    self.currentPage = 0;
    self.isSlider = YES;
    self.searchWithTypeDaraArray = [NSMutableArray array];
    [self pagesLayout];
    
    if (self.isFromHome) {
        self.topView.searchTF.text = self.key;
        self.searchCollectionView.hidden = YES;
        [self searchResult];
    }
    
   [self hotKeyRequest];
    
    
}

- (void)addSegItemsWithNameArray:(NSArray *)nameArr {
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSMutableArray *titleArrM = [NSMutableArray arrayWithCapacity:10];
    
    for (NSString *title in nameArr) {
        if ([title isEqualToString:@"综合"]) {
            
            [arrM addObject:self.synthesizeVC];
            [titleArrM addObject:title];
            
        }else if ([title isEqualToString:@"疾病"]) {
            
            [arrM addObject:self.dieaseListVC];
            [titleArrM addObject:title];
            
        }else if([title isEqualToString:@"症状"]){
            
            [arrM addObject:self.symptomListVC];
            [titleArrM addObject:title];
            
        } else if([title isEqualToString:@"药品"]){
            
            [arrM addObject:self.drugListVC];
            [titleArrM addObject:title];
            
        }else if([title isEqualToString:@"医院"]){
        
            [arrM addObject:self.hosptialListVC];
            [titleArrM addObject:title];
            
        }else if([title isEqualToString:@"养老院"]){
            
            [arrM addObject:self.geracomiumListVC];
            [titleArrM addObject:title];
            
        }else if([title isEqualToString:@"医生"]){
            
            [arrM addObject:self.doctorListVC];
            [titleArrM addObject:title];
            
        }else if([title isEqualToString:@"资讯"]){
            
            [arrM addObject:self.infoListVC];
            [titleArrM addObject:title];
            
        }
    }
    
    [self.segContentVC setUpWithItems:titleArrM childVCs:arrM];

}

- (void)roadToDestion:(NSNotification *)sender {

    BATSearchSimpleModel *model = (BATSearchSimpleModel *)sender.object;
    self.segContentVC.segmentBar.selectIndex = model.type;
    [self.segContentVC showChildVCViewAtIndex:model.type];
    
    BATSearchDieaseListViewController *searchListVC = self.segContentVC.childViewControllers[model.type];
    searchListVC.title = model.title;
    searchListVC.type = model.type;
    searchListVC.key = model.key;
    searchListVC.lat = model.lat;
    searchListVC.lon = model.lon;
    searchListVC.keySourceType = model.keySourceType;
    searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
    [searchListVC.searchCollectionView.mj_header beginRefreshing];
  
}

- (void)LLSegmentBarVC:(LLSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex {

    NSLog(@"%zd %zd",toIndex,fromIndex);
    UIViewController *selectedVC = self.segContentVC.childViewControllers[toIndex];
    
    if ([selectedVC isKindOfClass:[BATSynthesizeSearchViewController class]]) {


    }
    else if ([selectedVC isKindOfClass:[BATSearchDieaseListViewController class]]) {
        
        BATSearchDieaseListViewController *searchListVC = (BATSearchDieaseListViewController *)selectedVC;
        searchListVC.key = self.key;
        searchListVC.lat = self.lat;
        searchListVC.lon = self.lon;
        searchListVC.keySourceType = 0;
        searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
    }
    else if ([selectedVC isKindOfClass:[BATSearchSymptomListViewController class]]) {
        
        BATSearchSymptomListViewController *searchListVC = (BATSearchSymptomListViewController *)selectedVC;
        searchListVC.key = self.key;
        searchListVC.lat = self.lat;
        searchListVC.lon = self.lon;
        searchListVC.keySourceType = 0;
        searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
    }
    else if ([selectedVC isKindOfClass:[BATDrugSearchListViewController class]]) {
        
        BATDrugSearchListViewController *searchListVC = (BATDrugSearchListViewController *)selectedVC;
        searchListVC.key = self.key;
        searchListVC.lat = self.lat;
        searchListVC.lon = self.lon;
        searchListVC.keySourceType = 0;
        searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
    }
    else if ([selectedVC isKindOfClass:[BATHosptialSearchListViewController class]]) {
        
        BATHosptialSearchListViewController *searchListVC = (BATHosptialSearchListViewController *)selectedVC;
        searchListVC.key = self.key;
        searchListVC.lat = self.lat;
        searchListVC.lon = self.lon;
        searchListVC.keySourceType = 0;
        searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
    }
    else if ([selectedVC isKindOfClass:[BATGeracomiumSearchListViewController class]]) {
        
        BATGeracomiumSearchListViewController *searchListVC = (BATGeracomiumSearchListViewController *)selectedVC;
        searchListVC.key = self.key;
        searchListVC.lat = self.lat;
        searchListVC.lon = self.lon;
        searchListVC.keySourceType = 0;
        searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
    }
    else if ([selectedVC isKindOfClass:[BATDoctorSearchListViewController class]]) {
        
        BATDoctorSearchListViewController *searchListVC = (BATDoctorSearchListViewController *)selectedVC;
        searchListVC.key = self.key;
        searchListVC.lat = self.lat;
        searchListVC.lon = self.lon;
        searchListVC.keySourceType = 0;
        searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
    }
    else if ([selectedVC isKindOfClass:[BATInfoSearchListViewController class]]) {
        
        BATInfoSearchListViewController *searchListVC = (BATInfoSearchListViewController *)selectedVC;
        searchListVC.key = self.key;
        searchListVC.lat = self.lat;
        searchListVC.lon = self.lon;
        searchListVC.keySourceType = 0;
        searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
    }
    /*
    switch (toIndex) {
        case 1: {
            BATSearchDieaseListViewController *searchListVC = self.segContentVC.childViewControllers[1];
            searchListVC.type = toIndex;
            searchListVC.key = self.key;
            searchListVC.lat = self.lat;
            searchListVC.lon = self.lon;
            searchListVC.keySourceType = 0;
            searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
         //   [searchListVC.searchCollectionView.mj_header beginRefreshing];
            break;
        }
        case 2: {
            BATSearchDieaseListViewController *searchListVC = self.segContentVC.childViewControllers[2];
            searchListVC.type = toIndex;
            searchListVC.key = self.key;
            searchListVC.lat = self.lat;
            searchListVC.lon = self.lon;
            searchListVC.keySourceType = 0;
            searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
          //  [searchListVC.searchCollectionView.mj_header beginRefreshing];
            break;
        }
        case 3: {
            BATSearchDieaseListViewController *searchListVC = self.segContentVC.childViewControllers[3];
            searchListVC.type = toIndex;
            searchListVC.key = self.key;
            searchListVC.lat = self.lat;
            searchListVC.lon = self.lon;
            searchListVC.keySourceType = 0;
            searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
          //  [searchListVC.searchCollectionView.mj_header beginRefreshing];
            break;
        }
        case 4: {
            BATHosptialSearchListViewController *searchListVC = self.segContentVC.childViewControllers[4];
            searchListVC.type = toIndex;
            searchListVC.key = self.key;
            searchListVC.lat = self.lat;
            searchListVC.lon = self.lon;
            searchListVC.keySourceType = 0;
            searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
        //    [searchListVC.searchCollectionView.mj_header beginRefreshing];
            break;
        }
        case 5: {
            BATGeracomiumSearchListViewController *searchListVC = self.segContentVC.childViewControllers[5];
            searchListVC.type = toIndex;
            searchListVC.key = self.key;
            searchListVC.lat = self.lat;
            searchListVC.lon = self.lon;
            searchListVC.keySourceType = 0;
            searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
         //   [searchListVC.searchCollectionView.mj_header beginRefreshing];
            break;
        }
        case 6: {
            BATDoctorSearchListViewController *searchListVC = self.segContentVC.childViewControllers[6];
            searchListVC.type = toIndex;
            searchListVC.key = self.key;
            searchListVC.lat = self.lat;
            searchListVC.lon = self.lon;
            searchListVC.keySourceType = 0;
            searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
         //   [searchListVC.searchCollectionView.mj_header beginRefreshing];
            break;
        }
        case 7: {
            BATInfoSearchListViewController *searchListVC = self.segContentVC.childViewControllers[7];
            searchListVC.type = toIndex;
            searchListVC.key = self.key;
            searchListVC.lat = self.lat;
            searchListVC.lon = self.lon;
            searchListVC.keySourceType = 0;
            searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
        //    [searchListVC.searchCollectionView.mj_header beginRefreshing];
            break;
        }
            
            
        default:
            break;
    }
*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
//    [TalkingData trackPageBegin:@"搜索"];
    
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;

//    [TalkingData trackPageEnd:@"搜索"];
}

#pragma mark - UICollectionDataSource && UICollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

//4种情况，下同

    if (self.key.length == 0 || self.isSlider == YES) {
        //默认界面
        //默认界面最先判断，可能情况：有搜索类型，但是无搜索关键字
        return 2;
    }

    if (self.relateWordModel) {

        //联想关联词界面
        //关联词情况优先判断，可能情况：1、type为其他类型进行搜索 2、有搜索结果的时候重新搜索
        return 1;
    }

    if (self.type != kSearchAll) {

        //类型搜索界面
        return 1;
    }

    if (self.searchResultModel) {
        //全文搜索界面
        return 7;
    }

    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.key.length == 0 || self.isSlider == YES) {
        if (section == 0) {
            return self.hotKeyModel.Data.count;
        }
        if (section == 1) {
            NSArray * array = [[NSUserDefaults standardUserDefaults] valueForKey:SEARCH_HISTORY];
            return array.count;
        }
    }

    if (self.relateWordModel) {
        return self.relateWordModel.resultData.count;
    }

    if (self.type != kSearchAll) {
        return self.searchWithTypeDaraArray.count;
    }

    if (self.searchResultModel) {
        SearchResultdata *searchResult = self.searchResultModel.resultData[section];
        return searchResult.content.count;
    }
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.key.length == 0 || self.isSlider == YES) {

        if (indexPath.section == 0) {

            BATHotKeyCollectionViewCell * hotKeyCell = [collectionView dequeueReusableCellWithReuseIdentifier:HOT_KEY_CELL forIndexPath:indexPath];
            HotKeyData * key = self.hotKeyModel.Data[indexPath.row];
            hotKeyCell.keyLabel.text = key.Keyword;
            BOOL isselect = [self.hotKeyModel.Data[indexPath.item] isSelect];
            if (isselect) {
                hotKeyCell.layer.borderColor = END_COLOR.CGColor;
                hotKeyCell.keyLabel.textColor = END_COLOR;
            }else {
                hotKeyCell.layer.borderColor = [UIColor grayColor].CGColor;
                hotKeyCell.keyLabel.textColor = UIColorFromHEX(0X666666, 1);
            }
            return hotKeyCell;

        }
        else {

            BATSearchHistoryCollectionViewCell * searchHistoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:SEARCH_HISTORY_CELL forIndexPath:indexPath];
            NSArray * array = [[NSUserDefaults standardUserDefaults] valueForKey:SEARCH_HISTORY];
            NSString * searchHistory = array[indexPath.row];
            searchHistoryCell.recordLabel.text = searchHistory;
            return searchHistoryCell;
        }
    }

    if (self.relateWordModel) {

        BATRelateWordCollectionViewCell *relateCell = [collectionView dequeueReusableCellWithReuseIdentifier:RELATE_CELL forIndexPath:indexPath];
        relateCell.relateWordLabel.text = self.relateWordModel.resultData[indexPath.row];
        return relateCell;
    }

    if (self.type != kSearchAll) {

        SearchWithTypeContent *searchContent  = self.searchWithTypeDaraArray[indexPath.row];
        switch (self.type) {
            case kSearchAll: {
                //全部
                break;
            }
            case kSearchCondition: {

                BATConditionCollectionViewCell * conditionCell = [collectionView dequeueReusableCellWithReuseIdentifier:CONDITION_CELL forIndexPath:indexPath];
                conditionCell.nameLabel.text = searchContent.resultTitle;
                return conditionCell;

                break;
            }
            case kSearchSymptom: {
                
                BATConditionCollectionViewCell * conditionCell = [collectionView dequeueReusableCellWithReuseIdentifier:CONDITION_CELL forIndexPath:indexPath];
                conditionCell.nameLabel.text = searchContent.resultTitle;
                return conditionCell;
                
                break;
            }
            case kSearchTreatment: {

                BATTreatmentCollectionViewCell * treatmentCell = [collectionView dequeueReusableCellWithReuseIdentifier:TREATMENT_CELL forIndexPath:indexPath];
                [treatmentCell.treatmentImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.pictureUrl]] placeholderImage:[UIImage imageNamed:@"默认图"]];
                treatmentCell.nameLabel.text = searchContent.resultTitle;
                treatmentCell.facturerLbel.text = searchContent.manufactorName;
                return treatmentCell;
                break;
            }
            case kSearchHospital: {

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
//                hospitalCell.addressLabel.text = searchContent.address;
                hospitalCell.titleAddressLabel.text = [NSString stringWithFormat:@"地址:  %@",searchContent.address];
                hospitalCell.titlePhoneLabel.text = [NSString stringWithFormat:@"电话:  %@",[searchContent.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                return hospitalCell;
                break;
            }
            case kSearchGeracomium: {
                
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

                BATDoctorCollectionViewCell * doctorCell = [collectionView dequeueReusableCellWithReuseIdentifier:DOCTOR_CELL forIndexPath:indexPath];
                doctorCell.delegate = self;
                doctorCell.indexPath = indexPath;
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
//                 }
                
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

                BATInformationCollectionViewCell * informationCell = [collectionView dequeueReusableCellWithReuseIdentifier:INFORMATION_CELL forIndexPath:indexPath];
                [informationCell.inforImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.mainImage]] placeholderImage:[UIImage imageNamed:@"默认图"]];
                informationCell.nameLabel.text = searchContent.resultTitle;
                informationCell.descriptionLabel.text = [searchContent.resultDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                return informationCell;
                break;
            }
        }
    }

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
                treatmentCell.facturerLbel.text = searchContent.manufactorName;
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


    //header
    if (self.key.length == 0 || self.isSlider == YES) {
        if (kind == UICollectionElementKindSectionHeader) {
            BATSearchHeaderCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SEARCH_HEADER forIndexPath:indexPath];
            switch (indexPath.section) {
                case 0:
                {
                    //热门词
                    header.leftImageView.image = [UIImage imageNamed:@"icon-rmss"];
                    header.titleLabel.text = @"热门搜索";
                    [header.clearButton setHidden:YES];
                }
                    break;
                case 1:
                {
                    //历史搜索
                    header.leftImageView.image = [UIImage imageNamed:@"search-history"];
                    header.titleLabel.text = @"历史搜索";
                    [header.clearButton setHidden:NO];
                    WEAK_SELF(self);
                    [header setClearBlock:^{

                        //清除历史纪录
                        STRONG_SELF(self);
                        NSArray * array = [NSArray array];
                        [[NSUserDefaults standardUserDefaults] setObject:array forKey:SEARCH_HISTORY];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        [self.searchCollectionView reloadData];
                    }];
                }
                    break;
                default:
                    break;
            }
            return header;
        }
    }


    if (self.relateWordModel) {
        return nil;
    }

    if (self.type != kSearchAll) {
        return nil;
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
    if (self.key.length == 0 || self.isSlider == YES) {
        size = CGSizeMake(SCREEN_WIDTH, 40);
        return size;
    }

    if (self.relateWordModel) {
        return CGSizeZero;
    }

    if (self.type != kSearchAll) {
        return CGSizeZero;
    }

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
    if (self.key.length == 0 || self.isSlider == YES) {
        if (section == 1) {
            return size;
        }
        return CGSizeMake(SCREEN_WIDTH, 10);
    }

    if (self.relateWordModel) {
        return size;
    }

    if (self.type != kSearchAll) {
        return size;
    }

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
    //默认界面
    if (self.key.length == 0 || self.isSlider == YES) {
        if (indexPath.section == 0) {
            //关键字
            HotKeyData * key = self.hotKeyModel.Data[indexPath.row];

            CGSize textSize = [key.Keyword boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            size = CGSizeMake(textSize.width+20, 30);
        }
        else if (indexPath.section == 1) {
            //历史纪录
            size = CGSizeMake(SCREEN_WIDTH, 40);
        }
        return size;
    }

    if (self.relateWordModel) {
        size = CGSizeMake(SCREEN_WIDTH-20, 40);
        return size;
    }

    if (self.type != kSearchAll) {

        switch (self.type) {
            case kSearchAll: {
                break;
            }
            case kSearchCondition: {
                
                SearchWithTypeContent *searchContent = self.searchWithTypeDaraArray[indexPath.row];
                CGSize textSize = [searchContent.resultTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
                CGFloat height = textSize.height + 20 > 40 ? textSize.height + 20 : 40;
                size = CGSizeMake(SCREEN_WIDTH-20, height);
                break;
            }
            case kSearchSymptom: {
                
                SearchWithTypeContent *searchContent = self.searchWithTypeDaraArray[indexPath.row];
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

    if (self.key.length == 0 || self.isSlider == YES) {
 
        if (section == 0) {

            return 10;
        }
    }

    if (self.relateWordModel) {

        return 1;
    }

    if (self.type != kSearchAll) {
        if (self.type == kSearchCondition) {

            //疾病
            return 5;
        }
        return 1;
    }

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
    if (self.key.length == 0 || self.isSlider == YES) {

        if (section == 0) {

            //热门词
            edge = UIEdgeInsetsMake(10, 10, 10, 10);
            return edge;
        }
    }

    if (self.relateWordModel) {

    }

    if (self.type != kSearchAll) {

        if (self.type == kSearchCondition) {

            return UIEdgeInsetsMake(10, 10, 0, 10);
        }
    }

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

    if (self.key.length == 0 || self.isSlider == YES) {
        //判断是否点击，这里要取反
        self.isClikc = NO;

        
        if (indexPath.section == 0) {
            
            for (HotKeyData *dataModel in self.hotKeyModel.Data) {
                dataModel.isSelect = NO;
            }
 
            //热门
            BATHotKeyCollectionViewCell * hotKeyCell = (BATHotKeyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

            HotKeyData *dataModel = self.hotKeyModel.Data[indexPath.item];
            dataModel.isSelect = YES;

            self.key = hotKeyCell.keyLabel.text;
            self.keywordSource = BATkeywordSourceHotWords;
            
            //给记录词汇赋值
            self.recordWord = hotKeyCell.keyLabel.text;
            
            [self searchResult];
            self.topView.searchTF.text = hotKeyCell.keyLabel.text;
        }
        else if (indexPath.section == 1) {


            //历史
            BATSearchHistoryCollectionViewCell * searchHistoryCell = (BATSearchHistoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            self.key = searchHistoryCell.recordLabel.text;
            
            //给记录词汇赋值
            self.recordWord = searchHistoryCell.recordLabel.text;
            
            self.keywordSource = BATkeywordSourceNoromalwords;
            
            [self searchResult];
            self.topView.searchTF.text = searchHistoryCell.recordLabel.text;
        }
        return;
    }

    if (self.relateWordModel) {
        self.searchCollectionView.hidden = YES;
        //给记录词汇赋值
        self.recordWord = self.key;
        self.segContentVC.segmentBar.selectIndex = 0;
        [self.segContentVC showChildVCViewAtIndex:0];
        //关联词汇
        [self.topView.searchTF resignFirstResponder];
        self.topView.searchTF.text = self.relateWordModel.resultData[indexPath.row];
        self.key = self.relateWordModel.resultData[indexPath.row];
        self.keywordSource = BATkeywordSourceRelateWords;
        [self searchResult];
        self.relateWordModel = nil;
        return;
    }
    

    
    //刷新纪录词
    self.recordWord = self.key;

    if (self.type != kSearchAll && self.searchWithTypeDaraArray.count > 0) {
        //判断是否点击
        self.isClikc = YES;
        
        SearchWithTypeContent *searchContent  = self.searchWithTypeDaraArray[indexPath.row];
        switch (self.type) {
            case kSearchAll: {
                break;
            }
            case kSearchCondition: {
//                BATDieaseDetailController *searchDieaseCtl = [[BATDieaseDetailController alloc]init];
//                searchDieaseCtl.DieaseID = [searchContent.resultId intValue];
//                searchDieaseCtl.EntryCNName = searchContent.resultTitle;
//                searchDieaseCtl.pathName = self.key;
//                [self.navigationController pushViewController:searchDieaseCtl animated:YES];
                BATSearchDieaseDetailController *searchDieaseCtl = [[BATSearchDieaseDetailController alloc]init];
                searchDieaseCtl.titleName = @"疾病百科";
                searchDieaseCtl.DieaseID = [searchContent.resultId intValue];
                searchDieaseCtl.EntryCNName = searchContent.resultTitle;
                searchDieaseCtl.resultDesc = searchContent.resultDesc;
                [self.navigationController pushViewController:searchDieaseCtl animated:YES];

                break;
            }case kSearchSymptom: {
//                BATDieaseDetailController *searchDieaseCtl = [[BATDieaseDetailController alloc]init];
//                searchDieaseCtl.DieaseID = [searchContent.resultId intValue];
//                searchDieaseCtl.EntryCNName = searchContent.resultTitle;
//                searchDieaseCtl.pathName = self.key;
//                [self.navigationController pushViewController:searchDieaseCtl animated:YES];
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
                drugVC.pathName = self.key;
                [self.navigationController pushViewController:drugVC animated:YES];
                break;
            }
            case kSearchHospital: {
                BATNewHospitalInfoViewController *hospitalVC = [[BATNewHospitalInfoViewController alloc] init];
                hospitalVC.HospitailID = searchContent.resultId;
                hospitalVC.HospitailTitle = searchContent.resultTitle;
                hospitalVC.pathName = self.key;
                [self.navigationController pushViewController:hospitalVC animated:YES];
                break;
            }
            case kSearchGeracomium: {
                BATGeracomiumController *geracomiumVC = [[BATGeracomiumController alloc]init];
                geracomiumVC.gerID = searchContent.resultId;
                geracomiumVC.titleName = searchContent.resultTitle;
                geracomiumVC.pathName = self.key;
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
                break;
            }
            case kSearchInformation: {
                
//                NSString *ipString = [[NSUserDefaults standardUserDefaults] objectForKey:@"appdominUrl"];
//                NSString * urlString = [NSString stringWithFormat:@"%@/App/NewsDetail/%@",ipString,searchContent.resultId];
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
        return;
    }

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
                //药品
                BATDrugInfoDetailViewController *drugVC = [[BATDrugInfoDetailViewController alloc] init];
                drugVC.drugID = searchContent.resultId;
                drugVC.drugTitle = searchContent.resultTitle;
                drugVC.pathName = self.key;
                [self.navigationController pushViewController:drugVC animated:YES];

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
                BATNewsDetailViewController *webView = [[BATNewsDetailViewController alloc]init];
                webView.newsID = searchContent.resultId;
                webView.titleStr = searchContent.resultTitle;
                webView.pathName = self.key;
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

#pragma mark - UITextFieldDelegate
- (void)textFieldEditChanged:(UITextField *)textField {

    
    self.searchCollectionView.hidden = NO;
    DDLogWarn(@"%@",textField.text);
   // self.isClikc = NO;
    //隐藏类型选择
    self.isShow = NO;
    
    if (![self.recordWord isEqualToString:self.key]) {
        self.isClikc = NO;
    }else {
        self.isClikc = YES;
    }
    
    self.recordWord = self.key;
    self.key = textField.text;
    
 

    if (self.key.length == 0) {

        //恢复默认
        self.relateWordModel = nil;
        [self.searchCollectionView reloadData];
        return;
    }


    [self searchRelateWord];//搜索关联词

   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if (textField.text.length > 0) {
        self.relateWordModel = nil;
        DDLogDebug(@"开始搜索");
        self.currentPage = 0;
        self.key = textField.text;
        [textField resignFirstResponder];
        self.keywordSource = BATkeywordSourceNoromalwords;
        [self searchResult];
    }
    
    if (!self.isClikc) {
        [self isSearchAction];
    }
    
    self.segContentVC.segmentBar.selectIndex = 0;
    [self.segContentVC showChildVCViewAtIndex:0];

    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {

    self.searchCollectionView.hidden = NO;
    self.key = @"";
    self.currentPage = 0;
    self.relateWordModel = nil;
    [self.searchWithTypeDaraArray removeAllObjects];
    self.searchResultModel = nil;
    [self.searchCollectionView reloadData];

    
    self.segContentVC.segmentBar.selectIndex = 0;
    [self.segContentVC showChildVCViewAtIndex:0];
    

    return YES;
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

//导航栏－改变类型
- (void)changeSearchType {

    [self.topView endEditing:YES];
    [YCXMenu setHasShadow:YES];
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(0, 0, 100, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
        DDLogDebug(@"%@",item.userInfo);
        self.keywordSource = BATkeywordSourceNoromalwords;
        [self.topView.chooseButton setTitle:item.title forState:UIControlStateNormal];
        self.type = [item.userInfo[@"type"] intValue];
        self.currentPage = 0;
        self.isShow = NO;
        [YCXMenu dismissMenu];
        [self searchResult];
    }];
}

//点击更多
- (void)showMoreWithTitle:(NSString *)title Type:(kSearchType)type {

    //更改为已操作状态
    self.isClikc = YES;
    
    BATSearchListViewController * searchListVC = [BATSearchListViewController new];
    searchListVC.title = title;
    searchListVC.type = type;
    searchListVC.key = self.key;
    searchListVC.lat = self.lat;
    searchListVC.lon = self.lon;
    searchListVC.keySourceType = self.keywordSource;
    searchListVC.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
    [self.navigationController pushViewController:searchListVC animated:YES];
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

#pragma mark - NET
- (void)hotKeyRequest {

    [HTTPTool requestWithURLString:@"/api/Search/GetHotKeywords" parameters:nil type:kGET success:^(id responseObject) {

        self.hotKeyModel = [BATHotKeyModel mj_objectWithKeyValues:responseObject];
        if (self.hotKeyModel.ResultCode == 0) {
            [self.searchCollectionView reloadData];
        }
    } failure:^(NSError *error) {

    }];
}

- (void)searchRelateWord {
    [HTTPTool requestWithSearchURLString:@"/elasticsearch/commonsearch/querykeyword" parameters:@{@"keyword":self.key} success:^(id responseObject) {

        self.relateWordModel = [BATRelateWordModel mj_objectWithKeyValues:responseObject];
        self.isSlider = NO;
        [self.searchCollectionView reloadData];
    } failure:^(NSError *error) {

    }];
}

- (void)searchResult {
    
    self.defaultView.hidden = YES;
    
    BOOL isConnectNet =  [Tools checkNetWorkIsOk];
    if (!isConnectNet) {
        self.key = nil;
        return;
    }

    if (self.key.length == 0) {
        self.searchCollectionView.mj_footer.hidden = YES;
        return;
    }
    [self.topView endEditing:YES];
    
    self.relateWordModel = nil;
    
    NSArray * historyArray = [[NSUserDefaults standardUserDefaults] valueForKey:SEARCH_HISTORY];
    if (!historyArray) {

        historyArray = [NSArray array];
    }
    NSMutableArray * array = [NSMutableArray arrayWithArray:historyArray];
    if (![array containsObject:self.key]) {

        [array insertObject:self.key atIndex:0];
        if (array.count > 6) {

            [array removeLastObject];
        }
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:SEARCH_HISTORY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    [self showProgress];
    if (self.type == kSearchAll) {
        self.searchCollectionView.mj_footer.hidden = YES;
        //全文搜索
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.key forKey:@"keyword"];
        [dict setValue:@"ios" forKey:@"devicetype"];
        
        //获取ip
        NSString *ipString = [Tools get4GorWIFIAddress];
        [dict setValue:ipString forKey:@"userIp"];
        
         //获取经纬度
        [dict setValue:@(self.lat) forKey:@"lat"];
        [dict setValue:@(self.lon) forKey:@"lon"];
        
        //生成随机数
        NSString *randNumbers = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
        if (!randNumbers) {
            [[NSUserDefaults standardUserDefaults] setObject:[Tools randomArray] forKey:@"RANDNUMBERS"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            randNumbers =  [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
            [dict setValue:randNumbers forKey:@"searchUserId"];
            
        }else {
            
            [dict setValue:randNumbers forKey:@"searchUserId"];
            
        }
      
        
        [dict setValue:@(self.keywordSource) forKey:@"keywordSource"];
        
        //判断是否登录，登录了才传ID
        if (LOGIN_STATION) {
            [dict setValue:[self getCurrentID] forKey:@"accountId"];
        }
        
        [dict setValue:[self getPostUUID] forKey:@"userDeviceId"];
        

        [HTTPTool requestWithSearchURLString:@"/elasticsearch/searchapp/advancedqueryforapp" parameters:dict success:^(id responseObject) {
            [self dismissProgress];
            [self.defaultView setHidden:YES];

//            [TalkingData trackEvent:@"100005" label:@"搜索"];
            
            self.searchResultModel = [BATSearchResultModel mj_objectWithKeyValues:responseObject];
            //移除不需要的分类
            [self.searchResultModel.resultData removeObjectAtIndex:3];
           
            //疾病位置
            [self.searchResultModel.resultData insertObject:self.searchResultModel.resultData[3] atIndex:1];
             [self.searchResultModel.resultData removeObjectAtIndex:4];
            
            //养老院位置
            [self.searchResultModel.resultData insertObject:[self.searchResultModel.resultData lastObject] atIndex:4];
            [self.searchResultModel.resultData removeLastObject];
            
            SearchResultdata *geracomiumSearchResultdata = self.searchResultModel.resultData[4];
            if (geracomiumSearchResultdata.content.count == 0
                && ![self.key containsString:@"养老院"]
                && ![self.key containsString:@"养老"]
                && ![self.key containsString:@"院"]) {
                [self addSegItemsWithNameArray:self.nameArrayNoGeracomium];
            }
            else {
                [self addSegItemsWithNameArray:self.nameArray];
            }
            
            self.isSlider = NO;
            
            if (self.searchResultModel.resultData.count == 0) {
                [self.defaultView showDefaultView];
            }
            self.searchCollectionView.hidden = YES;
            self.searchResultModel.key = self.key;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SYNTHESIZE_INFO" object:self.searchResultModel];
            
            if ([self.key containsString:@"药"]) {
                BATSearchSimpleModel *model = [BATSearchSimpleModel new];
                model.title = @"药品百科";
                model.type = 3;
                model.key = self.key;
                model.lat = self.lat;
                model.lon = self.lon;
                model.keySourceType = self.keywordSource;
                model.searchUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ROADTODESTION" object:model];
            }
           
            

            
            [self.searchCollectionView reloadData];

        } failure:^(NSError *error) {
            [self dismissProgress];
            [self.defaultView showDefaultView];
        }];
        return;
    }
    
    //类型搜索
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.key forKey:@"keyword"];
    [dict setValue:@"ios" forKey:@"devicetype"];
    [dict setValue:self.typeArray[self.type] forKey:@"types"];
    [dict setValue:@(self.currentPage) forKey:@"page"];
    //获取ip
    NSString *ipString = [Tools get4GorWIFIAddress];
    [dict setValue:ipString forKey:@"userIp"];
    
    //生成随机数
    NSString *randNumbers = [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
    if (!randNumbers) {
        [[NSUserDefaults standardUserDefaults] setObject:[Tools randomArray] forKey:@"RANDNUMBERS"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        randNumbers =  [[NSUserDefaults standardUserDefaults] objectForKey:@"RANDNUMBERS"];
        [dict setValue:randNumbers forKey:@"searchUserId"];
        
    }else {
        
        [dict setValue:randNumbers forKey:@"searchUserId"];
        
    }
    
    
    [dict setValue:@(self.keywordSource) forKey:@"keywordSource"];
    
    
    //获取经纬度
    [dict setValue:@(self.lat) forKey:@"lat"];
    [dict setValue:@(self.lon) forKey:@"lon"];
    
    //判断是否登录，登录了才传ID
    if (LOGIN_STATION) {
        [dict setValue:[self getCurrentID] forKey:@"accountId"];
    }
    
    [dict setValue:[self getPostUUID] forKey:@"userDeviceId"];

    [HTTPTool requestWithSearchURLString:@"/elasticsearch/commonsearch/advancedquerywithtypes"
                              parameters:dict
                                 success:^(id responseObject) {
                                     [self dismissProgress];
                                     
                                     

                                     [self.searchCollectionView.mj_footer endRefreshing];
                                     self.searchCollectionView.mj_footer.hidden = NO;
                                     BATSearchWithTypeModel *searchWithTypeModel = [BATSearchWithTypeModel mj_objectWithKeyValues:responseObject];
                                     if (self.currentPage == 0) {

                                         [self.searchWithTypeDaraArray removeAllObjects];
                                     }

                                     [self.searchWithTypeDaraArray addObjectsFromArray:searchWithTypeModel.resultData.content];
                                     if (self.searchWithTypeDaraArray.count >= searchWithTypeModel.resultData.totalElements) {

                                         [self.searchCollectionView.mj_footer endRefreshingWithNoMoreData];
                                     }

                                     if (searchWithTypeModel.resultData.totalElements == 0) {
                                         //没有数据
                                         self.searchCollectionView.mj_footer.hidden = YES;
                                     }
                                     
                                     self.isSlider = NO;
                                     
                                     if(searchWithTypeModel.resultData.content.count == 0){
                                         [self.defaultView showDefaultView];
                                     }
                                     
                                     [self.searchCollectionView reloadData];
                                 } failure:^(NSError *error) {
                                     [self dismissProgress];
                                     [self.defaultView showDefaultView];
                                 }];
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

#pragma mark - setter && getter
- (BATTopSearchView *)topView {
    if (!_topView) {
        _topView = [[BATTopSearchView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        _topView.searchTF.delegate = self;
        [_topView.searchTF addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        WEAK_SELF(self);
        [_topView setCancelBlock:^{

            STRONG_SELF(self);
            if (!self.isClikc) {
                 [self isClikcAction];
            }
            self.searchCollectionView.mj_footer.hidden = YES;
            self.isClikc = NO;
            [self cancelSearch];
            self.isShow = NO;
            self.isSlider = YES;
            self.currentPage = 0;
            [YCXMenu dismissMenu];

        }];

        [_topView setChooseType:^{

            STRONG_SELF(self);
            if (!self.isShow) {
                  [self changeSearchType];
            }else {
                [YCXMenu dismissMenu];
            }
            self.isShow = !self.isShow;
          
        }];
    }
    return _topView;
}

- (UICollectionView *)searchCollectionView {
    if (!_searchCollectionView) {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        _searchCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:flow];
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
        
        _searchCollectionView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{

            self.currentPage ++;
            [self searchResult];
        }];
        
        _searchCollectionView.mj_footer.hidden = YES;

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
            [self searchResult];
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
    
    
    if (self.count < 1) {
        if (self.isFromHome) {
            [self searchResult];
            self.count++;
        }
    }
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
