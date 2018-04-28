//
//  BATSectionThreeCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSectionThreeCell.h"
#import "BATSearchWithTypeModel.h"

//Cell
#import "BATSearchDoctorCell.h"
#import "BATDieaseDetailCollectionViewCell.h"

@interface BATSectionThreeCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation BATSectionThreeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.searchCollection];
        [self.searchCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - Setter and Getter
- (void)setTypModelArray:(NSMutableArray *)typModelArray {

    _typModelArray = typModelArray;
    [self.searchCollection reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

//每个item 的视图的宽高  只有宽高，没有frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH, 330);
}
//上下间距 每个section items上下行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATDieaseDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATDieaseDetailCollectionViewCell" forIndexPath:indexPath];
    cell.modelArray = self.typModelArray;
    return cell;
}


#pragma mark scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADDIEASECOLLECTIONVIEWCELL" object:@(page)];
}


#pragma mark - Lazy Load
- (UICollectionView *)searchCollection {

    if (!_searchCollection) {
         UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _searchCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 330) collectionViewLayout:flow];
        _searchCollection.delegate = self;
        _searchCollection.dataSource = self;
        _searchCollection.showsHorizontalScrollIndicator = NO;
        _searchCollection.alwaysBounceVertical = YES;
        _searchCollection.pagingEnabled = YES;
        _searchCollection.bounces = NO;
        [_searchCollection registerClass:[BATDieaseDetailCollectionViewCell class] forCellWithReuseIdentifier:@"BATDieaseDetailCollectionViewCell"];
    }
    return _searchCollection;
}

@end
