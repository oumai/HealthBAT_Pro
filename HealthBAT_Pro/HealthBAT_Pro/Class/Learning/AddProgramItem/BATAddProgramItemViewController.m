//
//  BATAddProgramItemViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/3/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAddProgramItemViewController.h"
#import "BATAddProgramTimeCell.h"
#import "BATAddProgramTitleCell.h"
#import "BATAddProgramRemarkCell.h"
#import "BATAddProgramSelectTimeViewController.h"
#import "BATProgramDetailModel.h"
#import "BATClockManager.h"

@interface BATAddProgramItemViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@end

@implementation BATAddProgramItemViewController

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
    
//    WEAK_SELF(self);
//    UIBarButtonItem *submintBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"保存" style:UIBarButtonItemStyleDone handler:^(id sender) {
//        STRONG_SELF(self);
//        
//        [self requestEditSonProgramme];
//    }];
    
    UIButton *custemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [custemBtn setTitle:@"保存" forState:UIControlStateNormal];
    [custemBtn setTitleColor:UIColorFromHEX(0X6ccc56, 1) forState:UIControlStateNormal];
    [custemBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:custemBtn];
    
    
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)saveAction {
 [self requestEditSonProgramme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.addProgramItemView.tableView registerClass:[BATAddProgramTitleCell class] forCellReuseIdentifier:@"BATAddProgramTitleCell"];
    [self.addProgramItemView.tableView registerClass:[BATAddProgramTimeCell class] forCellReuseIdentifier:@"BATAddProgramTimeCell"];
    [self.addProgramItemView.tableView registerClass:[BATAddProgramRemarkCell class] forCellReuseIdentifier:@"BATAddProgramRemarkCell"];
    
    if (self.subTemplateID == 0) {
        self.title = @"添加提醒";
        self.addProgramItemView.button.hidden = YES;
    } else {
        self.title = @"修改提醒";
    }
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BATAddProgramTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAddProgramTitleCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"名称";
            cell.titleTextField.text = self.itemTitle;
            cell.titleTextField.delegate = self;
            return cell;
        } else if (indexPath.row == 1) {
            BATAddProgramTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAddProgramTimeCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"时间";
            cell.timeLabel.text = self.jobTime;
            return cell;
        }
    }
    BATAddProgramRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAddProgramRemarkCell" forIndexPath:indexPath];
    cell.titleLabel.text = @"备注";
    cell.textView.text = self.resultDesc;
    cell.textView.delegate = self;
    return cell;
}

#pragma mark - UITableViewDetegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        BATAddProgramSelectTimeViewController *selectTimeVC = [[BATAddProgramSelectTimeViewController alloc] init];
        selectTimeVC.hidesBottomBarWhenPushed = YES;
        
        WEAK_SELF(self);
        selectTimeVC.saveTime = ^(NSString *time){
            STRONG_SELF(self);
            self.jobTime = time;
            [self.addProgramItemView.tableView reloadData];
        };
        
        [self.navigationController pushViewController:selectTimeVC animated:YES];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.itemTitle = textField.text;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.resultDesc = textView.text;
}

#pragma mark - Action
- (void)modifyNotification
{
    BATClockManager *clockManager = [BATClockManager shared];
    [clockManager settingClock:self.itemTitle body:self.resultDesc clockTime:self.jobTime identifier:self.identifer nextDay:NO];
}

- (void)deleteNotification
{
    BATClockManager *clockManager = [BATClockManager shared];
    [clockManager removeClock:@[self.identifer]];
}

#pragma mark - Net
- (void)requestEditSonProgramme
{
    [self.view endEditing:YES];
    
    if (self.itemTitle.length <= 0) {
        [self showText:@"请输入名称"];
        return;
    }
    
    if (self.jobTime.length <= 0) {
        [self showText:@"请输入选择时间"];
        return;
    }
    
    if (self.resultDesc.length <= 0) {
        self.resultDesc = @"";
//        [self showText:@"请输入备注"];
//        return;
    }
    
    [self showProgress];
    [HTTPTool requestWithURLString:@"/api/trainingteacher/EditSonProgramme" parameters:@{@"EvaluationID":@(self.evaluationID),@"ID":@(self.subTemplateID),@"JobTime":self.jobTime,@"Title":self.itemTitle,@"ResultDesc":self.resultDesc} type:kPOST success:^(id responseObject) {
        [self dismissProgress];
        
        
        //开启了闹钟才会设置本地推送
        if (self.isFlag) {
            if (self.subTemplateID == 0) {
                BATProgramItem *data = [BATProgramItem mj_objectWithKeyValues:responseObject[@"Data"]];
                self.identifer = [NSString stringWithFormat:@"template_%ld_%ld",(long)self.templateID,(long)data.ID];
            }
            
            [self modifyNotification];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATRefreshProgramNotication" object:nil];
        
    } failure:^(NSError *error) {
        [self dismissProgress];
    }];
}

- (void)requestDelSonProgramme
{
    [self showProgress];
    [HTTPTool requestWithURLString:@"/api/trainingteacher/DelSonProgramme" parameters:@{@"ID":@(self.subTemplateID)} type:kGET success:^(id responseObject) {
        [self dismissProgress];
        
        [self deleteNotification];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BATRefreshProgramNotication" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [self dismissProgress];
    }];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.addProgramItemView];
    
    WEAK_SELF(self);
    [self.addProgramItemView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - get  & set
- (BATAddProgramItemView *)addProgramItemView
{
    if (_addProgramItemView == nil) {
        _addProgramItemView = [[BATAddProgramItemView alloc] init];
        _addProgramItemView.tableView.delegate = self;
        _addProgramItemView.tableView.dataSource = self;
        
        WEAK_SELF(self);
        _addProgramItemView.buttonHandle = ^(){
            STRONG_SELF(self);
            
            [self requestDelSonProgramme];
        };
    }
    return _addProgramItemView;
}

@end
