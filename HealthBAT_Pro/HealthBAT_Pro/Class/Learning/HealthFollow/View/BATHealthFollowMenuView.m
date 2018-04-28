//
//  BATHealthFollowMenuView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/21.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFollowMenuView.h"
#import "BATHealthFollowMenuCell.h"

@interface BATHealthFollowMenuView () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation BATHealthFollowMenuView

- (void)dealloc
{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self pageLayout];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BATHealthFollowMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATHealthFollowMenuCell" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:@"icon-wdfa"];
    cell.titleLabel.text = @"我的方案";
    
    /*
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"icon-faxian"];
        cell.titleLabel.text = @"发现";
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"icon-tz"];
        cell.titleLabel.text = @"帖子";
    } else if (indexPath.row == 2) {
        cell.imageView.image = [UIImage imageNamed:@"icon-wdfa"];
        cell.titleLabel.text = @"我的方案";
    }*/
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionCellClicked) {
        self.collectionCellClicked(indexPath);
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.collectionView];
    
    WEAK_SELF(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
}

#pragma mark - get & set
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, 60);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[BATHealthFollowMenuCell class] forCellWithReuseIdentifier:@"BATHealthFollowMenuCell"];
    }
    return _collectionView;
}

@end
