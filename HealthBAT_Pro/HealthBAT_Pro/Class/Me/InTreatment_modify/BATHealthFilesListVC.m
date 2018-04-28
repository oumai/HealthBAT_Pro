//
//  BATHealthFilesViewController.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/6/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//
static NSString *fileCellID = @"fileCell";\

#define KHexColor(stringColor) [UIColor colorForHexString:stringColor]

#import "BATHealthFilesListVC.h"
#import "BATHealthFilesCell.h"
#import "UIColor+HNExtensions.h"
#import "BATChooseEntiyModel.h"
#import "ChooseTreatmentModel.h"
#import "BATAddInTreamentViewController.h" //新增就诊人
#import "BATEditInTreatmentViewController.h"//编辑就诊人

@interface BATHealthFilesListVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *fileArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSString *beginTime;
//@property (nonatomic,strong) BATDefaultView *defaultView;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic, strong) UILabel *detaiLabel;
@end

@implementation BATHealthFilesListVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    _headerView.userInteractionEnabled = YES;
    _headerView.backgroundColor = [UIColor whiteColor];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"就诊人管理";
    self.fileArray = [NSMutableArray array];
    [self configureUI];
    
}


- (void)tapClick
{
    BATAddInTreamentViewController *vc = [BATAddInTreamentViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    [vc setRefreshBlock:^{
        
        [self.tableView.mj_header beginRefreshing];
        
    }];
}

#pragma mark ------------------------------------------------------------------UITableViewDatasource Delegate-------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fileArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATHealthFilesCell *cell = [tableView dequeueReusableCellWithIdentifier:fileCellID];
    if (nil == cell) {
        cell = [[BATHealthFilesCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fileCellID];
    }
    cell.path = indexPath;
    cell.model = self.fileArray[indexPath.row];
    
    
    [cell setSwitchBlock:^(BATHealthFilesCell*ce,NSIndexPath *path){
        
        
        for (int i =0; i<self.fileArray.count; i++) {
            ChooseTreatmentModel *model = self.fileArray[i];
            if (i==path.row) {
                if (model.isDefault) {
                    model.isDefault = YES;
                }else {
                    [self isDefaultRequestWithMember:model];
                }
            }else {
                model.isDefault = NO;
            }
        }
        [self.tableView reloadData];

        
    }];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isConsultionAndAppointmentYes == YES) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        ChooseTreatmentModel *model = self.fileArray[indexPath.row];

        if (model.IsPerfect == NO) {
            
            //把请求的传值过去
            BATEditInTreatmentViewController *vc = [BATEditInTreatmentViewController new];
            ChooseTreatmentModel *model = self.fileArray[indexPath.row];
            vc.nameString = model.name;
            vc.identityCardString = model.personID;
            vc.phoneNumberString = model.phoneNumber;
            vc.relationshipString = model.relateship;
            vc.ID = model.ID;
            vc.hidesBottomBarWhenPushed = YES;
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
            
            
            [vc setRefreshBlock:^{
                
                [self.tableView.mj_header beginRefreshing];
                
            }];
            
            return;
        }
        
        if (self.ChooseBlock) {
            self.ChooseBlock(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    else
    {
        //把请求的传值过去
        BATEditInTreatmentViewController *vc = [BATEditInTreatmentViewController new];
        ChooseTreatmentModel *model = self.fileArray[indexPath.row];
        vc.nameString = model.name;
        vc.identityCardString = model.personID;
        vc.phoneNumberString = model.phoneNumber;
        vc.relationshipString = model.relateship;
        vc.ID = model.ID;
        vc.hidesBottomBarWhenPushed = YES;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        
        
        [vc setRefreshBlock:^{
            
            [self.tableView.mj_header beginRefreshing];
            
        }];
        
    }
       
}
#pragma mark - 默认开关的设置

-(void)isDefaultRequestWithMember:(ChooseTreatmentModel *)model {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:model.memberID forKey:@"MemberID"];
    //[dict setValue:@(model.ID) forKey:@"ID"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/SetDetaultUserMember" parameters:dict type:kGET success:^(id responseObject) {
        DDLogDebug(@"%@",responseObject);
        model.isDefault = !model.isDefault;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -NET
-(void)FiledListRequest {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetUserMembers" parameters:dict type:kGET success:^(id responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        
        if (self.currentPage == 1) {
            [self.fileArray removeAllObjects];
        }
        NSLog(@"responseObject = %@",responseObject);
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
            model.age = dataModel.Age;
            model.Gender = dataModel.Gender;
            [self.fileArray addObject:model];
        }
        
//        if (self.fileArray.count == 0) {
//            [self.defaultView showDefaultView];
//        }
        if (self.fileArray.count == 5) {
            _headerView.backgroundColor = BASE_BACKGROUND_COLOR;
            _headerView.userInteractionEnabled = NO;
        }
        _detaiLabel.text = [NSString stringWithFormat:@"(已新增了%ld人，还能新增%ld人)",(long)self.fileArray.count,(long)(5-self.fileArray.count)];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
//        [self.defaultView showDefaultView];
    }];
    
}
#pragma mark - SETTER
- (void)configureUI
{
    [self.view addSubview:self.tableView];
    
    
    
    [self.headerView addSubview:self.addImageView];
    [_addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView.mas_centerY).offset(0);
        make.left.equalTo(self.headerView.mas_left).offset(10);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    
    [self.headerView addSubview:self.addLabel];
    [_addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addImageView.mas_right).offset(10);
        make.centerY.equalTo(self.headerView.mas_centerY).offset(0);
        make.width.equalTo(self.addLabel.mas_width);
        make.height.equalTo(@14);
    }];

    
    [self.headerView addSubview:self.detaiLabel];
    [_detaiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addLabel.mas_right).offset(10);
        make.centerY.equalTo(self.headerView.mas_centerY).offset(0);
        make.width.equalTo(self.detaiLabel.mas_width);
        make.height.equalTo(@14);
    }];
    
    
    
    self.currentPage = 1;
    [self.tableView.mj_header beginRefreshing];
    
    
