//
//  BATTopicScorListCell.m
//  RecordTest
//
//  Created by kmcompany on 2017/3/16.
//  Copyright © 2017年 kmcompany. All rights reserved.
//

#import "BATTopicScorListCell.h"
#import "BATHotTopicModel.h"
#import "BATTopicTableViewCell.h"
#import "BATHotTopicModel.h"
@interface BATTopicScorListCell()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIScrollView *backScroView;

@property (nonatomic,assign) NSInteger LeftCurrentPage;

@property (nonatomic,assign) NSInteger RightCurrentPage;


@end

@implementation BATTopicScorListCell

static NSString *const leftCellReuse = @"leftCellReuse";
static NSString *const RightCellReuse = @"RightCellReuse";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScroview:) name:@"SCROLLVIEWROW" object:nil];
        
        self.isCanScor = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsTableCanScroll) name:@"Topic_LOCK_SCROLL" object:nil];
        
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsTableScrollToTop) name:@"Cell_LOCK_SCROLL" object:nil];
        
        [self.contentView addSubview:self.backScroView];

        
        [self.backScroView addSubview:self.leftTab];

        self.leftTab.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40 -64);
        
        [self.backScroView addSubview:self.rightTab];

        self.rightTab.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40 -64);
        
        
    }
    return self;
}

