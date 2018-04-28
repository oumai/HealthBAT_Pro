//
//  ViewController.m
//  BATmySelfIntreatmentController
//
//  Created by kmcompany on 16/10/9.
//  Copyright © 2016年 kmcompany. All rights reserved.
//

#import "BATSelfDiagnosisController.h"

#import "leftTabCell.h"

#import "rightCell.h"

#import "BATSelfDiagnosisModel.h"
#import "BATSearchViewController.h"

#import "UINavigationController+FDFullscreenPopGesture.h"
#import "MQChatViewManager.h"

#import "BATSearchDieaseDetailController.h"


@interface BATSelfDiagnosisController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *leftTab;
@property (nonatomic,strong) UITableView *rightTab;
@property (nonatomic,strong) NSMutableArray *leftArr;
@property (nonatomic,strong) NSMutableArray *rightArr;
@property (nonatomic,strong) BATSelfDiagnosisModel *diagnosisModel;
@property (nonatomic,assign) NSInteger segNums;
@property (nonatomic,assign) NSInteger rowNmus;
@property (nonatomic,assign) NSInteger leftCounts;
@property (nonatomic,assign) NSInteger realNums;

@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,assign) BOOL isPopAction;

@property (nonatomic,strong) NSString *dieaseName;
@property (nonatomic,strong) NSString *dieaseType;
@property (nonatomic,strong) NSString *mainType;

@property (nonatomic,strong) UIImageView *titleImageView;
@end

@implementation BATSelfDiagnosisController

static NSString * const leftCell = @"LEFTCELL";
static NSString * const rightCells = @"RIGHTCELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    
    [self selfdDiagnosisRequest];
    
}

