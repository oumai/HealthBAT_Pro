

#import "BATEatSearchTwiceViewController.h"
#import "BATTrainStudioCourseDetailViewController.h"
#import "UITableView+SeparatorInsetEdge.h"
#import "BATTableViewPlaceHolder.h"
#import "UIButton+TouchAreaInsets.h"
#import "UIButton+ImagePosition.h"

#import "BATEmptyDataView.h"

#import "BATTrainStudioSearchKeyWordModel.h"
#import "BATTrainStudioListModel.h"

//新的cell
#import "BATHealthThreeSecondsFoodEnterCell.h"
#import "BATHealthEvalutionServce.h"
#import "BATSearchFoodModel.h"
#import "BATHealthThreeSecondsRecommedFoodListModel.h"
#import "BATEatSearchTableViewCell.h"

#import "BATHealthThreeSecondsFoodEnterAlertView.h"
#import "UIButton+ImagePosition.h"
#import "BATHealthThreeSecondsRecommedFoodListModel.h"
#import "BATPerson.h"
#import "BATEatSearchAlert.h"
#import "BATHealthThreeSecondsDetailController.h"


static NSString *const keyWordCellId = @"UITableViewCell";
static NSString *const studioListCellId = @"BATEatSearchTableViewCell";

@interface BATEatSearchTwiceViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, BATTableViewPlaceHolderDelegate, BATHealthThreeSecondsFoodEnterAlertViewDelegate>
/** 搜索UITextField */
@property (nonatomic, strong) UITextField *navTextField;
/** UITableView */
@property (nonatomic, strong) UITableView *tableView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 标记是否点击了搜索关键字 */
@property (nonatomic, assign) BOOL  isDidClickKeyWord;
/** 无数据占位 view */
@property (nonatomic, strong) BATEmptyDataView *emptyDataView;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) BATPerson *loginUserModel;

@property (nonatomic, strong) BATHealthThreeSecondsFoodEnterAlertView *foodEnterAlertView;

@property (nonatomic, strong) BATHealthThreeSecondsRecommedFoodListModel *recommendFoodModel;

@property (strong, nonatomic) BATEatSearchAlert *alertView;

@property (strong, nonatomic) UIView *topSearchView;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UIView *alertViewOfME;

@property (nonatomic, assign) NSInteger count; //0是正常 count是暂无数据
@end

@implementation BATEatSearchTwiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"食物录入";
    _count = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topSearchView];
    [self.view addSubview:self.alertViewOfME];
    [self.view addSubview:self.tableView];

    [self layoutSelf];
}
- (void)layoutSelf; {

    [self.topSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(0);
        make.height.mas_equalTo(70);
    }];
    [self.alertViewOfME mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(0);
        make.top.mas_equalTo(self.view).offset(70);
        make.height.mas_equalTo(50);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(0);
        if (_count == 1) {
            make.top.mas_equalTo(self.topSearchView.mas_bottom).offset(50);
//            self.alertViewOfME.hidden = NO;
        } else {
            make.top.mas_equalTo(self.topSearchView.mas_bottom);
//            self.alertViewOfME.hidden = YES;
        }
    }];
    
    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self.alertView];
    WEAK_SELF(appDelegate);
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(appDelegate);
        make.top.equalTo(appDelegate.window.mas_top).offset(SCREEN_HEIGHT);
        make.left.right.equalTo(appDelegate.window);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    
}

#pragma mark - BATTableViewPlaceHolderDelegate
/**
 无数据占位 view
 */
- (UIView *)makePlaceHolderView{
    if (!_emptyDataView) {
        _emptyDataView = [[BATEmptyDataView alloc]initWithFrame:self.tableView.bounds];
        WeakSelf
        _emptyDataView.reloadRequestBlock = ^{
            //重新加载
            [weakSelf textFieldDidChange:weakSelf.navTextField];
        };
        
    }
    return _emptyDataView;
    
}

#pragma mark - 导航栏设置

- (UIView *)topSearchView{
    
    if (!_topSearchView) {
        _topSearchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        _topSearchView.backgroundColor = [UIColor whiteColor];
        
        UIView *viewTFBgView = [[UIView alloc] init];
        viewTFBgView.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30, 40);
        viewTFBgView.backgroundColor = RGB(238, 238, 238);
        viewTFBgView.layer.cornerRadius = 20;
        viewTFBgView.layer.masksToBounds = YES;
        
        [viewTFBgView addSubview:self.navTextField];
//        [viewTFBgView addSubview:self.searchBar];
        [self.navTextField becomeFirstResponder];
        [_topSearchView addSubview:viewTFBgView];
    }
    return _topSearchView;
}

