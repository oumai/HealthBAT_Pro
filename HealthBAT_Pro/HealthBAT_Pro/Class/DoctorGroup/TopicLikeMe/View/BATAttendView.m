//
//  BATAttendView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/17.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAttendView.h"
#import "BATProjectCell.h"
#import "BATLeftAttendCell.h"
#import "BATRightAttendCell.h"
#import "BATHotTopicListModel.h"
#import "BATSameTopicUserModel.h"
#import "YYText.h"
@interface BATAttendView()<UITableViewDelegate,UITableViewDataSource,BATRightAttendCellDelegate,YYTextViewDelegate>
@property (nonatomic,strong) BATHotTopicListModel *model;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign) NSInteger clickRow;
@property (nonatomic,strong) BATSameTopicUserModel *topicUserModel;

@property (nonatomic,strong) NSString *ListId;

@property (nonatomic,strong) NSMutableArray *dataArray;

@end
@implementation BATAttendView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.dataArray = [NSMutableArray array];
        [self addSubview:self.leftTableView];
        [self addSubview:self.rightTableView];
        
        WEAK_SELF(self);
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(130);
            make.top.bottom.equalTo(self).offset(0);
            make.width.mas_equalTo(1);
            
        }];
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"BATRefreshMoreProgramListNotification" object:nil];
    }
    return self;
    
}


- (void)setLeftTable {
    
    [self GetLeftDataRequest];
    
}

#pragma mark - Notification
- (void)refresh:(NSNotification *)notif
{
    [self.rightTableView.mj_header beginRefreshing];
}

#pragma mark - NET
#pragma mark - 获取右边列表数据
- (void)GetRightDataRequest {
  
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.ListId forKey:@"topicID"];
    [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
    [dict setValue:@"10" forKey:@"pageSize"];
    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetLikeMeList" parameters:dict type:kGET success:^(id responseObject) {
        
        [self.rightTableView.mj_header endRefreshing];
        [self.rightTableView.mj_footer endRefreshing];
        
        self.rightTableView.mj_footer.hidden = NO;
        
        
        if (self.currentPage == 0) {
            [self.dataArray removeAllObjects];
        }
        
        self.topicUserModel  = [BATSameTopicUserModel mj_objectWithKeyValues:responseObject];
        
        
        [self.dataArray addObjectsFromArray:self.topicUserModel.Data];
        
        if (self.topicUserModel.RecordsCount == self.dataArray.count) {
            [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.rightTableView reloadData];
    } failure:^(NSError *error) {
        [self.rightTableView.mj_header endRefreshing];
        [self.rightTableView.mj_footer endRefreshing];
    }];
}
#pragma mark - 获取左边列表数据
- (void)GetLeftDataRequest {
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(0) forKey:@"accountId"];

    
    [HTTPTool requestWithURLString:@"/api/dynamic/GetMyTopicList" parameters:dict type:kGET success:^(id responseObject) {
        
        
        self.model  = [BATHotTopicListModel mj_objectWithKeyValues:responseObject];
        
        if (self.model.Data.count > 0) {
            HotTopicListData *data = self.model.Data[0];
            data.isSelect = YES;
            
            
            HotTopicListData *model = self.model.Data[0];
            self.ListId = model.ID;
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:model.ID forKey:@"topicID"];
            [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
            [dict setValue:@"10" forKey:@"pageSize"];
            
            [HTTPTool requestWithURLString:@"/api/dynamic/GetLikeMeList" parameters:dict type:kGET success:^(id responseObject) {
                self.topicUserModel  = [BATSameTopicUserModel mj_objectWithKeyValues:responseObject];
                
                self.rightTableView.mj_footer.hidden = NO;
                
                [self.dataArray addObjectsFromArray:self.topicUserModel.Data];
                
                if (self.dataArray.count == self.topicUserModel.RecordsCount) {
                    [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                [self.rightTableView reloadData];
            } failure:^(NSError *error) {
                
            }];
                   //     [[NSNotificationCenter defaultCenter] postNotificationName:@"ATTENDLISTSHOWNOTICE" object:nil];
            self.defaultView.hidden = YES;
        }else {
            self.defaultView.hidden  = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ATTENDLISTSHOWNOTICE" object:nil];
        }
        
        
        
        if (self.model.Data.count == self.model.RecordsCount) {
            self.leftTableView.mj_footer.hidden = NO;
            [self.leftTableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.leftTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.leftTableView) {
        return self.model.Data.count;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        
        BATLeftAttendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (self.model.Data.count>0) {
          cell.dataModel = self.model.Data[indexPath.row];
        }
        return cell;
        
    }else {
        
        BATRightAttendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.delegate = self;
        cell.rowPath = indexPath;
        if (self.topicUserModel.Data.count >0) {
            cell.topicUsermodel = self.dataArray[indexPath.row];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.rightTableView) {
        return 82.5;
    }
    return 55;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        
        for (HotTopicListData *model in self.model.Data) {
            model.isSelect = NO;
        }

        self.currentPage = 0;
        
        HotTopicListData *model = self.model.Data[indexPath.row];
        model.isSelect = YES;

        self.selectIndex = indexPath.row;
        self.currentPage = 0;

        [self.leftTableView reloadData];
//
        self.ListId = model.ID;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:model.ID forKey:@"topicID"];
        [dict setValue:@(self.currentPage) forKey:@"pageIndex"];
        [dict setValue:@"10" forKey:@"pageSize"];
        
        [HTTPTool requestWithURLString:@"/api/dynamic/GetLikeMeList" parameters:dict type:kGET success:^(id responseObject) {
            
            if (self.currentPage == 0) {
                [self.dataArray removeAllObjects];
            }
            
            self.rightTableView.mj_footer.hidden = YES;
            
            self.topicUserModel  = [BATSameTopicUserModel mj_objectWithKeyValues:responseObject];
            [self.dataArray addObjectsFromArray:self.topicUserModel.Data];
            
            if (self.dataArray.count == self.topicUserModel.RecordsCount) {
                [self.rightTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.rightTableView reloadData];
        } failure:^(NSError *error) {
            
        }];
        
    }
}

//刷新数据
- (void)updateData {
    [self GetLeftDataRequest];
}

#pragma mark -YYTextViewDelegate
- (BOOL)textView:(YYTextView *)textView shouldTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange
{
    return YES;
}
- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect
{

    if ([self.delegate respondsToSelector:@selector(BATRightTableView:indexPath:)]) {
        [self.delegate BATRightTableView:self indexPath:nil];
    }
    
}

#pragma mark - BATRightAttendCellDelegate
- (void)BATRightAttendActionWithRowPath:(NSIndexPath *)rowPath {

    sameTopicUserData *moment = self.topicUserModel.Data[rowPath.row];
    NSString *urlString = nil;
    if (moment.IsUserFollow) {
        urlString = @"/api/dynamic/CancelOperation";
        [self AttendRequesetWithURL:urlString monent:moment];
    }else {
        urlString = @"/api/dynamic/ExecuteOperation";
        [self AttendRequesetWithURL:urlString monent:moment];
    }
}

- (void)BATRightTableViewToPersonVCindexPath:(NSIndexPath *)pathRow {
    
     sameTopicUserData *moment = self.topicUserModel.Data[pathRow.row];
    if ([self.delegate respondsToSelector:@selector(BATRightTableView:accountID:)]) {
        [self.delegate BATRightTableView:self accountID:moment.AccountID];
    }
}

//对用于关注用
- (void)AttendRequesetWithURL:(NSString *)url monent:(sameTopicUserData *)monent {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:monent.AccountID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        monent.IsUserFollow = !monent.IsUserFollow;
        [self.rightTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Lazy load
- (UITableView *)rightTableView {
    
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(130, 0, SCREEN_WIDTH - 130, SCREEN_HEIGHT - 65 - 44 ) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        [_rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_rightTableView registerNib:[UINib nibWithNibName:@"BATRightAttendCell" bundle:nil] forCellReuseIdentifier:@"rightCell"];
        
        WEAK_SELF(self)
        _rightTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.currentPage = 0;
            [self GetRightDataRequest];
        }];
        
        
        _rightTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self)
            self.currentPage ++ ;
             [self GetRightDataRequest];
        }];
        
        _rightTableView.mj_footer.hidden = YES;
    }
    return _rightTableView;
    
}

