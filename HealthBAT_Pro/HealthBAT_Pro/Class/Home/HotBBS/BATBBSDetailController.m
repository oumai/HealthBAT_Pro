//
//  BATBBSDetailController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATBBSDetailController.h"
#import "BATHealthCircleTableViewCell.h"
#import "BATMomentsModel.h"
#import "BATBBSBottomView.h"
#import "BATSendCommentView.h"
#import "BATMomentsModel.h"
@interface BATBBSDetailController ()<UITableViewDelegate,UITableViewDataSource,YYTextViewDelegate>
@property (nonatomic,strong) UITableView *bbsTab;
@property (nonatomic,strong) NSMutableArray *commentsArr;
@property (nonatomic,strong) BATBBSBottomView *bottomView;
@property (nonatomic,strong) BATSendCommentView *sendCommentView;
@property (nonatomic,strong) NSString *contentString;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) BATMomentsModel *holeModel;
@property (nonatomic,assign) BOOL isRefresh;
@end

@implementation BATBBSDetailController

static NSString *const bbsReuseCell = @"bbsReuseCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    [self GetCommentsRequest];
    
    [self pageLayout];
    
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
    if (self.isRefreshBlock) {
        self.isRefreshBlock(self.isRefresh);
    }

}

- (void)GetCommentsRequest {
  

        
        [HTTPTool requestWithURLString:[NSString stringWithFormat:@"/api/DynamicLoop/GetDynamicLoopReplyList?postId=%@&pageIndex=%zd&pageSize=10",self.monentsModel ? self.monentsModel.PostId : self.PostId,self.currentPage] parameters:nil type:kGET success:^(id responseObject) {
            
            [self.bbsTab.mj_footer endRefreshing];
            [self.bbsTab.mj_header endRefreshing];
            
            self.holeModel = [BATMomentsModel mj_objectWithKeyValues:responseObject];
            for (BATMomentData *dataModel in self.holeModel.Data) {
                dataModel.IsHideCommon = YES;
            }
            self.monentsModel = self.holeModel.Data[0];
            
            if (self.currentPage == 0) {
                [self.commentsArr removeAllObjects];
            }
            for (BATComments *data in self.monentsModel.Comments) {
                BATMomentData *newMoment = [[BATMomentData alloc]init];
                newMoment.PostId = data.PostId;
                newMoment.MarkHelpful = data.MarkHelpful;
                newMoment.imgList = @[];
                newMoment.AccountID = data.AccountID;
                newMoment.AccountType = data.AccountType;
                newMoment.PhotoPath = data.PhotoPath;
                newMoment.UserName = data.UserName;
                newMoment.Comments = [NSMutableArray array];
                newMoment.IsMaster = data.IsMaster;
                newMoment.ID = data.ID;
                newMoment.CreatedTime = data.CreatedTime;
                newMoment.DynamicContent = data.CommentContent;
                [self.commentsArr addObject:newMoment];
            }
            
            if (self.monentsModel.CommentCount == self.commentsArr.count) {
                [_bbsTab.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_bbsTab reloadData];
            
            if (self.isScro) {
                if (self.commentsArr.count != 0) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
                    [_bbsTab scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    self.isScro = NO;
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    
    
   

}

- (void)GetData {
    
//    self.commentsArr = [NSMutableArray array];
//    
//    for (BATComments *data in self.monentsModel.Comments) {
//        BATMomentData *newMoment = [[BATMomentData alloc]init];
//        newMoment.PostId = data.PostId;
//        newMoment.MarkHelpful = data.MarkHelpful;
//        newMoment.imgList = @[];
//        newMoment.AccountID = data.AccountID;
//        newMoment.AccountType = data.AccountType;
//        newMoment.PhotoPath = data.PhotoPath;
//        newMoment.UserName = data.UserName;
//        newMoment.Comments = [NSMutableArray array];
//        newMoment.IsMaster = data.IsMaster;
//        newMoment.ID = data.ID;
//        newMoment.CreatedTime = data.CreatedTime;
//        newMoment.DynamicContent = data.CommentContent;
//        [self.commentsArr addObject:newMoment];
//    }

}


- (void)pageLayout {

    self.title = @"帖子详情";
    
    self.commentsArr = [NSMutableArray array];
    
    [self.view addSubview:self.bbsTab];
    
    [self.view addSubview:self.bottomView];
    
    WEAK_SELF(self);
    [self.view addSubview:self.sendCommentView];
    [self.sendCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(1200);
        make.height.mas_equalTo(1200);
    }];
    
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 0.01;
    }else {
    return 60;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    if (section == 1) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        backView.backgroundColor = [UIColor whiteColor];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
        title.text = @"回帖";
        [backView addSubview:title];
        
        UILabel *countLb =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 10, 60, 40)];
        countLb.text = [NSString stringWithFormat:@"(%zd)",self.monentsModel.CommentCount];
        countLb.textColor = [UIColor grayColor];
        countLb.font = [UIFont systemFontOfSize:12];
        [backView addSubview:countLb];
        
        return backView;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (section == 0) {
        return 1;
    }else {
    return self.commentsArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BATHealthCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATHealthCircleTableViewCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    if (indexPath.section == 0) {
        cell.sexImageView.hidden = NO;
        cell.thumbsUpButton.hidden = NO;
        cell.thumbsUpCountLabel.hidden = NO;
        cell.commentButton.hidden = NO;
        cell.desLB.hidden = NO;
        [cell configrationCell:self.monentsModel];
        if (self.monentsModel.IsHot == 0) {
            cell.isHotBBS.hidden = YES;
        }else {
            cell.isHotBBS.hidden = NO;
        }
        WEAK_SELF(self);
        cell.commentAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"评论按钮点击%@",cellIndexPath);
            STRONG_SELF(self);
            
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC
                return;
            }

            [self.sendCommentView.commentTextView becomeFirstResponder];
            
        };
        
        cell.thumbsUpAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"点赞按钮点击%@",cellIndexPath);
            STRONG_SELF(self);
            [self requestCancelAndThumpUp:cellIndexPath];
        };
    }else {
        cell.sexImageView.hidden = YES;
        cell.thumbsUpButton.hidden = YES;
        cell.thumbsUpCountLabel.hidden = YES;
        cell.commentButton.hidden = YES;
        cell.desLB.hidden = YES;
        [cell configrationCell:self.commentsArr[indexPath.row]];
    }
   
    return cell;

}

