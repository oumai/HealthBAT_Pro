//
//  BATRightTableView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/28.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATRightTableView.h"
#import "BATProjectCell.h"
#import "BATProgrammesTypeCell.h"
@interface BATRightTableView()<UITableViewDelegate,UITableViewDataSource,BATProjectCellDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) BATProgrammesTypeModel *typeModel;
@property (nonatomic,strong) BATMyProgrammesModel *model;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) NSInteger clickRow;
@end

@implementation BATRightTableView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.leftTableView];
        [self addSubview:self.rightTableView];
        
        WEAK_SELF(self);
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(80);
            make.top.bottom.equalTo(self).offset(0);
            make.width.mas_equalTo(1);
            
        }];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"BATRefreshMoreProgramListNotification" object:nil];

        
        
    }
    return self;

}


- (void)setLeftTableViewModel:(BATProgrammesTypeModel *)typeModel {
 
    self.typeModel = typeModel;
    [self.leftTableView reloadData];
    
    [self GetMoreProgrammesRequest];
    
}

#pragma mark - Notification
- (void)refresh:(NSNotification *)notif
{
    [self.rightTableView.mj_header beginRefreshing];
}

#pragma mark - NET
- (void)GetMoreProgrammesRequest {
    
    ProgrammesType *typeModel = self.typeModel.Data[self.selectIndex];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:typeModel.CategoryID forKey:@"categoryID"];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];
    
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetMoreProgrammes" parameters:dict type:kGET success:^(id responseObject) {
        
        [self.rightTableView.mj_footer endRefreshing];
        [self.rightTableView.mj_header endRefreshing];
        
        self.model  = [BATMyProgrammesModel mj_objectWithKeyValues:responseObject];
        
        if (self.model.Data.count == self.model.RecordsCount) {
            self.rightTableView.mj_footer.hidden = NO;
            [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.rightTableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

- (void)requestInsertProgramme:(NSInteger)row
{
    
    ProgrammesData * data = self.model.Data[row];
    
    [HTTPTool requestWithURLString:@"/api/trainingteacher/InsertProgramme" parameters:@{@"templateID":@(data.ID)} type:kGET success:^(id responseObject) {
        
        [self GetMoreProgrammesRequest];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATRefreshSelectProgramListNotification" object:nil];
        
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.leftTableView) {
        return self.typeModel.Data.count;
    }
    return self.model.Data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (tableView == self.leftTableView) {
        
        BATProgrammesTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.typeModel = self.typeModel.Data[indexPath.row];
        return cell;

    }else {
    
        BATProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        cell.model = self.model.Data[indexPath.row];
        [cell.subTitle setTitle:@"添加" forState:UIControlStateNormal];
        
        cell.subTitle.hidden = cell.model.IsFlag;
        cell.clickBtn.hidden = cell.model.IsFlag;
        cell.stateLabel.hidden = !cell.model.IsFlag;
        cell.pathRow = indexPath;
        [cell.clickBtn setImage:[UIImage imageNamed:@"ic-tj"] forState:UIControlStateNormal];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (tableView == self.rightTableView) {
        return 85;
    }
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.leftTableView) {
        
        for (ProgrammesType *model in self.typeModel.Data) {
            model.isSelect = NO;
        }
        
        ProgrammesType *model = self.typeModel.Data[indexPath.row];
        model.isSelect = YES;
        
        self.selectIndex = indexPath.row;
        self.currentPage = 0;
        
        [self.leftTableView reloadData];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:model.CategoryID forKey:@"categoryID"];
        [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
        [dict setValue:@"10" forKey:@"pageSize"];
        
        [HTTPTool requestWithURLString:@"/api/trainingteacher/GetMoreProgrammes" parameters:dict type:kGET success:^(id responseObject) {
            self.model  = [BATMyProgrammesModel mj_objectWithKeyValues:responseObject];
            [self.rightTableView reloadData];
        } failure:^(NSError *error) {
            
        }];
    
    }
}

//添加方案代理
#pragma mark - BATProjectCellDelegate 
- (void)BATProjectCellClickAction:(NSInteger)row {
    
    self.clickRow = row;
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否添加该方案?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    WEAK_SELF(self);
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        STRONG_SELF(self)
        [self requestInsertProgramme:self.clickRow];
    }];
    
    // Add the actions.
    [alter addAction:cancelAction];
    [alter addAction:otherAction];
    
    [[Tools getCurrentVC] presentViewController:alter animated:YES completion:nil];
    
//    UIAlertController *alter = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否添加该方案?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    [alter show];
   
}

#pragma mark  - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 
    if (buttonIndex == 1) {
         [self requestInsertProgramme:self.clickRow];
    }
}

#pragma mark - Lazy load
- (UITableView *)rightTableView {

    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 80, SCREEN_HEIGHT - 45) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        [_rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_rightTableView registerNib:[UINib nibWithNibName:@"BATProjectCell" bundle:nil] forCellReuseIdentifier:@"rightCell"];
        
        WEAK_SELF(self)
        _rightTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self GetMoreProgrammesRequest];
        }];
        
        
        _rightTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self)
            self.currentPage ++ ;
            //            [self videoRequest];
        }];
        
        _rightTableView.mj_footer.hidden = YES;
    }
    return _rightTableView;

}

- (UITableView *)leftTableView {
    
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, SCREEN_HEIGHT - 45) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        [_leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_leftTableView registerClass:[BATProgrammesTypeCell class] forCellReuseIdentifier:@"leftCell"];
    }
    return _leftTableView;
    
}

- (UIView *)lineView {

    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _lineView;
}

@end