- (UITableView *)leftTableView {
    
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 130, SCREEN_HEIGHT - 45 - 64) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.backgroundColor = UIColorFromHEX(0Xf0f0f0, 1);
        [_leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_leftTableView registerClass:[BATLeftAttendCell class] forCellReuseIdentifier:@"leftCell"];
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

- (UIView *)defaultView {
    
    if(!_defaultView) {
        _defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
        _defaultView.backgroundColor = [UIColor whiteColor];
        _defaultView.hidden = YES;
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"无数据"]];
        img.frame = CGRectMake(SCREEN_WIDTH/2 - 115/2, 65, 115, 130);
        [_defaultView addSubview:img];

        YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+15, SCREEN_WIDTH, 200)];
        textView.delegate = self;
        textView.textAlignment = NSTextAlignmentCenter;
        textView.editable = NO;
        textView.scrollEnabled = NO;
        

         NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"您还未关注任何话题,请在“话题推荐”\n中找到感兴趣的话题进行关注\n精彩生活不容错过!"];
        [text yy_setFont:[UIFont systemFontOfSize:15] range:text.yy_rangeOfAll];
        text.yy_lineSpacing = 0;
        [text yy_setColor:UIColorFromHEX(0X999999, 1) range:NSMakeRange(0, text.length)];
        [text yy_setColor:UIColorFromHEX(0Xeb2828, 1) range:NSMakeRange(13, 4)];
        [text setYy_alignment:NSTextAlignmentCenter];
        YYTextBorder *highlightBorder = [YYTextBorder new];
        highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
        highlightBorder.cornerRadius = 3;
        highlightBorder.fillColor = BASE_BACKGROUND_COLOR;
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setBackgroundBorder:highlightBorder];
        // 数据信息，用于稍后用户点击
        NSString *fromNames = [text.string substringWithRange:NSMakeRange(13,4)];
        highlight.userInfo = @{@"linkValue" : fromNames,@"linkType":@(0)};
        [text yy_setTextHighlight:highlight range:NSMakeRange(13, 4)];
        
        
        textView.attributedText = text;
        [_defaultView addSubview:textView];
        
        [self addSubview:_defaultView];
        
    }
    return _defaultView;
}


@end
