//
//  BATInvitationDetailController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATInvitationDetailController.h"
#import "BATInvitationModel.h"
#import "BATInvitationTitleCell.h"
#import "BATInvitationPersonCell.h"
#import "BATInvitationContentCell.h"
#import "BATTopicPersonController.h"
#import "BATCourseCommentTableViewCell.h"
#import "BATTopicRecordModel.h"
#import "BATSendCommentView.h"
#import "BATPerson.h"
@interface BATInvitationDetailController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YYTextViewDelegate>

@property (nonatomic,strong) BATInvitationModel *model;

@property (nonatomic,strong) BATTopicRecordModel *replyModel;

@property (nonatomic,strong) UITableView *invitationTab;

@property (nonatomic,strong) UIView *commentView;

@property (nonatomic,strong) UITextField *searchTF;

@property (nonatomic,strong) BATSendCommentView *sendCommentView;

@property (nonatomic,strong) NSString *contentString;

@property (nonatomic,strong) NSString *ParentID;

@property (nonatomic,strong) NSString *ParentLevelID;

@property (nonatomic,strong) UILabel *leftplTitle;

@property (nonatomic,strong) UILabel *rightplTitle;

@property (nonatomic,strong) UIImageView *plRighticon;

@property (nonatomic,strong) BATPerson *person;

@end

@implementation BATInvitationDetailController

- (void)viewWillAppear:(BOOL)animated {
 
    self.navigationController.navigationBar.translucent=NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self pageLayout];
    
    [self GetTopicDetailRequest];
    
    [self GetCommentRequest];
    
    //更新阅读量
    [self updateReadNum];
    
}

- (void)updateReadNum {

    [HTTPTool requestWithURLString:@"/api/dynamic/UpdateReadNum" parameters:@{@"PostID":self.ID} type:kPOST success:^(id responseObject) {
    
        if (self.updateReadNumBlock) {
            self.updateReadNumBlock();
        }
    
    } failure:^(NSError *error) {
        
    }];
}

- (void)GetCommentRequest {

    [HTTPTool requestWithURLString:@"/api/dynamic/GetReplyList" parameters:@{@"postId":self.ID} type:kGET success:^(id responseObject) {
        self.replyModel = [BATTopicRecordModel mj_objectWithKeyValues:responseObject];
        [self.invitationTab reloadData];
        self.leftplTitle.text = [NSString stringWithFormat:@"评论%zd",self.replyModel.Data.count];
        [self.invitationTab.mj_header endRefreshing];
        [self.invitationTab.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.invitationTab.mj_header endRefreshing];
        [self.invitationTab.mj_footer endRefreshing];
    }];
    
}

