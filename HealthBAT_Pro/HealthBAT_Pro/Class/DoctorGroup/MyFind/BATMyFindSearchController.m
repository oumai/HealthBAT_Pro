//
//  BATMyFindSearchController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMyFindSearchController.h"
#import "BATTopicSearchCell.h"
#import "BATTopicPersonController.h"
#import "BATTopicSearchModel.h"
#import "BATInvitationDetailController.h"
#import "BATTopicDetailController.h"
#import "BATPersonDetailController.h"
@interface BATMyFindSearchController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,strong) UITableView *searchTab;
@property (nonatomic,strong) BATTopicSearchModel  *model;
@end

@implementation BATMyFindSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    [self pageLayout];
    
    [self searchRequestWithKeyWord:self.KeyWord];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
}

- (void)pageLayout {
    
    self.title = @"发现";
  
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:self.searchTF];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    [headerView addSubview:lineView];
    [self.view addSubview:headerView];
    
//    self.searchTab.tableHeaderView = headerView;
    [self.view addSubview:self.searchTab];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.model.resultData.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.model.resultData[section] body].content count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BATTopicSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATTopicSearchCell"];
    if (self.model) {
        TopicSearchBody *body = [self.model.resultData[indexPath.section] body];
        cell.model = body.content[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        TopicSearchBody *body = [self.model.resultData[indexPath.section] body];
        BATTopicDetailController *detailVC = [[BATTopicDetailController alloc]init];
        detailVC.ID = body.content[indexPath.row].resultId;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if(indexPath.section == 1) {
        TopicSearchBody *body = [self.model.resultData[indexPath.section] body];
        BATInvitationDetailController *invitationVC = [[BATInvitationDetailController alloc]init];
        invitationVC.ID = body.content[indexPath.row].resultId;
        [self.navigationController pushViewController:invitationVC animated:YES];
    }else {
        TopicSearchBody *body = [self.model.resultData[indexPath.section] body];
        /*
        BATTopicPersonController *personVC = [[BATTopicPersonController alloc]init];
        personVC.accountID = [body.content[indexPath.row] resultId];
        [self.navigationController pushViewController:personVC animated:YES];
         */
        
        //新个人主页控制器
        BATPersonDetailController *personDetailVC = [[BATPersonDetailController alloc]init];
        personDetailVC.accountID = [body.content[indexPath.row] resultId];
        [self.navigationController pushViewController:personDetailVC animated:YES];
    }
   
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
    if ([[self.model.resultData[section] body].content count] == 0) {
        return nil;
    }
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backView.backgroundColor =  UIColorFromRGB(238, 238, 238, 1);
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 2, 20)];
    lineView.backgroundColor = UIColorFromHEX(0x45a0f0, 1);
    [backView addSubview:lineView];
    
    UILabel *titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x666666, 1) textAlignment:NSTextAlignmentLeft];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(lineView.frame) + 10, 0, 120, 40);
    [backView addSubview:titleLabel];
    
    TopicResultData *data = self.model.resultData[section];
    if ([data.type isEqualToString:@"topic_info"]) {
        titleLabel.text = @"相关话题";
    }else if([data.type isEqualToString:@"post_info"]) {
        titleLabel.text = @"相关帖子";
    }else {
        titleLabel.text = @"相关好友";
    }
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if ([[self.model.resultData[section] body].content count] == 0) {
        return 0.01;
    }
    return 40;
}



#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)text {

    self.KeyWord = text.text;
}

#pragma mark - TextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (self.KeyWord.length == 0) {
        textField.enablesReturnKeyAutomatically = YES;
        return NO;
    }
    [self searchRequestWithKeyWord:self.KeyWord];
    return YES;
}

#pragma mark - NET
- (void)searchRequestWithKeyWord:(NSString *)keyWord {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"ios" forKey:@"devicetype"];
    [dict setObject:self.KeyWord forKey:@"keyword"];
    [dict setObject:@"3" forKey:@"itemsize"];
    
    [HTTPTool requestWithSearchURLString:@"/elasticsearch/searchapp/snsSearch" parameters:dict success:^(id responseObject) {
        
        self.model = [BATTopicSearchModel mj_objectWithKeyValues:responseObject];
        [self.model.resultData insertObject:self.model.resultData[2] atIndex:0];
        [self.model.resultData removeObjectAtIndex:3];
        [self.searchTab reloadData];
       
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Lazy load
- (UITableView *)searchTab {

    if (!_searchTab) {
        _searchTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) style:UITableViewStylePlain];
        _searchTab.delegate = self;
        _searchTab.dataSource = self;
        _searchTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_searchTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_searchTab registerClass:[BATTopicSearchCell class] forCellReuseIdentifier:@"BATTopicSearchCell"];
    }
    return _searchTab;
}

- (UITextField *)searchTF {
    
    if (!_searchTF) {
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:nil BorderStyle:UITextBorderStyleNone];
        _searchTF.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 30);
        _searchTF.clearButtonMode = UITextFieldViewModeNever;
        _searchTF.placeholder = @"搜话题/帖子/好友";
        _searchTF.text = self.KeyWord;
        _searchTF.textColor = [UIColor blackColor];
        _searchTF.backgroundColor = [UIColor colorWithPatternImage:[Tools imageFromColor:UIColorFromHEX(0Xf6f6f6, 1)]];
        [_searchTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-search"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        _searchTF.returnKeyType = UIReturnKeySearch;
        
        _searchTF.layer.cornerRadius = 5.0f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
}

@end
