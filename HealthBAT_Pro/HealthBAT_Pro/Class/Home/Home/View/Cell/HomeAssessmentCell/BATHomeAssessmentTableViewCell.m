//
//  AssessmentCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/7/62016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeAssessmentTableViewCell.h"
#import "BATHomeAssessmentCollectionViewCell.h"
#import "BATHealthAssessmentModel.h"

static  NSString * const ASSESSMENT_COLLECTIONVIEW_CELL = @"AssessmentCollectionViewCell";

@implementation BATHomeAssessmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.assessmentCollectionView];
        [self.assessmentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@10);
            make.bottom.equalTo(@-10);
            make.right.equalTo(@0);
        }];


    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BATHomeAssessmentCollectionViewCell *assessmentCell = [collectionView dequeueReusableCellWithReuseIdentifier:ASSESSMENT_COLLECTIONVIEW_CELL forIndexPath:indexPath];
    if (self.dataArray.count > 0) {
        BATAssessmentData * data = self.dataArray[indexPath.section];
        [assessmentCell.assessmentImageView sd_setImageWithURL:[NSURL URLWithString:data.ThemeCoverImg] placeholderImage:[UIImage imageNamed:@"默认图"]];
        assessmentCell.countLabel.text = [NSString stringWithFormat:@"已有%ld人参与",(long)data.EvaluatedCount];
    }
    return assessmentCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = CGSizeMake(150+10, 90);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    DDLogError(@"点击－－%ld",(long)indexPath.section);
    if (self.assessmentClick) {
        self.assessmentClick(indexPath);
    }
}

#pragma mark - getter
- (UICollectionView *)assessmentCollectionView {

    if (!_assessmentCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _assessmentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _assessmentCollectionView.backgroundColor = [UIColor whiteColor];
        _assessmentCollectionView.showsHorizontalScrollIndicator = NO;
        _assessmentCollectionView.delegate = self;
        _assessmentCollectionView.dataSource = self;

        [_assessmentCollectionView registerClass:[BATHomeAssessmentCollectionViewCell class] forCellWithReuseIdentifier:ASSESSMENT_COLLECTIONVIEW_CELL];
    }
    return _assessmentCollectionView;
}

@end