//    [self.view addSubview:self.defaultView];
//    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.bottom.right.left.top.equalTo(self.view);
//        make.top.equalTo(self.view).offset(50);
//        make.bottom.right.left.equalTo(self.view);
//    }];
    
}

-(UITableView *)tableView {
    
    
   
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = BASE_BACKGROUND_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 150;
        _tableView.tableHeaderView = self.headerView;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[BATHealthFilesCell class] forCellReuseIdentifier:fileCellID];
        
        
        WEAK_SELF(self);
        _tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 1;
            [self FiledListRequest];
        }];
        

    }
    return _tableView;
}
- (UIView *)headerView
{
    
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,60);
        [_headerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
    }
    return _headerView;
}

- (UIImageView *)addImageView
{
    if (!_addImageView) {
        
        
        _addImageView = [UIImageView new];
        _addImageView.image = [UIImage imageNamed:@"person_add"];
       
    }
    return _addImageView;
}
- (UILabel *)addLabel
{
    if (!_addLabel) {
        
        _addLabel = [UILabel new];
        _addLabel.font = [UIFont systemFontOfSize:16];
        _addLabel.textColor = KHexColor(@"#666666");
        _addLabel.text = @"新增就诊人";
    }

    return _addLabel;
}

- (UILabel *)detaiLabel
{
    if (!_detaiLabel) {
        
        _detaiLabel = [UILabel new];
        _detaiLabel.font = [UIFont systemFontOfSize:14];
        _detaiLabel.textColor = KHexColor(@"#999999");
       
    }
    
    return _detaiLabel;
}
//- (BATDefaultView *)defaultView{
//    if (!_defaultView) {
//        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
//        _defaultView.hidden = YES;
//        WEAK_SELF(self);
//        [_defaultView setReloadRequestBlock:^{
//            STRONG_SELF(self);
//            DDLogInfo(@"=====重新开始加载！=====");
//            self.defaultView.hidden = YES;
//
//            [self.tableView.mj_header beginRefreshing];
//        }];
//
//    }
//    return _defaultView;
//}

@end