- (void)GetTopicDetailRequest {
    [HTTPTool requestWithURLString:@"/api/dynamic/GetPostDetail" parameters:@{@"ID":self.ID} type:kGET success:^(id responseObject) {
        
        
        self.invitationTab.hidden = NO;
        self.commentView.hidden = NO;
        
        self.model = [BATInvitationModel mj_objectWithKeyValues:responseObject];
        self.model.Data.CreatedTime = [self.model.Data.CreatedTime substringToIndex:16];
        self.rightplTitle.text = [NSString stringWithFormat:@"点赞%zd",self.model.Data.StarNum];
        if (self.model.Data.IsSetStar) {
            self.plRighticon.image = [UIImage imageNamed:@"icon_dianzan_pre"];

            
        }else {
            self.plRighticon.image = [UIImage imageNamed:@"icon_dianzan"];
                    }
        [self.invitationTab reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - NET
- (void)SubmitReply {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.ID forKey:@"PostID"];
    [dict setValue:@"0" forKey:@"ReplyType"];
    [dict setValue:self.ParentID forKey:@"ParentID"];
    [dict setValue:self.ParentLevelID forKey:@"ParentLevelID"];
    [dict setValue:self.contentString forKey:@"ReplyContent"];
    [dict setValue:@"" forKey:@"AudioUrl"];
    [dict setValue:@"" forKey:@"AudioLong"];
    
    [HTTPTool requestWithURLString:@"/api/dynamic/SubmitReply" parameters:dict type:kPOST success:^(id responseObject) {
        [self.invitationTab.mj_header beginRefreshing];
        [self.view endEditing:YES];
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - action
- (void)keyboardWillShow:(NSNotification *)notif {
    
    
    CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        
        self.sendCommentView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, -keyboardFrame.size.height-self.sendCommentView.bounds.size.height);
        
    } completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)notif {
    
    
    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
        
        self.sendCommentView.transform = CGAffineTransformIdentity;
        
    } completion:nil];
    
}

- (void)pageLayout {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"帖子详情";
    
    self.person = PERSON_INFO;
   
    [self.view addSubview:self.invitationTab];
    
     [self.view addSubview:self.commentView];
    
    WEAK_SELF(self);
    [self.view addSubview:self.sendCommentView];
    [self.sendCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(1200);
        make.height.mas_equalTo(1200);
    }];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 3;
    }else {
        return self.replyModel.Data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            BATInvitationTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"BATInvitationTitleCell"];
            titleCell.titleLb.text = self.model.Data.Title;
            [titleCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return titleCell;
        }else if(indexPath.row == 1){
            BATInvitationPersonCell *personCell = [tableView dequeueReusableCellWithIdentifier:@"BATInvitationPersonCell"];
            [personCell.headImage sd_setImageWithURL:[NSURL URLWithString:self.model.Data.PhotoPath]];
            personCell.tipsLb.text = [NSString stringWithFormat:@"#%@#",self.model.Data.Topic];
            NSString *timeStr = nil;
            timeStr = [self getTimeStringFromDateString:self.model.Data.CreatedTime];
            personCell.timeLb.text = [NSString stringWithFormat:@"%@ 阅读%zd",timeStr,self.model.Data.ReadNum];

            personCell.nameLb.text = self.model.Data.UserName;
            [personCell setSelectionStyle:UITableViewCellSelectionStyleNone];

            if (self.person.Data.AccountID == [self.model.Data.AccountID integerValue]) {
                personCell.attendBtn.hidden = YES;
            }else {
                personCell.attendBtn.hidden = NO;
                if (self.model.Data.IsUserFollow) {
                    [personCell.attendBtn setBackgroundImage:[UIImage imageNamed:@"icon-ygz-gray"] forState:UIControlStateNormal];
                    personCell.attendBtn.titleLabel.text = nil;
                }else {
                    [personCell.attendBtn setBackgroundImage:[UIImage imageNamed:@"icon-jgz"] forState:UIControlStateNormal];
                }
            }
            
            personCell.invitationBlock = ^(){
                BATTopicPersonController *personVC = [[BATTopicPersonController alloc]init];
                personVC.accountID = self.model.Data.AccountID;
                WEAK_SELF(self);
                personVC.PersonRefreshBlock = ^(BOOL isChange){
                    STRONG_SELF(self);
                    [self GetTopicDetailRequest];
                };
                [self.navigationController pushViewController:personVC animated:YES];
            };
            
            
            personCell.attendblock = ^(){
            
                if (!LOGIN_STATION) {
                    PRESENT_LOGIN_VC
                    return;
                }
                [self attendActionRequest];
                
            };
            return personCell;
            
        }else {
            BATInvitationContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:@"BATInvitationContentCell"];
//            contentCell.contentLb.text = self.model.Data.PostContent;
            contentCell.model = self.model;
            [contentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return contentCell;
            
        }
    }else {
        BATCourseCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATCourseCommentTableViewCell"];
        cell.indexPath = indexPath;
        [cell configTopicData:self.replyModel.Data[indexPath.row]];
        
        cell.likeAction = ^(NSIndexPath *cellIndexPath) {
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
        TopicReplyData *data = self.replyModel.Data[cellIndexPath.row];
            
            NSLog(@"%zd",cellIndexPath.row);
            NSString *urlString = nil;
            if (data.IsSetStar) {
               
                urlString = @"/api/dynamic/CancelOperation";
                [self AttendTopicRequesetWithURL:urlString monent:data type:1];
                
            }else {
                urlString = @"/api/dynamic/ExecuteOperation";
                [self AttendTopicRequesetWithURL:urlString monent:data type:1];
            }
            NSLog(@"点赞");
        };
        cell.commentAction = ^(NSIndexPath *cellIndexPath) {
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }
            
        TopicReplyData *data = self.replyModel.Data[cellIndexPath.row];
            self.ParentID = data.ID;
            self.ParentLevelID = data.ID;
            self.sendCommentView.commentTextView.text = nil;
         [self.sendCommentView.commentTextView becomeFirstResponder];

        };
        
        //头像点击回调
        cell.headimgTapBlocks =^(NSIndexPath *path) {
        
             TopicReplyData *data = self.replyModel.Data[path.row];
            BATTopicPersonController *topicPersonVC = [[BATTopicPersonController alloc]init];
            topicPersonVC.accountID = data.AccountID;
            [self.navigationController pushViewController:topicPersonVC animated:YES];
            
        };
        return cell;
    }
   
}