#pragma mark - action
- (void)changeScroview:(NSNotification *)notice {

    NSDictionary *userDic = (NSDictionary *)notice.object;
    NSInteger page = [userDic[@"page"] integerValue];
    
    switch (page) {
        case 0:
            [self.backScroView setContentOffset:CGPointMake(0, 0)];
            break;
        case 1:
            [self.backScroView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
            break;
        default:
            break;
    }
}

- (void)newsTableCanScroll {
    
    self.isCanScor = YES;

}

- (void)CellCanScroll {

    self.isCanScor = YES;
}

- (void)newsTableScrollToTop {
    

}



#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.leftTab) {
        if (self.modelArr.count >0) {
            return self.modelArr.count;
        }
        return 0;
    }
    if (self.RightModelArr.count >0) {
        return self.RightModelArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.leftTab) {
        
        BATTopicTableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:leftCellReuse forIndexPath:indexPath];
       
       
        if (self.modelArr.count > 0) {
              self.leftTab.mj_footer.hidden = NO;
            HotTopicData *moment = self.modelArr[indexPath.row];
            cells.indexPath = indexPath;
            [cells configrationCell:moment];
             cells.moreButton.hidden = YES;
             cells.sexView.hidden = YES;
            if (moment.ReplyType == 1) {
                cells.commentButton.hidden = YES;
                [cells.thumbsUpButton setTitle:[NSString stringWithFormat:@"阅读%@",moment.ReadNum] forState:UIControlStateNormal];
            }else {
                cells.commentButton.hidden = NO;
                [cells.commentButton setTitle:[NSString stringWithFormat:@"阅读 %@",moment.ReadNum] forState:UIControlStateNormal];
                
                [cells.thumbsUpButton setTitle:[NSString stringWithFormat:@"点赞 %zd",moment.StarNum] forState:UIControlStateNormal];
            }
            
            if (self.leftTabRecordsCount == 0) {
                self.leftTab.mj_footer.hidden = YES;
            }else {
                self.leftTab.mj_footer.hidden = NO;
            }
            
            // WEAK_SELF(self);
            cells.avatarAction = ^(NSIndexPath *cellIndexPath) {
                DDLogWarn(@"头像点击%@",cellIndexPath);
                
                HotTopicData *moment = self.modelArr[cellIndexPath.row];
                if (self.HeadImagePushBlock) {
                    self.HeadImagePushBlock(moment.AccountID);
                }
                
                
            };
            
            if (self.leftTabRecordsCount == self.modelArr.count) {
                self.leftTab.mj_footer.hidden = YES;
            }
           
          
            WEAK_SELF(self);
            cells.moreAction = ^(NSIndexPath *cellIndexPath) {
                DDLogWarn(@"更多操作点击%@",cellIndexPath);
                STRONG_SELF(self);
                if (LOGIN_STATION) {
                    NSString *urlString = nil;
                    if (moment.IsUserFollow) {
                        urlString = @"/api/dynamic/CancelOperation";
                        [self AttendRequesetWithURL:urlString monent:moment dataArr:self.modelArr];
                    }else {
                        urlString = @"/api/dynamic/ExecuteOperation";
                        [self AttendRequesetWithURL:urlString monent:moment dataArr:self.modelArr];
                    }
                }else {
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"isPresentVC" object:nil];
                }
               
            };
            
        }else {
            self.leftTab.mj_footer.hidden = YES;
        }
        return cells;
    }
    
    BATTopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RightCellReuse forIndexPath:indexPath];
    
    if (self.RightModelArr.count > 0) {
         self.rightTab.mj_footer.hidden = NO;
        HotTopicData *moment = self.RightModelArr[indexPath.row];
        cell.indexPath = indexPath;
        [cell configrationCell:moment];
         cell.moreButton.hidden = YES;
        cell.sexView.hidden = YES;
        if (moment.isAudio) {
            cell.commentButton.hidden = YES;
            [cell.thumbsUpButton setTitle:[NSString stringWithFormat:@"阅读%@",moment.ReadNum] forState:UIControlStateNormal];
        }else {
            cell.commentButton.hidden = NO;
            [cell.commentButton setTitle:[NSString stringWithFormat:@"阅读 %@",moment.ReadNum] forState:UIControlStateNormal];
            
            [cell.thumbsUpButton setTitle:[NSString stringWithFormat:@"点赞 %zd",moment.StarNum] forState:UIControlStateNormal];
        }
        
        if (self.RightTabRecordsCount == self.RightModelArr.count) {
//            [self.rightTab.mj_footer endRefreshingWithNoMoreData];
             self.rightTab.mj_footer.hidden = YES;
        }
        

        
        // WEAK_SELF(self);
        cell.avatarAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"头像点击%@",cellIndexPath);
            HotTopicData *moment = self.RightModelArr[cellIndexPath.row];
            if (self.HeadImagePushBlock) {
                self.HeadImagePushBlock(moment.AccountID);
            }

        };
        
        WEAK_SELF(self);
        cell.moreAction = ^(NSIndexPath *cellIndexPath) {
            DDLogWarn(@"更多操作点击%@",cellIndexPath);
            STRONG_SELF(self);
                       if (LOGIN_STATION) {
                NSString *urlString = nil;
                if (moment.IsUserFollow) {
                    urlString = @"/api/dynamic/CancelOperation";
                    [self AttendRequesetWithURL:urlString monent:moment dataArr:self.RightModelArr];
                }else {
                    urlString = @"/api/dynamic/ExecuteOperation";
                    [self AttendRequesetWithURL:urlString monent:moment dataArr:self.RightModelArr];
                }
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"isPresentVC" object:nil];

            }
            
        };
        
    }else {
     self.rightTab.mj_footer.hidden = YES;
    }
   
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *ID = nil;
    NSInteger isAudio = 0;
    if (tableView == self.leftTab) {
        HotTopicData *moment = self.modelArr[indexPath.row];
        ID = moment.ID;
        isAudio = moment.ReplyType;
    }else {
        HotTopicData *moment = self.RightModelArr[indexPath.row];
        ID = moment.ID;
        isAudio = moment.ReplyType;
    }
    if (self.pushBlock) {
        self.pushBlock(ID,isAudio);
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView != self.backScroView) {
        if (self.isCanScor == NO) {
            [scrollView setContentOffset:CGPointZero];
        }
        
        if (scrollView.contentOffset.y < 0) {
            [scrollView setContentOffset:CGPointZero];
            self.isCanScor = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Cell_LOCK_SCROLL" object:nil];
        }
    }
   
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == self.backScroView) {
        NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
        if (page) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLineAction" object:@{@"page":@"1"}];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLineAction" object:@{@"page":@"0"}];
        }
    }

  
}

