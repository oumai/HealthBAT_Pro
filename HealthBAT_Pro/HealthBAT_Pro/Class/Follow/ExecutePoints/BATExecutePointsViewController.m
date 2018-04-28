//
//  BATExecutePointsViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATExecutePointsViewController.h"
#import "BATExecutePointsTitleTableViewCell.h"
#import "BATExecutePointContentTableViewCell.h"

@interface BATExecutePointsViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation BATExecutePointsViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *closeButton = [[UIButton  alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    [closeButton setImage:[UIImage imageNamed:@"Follow_Close_ZXYD"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.executePointsView.tableView registerNib:[UINib nibWithNibName:@"BATExecutePointsTitleTableViewCell" bundle:nil
                                                   ] forCellReuseIdentifier:@"BATExecutePointsTitleTableViewCell"];
    
    [self.executePointsView.tableView registerNib:[UINib nibWithNibName:@"BATExecutePointContentTableViewCell" bundle:nil
                                                   ] forCellReuseIdentifier:@"BATExecutePointContentTableViewCell"];
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
    return self.programDetailModel.Data.PlanLst.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        BATExecutePointsTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATExecutePointsTitleTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"执行要点";
        return cell;
    }
    
    BATExecutePointContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATExecutePointContentTableViewCell" forIndexPath:indexPath];
    
    BATPlanItem *item = _programDetailModel.Data.PlanLst[indexPath.row  - 1];
    
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zd、%@",indexPath.row,item.Explain]];
//    
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.lineSpacing = 20;
//    
//    [string addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length - 1)];
    
    cell.contentLabel.text = [NSString stringWithFormat:@"%zd、%@",indexPath.row,item.Explain];

    return cell;

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - Action
- (void)closeButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.view addSubview:self.executePointsView];
    
    WEAK_SELF(self);
    [self.executePointsView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATExecutePointsView *)executePointsView
{
    if (_executePointsView == nil) {
        _executePointsView = [[BATExecutePointsView alloc] init];
        _executePointsView.tableView.delegate = self;
        _executePointsView.tableView.dataSource = self;
    }
    return _executePointsView;
}

@end