#pragma mark - 对某一行点赞或者取消点赞
- (void)requestCancelAndThumpUp:(NSIndexPath *)indexPath
{
  
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC
        return;
    }
    
    NSDictionary *params = @{@"OBJ_TYPE":@(kBATCollectionLinkTypeCare), @"OBJ_ID":self.monentsModel.PostId};
    
    [HTTPTool requestWithURLString:(!self.monentsModel.MarkHelpful ? @"/api/CollectLink/AddCollectLink" : @"/api/CollectLink/CanelCollectLink") parameters:params type:kPOST success:^(id responseObject) {
        
        self.isRefresh = YES;
        
        if (!self.monentsModel.MarkHelpful) {
            self.monentsModel.MarkHelpful = YES;
            self.monentsModel.MarkHelpfulCount++;
        } else {
            self.monentsModel.MarkHelpful = NO;
            self.monentsModel.MarkHelpfulCount--;
            
            if (self.monentsModel.MarkHelpfulCount < 0) {
                self.monentsModel.MarkHelpfulCount = 0;
            }
        }
        
        [self.bbsTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];

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

#pragma mark -发送评论
- (void)sendCommentRequest {
    NSLog(@"%@",self.contentString);
    
    if (self.sendCommentView.commentTextView.text.length>1000) {
        [self showText:@"评论内容不能超过1000个字符"];
        return;
    }
    
    
    NSDictionary *params = @{@"PostId":self.monentsModel.PostId, @"ParentId":@"", @"Body":self.contentString};
    
    [HTTPTool requestWithURLString:@"/api/DynamicLoop/AddReply" parameters:params type:kPOST success:^(id responseObject) {
        
//        BATComments *comments = [BATComments mj_objectWithKeyValues:[responseObject objectForKey:@"Data"]];
//
//        BATMomentData *newMoment = [[BATMomentData alloc]init];
//        newMoment.PostId = comments.PostId;
//        newMoment.MarkHelpful = comments.MarkHelpful;
//        newMoment.imgList = @[];
//        newMoment.AccountID = comments.AccountID;
//        newMoment.AccountType = comments.AccountType;
//        newMoment.PhotoPath = comments.PhotoPath;
//        newMoment.UserName = comments.UserName;
//        newMoment.Comments = [NSMutableArray array];
//        newMoment.IsMaster = comments.IsMaster;
//        newMoment.ID = comments.ID;
//        newMoment.CreatedTime = comments.CreatedTime;
//        newMoment.DynamicContent = comments.CommentContent;
//        [self.commentsArr addObject:newMoment];
//        
//        [self.monentsModel.Comments addObject:comments];
        self.sendCommentView.commentTextView.text = nil;
        
        self.isRefresh = YES;
        
        self.currentPage = 0;
        [self GetCommentsRequest];
        
        [self.bbsTab reloadData];

        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.bbsTab scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.view endEditing:YES];
}

#pragma mark -LazyFunnction
- (UITableView *)bbsTab {
    if (!_bbsTab) {
        
        _bbsTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50) style:UITableViewStylePlain];
        _bbsTab.estimatedRowHeight = 250;
        _bbsTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _bbsTab.rowHeight = UITableViewAutomaticDimension;
        _bbsTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _bbsTab.delegate = self;
        _bbsTab.dataSource = self;
        _bbsTab.tableFooterView = [UIView new];
//        [_bbsTab registerClass:[BATHealthCircleTableViewCell class] forCellReuseIdentifier:bbsReuseCell];
        [_bbsTab registerNib:[UINib nibWithNibName:@"BATHealthCircleTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATHealthCircleTableViewCell"];
        
        WEAK_SELF(self);
        _bbsTab.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [_bbsTab.mj_footer resetNoMoreData];
            [self GetCommentsRequest];
        }];
        
        _bbsTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage ++;
            [self GetCommentsRequest];
        }];
    }
    return _bbsTab;
}

- (BATBBSBottomView *)bottomView {

    if (!_bottomView) {
        _bottomView = [[BATBBSBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50 - 64, SCREEN_WIDTH, 50)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        WEAK_SELF(self);
        [_bottomView setEditBlock:^{
            STRONG_SELF(self);
            if (!LOGIN_STATION) {
                PRESENT_LOGIN_VC;
                return ;
            }
            [self editBegin];
        }];
    }
    return _bottomView;
}

- (void)editBegin {
 
    [self.sendCommentView.commentTextView becomeFirstResponder];
    
}

- (BATSendCommentView *)sendCommentView {
    
    if (!_sendCommentView) {
        _sendCommentView = [[BATSendCommentView alloc] init];
        _sendCommentView.commentTextView.delegate = self;
        WEAK_SELF(self);
        [_sendCommentView setSendBlock:^{
            STRONG_SELF(self);
            NSString *text = [self.sendCommentView.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.contentString = text;
            if (text.length == 0) {
                [self showErrorWithText:@"请输入评论"];
            }
            
            [self sendCommentRequest];
        }];
        
        [_sendCommentView setClaerBlock:^{
            STRONG_SELF(self);
            [self.view endEditing:YES];
        }];
    }
    
    return _sendCommentView;
}

@end
