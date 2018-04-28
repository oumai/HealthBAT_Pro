//
//  BATTrainStudioViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/7/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioViewController.h"
#import "BATTrainStudioListViewController.h"
#import "BATCourseSearchViewController.h"
#import "BATTrainStudioSearchListViewController.h"

#import <StoreKit/StoreKit.h>

#import "HMSegmentedControl.h"
#import "UIButton+TouchAreaInsets.h"
#import "UIColor+Gradient.h"
#import "UIButton+ImagePosition.h"
#import "BATTrainStudioCategoryModel.h"

#define kMARGIN 5

@interface BATTrainStudioViewController ()<UIScrollViewDelegate, UITextFieldDelegate, SKStoreProductViewControllerDelegate>
/** UIScrollView */
@property (nonatomic, strong) UIScrollView *bgScrollView;
/** 分段控制器 */
@property (nonatomic, strong) HMSegmentedControl *segmentController;
/** 视频分类数据源 */
@property (nonatomic, strong) NSMutableArray *categoryDataSource;
/** 顶部搜索 View */
@property (nonatomic, strong) UIView *topSearchView;

@end

@implementation BATTrainStudioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"培训工作室";
    self.view.backgroundColor = BASE_BACKGROUND_COLOR;
    
    //加载分类标题
    [self loadCategoryRequest];
    [self.view addSubview:self.topSearchView];
    [self.view addSubview:self.segmentController];
    [self.view addSubview:self.bgScrollView];
    [self setupNav];
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.topSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.segmentController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topSearchView.mas_bottom);
    }];
    
    [self.bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentController.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
        
        
    }];
    
}

#pragma mark - private
/**
 添加子控制器
 */
- (void)addChildVc{
    
    for (int i= 0; i<self.categoryDataSource.count; i++) {
        
        BATTrainStudioListViewController *trainStudioListVc = [[BATTrainStudioListViewController alloc]init];
        BATTrainStudioCategoryModel *categoryModel = self.categoryDataSource[i];
        trainStudioListVc.SubjectType = categoryModel.Code;
        [self addChildViewController:trainStudioListVc];
        
    }
    
    //主动调用显示第一个子控制器 View
    [self scrollViewDidEndScrollingAnimation:self.bgScrollView];
    
}
/**
 跳转搜索界面
 */
- (void)pushSearchViewController{
    
    BATTrainStudioSearchListViewController *searchListVc = [[BATTrainStudioSearchListViewController alloc]init];
    [self.navigationController pushViewController:searchListVc animated:YES];
    
}
/**
 点击分段控制器调用
 */
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentCtr{
    
    [self.bgScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*segmentCtr.selectedSegmentIndex, 0) animated:YES];
    
}
#pragma mark - Nav
/**
 设置导航栏
 */
- (void)setupNav{
    
    UIButton *openAppStoreButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 76, 26)];
    openAppStoreButton.contentMode = UIViewContentModeRight;
    [openAppStoreButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [openAppStoreButton setImage:[UIImage imageNamed:@"TrainStudio_Nav_downloadApp"] forState:UIControlStateNormal];
    [openAppStoreButton addTarget:self action:@selector(openAppStore) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *openAppStoreBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:openAppStoreButton];
    self.navigationItem.rightBarButtonItem = openAppStoreBarButtonItem;
}

#pragma mark - 模态打开 App Store

- (void)openAppStore{
    
    SKStoreProductViewController *storeProductViewController = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewController.delegate = self;
    //加载一个新的视图展示
    [storeProductViewController loadProductWithParameters:
     //appId 1253389488
     @{SKStoreProductParameterITunesItemIdentifier : YHS_APPSTORE_ID} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             DDLogDebug(@"error %@ with userInfo %@",error,[error userInfo]);
         }else{
             //模态弹出appstore
             [self presentViewController:storeProductViewController animated:YES completion:^{
                 
             }
              ];
         }
     }];
    
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Request
/**
 加载课程类型数据
 */
- (void)loadCategoryRequest{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"category"] = @"CourseCategory";
    
    //http://yhs-api.test.jkbat.com/api/Teacher/GetEnums?category=%20CourseCategory
    
    
    WeakSelf
    [HTTPTool requestWithMaintenanceURLString:@"/api/Teacher/GetEnums" parameters:dictM type:kGET success:^(id responseObject) {
        
        DDLogDebug(@"%@---",responseObject);
        weakSelf.categoryDataSource = [BATTrainStudioCategoryModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        //向数据源插入一条数据
        BATTrainStudioCategoryModel *allModel = [[BATTrainStudioCategoryModel alloc]init];
        allModel.Code = -1;
        allModel.Text = @"全部";
        [weakSelf.categoryDataSource insertObject:allModel atIndex:0];
        
        //添加子控制器
        [weakSelf addChildVc];
        
        NSMutableArray *categoryTitletM = [NSMutableArray array];
        for ( BATTrainStudioCategoryModel *model in self.categoryDataSource) {
            [categoryTitletM addObject:model.Text];
        }
        
        //设置分段控制器标题
        weakSelf.segmentController.sectionTitles = categoryTitletM;
        
        //设置 srollView 的ContentSize
        [weakSelf.bgScrollView setContentSize:CGSizeMake(SCREEN_WIDTH * weakSelf.categoryDataSource.count, 0)];
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:ErrorText];
    
    }];
    
    
}

