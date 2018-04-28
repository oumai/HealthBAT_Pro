//
//  BATdrugTableViewcell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATdrugTableViewcell.h"
#import "BATDrugCollectionCell.h"

@interface BATdrugTableViewcell()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation BATdrugTableViewcell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.productCollectionView];
        [self.productCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setDataArry:(NSMutableArray *)dataArry {

    _dataArry = dataArry;
    [self.productCollectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArry.count;
}

//每个item 的视图的宽高  只有宽高，没有frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH/3, 120);
}
//上下间距 每个section items上下行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATDrugCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATDrugCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (self.dataArry) {
        cell.model = self.dataArry[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.didselectBlock) {
        self.didselectBlock(indexPath);
    }
}

#pragma mark - Lazy Load
- (UICollectionView *)productCollectionView {
    
    if (!_productCollectionView) {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _productCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 330) collectionViewLayout:flow];
        _productCollectionView.delegate = self;
        _productCollectionView.dataSource = self;
        _productCollectionView.showsHorizontalScrollIndicator = NO;
        _productCollectionView.alwaysBounceVertical = YES;
        _productCollectionView.pagingEnabled = YES;
        _productCollectionView.bounces = NO;
        _productCollectionView.backgroundColor = [UIColor whiteColor];
        [_productCollectionView registerClass:[BATDrugCollectionCell class] forCellWithReuseIdentifier:@"BATDrugCollectionCell"];
    }
    return _productCollectionView;
}

@end