- (void)leftBackButtonClick{
    
    [self.navTextField resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        //搜索结果
        BATHealthThreeSecondsFoodEnterCell *trainStudioListCell = [tableView dequeueReusableCellWithIdentifier:studioListCellId];

        trainStudioListCell.recommedFoodModel = self.dataSource[indexPath.row];

        return trainStudioListCell;

}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

        return 88;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
 //弹出 选择框啊
    NSLog(@"哈喽");

        
    self.recommendFoodModel = self.dataSource[indexPath.row];
    self.alertView.recommendFoodModel = self.recommendFoodModel;
    [self showNewContentView:YES];
    
    
 
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, view.width - 20, 40);
    label.text = @"匹配食物列表";
    label.numberOfLines = 0;
    view.backgroundColor = [UIColor whiteColor];
    label.textColor = RGB(51, 51, 51);
    label.font = [UIFont systemFontOfSize:16];
    [view addSubview:label];
    if (_count == 0) {
        label.text = @"匹配食物列表";
    } else {
         label.text = @"推荐食物列表";
        
    }
    
    if (self.dataSource.count != 0) {
        view.hidden = NO;
        
    } else {
        view.hidden = YES;
    }
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.dataSource.count != 0) {
         return 40.0;
    }
    return 0.01;
   
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
#pragma mark - UITextFiledDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];

    [self loadSearchResultRequestWith:textField.text];

    return YES;
}

//- (BOOL)textFieldShouldClear:(UITextField *)textField{
//
//    [self.dataSource removeAllObjects];
//    [self.tableView bat_reloadData];
//
//    return YES;
//}
//当文本内容改变时调用

#pragma mark - Request
/**
 监听 UITextFiled 文字输入
 请求搜索关键字
 */
- (void)textFieldDidChange:(UITextField *)textFiled{
    
    if ([textFiled.text isEqualToString:@""]) {
        [self.dataSource removeAllObjects];
        [self.tableView bat_reloadData];
        _count = 0;
        //更新table的约束
        [self updateTableInside];
        return;
    }
    _pageSize = 10;
    _currentPage = 0;
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"foodName"] = textFiled.text;
    dictM[@"pageSize"] = @(_pageSize);
    dictM[@"pageIndex"] = @(_currentPage);
    
    
    BATHealthEvalutionServce *service = [[BATHealthEvalutionServce  alloc] init];
    [service MoHugetSearchEatInfoWithParamters:dictM success:^(BATSearchFoodModel *foodModel) {
        //这里要改 为找到的食物
        _count = 0;
        //更新table的约束
       [self updateTableInside];
        
        [self.dataSource removeAllObjects];
        for (NSDictionary *dic in foodModel.Data) {
            BATHealthThreeSecondsRecommedFoodListModel *model = [BATHealthThreeSecondsRecommedFoodListModel mj_objectWithKeyValues:dic];
            
            [self.dataSource addObject:model];
        }
        
        [self.tableView bat_reloadData];
        
    } failure:^(NSError *error) {
        //请求失败显示占位视图
        [self.tableView bat_reloadData];
    }];
    
}

/**
 搜索结果请求
 */
- (void)loadSearchResultRequestWith:(NSString *)keyWord{
  
    
    _pageSize = 10;
    _currentPage = 0;
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"foodName"] = keyWord;
    dictM[@"pageSize"] = @(_pageSize);
    dictM[@"pageIndex"] = @(_currentPage);
   
    
    BATHealthEvalutionServce *service = [[BATHealthEvalutionServce  alloc] init];
    [service getSearchEatInfoWithParamters:dictM success:^(BATSearchFoodModel *foodModel) {
        
        if ([foodModel.ResultMessage isEqualToString:@"暂无数据！"]) {
            //这个时候的数据用count判读
            _count = 1;
            
            //更新table的约束
           [self updateTableInside];
        } else {
         _count = 0;
            [self updateTableInside];
        }
        [self.dataSource removeAllObjects];
        for (NSDictionary *dic in foodModel.Data) {
          BATHealthThreeSecondsRecommedFoodListModel *model = [BATHealthThreeSecondsRecommedFoodListModel mj_objectWithKeyValues:dic];
            
            [self.dataSource addObject:model];
        }
        
        [self.tableView bat_reloadData];
        
    } failure:^(NSError *error) {
        //请求失败显示占位视图
        [self.tableView bat_reloadData];
    }];

    
}

