//
//  BATTrainStudioSearchListViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/7/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioSearchListViewController.h"
#import "BATTrainStudioCourseDetailViewController.h"
#import "UITableView+SeparatorInsetEdge.h"
#import "BATTableViewPlaceHolder.h"
#import "UIButton+TouchAreaInsets.h"
#import "UIButton+ImagePosition.h"

#import "BATTrainStudioListCell.h"
#import "BATEmptyDataView.h"

#import "BATTrainStudioSearchKeyWordModel.h"
#import "BATTrainStudioListModel.h"

static NSString *const keyWordCellId = @"UITableViewCell";
static NSString *const studioListCellId = @"BATTrainStudioListCell";

@interface BATTrainStudioSearchListViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, BATTableViewPlaceHolderDelegate>
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
@end

@implementation BATTrainStudioSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setupNav];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.mas_equalTo(0);
        
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

- (void)setupNav{
    
    self.navigationItem.titleView = self.navTextField;
    [self.navTextField becomeFirstResponder];
    
    //自定义返回按钮
    UIButton *leftBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    leftBackButton.backgroundColor = [UIColor redColor];
    leftBackButton.frame = CGRectMake(0, 0,20, 30);
    
    [leftBackButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    leftBackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftBackButton addTarget:self action:@selector(leftBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    //调整左边按钮距离屏幕左边的位置
    UIBarButtonItem *nagetiveSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil action:nil];
    
    nagetiveSpacer.width = -5;
    
    UIBarButtonItem *leftBackButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBackButton];
    self.navigationItem.leftBarButtonItems = @[nagetiveSpacer, leftBackButtonItem];
    
}
- (void)leftBackButtonClick{
    
    [self.navTextField resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_isDidClickKeyWord) {
        //关键字
        UITableViewCell *keyWordCell = [tableView dequeueReusableCellWithIdentifier:keyWordCellId];
        keyWordCell.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        BATTrainStudioSearchKeyWordModel *KeyWordModel =  self.dataSource[indexPath.row];
        keyWordCell.textLabel.textColor = UIColorFromHEX(0x333333, 1);
        keyWordCell.textLabel.font = [UIFont systemFontOfSize:13];
        keyWordCell.textLabel.text = KeyWordModel.Title;
        
        return keyWordCell;
        
    }else{
        
        //搜索结果
        BATTrainStudioListCell *trainStudioListCell = [tableView dequeueReusableCellWithIdentifier:studioListCellId];
        //SubjectType = -1 表示在列表页面加载全部视频，且在全部视频列表也显示视频类型在其他类型视频列表隐藏，在搜索结果列表也显示
        trainStudioListCell.SubjectType = -1;
        trainStudioListCell.studioListModel = self.dataSource[indexPath.row];
        
        return trainStudioListCell;
        
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_isDidClickKeyWord) {
        return 44;
    }else{
        return 105;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_isDidClickKeyWord) {
        //跳转到课程详情
        
        BATTrainStudioListModel *model = self.dataSource[indexPath.row];
        BATTrainStudioCourseDetailViewController *courseDetailVc = [[BATTrainStudioCourseDetailViewController alloc]init];
        courseDetailVc.ID = model.Id;
        
        [self.navigationController pushViewController:courseDetailVc animated:YES];
        
    }else{
        
        //点击了关键字
        self.isDidClickKeyWord = YES;
        [self.navTextField resignFirstResponder];
        BATTrainStudioSearchKeyWordModel *KeyWordModel =  self.dataSource[indexPath.row];
        [self loadSearchResultRequestWith:KeyWordModel.Title];
        
    }
    
}

#pragma mark - UITextFiledDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    self.isDidClickKeyWord = YES;
    [self loadSearchResultRequestWith:textField.text];
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    self.isDidClickKeyWord = NO;
    [self.dataSource removeAllObjects];
    [self.tableView bat_reloadData];
    
    return YES;
}

#pragma mark - Request
/**
 监听 UITextFiled 文字输入
 请求搜索关键字
 */
- (void)textFieldDidChange:(UITextField *)textFiled{
    
    
    [self.dataSource removeAllObjects];
    self.isDidClickKeyWord = NO;
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"keyword"] = textFiled.text;
    //发送网络请求获取相关内容- 》刷新表格
    WeakSelf
    [HTTPTool requestWithMaintenanceURLString:@"/api/Course/BatAutoComplete" parameters:dictM type:kGET success:^(id responseObject) {
        DDLogDebug(@"%@-----",responseObject);
        
        weakSelf.dataSource =  [BATTrainStudioSearchKeyWordModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [weakSelf.tableView bat_reloadData];
        
        
    } failure:^(NSError *error) {
        //请求失败显示占位视图
        [weakSelf.tableView bat_reloadData];
    }];
    
    
}

/**
 搜索结果请求
 */
- (void)loadSearchResultRequestWith:(NSString *)keyWord{
    
    [self.dataSource removeAllObjects];
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"keyword"] = keyWord;
    
    WeakSelf
    [HTTPTool requestWithMaintenanceURLString:@"/api/Course/BatSearch" parameters:dictM type:kGET success:^(id responseObject) {
        DDLogDebug(@"%@-----",responseObject);
        
        weakSelf.dataSource =  [BATTrainStudioListModel mj_objectArrayWithKeyValuesArray:responseObject[@"Data"]];
        
        [weakSelf.tableView bat_reloadData];
        
        
    } failure:^(NSError *error) {
        
        
        //请求失败显示占位视图
        [weakSelf.tableView bat_reloadData];
    }];
    
}

#pragma mark - lazy Load

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorColor = UIColorFromHEX(0xe0e0e0, 1);
        _tableView.bat_separatorInsetEdge = UIEdgeInsetsMake(0, 10, 0, 0);
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:keyWordCellId];
        [_tableView registerClass:[BATTrainStudioListCell class] forCellReuseIdentifier:studioListCellId];
        
    }
    return _tableView;
}

- (UITextField *)navTextField{
    if (!_navTextField) {
        _navTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH  , 35)];
        _navTextField.placeholder = @"搜索护理课程~";
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

- (void)dealloc{
    
    DDLogDebug(@"%s",__func__);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