- (void)AttendRequesetWithURL:(NSString *)url monent:(HotTopicData *)monent dataArr:(NSMutableArray *)dataArr {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"3" forKey:@"RelationType"];
    [dict setObject:monent.AccountID forKey:@"RelationID"];
    
    [HTTPTool requestWithURLString:url parameters:dict type:kPOST success:^(id responseObject) {
        
        monent.IsUserFollow = !monent.IsUserFollow;
        for (HotTopicData *data in dataArr) {
            if ([data.AccountID isEqualToString:monent.AccountID]) {
                data.IsUserFollow = monent.IsUserFollow;
            }
        }
    
        [self.leftTab reloadData];
        [self.rightTab reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

//刷新左表格
- (void)setModelArr:(NSMutableArray *)modelArr {

    _modelArr = modelArr;
    
    [self.leftTab reloadData];
}

//刷新右表格
- (void)setRightModelArr:(NSMutableArray *)RightModelArr {

    _RightModelArr = RightModelArr;
    [self.rightTab reloadData];
}

- (void)setLeftTabRecordsCount:(NSInteger)leftTabRecordsCount {

    _leftTabRecordsCount = leftTabRecordsCount;
    [self.leftTab reloadData];
    
}

- (void)setRightTabRecordsCount:(NSInteger)RightTabRecordsCount {

    _RightTabRecordsCount = RightTabRecordsCount;
    [self.rightTab reloadData];
}
#pragma mark - Lazy Load
- (UIScrollView *)backScroView {

    if (!_backScroView) {
        _backScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - 64)];
        _backScroView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 40- 64);
        _backScroView.backgroundColor = [UIColor whiteColor];
        _backScroView.pagingEnabled = YES;
        _backScroView.delegate = self;
    }
    return _backScroView;
}

- (UITableView *)leftTab {

    if (!_leftTab) {
        _leftTab = [[UITableView alloc]init];
        _leftTab.delegate = self;
        _leftTab.dataSource = self;
        _leftTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTab.estimatedRowHeight = 250;
        _leftTab.rowHeight = UITableViewAutomaticDimension;
        _leftTab.tableFooterView = [UIView new];
        [_leftTab registerNib:[UINib nibWithNibName:@"BATTopicTableViewCell" bundle:nil] forCellReuseIdentifier:leftCellReuse];
        WEAK_SELF(self);
        _leftTab.mj_header.hidden = YES;
        _leftTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.LeftCurrentPage ++;
            if (self.LeftFooterReflashBlock) {
                self.LeftFooterReflashBlock(self.LeftCurrentPage);
            }
        }];
         _leftTab.mj_footer.hidden = YES;
    }
    return _leftTab;
}


- (UITableView *)rightTab {

    if (!_rightTab) {
        _rightTab = [[UITableView alloc]init];
        _rightTab.delegate = self;
        _rightTab.dataSource = self;
        _rightTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTab.estimatedRowHeight = 250;
        _rightTab.rowHeight = UITableViewAutomaticDimension;
        _rightTab.tableFooterView = [UIView new];
        [_rightTab registerNib:[UINib nibWithNibName:@"BATTopicTableViewCell" bundle:nil] forCellReuseIdentifier:RightCellReuse];
        _rightTab.mj_header.hidden = YES;
        _rightTab.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
           
            self.RightCurrentPage ++;
            if (self.RightFooterReflashBlock) {
                self.RightFooterReflashBlock(self.RightCurrentPage);
            }

        }];
        _rightTab.mj_footer.hidden = YES;

    }
    return _rightTab;
}

@end
