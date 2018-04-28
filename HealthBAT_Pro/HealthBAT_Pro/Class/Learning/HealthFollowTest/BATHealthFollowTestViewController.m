//
//  BATHealthFollowTestViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowTestViewController.h"
#import "BATHealthFollowTestTableViewCell.h"
#import "BATTemplateModel.h"
#import "BATProgramDetailViewController.h"
#import "BATProgramDetailModel.h"

@interface BATHealthFollowTestViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BATTemplateModel *templateModel;

@end

@implementation BATHealthFollowTestViewController

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self requestGetSubjectLst];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.healthFollowTestView.tableView registerClass:[BATHealthFollowTestTableViewCell class] forCellReuseIdentifier:@"BATHealthFollowTestTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _templateModel.Data.Questionlst.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATHealthFollowTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATHealthFollowTestTableViewCell" forIndexPath:indexPath];
    
    if (_templateModel.Data.Questionlst.count > 0) {
        BATQuestion *question = _templateModel.Data.Questionlst[indexPath.row];
        [cell configData:question indexPath:indexPath];
        
    }
    
    return cell;
}

#pragma mark - Net
- (void)requestGetSubjectLst
{
    
    [self showProgress];
    
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetSubjectLst" parameters:@{@"courseID":@(self.courseID)} type:kGET success:^(id responseObject) {
        
        [self dismissProgress];
        
        _templateModel = [BATTemplateModel mj_objectWithKeyValues:responseObject];
        
        [self.healthFollowTestView.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self dismissProgress];
    }];
}

- (void)requestGetResult
{
    [self showProgress];
    [HTTPTool requestWithURLString:@"/api/trainingteacher/GetResult" parameters:@{@"templateID":@(self.templateModel.Data.ID)} type:kGET success:^(id responseObject) {
        [self dismissProgress];
        
        NSInteger totalQuestion = self.templateModel.Data.Questionlst.count;
        
        float score = 0;
        
        for (int i = 0; i < totalQuestion; i++) {
            BATQuestion *question = self.templateModel.Data.Questionlst[i];
            for (BATQuestionAnswerItem *item in question.QuestionItemLst) {
                if (item.isSelect) {
                    score += item.ItemScore;
                }
            }
        }
        
        DDLogDebug(@"totalQuestion %ld, score %.0f percentage %.0f%%",(long)totalQuestion,score,score / totalQuestion * 100);
        
        BATProgramDetailViewController *programDetailVC = [[BATProgramDetailViewController alloc] init];
        programDetailVC.templateID = self.templateModel.Data.ID;
        programDetailVC.persentage = score / totalQuestion;
        programDetailVC.isFromTest = YES;
        programDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:programDetailVC animated:YES];
        
    } failure:^(NSError *error) {
        [self dismissProgress];
    }];
}


#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.healthFollowTestView];
    
    WEAK_SELF(self);
    [self.healthFollowTestView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATHealthFollowTestView *)healthFollowTestView
{
    if (_healthFollowTestView == nil) {
        _healthFollowTestView = [[BATHealthFollowTestView alloc] init];
        _healthFollowTestView.tableView.rowHeight = UITableViewAutomaticDimension;
        _healthFollowTestView.tableView.estimatedRowHeight = 100;
        _healthFollowTestView.tableView.delegate = self;
        _healthFollowTestView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        _healthFollowTestView.submitAction = ^(){
            STRONG_SELF(self);
            
            [self requestGetResult];
        };
    }
    return _healthFollowTestView;
}

@end