//对人关注
- (void)attendActionRequest {

    NSString *url = nil;
    if (self.model.Data.IsUserFollow) {
        url = @"/api/dynamic/CancelOperation";
    }else {
        url = @"/api/dynamic/ExecuteOperation";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:self.model.Data.AccountID forKey:@"RelationID"];
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        self.model.Data.IsUserFollow = !self.model.Data.IsUserFollow;
        [self.invitationTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)AttendTopicRequesetWithURL:(NSString *)url monent:(TopicReplyData *)monent type:(NSInteger)type {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(type) forKey:@"RelationType"];
    [dict setObject:monent.ID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        
        if (!monent.IsSetStar) {
            monent.IsSetStar = YES;
            monent.StarNum ++;
        } else {
            monent.IsSetStar = NO;
            monent.StarNum--;
            
            if (monent.StarNum < 0) {
                monent.StarNum = 0;
            }
        }
        [self.invitationTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

//- (void)submitReplyRequest {
//  
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict setValue:self.ID forKey:@"PostID"];
//    [dict setValue:@"0" forKey:@"ReplyType"];
//    [dict setValue:self.ParentID forKey:@"ParentID"];
//    [dict setValue:self.ParentLevelID forKey:@"ParentLevelID"];
//    [dict setValue:@"" forKey:@"ReplyContent"];
//    [dict setValue:@"" forKey:@"AudioUrl"];
//    [dict setValue:@"" forKey:@"AudioLong"];
//    
//    [HTTPTool requestWithURLString:@"/api/dynamic/SubmitReply" parameters:nil type:kPOST success:^(id responseObject) {
//        [self.invitationTab.mj_header beginRefreshing];
//    } failure:^(NSError *error) {
//        
//    }];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return nil;
    }
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
    title.font = [UIFont systemFontOfSize:15];
    title.textColor = UIColorFromHEX(0X333333, 1);
    title.text = @"评论";
    [backView addSubview:title];
    
    UILabel *countLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 0, 100, 40)];
    countLb.font = [UIFont systemFontOfSize:12];
    countLb.textColor = UIColorFromHEX(0X999999, 1);
    countLb.text = [NSString stringWithFormat:@"(%zd)",self.replyModel.Data.count];
    [backView addSubview:countLb];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    [backView addSubview:lineView];
    
    return backView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 0.01;
    }else {
    return 40;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    [self editBegin];
    self.sendCommentView.commentTextView.text = nil;
    return YES;
}

- (void)editBegin {
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC
        return;
    }
    
    self.ParentID = nil;
    self.ParentLevelID = nil;
    self.sendCommentView.commentTextView.text = nil;
    [self.sendCommentView.commentTextView becomeFirstResponder];
    
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    
    if (textView.text.length > 0) {
        self.sendCommentView.sendCommentButton.enabled = YES;
        self.sendCommentView.sendCommentButton.backgroundColor = BASE_COLOR;
    }
    if (textView.text.length == 0) {
        self.sendCommentView.sendCommentButton.enabled = NO;
        self.sendCommentView.sendCommentButton.backgroundColor = [UIColor lightGrayColor];
    }
}