-(void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    if (self.isPopAction) {
        [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"首页-自我诊断" moduleId:5 beginTime:self.beginTime];
    }
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;

   // [TalkingData trackPageEnd:@"自我诊断"];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTab) {
        for (int i=0; i<[[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList] count]; i++) {
            Partsitemlist *model = [self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][i];
            if (model.isSelect) {
                self.rowNmus = i;
                break;
            }
        }
        return [[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList] count];
    }else {
        //为防止数组越界，加此判断，此后的循环是为了找到之前左边tableview的标记
        if (self.rowNmus >= self.leftCounts) {
            for (int i=0; i<[[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList] count]; i++) {
                Partsitemlist *model = [self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][i];
                if (model.isSelect) {
                    self.realNums = i;
                    self.rowNmus = i;
                    break;
                }
            }
        }else {
            self.realNums = self.rowNmus;
        }
        return [[[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][self.realNums] disList] count];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTab) {
        leftTabCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCell];
        if (cell == nil) {
            cell = [[leftTabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCell];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = [self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][indexPath.row];
        return cell;
    }else {
        rightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCells];
        if (cell == nil) {
            cell = [[rightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCells];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.rightModels = [[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][self.realNums] disList][indexPath.row];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTab) {
        for (int i=0; i<[[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList] count]; i++) {
            Partsitemlist *model = [self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][i];
            if (i==indexPath.row) {
                model.isSelect = YES;
                self.dieaseType = model.ItemName;
            }else {
                model.isSelect = NO;
            }
        }
        
        self.rowNmus = indexPath.row;
        
        [self.leftTab reloadData];
        [self.rightTab reloadData];
    }else {
        self.isPopAction = NO;
        for (int i=0; i<[[[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][self.rowNmus] disList] count ]; i++) {
            Dislist *model = [[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][self.rowNmus] disList][i];
            if (i==indexPath.row) {
                model.isSelect = YES;
                self.dieaseName = model.DisName;
            }else {
                model.isSelect = NO;
            }
        }
        
        [self.rightTab reloadData];
//        
        Dislist *model = [[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][self.rowNmus] disList][indexPath.row];
//
//        NSArray *welcomTextArray = @[@"欢迎您光临，身体有什么不舒服吗？",@"您好，最近身体有什么不适症状吗？",@"您好，最近怎样？身体有什么不适症状吗？",@"您好，哪不舒服？"];
//        
//        MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
//        [chatViewManager setNavTitleText:@"小美"];
//        [chatViewManager setincomingDefaultAvatarImage:[UIImage imageNamed:@"机器人头像"]];
//        [chatViewManager setoutgoingDefaultAvatarImage:[UIImage imageNamed:@"personalCenter_defaultAvator"]];
//        [chatViewManager enableChatWelcome:YES];
//        [chatViewManager setChatWelcomeText:welcomTextArray[[Tools getRandomNumber:0 to:3]]];
//        [chatViewManager setIsSearchDisease:YES];
//        [chatViewManager enableShowNewMessageAlert:NO];
//        [chatViewManager enableTopAutoRefresh:NO];
//        [chatViewManager enableTopPullRefresh:NO];
//        [chatViewManager setFirstMessage:model.DisName];
//
//
//        chatViewManager.chatViewStyle.enableRoundAvatar = YES;
//        chatViewManager.chatViewStyle.navBarRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        chatViewManager.chatViewStyle.outgoingBubbleImage = [UIImage imageNamed:@"蓝色对话框"];
//        chatViewManager.chatViewStyle.incomingBubbleImage = [UIImage imageNamed:@"灰色对话框"];
//        chatViewManager.chatViewStyle.outgoingMsgTextColor = UIColorFromHEX(0xffffff, 1);
//        chatViewManager.chatViewStyle.incomingMsgTextColor = UIColorFromHEX(0x333333, 1);
//
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [backButton setFrame:CGRectMake(0, 0, 50, 50)];
//        [backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
//        chatViewManager.chatViewStyle.navBarLeftButton = backButton;
//        
//        [chatViewManager pushMQChatViewControllerInViewController:self];


        BATSearchDieaseDetailController *searchDieaseCtl = [[BATSearchDieaseDetailController alloc]init];
        //            searchDieaseCtl.resultDesc = @"";
        searchDieaseCtl.DieaseID = model.ID;
        searchDieaseCtl.EntryCNName = @"";
        //            searchDieaseCtl.pathName = @"";
        searchDieaseCtl.titleName = @"疾病百科";
        [self.navigationController pushViewController:searchDieaseCtl animated:YES];



//        BATDieaseDetailController *dieaseVC = [BATDieaseDetailController new];
//        dieaseVC.EntryCNName = model.DisName;
//        dieaseVC.DieaseID = model.ID;
//        dieaseVC.isSaveUserOperaAction = YES;
//        dieaseVC.pathName = [NSString stringWithFormat:@"首页-自我诊断-%@-%@-%@",self.mainType,self.dieaseType,self.dieaseName];
//        [self.navigationController pushViewController:dieaseVC animated:YES];
    }
}

#pragma mark -Action
-(void)typeChangeAction:(UIButton *)seg {
    self.segNums = seg.tag;
    
    switch (seg.tag) {
        case 0:
            self.mainType = @"典型人群";
            self.titleImageView.image = [UIImage imageNamed:@"btn-dxrq"];
            break;
        case 1:
            self.mainType = @"科室分类";
            self.titleImageView.image = [UIImage imageNamed:@"btn-ksfl"];
            break;
        default:
            break;
    }
//    self.rowNmus = 0;
//    
//    for (int i=0; i<[[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList] count]; i++) {
//        Partsitemlist *model = [self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][i];
//        if (i==0) {
//            model.isSelect = YES;
//        }else {
//            model.isSelect = NO;
//        }
//    }
//    
//    for (int i=0; i<[[[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][self.rowNmus] disList] count ]; i++) {
//        Dislist *model = [[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList][self.rowNmus] disList][i];
//        if (i==0) {
//            model.isSelect = YES;
//        }else {
//            model.isSelect = NO;
//        }
//    }
    
    [self.leftTab reloadData];
    [self.rightTab reloadData];
}


//-(void)moreSearchAction {
//
//    BATSearchViewController *seachVC = [BATSearchViewController new];
//    [self.navigationController pushViewController:seachVC animated:YES];
//    
//}

#pragma mark -NET 
-(void)selfdDiagnosisRequest {
    
   [HTTPTool requestWithURLString:@"/api/common/GetHealthCheckConfigRedis" parameters:nil type:kGET success:^(id responseObject) {

       self.diagnosisModel = [BATSelfDiagnosisModel mj_objectWithKeyValues:responseObject];
       [[self.diagnosisModel.Data.partsCategoryList[0] partsItemList][0] setIsSelect:YES];
       [[self.diagnosisModel.Data.partsCategoryList[1] partsItemList][0] setIsSelect:YES];
       
       self.leftCounts = [[self.diagnosisModel.Data.partsCategoryList[self.segNums] partsItemList] count];
       
       [self.leftTab reloadData];
       [self.rightTab reloadData];
   } failure:^(NSError *error) {
       
   }];
    
}


#pragma mark - pageLayout
-(void)pageLayout {
    
    self.isPopAction = YES;
    self.mainType = @"典型人群";
    self.dieaseType = @"高发疾病";
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];

//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic-search"] style:UIBarButtonItemStylePlain target:self action:@selector(moreSearchAction)];
    
//    NSArray *nameArrs = @[@"典型人群",@"科室分类"];
//    UISegmentedControl *segCtl = [[UISegmentedControl alloc]initWithItems:nameArrs];
//    segCtl.tintColor = BASE_COLOR;
//    segCtl.frame = CGRectMake(0, 0, 188, 28);
//    [segCtl setSelectedSegmentIndex:0];
//    [segCtl addTarget:self action:@selector(typeChangeAction:) forControlEvents:UIControlEventValueChanged];
//    self.navigationItem.titleView = segCtl;
    self.titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.titleImageView.image = [UIImage imageNamed:@"btn-dxrq"];
    self.titleImageView.userInteractionEnabled = YES;
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    leftBtn.tag = 0;
    [leftBtn addTarget:self action:@selector(typeChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImageView addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 100, 30)];
    rightBtn.tag = 1;
    [rightBtn addTarget:self action:@selector(typeChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImageView addSubview:rightBtn];
    
    self.navigationItem.titleView = _titleImageView;
    
}

#pragma mark - SETTER - GETTER
-(UITableView *)leftTab {
    if (!_leftTab) {
        _leftTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 140, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _leftTab.delegate = self;
        _leftTab.dataSource = self;
        _leftTab.backgroundColor = UIColorFromHEX(0Xf0f0f0, 1);
        [_leftTab registerClass:[leftTabCell class] forCellReuseIdentifier:leftCell];
        [_leftTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_leftTab];
    }
    return _leftTab;
}

-(UITableView *)rightTab {
    if (!_rightTab) {
        _rightTab = [[UITableView alloc]initWithFrame:CGRectMake(140, 0, SCREEN_WIDTH-140, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _rightTab.delegate = self;
        _rightTab.dataSource = self;
        [_rightTab registerClass:[rightCell class] forCellReuseIdentifier:rightCells];
        [_rightTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.view addSubview:_rightTab];
    }
    return _rightTab;
}

-(NSMutableArray *)leftArr {
    if (!_leftArr) {
        _leftArr = [NSMutableArray array];
    }
    return _leftArr;
}

-(NSMutableArray *)rightArr {
    if (!_rightArr) {
        _rightArr = [NSMutableArray array];
    }
    return _rightArr;
}

@end