#pragma mark - lazy Load

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
//        _tableView.tableHeaderView = self.topSearchView;
        
        _tableView.separatorColor = UIColorFromHEX(0xe0e0e0, 1);
        _tableView.bat_separatorInsetEdge = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:keyWordCellId];
        [_tableView registerNib:[UINib nibWithNibName:@"BATHealthThreeSecondsFoodEnterCell" bundle:nil]  forCellReuseIdentifier:studioListCellId];
        
    }
    return _tableView;
}

- (UITextField *)navTextField{
    if (!_navTextField) {
        _navTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH  , 40)];
        _navTextField.placeholder = @"请输入食物名称~";
        [_navTextField setValue:UIColorFromHEX(0x999999, 1) forKeyPath:@"_placeholderLabel.textColor"];
        //设置光标颜色
        _navTextField.tintColor = UIColorFromHEX(0x6cc56, 1);
        _navTextField.textColor = UIColorFromHEX(0x333333, 1);
        _navTextField.backgroundColor = BASE_BACKGROUND_COLOR;
        _navTextField.returnKeyType = UIReturnKeySearch;
        //设置返回键无文字时不可点击状态
        _navTextField.enablesReturnKeyAutomatically = YES;
        _navTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _navTextField.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-search"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        _navTextField.leftView = leftIcon;
        _navTextField.leftViewMode = UITextFieldViewModeAlways;
        _navTextField.layer.cornerRadius = 2.0f;
        _navTextField.clipsToBounds = YES;
        
        _navTextField.delegate = self;
        [_navTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
 
    }
    return _navTextField;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
    }
    return _dataSource;
}