#pragma mark - Lazy Load
- (UITableView *)invitationTab {

    if (!_invitationTab) {
        _invitationTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) style:UITableViewStylePlain];
        _invitationTab.delegate = self;
        _invitationTab.dataSource = self;
        _invitationTab.estimatedRowHeight = 250;
        _invitationTab.rowHeight = UITableViewAutomaticDimension;
        _invitationTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_invitationTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_invitationTab registerNib:[UINib nibWithNibName:@"BATInvitationTitleCell" bundle:nil] forCellReuseIdentifier:@"BATInvitationTitleCell"];
        [_invitationTab registerNib:[UINib nibWithNibName:@"BATInvitationPersonCell" bundle:nil] forCellReuseIdentifier:@"BATInvitationPersonCell"];
        [_invitationTab registerNib:[UINib nibWithNibName:@"BATInvitationContentCell" bundle:nil] forCellReuseIdentifier:@"BATInvitationContentCell"];
        [_invitationTab registerClass:[BATCourseCommentTableViewCell class] forCellReuseIdentifier:@"BATCourseCommentTableViewCell"];
        WEAK_SELF(self);
        _invitationTab.hidden = YES;
        _invitationTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            [self GetCommentRequest];
        }];

    }
    return _invitationTab;
}

- (void)commentAction {

    if (self.replyModel.Data.count >0) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.invitationTab scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

- (void)priseAction {
    
    
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC
        return;
    }

    if (self.model) {
        
        NSString *url = nil;
        if (self.model.Data.IsSetStar) {
            url = @"/api/dynamic/CancelOperation";
        }else {
            url = @"/api/dynamic/ExecuteOperation";
        }
        
        [self AttendRequesetWithURL:url];
    }
 

    
  
}

- (void)AttendRequesetWithURL:(NSString *)url{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"0" forKey:@"RelationType"];
    [dict setObject:self.model.Data.ID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        if (self.model.Data.IsSetStar) {
            self.model.Data.StarNum -= 1;
        }else {
            self.model.Data.StarNum += 1;
        }
       
        
        self.rightplTitle.text = self.model.Data.IsSetStar ? [NSString stringWithFormat:@"点赞%zd",self.model.Data.StarNum] : [NSString stringWithFormat:@"点赞%zd",self.model.Data.StarNum];

      
        
        self.model.Data.IsSetStar = !self.model.Data.IsSetStar;
        self.plRighticon.image = self.model.Data.IsSetStar ? [UIImage imageNamed:@"icon_dianzan_pre"] : [UIImage imageNamed:@"icon_dianzan"];
        
        if (self.priseBlock) {
            self.priseBlock(self.model.Data.IsSetStar);
        }
//        self.rightplTitle.text = self.model.Data.IsSetStar ? [NSString stringWithFormat:@"点赞%zd",self.model.Data.StarNum +1] : [NSString stringWithFormat:@"点赞%zd",self.model.Data.StarNum-1];
//        self.rightplTitle.text = [NSString stringWithFormat:@"点赞%zd",self.model.Data.StarNum +1];
        
    } failure:^(NSError *error) {
        
    }];
}

- (UIView *)commentView {

    if (!_commentView) {
        _commentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 - 64, SCREEN_WIDTH, 50)];
        _commentView.backgroundColor = [UIColor whiteColor];
        [_commentView addSubview:self.searchTF];
        
        UIView *LeftcommentView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 134, 0, 50, 50)];
        LeftcommentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *LefttTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentAction)];
        [LeftcommentView addGestureRecognizer:LefttTap];
        
        UIImageView *plicon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-pl-black"]];
        plicon.frame = CGRectMake(25 - 8.5, 8, 17, 17);
        [LeftcommentView addSubview:plicon];
        
        self.leftplTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 17 + 5 + 2, 50, 30)];
        self.leftplTitle.font = [UIFont systemFontOfSize:13];
        self.leftplTitle.textAlignment = NSTextAlignmentCenter;
        self.leftplTitle.textColor = UIColorFromHEX(0X999999, 1);
        self.leftplTitle.text = @"评论";
        

        
        [LeftcommentView addSubview:self.leftplTitle];
        
        [_commentView addSubview:LeftcommentView];
