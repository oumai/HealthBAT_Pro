//
//  BATHealthFollowCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowCell.h"
#import "BATHealthFollowTableCell.h"
#import "BATCourseModel.h"

@interface BATHealthFollowCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 是否刷新数据
 */
@property (nonatomic,assign) BOOL isRefresh;

/**
 是否可以滑动
 */
@property (nonatomic,assign) BOOL canScroll;

@end

@implementation BATHealthFollowCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //注册刷新数据通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAllData) name:@"HealthFollow" object:nil];
        //注册列表滑动通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canScoll:) name:@"BATHealthFollowTableCellTableCanScrollNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCategory:) name:@"BATHealthFollowChangeCategory" object:nil];
        
        _isRefresh = NO;
        
        [self pageLayout];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeCategory:(NSNotification *)noti {
    
    NSInteger number = [noti.userInfo[@"CategoryType"] integerValue];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = number + 100;
    [self.categoryView buttonAction:btn];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryView.buttons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BATHealthFollowTableCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"BATHealthFollowTableCell_%ld",(long)indexPath.row] forIndexPath:indexPath];
    
    if (self.categoryView.buttons.count > 0) {
        BATSpecialtyTopicData *data = self.categoryView.specialModel.Data[indexPath.row];
        cell.ObjID = data.ObjID;
        cell.canScroll = self.canScroll;
        
//        cell.isRefresh = [self.categoryView.refreshs[indexPath.row] boolValue];
        
        WEAK_SELF(self);
        cell.courseClicked = ^(BATCourseData *data){
            //课程点击
            STRONG_SELF(self);
            if (self.healthCourseClick) {
                self.healthCourseClick(data);
            }
        };
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    BATHealthFollowTableCell *tempCell = (BATHealthFollowTableCell *)cell;
    
    //数据是否刷新
    BOOL refresh = [self.categoryView.refreshs[indexPath.row] boolValue];
    
    if (refresh) {
        //刷新时重置数据
        [tempCell.dataSource removeAllObjects];
        tempCell.pageIndex = 0;
    }

    if (tempCell.dataSource.count <= 0) {
        [tempCell requestSpecialtyTopicList:^(BOOL isFinish) {
//            self.isRefresh = !isFinish;
            //改变分类刷新状态
            [self.categoryView.refreshs replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
        }];
    } else {
        [tempCell.tableView reloadData];
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    [self.categoryView categoryAnimate:page + 100];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSInteger page = scrollView.contentOffset.x / SCREEN_WIDTH;
//    
//    [self.categoryView categoryAnimate:page + 100];
//}

#pragma mark - Action
- (void)requestAllData
{
    //判断是否刷新
    if (self.categoryView.buttons.count > 0) {
        _isRefresh = YES;
    } else {
        _isRefresh = NO;
    }
    [self.categoryView requestAllCourseList];
}

- (void)canScoll:(NSNotification *)notif
{
    self.canScroll = YES;
    
    [self.collectionView reloadData];
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.categoryView];
    [self.contentView addSubview:self.collectionView];
    WEAK_SELF(self);
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.bottom.equalTo(self.contentView);
        make.top.equalTo(self.categoryView.mas_bottom);
    }];
}

#pragma mark - get & set

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 50);
//        flowLayout.minimumLineSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
//        _collectionView.layer.borderColor = [UIColor yellowColor].CGColor;
//        _collectionView.layer.borderWidth = 1;
        
//        [_collectionView registerClass:[BATHealthFollowTableCell class] forCellWithReuseIdentifier:@"BATHealthFollowTableCell"];
        
    }
    return _collectionView;
}

- (BATHealthFollowCategoryView *)categoryView
{
    if (_categoryView == nil) {
        _categoryView = [[BATHealthFollowCategoryView alloc] init];
        
        WEAK_SELF(self);
        _categoryView.categoryButtonAction = ^(NSInteger index) {
            //分类点击
            STRONG_SELF(self);
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        };
        
        _categoryView.loadCategoryFinish = ^(BOOL success) {
            //分类加载完成
            STRONG_SELF(self);
            if (!self.isRefresh) {
                for (NSInteger i = 0; i < self.categoryView.buttons.count; i++) {
                    [self.collectionView registerClass:[BATHealthFollowTableCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"BATHealthFollowTableCell_%ld",(long)i]];
                }
                
                [self.collectionView reloadData];
                
            } else {
                
                [self.collectionView reloadData];

                if (self.categoryView.buttons.count > 0) {
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
                }
                
                
            }

        };
    }
    return _categoryView;
}

@end
