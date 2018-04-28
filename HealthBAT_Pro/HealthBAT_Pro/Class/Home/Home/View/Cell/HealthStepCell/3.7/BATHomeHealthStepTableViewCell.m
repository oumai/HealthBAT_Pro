//
//  BATHomeHealthStepTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHealthStepTableViewCell.h"
#import "BATHomeHealthStepCollectionViewCell.h"

static  NSString * const HEALTH_STEP_CELL = @"HealthStepCell";

@implementation BATHomeHealthStepTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.detailArray = @[
                             @"步数",
                             @"热能消耗",
                             @"脂肪消耗"
                             ];
        self.imageArray = @[
                            @"ic-bs",
                            @"ic-rnxh",
                            @"ic-zfxh"
                            ];

        [self.contentView addSubview:self.healthStepCollectionView];
        [self.healthStepCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(@0);
            make.height.mas_equalTo(81);
        }];
        
    }
    return self;
}
#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.titleArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATHomeHealthStepCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HEALTH_STEP_CELL forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.section];
    cell.detailImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArray[indexPath.row]]];
    cell.detailLabel.text = self.detailArray[indexPath.section];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


//上下间距 每个section items上下行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return CGFLOAT_MIN;
}
//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake((SCREEN_WIDTH)/((float)self.titleArray.count), 81);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - getter
- (UICollectionView *)healthStepCollectionView {
    
    if (!_healthStepCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _healthStepCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _healthStepCollectionView.backgroundColor = [UIColor whiteColor];
        _healthStepCollectionView.showsHorizontalScrollIndicator = NO;
        _healthStepCollectionView.delegate = self;
        _healthStepCollectionView.dataSource = self;
        _healthStepCollectionView.pagingEnabled = YES;
        
        [_healthStepCollectionView registerClass:[BATHomeHealthStepCollectionViewCell class] forCellWithReuseIdentifier:HEALTH_STEP_CELL];
        
        [_healthStepCollectionView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return _healthStepCollectionView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