//        
        UIView *RightcommentView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 17 - 50, 0, 50, 50)];
        RightcommentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *RightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(priseAction)];
        [RightcommentView addGestureRecognizer:RightTap];
         
        
        self.plRighticon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_dianzan"]];
        self.plRighticon.frame = CGRectMake(25 - 8.5, 8, 17, 17);
        [RightcommentView addSubview:self.plRighticon];
        
        self.rightplTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 17 + 5 + 2, 50, 30)];
        self.rightplTitle.font = [UIFont systemFontOfSize:13];
        self.rightplTitle.text = @"点赞";
        self.rightplTitle.textAlignment = NSTextAlignmentCenter;
        self.rightplTitle.textColor = UIColorFromHEX(0X999999, 1);
        [RightcommentView addSubview:self.rightplTitle];
        
        [_commentView addSubview:RightcommentView];
        
        _commentView.hidden = YES;
        
    }
    return _commentView;
}

- (UITextField *)searchTF {
    
    if (!_searchTF) {
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:14] textColor:nil placeholder:nil BorderStyle:UITextBorderStyleNone];
        _searchTF.frame = CGRectMake(10, 10,SCREEN_WIDTH - 50 - 100, 30);
        _searchTF.clearButtonMode = UITextFieldViewModeNever;
        _searchTF.placeholder = @"写评论...";
        _searchTF.textColor = UIColorFromHEX(0X999999, 1);
        _searchTF.returnKeyType = UIReturnKeySearch;
        _searchTF.backgroundColor = [UIColor colorWithPatternImage:[Tools imageFromColor:UIColorFromHEX(0Xf6f6f6, 1)]];
        _searchTF.clipsToBounds = YES;
        UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-tjpl"]];
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:searchIcon];
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.delegate = self;
        
        _searchTF.layer.cornerRadius = 14.0f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{

    NSLog(@"%@",textView.text);
   // NSString *str = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([text isEqualToString:@"\n"] ) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;

}

- (BATSendCommentView *)sendCommentView {
    
    if (!_sendCommentView) {
        _sendCommentView = [[BATSendCommentView alloc] init];
        _sendCommentView.commentTextView.delegate = self;
        _sendCommentView.commentTextView.returnKeyType = UIReturnKeyDone;
        WEAK_SELF(self);
        [_sendCommentView setSendBlock:^{
            STRONG_SELF(self);
            NSString *text = [self.sendCommentView.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.contentString = text;
            if (text.length == 0) {
                [self showErrorWithText:@"请输入评论"];
            }else {
                [self SubmitReply];

            }
        }];
        
        [_sendCommentView setClaerBlock:^{
            STRONG_SELF(self);
            [self.view endEditing:YES];
        }];
    }
    
    return _sendCommentView;
}


/**
 *  格式化时间
 *
 *  @param dateString 时间
 *
 *  @return 格式后的时间
 */
- (NSString *)getTimeStringFromDateString:(NSString *)dateString
{
    NSString *timeString = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate = [formatter dateFromString:dateString];
    NSTimeInterval sendInterval = [startDate timeIntervalSince1970];
    
    NSDate *nowDate = [NSDate date];
    NSString *strNow = [formatter stringFromDate:nowDate];
    NSDate *nowingDate = [formatter dateFromString:strNow];
    NSTimeInterval nowInterval = [nowingDate timeIntervalSince1970];
    
    NSTimeInterval minusInterval = nowInterval - sendInterval;
    
    if (minusInterval < 60) {
        timeString = @"刚刚...";
    }
    else if (minusInterval >= 60 && minusInterval < 3600) {
        timeString = [NSString stringWithFormat:@"%ld分钟前", (long)minusInterval / 60];
    }
    else if (minusInterval >= 3600 && minusInterval < 86400) {
        timeString = [NSString stringWithFormat:@"%ld小时前", (long)minusInterval / 3600];
    }
    else if (minusInterval >= 86400 ) {
        if ((long)minusInterval / 86400 == 1) {
            timeString = @"昨天";
        }else {
            dateString = [dateString substringToIndex:16];
            timeString = dateString;
        }
    }
    
    
    return timeString;
}




@end
