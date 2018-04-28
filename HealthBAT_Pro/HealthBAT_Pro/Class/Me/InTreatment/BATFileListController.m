//
//  BATFileListController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFileListController.h"
#import "BATFileCell.h"
#import "BATEditFileController.h"
#import "BATEditDetailController.h"
#import "BATChooseEntiyModel.h"
#import "ChooseTreatmentModel.h"
@interface BATFileListController ()<UITableViewDelegate,UITableViewDataSource,BATFileCellDelegate>
@property (nonatomic,strong) UITableView *FileTableView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *fileArr;
@property (nonatomic,strong) NSString *beginTime;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATFileListController

static NSString * const FileCell = @"FILECELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    
}

-(void)viewWillDisappear:(BOOL)animated {
  
    [super viewWillDisappear:animated];
     [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"个人中心-就诊人管理" moduleId:4 beginTime:self.beginTime];
}

-(void)pageLayout {
    
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    _fileArr = [NSMutableArray array];
    
    [self.view addSubview:self.FileTableView];
    
    self.currentPage = 1;
    [self.FileTableView.mj_header beginRefreshing];
    
    self.title = @"档案管理";
    
  //  WEAK_SELF(self);
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn setImage:[UIImage imageNamed:@"icon-tthy"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(pushToEditVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItme = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = barItme;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon-tthy"] style:UIBarButtonItemStylePlain handler:^(id sender) {
//        STRONG_SELF(self);
//        if (self.fileArr.count == 5) {
//            [self showText:@"超出档案规定数量"];
//            return;
//        }
//        BATEditDetailController *editVC = [[BATEditDetailController alloc]init];
//        editVC.isAdd = YES;
//        [editVC setRefreshBlock:^{
//            [self.FileTableView.mj_header beginRefreshing];
//        }];
//        [self.navigationController pushViewController:editVC animated:YES];
//    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
}

- (void)pushToEditVC {
    if (self.fileArr.count == 5) {
        [self showText:@"超出档案规定数量"];
        return;
    }
    BATEditDetailController *editVC = [[BATEditDetailController alloc]init];
    editVC.isAdd = YES;
    [editVC setRefreshBlock:^{
        [self.FileTableView.mj_header beginRefreshing];
    }];
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 185;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BATFileCell *cell = [tableView dequeueReusableCellWithIdentifier:FileCell];
    if (cell == nil) {
        cell = [[BATFileCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FileCell];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.delegate = self;
    cell.path = indexPath;
    cell.model = self.fileArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.ChooseBlock) {
        ChooseTreatmentModel *model = self.fileArr[indexPath.row];
        self.ChooseBlock(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
//    BATFileCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [self BATFileCellEdit:cell IndexPath:indexPath];

}

#pragma mark - BATFileCellDelegate
//设置默认就诊人
-(void)BATFileCellSetDefault:(BATFileCell *)cell IndexPath:(NSIndexPath *)pathRows {
    for (int i =0; i<self.fileArr.count; i++) {
        ChooseTreatmentModel *model = self.fileArr[i];
        if (i==pathRows.row) {
            if (model.isDefault) {
                model.isDefault = YES;
            }else {
                [self isDefaultRequestWithMember:model];
            }
        }else {
            model.isDefault = NO;
        }
    }
    [self.FileTableView reloadData];
}

-(void)isDefaultRequestWithMember:(ChooseTreatmentModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:model.memberID forKey:@"MemberID"];
    [dict setValue:@(model.ID) forKey:@"ID"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/SetDetaultUserMember" parameters:dict type:kGET success:^(id responseObject) {
        DDLogDebug(@"%@",responseObject);
        model.isDefault = !model.isDefault;
        [self.FileTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
//编辑点击事件
-(void)BATFileCellEdit:(BATFileCell *)cell IndexPath:(NSIndexPath *)pathRows {
    
    ChooseTreatmentModel *model = self.fileArr[pathRows.row];
    if (pathRows.row >0) {
        BATEditDetailController *editVC = [[BATEditDetailController alloc]init];
        editVC.isAdd = NO;
        editVC.model = model;
        [editVC setRefreshBlock:^{
            [self.FileTableView.mj_header beginRefreshing];
        }];
        [self.navigationController pushViewController:editVC animated:YES];
    }else {
        BATEditFileController *editFiledVC = [[BATEditFileController alloc]init];
        editFiledVC.model = model;
        [editFiledVC setRefreshBlock:^{
            [self.FileTableView.mj_header beginRefreshing];
        }];
        [self.navigationController pushViewController:editFiledVC animated:YES];
    }
   
    
}

#pragma mark -NET
-(void)FiledListRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetUserMembers" parameters:dict type:kGET success:^(id responseObject) {
        
        [self.FileTableView.mj_header endRefreshing];
        
        if (self.currentPage == 1) {
            [self.fileArr removeAllObjects];
        }
        
        
        BATChooseEntiyModel *model = [BATChooseEntiyModel mj_objectWithKeyValues:responseObject];
        for (MyResData *dataModel in model.Data) {
            ChooseTreatmentModel *model = [ChooseTreatmentModel new];
            model.name = dataModel.MemberName;
            switch (dataModel.Relation) {
                case 0:
                    model.relateship = @"本人";
                    break;
                case 1:
                    model.relateship = @"配偶";
                    break;
                case 2:
                    model.relateship = @"父亲";
                    break;
                case 3:
                    model.relateship = @"母亲";
                    break;
                case 4:
                    model.relateship = @"儿子";
                    break;
                case 5:
                    model.relateship = @"女儿";
                    break;
                case 6:
                    model.relateship = @"其他";
                    break;
                default:
                    break;
            }
            model.Sex = dataModel.Sex;
            model.phoneNumber = dataModel.Mobile;
            model.personID = dataModel.IDNumber;
            model.isDefault = dataModel.IsDefault;
            model.memberID = dataModel.MemberID;
            model.userID = dataModel.UserID;
            model.ages = dataModel.Ages;
            model.height = dataModel.Height;
            model.weight = dataModel.Weight;
            model.photoPath = dataModel.PhotoPath;
            model.IsPerfect = dataModel.IsPerfect;
            model.Exercise = dataModel.Exercise;
            model.Dietary = dataModel.Dietary;
            model.Sleep = dataModel.Sleep;
            model.Mentality = dataModel.Mentality;
            model.Working = dataModel.Working;
            model.ID = dataModel.ID;
            [self.fileArr addObject:model];
        }
        
        if (self.fileArr.count == 0) {
            [self.defaultView showDefaultView];
        }
        [self.FileTableView reloadData];
    } failure:^(NSError *error) {
        [self.FileTableView.mj_header endRefreshing];
        [self.defaultView showDefaultView];
    }];
    
}

#pragma mark - SETTER
-(UITableView *)FileTableView {
    if (!_FileTableView) {
        _FileTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _FileTableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _FileTableView.delegate = self;
        _FileTableView.dataSource = self;
        [_FileTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_FileTableView registerClass:[BATFileCell class] forCellReuseIdentifier:FileCell];
        WEAK_SELF(self)
        _FileTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 1;
            [self FiledListRequest];
        }];
    }
    return _FileTableView;
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
            
            [self.FileTableView.mj_header beginRefreshing];
        }];
        
    }
    return _defaultView;
}
@end
