//
//  BATMyProjectController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyProjectController.h"
#import "BATHeaderView.h"
#import "BATProjectCell.h"
#import "BATMyProgrammesModel.h"
#import "BATProgrammesTypeModel.h"
#import "BATRightTableView.h"
#import "BATDefaultView.h"
#import "BATProgramDetailViewController.h"

@interface BATMyProjectController ()<BATHeaderViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,BATProjectCellDelegate>
@property (nonatomic,strong) BATHeaderView *headerView;
@property (nonatomic,strong) UIScrollView *backScro;
@property (nonatomic,strong) UITableView *leftTab;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *leftArr;
@property (nonatomic,strong) BATMyProgrammesModel *model;
@property (nonatomic,strong) BATProgrammesTypeModel *typeModel;

@property (nonatomic,strong) BATRightTableView *rightTableView;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATMyProjectController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    
    [self.leftTab.mj_header beginRefreshing];
    
    [self GetProgrammesTypeRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"BATRefreshSelectProgramListNotification" object:nil];
    
}



- (void)pageLayout {
    
    self.leftArr = [NSMutableArray array];
    
    self.title = @"我的方案";
    self.headerView = [[BATHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    self.headerView.delegate = self;
    [self.headerView.chatBtn setTitle:@"已选方案" forState:UIControlStateNormal];
    [self.headerView.bookBtn setTitle:@"更多方案" forState:UIControlStateNormal];
    [self.headerView selectPages:0];
    [self.view addSubview:self.headerView];
    
    self.backScro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
    self.backScro.delegate = self;
    [self.backScro setContentSize:CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 45)];
    self.backScro.pagingEnabled = YES;
    [self.view addSubview:self.backScro];
    
    [self.backScro addSubview:self.leftTab];
    
    self.rightTableView = [[BATRightTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 45)];
    [self.backScro addSubview:self.rightTableView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    [self.view addSubview:lineView];
    
    [self.headerView setLineViewPostionWihPage:1];
    [self.backScro setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];


}

#pragma mark - UITableViewDelegate 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.Data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    BATProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
    cell.delegate = self;
    [cell.clickBtn setImage:[UIImage imageNamed:@"ic-scya"] forState:UIControlStateNormal];
    cell.model = self.model.Data[indexPath.row];
    cell.pathRow = indexPath;
    cell.stateLabel.hidden = YES;
    cell.subTitle.hidden = NO;
    cell.clickBtn.hidden = NO;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BATProgramDetailViewController *programDetailVC = [[BATProgramDetailViewController alloc] init];
    
    ProgrammesData *data = self.model.Data[indexPath.row];
    programDetailVC.templateID = data.ID;
    programDetailVC.isFromTest = NO;
    programDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:programDetailVC animated:YES];
}

//删除代理事件
#pragma mark - BATProjectCellDelegate
- (void)BATProjectCellClickAction:(NSInteger)row {
    
    WEAK_SELF(self)
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定放弃方案吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        STRONG_SELF(self);
        [self requestDelProgramme:row];
        
    }];
    
    // Add the actions.
    [alertController addAction:otherAction];
    [alertController addAction:cancelAction];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];

    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    NSInteger currentCount = scrollView.contentOffset.x/SCREEN_WIDTH;
    switch (currentCount) {
        case 0:
            [self.headerView setLineViewPostionWihPage:0];
            break;
        case 1:
            [self.headerView setLineViewPostionWihPage:1];
            break;
        default:
            break;
    }

}

#pragma mark - BATHeaderViewDelegate
- (void)BATHeaderViewSeleWithPage:(NSInteger)pages {
 
    switch (pages) {
        case 0: {
            [self.headerView setLineViewPostionWihPage:0];
            [UIView animateWithDuration:0.3 animations:^{
                [self.backScro setContentOffset:CGPointMake(0, 0)];
            }];
        }
            break;
        case 1: {
            [self.headerView setLineViewPostionWihPage:1];
            [UIView animateWithDuration:0.3 animations:^{
                 [self.backScro setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Notification
- (void)refresh:(NSNotification *)notif
{
    [self.headerView setLineViewPostionWihPage:0];
    [UIView animateWithDuration:0.3 animations:^{
        [self.backScro setContentOffset:CGPointMake(0, 0)];
    }];
    [self.leftTab.mj_header beginRefreshing];
}

#pragma mark - NET
- (void)GetProgrammesTypeRequest {
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetProgrammesType" parameters:nil type:kGET success:^(id responseObject) {
        self.typeModel = [BATProgrammesTypeModel mj_objectWithKeyValues:responseObject];
        NSLog(@"%@",responseObject);
        ProgrammesType *typeModel = self.typeModel.Data[0];
        typeModel.isSelect = YES;
        [self.rightTableView setLeftTableViewModel:self.typeModel];
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestDelProgramme:(NSInteger)row
{
    
    ProgrammesData * data = self.model.Data[row];
    
    [HTTPTool requestWithURLString:@"/api/trainingteacher/DelProgramme" parameters:@{@"templateID":@(data.ID)} type:kGET success:^(id responseObject) {
        
        [self GetMyProgrammesRequest];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATRefreshMoreProgramListNotification" object:nil];
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)GetMyProgrammesRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@(10) forKey:@"pageSize"];
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetMyProgrammes" parameters:dict type:kGET success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self.leftTab.mj_header endRefreshing];
        [self.leftTab.mj_footer endRefreshing];
        
        self.model = [BATMyProgrammesModel mj_objectWithKeyValues:responseObject];
        [self.leftTab reloadData];
        if (self.model.Data.count == 0) {
            self.defaultView.hidden = NO;
        }else {
            self.defaultView.hidden = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - lazy load
- (UITableView *)leftTab {

    if (!_leftTab) {
        _leftTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -45) style:UITableViewStylePlain];
        _leftTab.delegate = self;
        _leftTab.dataSource = self;
        [_leftTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_leftTab registerNib:[UINib nibWithNibName:@"BATProjectCell" bundle:nil] forCellReuseIdentifier:@"leftCell"];
        
        WEAK_SELF(self)
        _leftTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self GetMyProgrammesRequest];
        }];
        
        
        _leftTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self)
            self.currentPage ++ ;
            [self GetMyProgrammesRequest];
        }];
        
        _leftTab.mj_footer.hidden = YES;

    }
    return _leftTab;
}

- (BATDefaultView *)defaultView {

    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectMake(0, 45 - 64, SCREEN_WIDTH - 50, 300)];
        _defaultView.backgroundColor = [UIColor whiteColor];
        _defaultView.center = self.view.center;
        [_defaultView changeDefaultStyleOfShowReloadButtonForNoNet:NO andRequsetStateError:NO];
        _defaultView.imageV.image = [UIImage imageNamed:@"无数据"];
        _defaultView.titleLabel.text = @"请先添加方案";
        _defaultView.reloadButton.hidden = NO;
        _defaultView.reloadButton.backgroundColor = BASE_COLOR;
        [_defaultView.reloadButton setTitleColor:UIColorFromHEX(0Xffffff, 1) forState:UIControlStateNormal];
        _defaultView.reloadButton.layer.borderColor = BASE_COLOR.CGColor;
        _defaultView.reloadButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_defaultView.reloadButton setTitle:@"立即添加" forState:UIControlStateNormal];
        
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            [self.headerView.bookBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }];
        _defaultView.hidden = YES;
        [self.backScro addSubview:_defaultView];
    }
    return _defaultView;
}



@end
