//
//  BATMoreTopicsFootView.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMoreTopicsFootView.h"
#import "BATHotTopicCollectionCell.h"
#import "BATMyFindEqualCellFlowLayout.h"
@interface BATMoreTopicsFootView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
BATMyFindEqualCellFlowLayoutDelegate
>
@property (nonatomic ,strong)   UICollectionView                *collectionView;
@property (nonatomic ,strong)   UIView                          *topicTitleView;
@property (nonatomic ,copy)     NSArray<MyTopicListDataModel *> *modelArray;
@end


@implementation BATMoreTopicsFootView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- private
- (void)setupUI {
    [self addSubview:self.collectionView];
    [self addSubview:self.topicTitleView];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.topicTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(1);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicTitleView.mas_bottom).offset(1);
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setDataShowStyle:(BATTopicListModel *)model {
    self.modelArray = model.Data;
    for (MyTopicListDataModel *dataModel in self.modelArray) {
        dataModel.Topic = [NSString stringWithFormat:@"#%@#",dataModel.Topic];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BATHotTopicCollectionCell *topicCell = [collectionView dequeueReusableCellWithReuseIdentifier:BATHotTopicCollectionCellIdentifier forIndexPath:indexPath];
    if (self.modelArray.count > 0) {
        MyTopicListDataModel *model = self.modelArray[indexPath.row];
        [topicCell.keyLabel setTitle:model.Topic forState:UIControlStateNormal];
        if (model.isSelect) {
            [topicCell.keyLabel setGradientColors:@[START_COLOR,END_COLOR]];
            topicCell.layer.borderColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img-qryy"]].CGColor;
        }else {
            [topicCell.keyLabel setGradientColors:@[UIColorFromHEX(0X333333, 1),UIColorFromHEX(0X333333, 1)]];
            topicCell.layer.borderColor = BASE_LINECOLOR.CGColor;
        }
    }
    return topicCell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.modelArray.count > 0) {
        for (MyTopicListDataModel *model in self.modelArray) {
            model.isSelect = NO;
        }
        MyTopicListDataModel *model =self.modelArray[indexPath.row];
        model.isSelect = YES;
        [self.collectionView reloadData];
        if (self.delegate && [self.delegate respondsToSelector:@selector(topicsFootView:didSelectedTopics:)]) {
            [self.delegate topicsFootView:self didSelectedTopics:model];
        }
    }
}

//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.modelArray.count > 0) {
        MyTopicListDataModel *model = self.modelArray[indexPath.row];
        CGSize textSize = [model.Topic boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        return CGSizeMake(textSize.width+20, 30);
    }
    return CGSizeZero;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    self.collectionView.frame = CGRectMake(0, 0, targetSize.width, MAXFLOAT);
    return [self.collectionView.collectionViewLayout collectionViewContentSize];
}

#pragma mark -- setter & getter
- (void)setDataWithListModel:(BATTopicListModel *)model {
    [self setDataShowStyle:model];
    [self.collectionView reloadData];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        BATMyFindEqualCellFlowLayout *flowLayout = [[BATMyFindEqualCellFlowLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionView registerClass:[BATHotTopicCollectionCell class] forCellWithReuseIdentifier:BATHotTopicCollectionCellIdentifier];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIView *)topicTitleView {
    if (!_topicTitleView) {
        _topicTitleView = [[UIView alloc] init];
        _topicTitleView.backgroundColor = [UIColor whiteColor];
        UILabel *topicTitleLabel = [[UILabel alloc] init];
        topicTitleLabel.textAlignment = NSTextAlignmentLeft;
        topicTitleLabel.text = @"选择帖子话题";
        topicTitleLabel.font = [UIFont systemFontOfSize:15];
        [_topicTitleView addSubview:topicTitleLabel];
        [topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_topicTitleView).insets(UIEdgeInsetsMake(0, 10, 0, 0));
        }];
    }
    return _topicTitleView;
}
@end