#pragma mark - UIScrolllViewDelegate
/**
 * 滚动视图动画完成后，调用该方法，如果没有动画，那么该方法将不被调用
 * 如果执行完setContentOffset:animated:后，scrollView的偏移量并没有发生改变的话，就不会调用scrollViewDidEndScrollingAnimation:方法
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    int index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    
    if (willShowChildVc.isViewLoaded) return;
    
    willShowChildVc.view.frame = scrollView.bounds;
    willShowChildVc.view.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:willShowChildVc.view];
}
/**
 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //添加子控制器 view
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentController setSelectedSegmentIndex:page animated:YES];
}
/**
 拖动结束，手从屏幕上抬起的一刹那，会执行这个方法,防止用户刚好拖到边界停止
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - lazy Load

- (HMSegmentedControl *)segmentController{
    if (!_segmentController) {
        
        /**
         //设置图片(普通)
         NSArray<UIImage *> *images = @[
         [UIImage imageNamed:@"TrainStudio_Catrgory_All_Nor"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_hlx_Nor"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_nkhl_Nor"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_wkhl_Nor"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_fckhl_Nor"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_ekhl_Nor"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_sqhl_Nor"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_ylhl_Nor"],
         ];
         
         //选中状态下的图片
         NSArray<UIImage *> *selectedImages = @[
         [UIImage imageNamed:@"TrainStudio_Catrgory_All_Sel"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_hlx_Sel"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_nkhl_Sel"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_wkhl_Sel"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_fckhl_Sel"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_ekhl_Sel"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_sqhl_Sel"],
         [UIImage imageNamed:@"TrainStudio_Catrgory_ylhl_Sel"],
         ];
         
         
         _segmentController = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selectedImages];
         
         _segmentController.frame = CGRectMake(0, CGRectGetMaxY(self.searchView.frame) + kMARGIN, SCREEN_WIDTH, 46);
         */
        
        _segmentController = [[HMSegmentedControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topSearchView.frame), SCREEN_WIDTH, 46)];
        
        //设置底部下划线的高度
        _segmentController.selectionIndicatorHeight = 2;
        
        //设置底部下划线的颜色
        _segmentController.selectionIndicatorColor = UIColorFromHEX(0x29ccbf, 1);
        
        //设置边框
        _segmentController.layer.borderColor = UIColorFromHEX(0xe0e0e0, 1).CGColor;
        _segmentController.layer.borderWidth = 0.5;
        _segmentController.layer.masksToBounds = YES;
        
        
        //设置底下的线和文字一样大
        _segmentController.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        //设置线的位置
        _segmentController.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        
        //设置文字颜色及字体
        _segmentController.titleTextAttributes = @{NSForegroundColorAttributeName : UIColorFromHEX(0x333333, 1),
                                                   NSFontAttributeName : [UIFont systemFontOfSize:15]};
        _segmentController.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor gradientFromColor:UIColorFromHEX(0x29ccbf, 1) toColor:UIColorFromHEX(0x6ccc56, 1) withHeight:15],
                                                           NSFontAttributeName :[UIFont systemFontOfSize:15]};
        
        //添加点击事件
        [_segmentController addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _segmentController;
}
- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentController.frame) , SCREEN_WIDTH, SCREEN_HEIGHT  - CGRectGetHeight(self.topSearchView.frame) - CGRectGetHeight(self.segmentController.frame)  - 64 )];
        _bgScrollView.delegate = self;
        _bgScrollView.pagingEnabled = YES;
        //        _bgScrollView.contentSize = CGSizeMake(8 * SCREEN_WIDTH, 0);
        _bgScrollView.backgroundColor = [UIColor whiteColor];
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
        
    }
    return _bgScrollView;
}

- (UIView *)topSearchView{
    
    if (!_topSearchView) {
        _topSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _topSearchView.backgroundColor = [UIColor whiteColor];
        
        UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 20, 30)];
        [searchButton setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateNormal];
        [searchButton setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateHighlighted];
        searchButton.backgroundColor = BASE_BACKGROUND_COLOR;
        searchButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        searchButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [searchButton setImage:[UIImage imageNamed:@"ic-search"] forState:UIControlStateNormal];
        [searchButton setTitle:@"搜索护理课程~" forState:UIControlStateNormal];
        [searchButton setTitle:@"搜索护理课程~" forState:UIControlStateHighlighted];
        searchButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        
        //设置图片与文字之间的间距
        [searchButton setImagePosition:ImagePositionLeft spacing:5];
        
        [searchButton addTarget:self action:@selector(pushSearchViewController) forControlEvents:UIControlEventTouchUpInside];
        
        [_topSearchView addSubview:searchButton];
        
    }
    return _topSearchView;
}
- (NSMutableArray *)categoryDataSource{
    if (!_categoryDataSource) {
        _categoryDataSource = [NSMutableArray array];
    }
    return _categoryDataSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc{
    
    DDLogDebug(@"%s",__func__);
}

@end
