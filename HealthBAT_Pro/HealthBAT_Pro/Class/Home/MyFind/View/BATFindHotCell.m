//
//  BATFindHotCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFindHotCell.h"
#import "BATHotTopicCollectionCell.h"
#import "BATMyFindEqualCellFlowLayout.h"
@interface  BATFindHotCell()<UICollectionViewDelegate,UICollectionViewDataSource,BATMyFindEqualCellFlowLayoutDelegate>
@property (nonatomic,strong) BATHotTopicListModel  *listModel;
@end

@implementation BATFindHotCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self pageLayout];
        
        
        [self.collectionView registerClass:[BATHotTopicCollectionCell class] forCellWithReuseIdentifier:@"BATHotTopicCollectionCell"];
       
    }
    
    return self;
}

- (void)confirgationCell:(BATHotTopicListModel *)hotKeyModel {

    self.listModel = hotKeyModel;
    [self.collectionView reloadData];
    [self.contentView layoutIfNeeded];

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listModel.Data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BATHotTopicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATHotTopicCollectionCell" forIndexPath:indexPath];
    
    if (self.listModel.Data.count > 0) {
        
        HotTopicListData *data = self.listModel.Data[indexPath.row];
        
        cell.keyLabel.text = data.Topic;
        
        if (data.isSelect) {
            cell.keyLabel.textColor = BASE_COLOR;
            cell.layer.borderColor = BASE_COLOR.CGColor;
        }else {
            cell.keyLabel.textColor = UIColorFromHEX(0X333333, 1);
            cell.layer.borderColor = BASE_BACKGROUND_COLOR.CGColor;
        }
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listModel.Data.count > 0) {
        
        for (HotTopicListData *data in self.listModel.Data) {
            data.isSelect = NO;
        }
        
         HotTopicListData *data = self.listModel.Data[indexPath.row];
         data.isSelect = YES;
        [self.collectionView reloadData];
        
        if (self.topicKeyTapBlock) {
            HotTopicListData *data = self.listModel.Data[indexPath.row];
            self.topicKeyTapBlock(indexPath,data.ID);
        }
    }
}

//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 20;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listModel.Data.count > 0) {
        HotTopicListData *data = self.listModel.Data[indexPath.row];
        
        CGSize textSize = [data.Topic boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        return CGSizeMake(textSize.width+20, 30);
    }
    return CGSizeZero;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority
{
    self.collectionView.frame = CGRectMake(0, 0, targetSize.width, MAXFLOAT);
    //    [self.collectionView layoutIfNeeded];
    
    return [self.collectionView.collectionViewLayout collectionViewContentSize];
}

#pragma makr - Layout
- (void)pageLayout
{
    [self.contentView addSubview:self.collectionView];
    
    WEAK_SELF(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.contentView);
    }];
}


#pragma mark - get&set
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        BATMyFindEqualCellFlowLayout *flowLayout = [[BATMyFindEqualCellFlowLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}


@end