//出了这个要展示出来以外，还要更新约束，并且改变headerview展示的label的text
- (UIView *)alertViewOfME {
    
    if (!_alertViewOfME) {
        _alertViewOfME = [[UIView alloc] init];
        
        _alertViewOfME.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10, 0, SCREEN_WIDTH - 20, 40);
        label.text = @"抱歉找不到匹配的食物";
        label.numberOfLines = 0;
        _alertViewOfME.backgroundColor = [UIColor whiteColor];
        label.textColor = RGB(51, 51, 51);
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        
  
        UILabel *label1 = [[UILabel alloc] init];
        label1.frame = CGRectMake(label.centerX - 90,  13, 14, 14);
        label1.text = @"!";
        label1.backgroundColor = RGB(240, 155, 6);
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont systemFontOfSize:12];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.layer.cornerRadius = 7;
        label1.layer.masksToBounds = YES;
        [_alertViewOfME addSubview:label1];
        
        [_alertViewOfME addSubview:label];
        
    }
    return _alertViewOfME;
    
}
#pragma mark - lazy Load
- (BATHealthThreeSecondsFoodEnterAlertView *)foodEnterAlertView{
    if (!_foodEnterAlertView) {
        _foodEnterAlertView = [[BATHealthThreeSecondsFoodEnterAlertView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _foodEnterAlertView.delegate = self;
        
    }
    return _foodEnterAlertView;
}
- (BATEatSearchAlert *)alertView {
    
    if (!_alertView) {
        BATEatSearchAlert *view = [[BATEatSearchAlert alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        WEAK_SELF(self);
        
        view.cancleBlock = ^{
            STRONG_SELF(self);
            [self showNewContentView:NO];
        };
        
        view.comfirmBlock = ^{
            
            STRONG_SELF(self);
            [self addFoodDataRequest];
            [self showNewContentView:NO];
        };
        
        _alertView = view;
        
    }
    return _alertView;
}
#pragma mark - action
/** 弹出此弹窗 */
- (void)show{
}
#pragma mark - BATHealthThreeSecondsFoodEnterAlertViewDelegate
- (void)foodEnterAlertView:(BATHealthThreeSecondsFoodEnterAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex; {
    
    //跳转到饮食详情
    if (buttonIndex) {
        NSLog(@"点了确定按钮");
        [self addFoodDataRequest];
        
    }
    
}
#pragma mark - 添加(更新)食物信息
- (void)addFoodDataRequest{
    
    [self showProgressWithText:@"正在添加"];
    
    if (!self.dateStr) {
        self.dateStr = [self dateConverStr];
    }
    NSMutableDictionary *dictM0 = [NSMutableDictionary dictionary];
    [dictM0 jk_setObj:self.dateStr forKey:@"DataDate"];
    
    
    NSMutableDictionary *ditcM2 = [NSMutableDictionary dictionary];
    ditcM2[@"FoodName"] = self.recommendFoodModel.MenuName;// 食物名称
    ditcM2[@"Count"] = @(1); //食物份量
    ditcM2[@"Calories"] = self.recommendFoodModel.HeatQty; //卡路里数
    ditcM2[@"OrderNum"] = @(1); //顺序号
    ditcM2[@"ImageUrl"] = self.recommendFoodModel.PictureURL; //顺序号
    
    NSArray *array = @[ditcM2];
    
    [dictM0 jk_setObj:array forKey:@"DietList"];
    WeakSelf;
    [HTTPTool requestWithURLString:@"api/EatCircle/AddDietDetails" parameters:dictM0 type:kPOST success:^(id responseObject) {
        
        [self showSuccessWithText:@"添加成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{            
            //跳转到详情
            BATHealthThreeSecondsDetailController *detailVc = [[BATHealthThreeSecondsDetailController alloc]init];
            detailVc.date = weakSelf.dateStr;
            [weakSelf.navigationController pushViewController:detailVc animated:YES];

        });
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:error.localizedDescription];
        DDLogDebug(@"%@======",error);
    }];
    
}

- (void)dealloc{
    
    DDLogDebug(@"%s",__func__);
}
#pragma mark - custom
- (void)showNewContentView:(BOOL)isShow {
    
    BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    
    WEAK_SELF(appDelegate);
    [self.alertView mas_updateConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(appDelegate);
        if (isShow) {
            make.top.equalTo(appDelegate.window.mas_top);
        } else {
            make.top.equalTo(appDelegate.window.mas_top).offset(SCREEN_HEIGHT);
        }
    }];
    
    [UIView animateWithDuration:0.5f animations:^{
        [appDelegate.window setNeedsLayout];
        [appDelegate.window layoutIfNeeded];
    }];
    
    
}
- (NSString *)dateConverStr{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return  [formatter stringFromDate:date];
}

#pragma mark - searchBar and delegate
- (UISearchBar *)searchBar {
    if (!_searchBar) {
         _searchBar = [[UISearchBar alloc] init];
        _searchBar.backgroundColor = [UIColor clearColor];
        _searchBar.showsCancelButton = NO;
        _searchBar.tintColor = [UIColor orangeColor];
        _searchBar.placeholder = @"搜索感兴趣的内容";
        _searchBar.frame = CGRectMake(15, 0, SCREEN_WIDTH - 30, 40);
        for (UIView *subView in _searchBar.subviews) {
            if ([subView isKindOfClass:[UIView  class]]) {
                [[subView.subviews objectAtIndex:0] removeFromSuperview];
                if ([[subView.subviews objectAtIndex:0] isKindOfClass:[UITextField class]]) {
                    UITextField *textField = [subView.subviews objectAtIndex:0];
                    textField.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                    
                    //设置输入框边框的颜色
                    //                    textField.layer.borderColor = [UIColor blackColor].CGColor;
                    //                    textField.layer.borderWidth = 1;
                    
                    //设置输入字体颜色
                    //                    textField.textColor = [UIColor lightGrayColor];
                    
                    //设置默认文字颜色
                    UIColor *color = [UIColor grayColor];
                    [textField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"丸子汤"
                                                                                        attributes:@{NSForegroundColorAttributeName:color}]];
                    //修改默认的放大镜图片
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
                    imageView.backgroundColor = [UIColor clearColor];
                    imageView.image = [UIImage imageNamed:@"ic-search"];
                    textField.leftView = imageView;
                }
            }
        }
      
    }
    return _searchBar;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}
- (void)showAlertViewWithString:(NSString *)str {
    
    NSString *title = NSLocalizedString(@"Title", nil);
    NSString *message = NSLocalizedString(@"I'm message", nil);
    NSString *cancelTitle = NSLocalizedString(@"Cancel", nil);
    NSString *okTitle = NSLocalizedString(@"OK", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        NSURL *urlStr = [NSURL URLWithString:@"https://appsto.re/cn/JZj6bb.i"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] canOpenURL:urlStr]) {
                [[UIApplication sharedApplication] openURL:urlStr];
            }
        });
    }];
    // 添加取消按钮才能点击空白隐藏
    [alertController addAction:cancelAction];
    [alertController addAction:OKAction];
    
    
     BATAppDelegate *appDelegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.rootTabBarController presentViewController:alertController animated:YES completion:nil];
    
    
    
}
- (void)updateTableInside {
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.mas_equalTo(0);
        
        if (_count == 0) {
            make.top.mas_equalTo(self.topSearchView.mas_bottom);
        } else {
            make.top.mas_equalTo(self.topSearchView.mas_bottom).offset(50);
        }

    }];
    
}
@end

