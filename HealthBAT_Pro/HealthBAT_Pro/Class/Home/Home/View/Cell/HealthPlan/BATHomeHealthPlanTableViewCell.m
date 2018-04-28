//
//  BATHomeHealthPlanTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeHealthPlanTableViewCell.h"
#import "BATHomeHealthPlanCollectionViewCell.h"

static  NSString * const HEALTH_PLAN_COLLECTIONVIEW_CELL = @"BATHomeHealthPlanCollectionViewCell";

@implementation BATHomeHealthPlanTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
                
        [self.contentView addSubview:self.healthPlanCollectionView];
        [self.healthPlanCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@10);
            make.bottom.equalTo(@-10);
            make.right.equalTo(@0);
        }];
        

    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BATHomeHealthPlanCollectionViewCell *healthPlanCell = [collectionView dequeueReusableCellWithReuseIdentifier:HEALTH_PLAN_COLLECTIONVIEW_CELL forIndexPath:indexPath];
    
    switch (indexPath.section) {
            case 0:
        {
            //美容
            healthPlanCell.healthPlanImageView.image = [UIImage imageNamed:@"img-jkjh1"];
            healthPlanCell.titleLabel.text = @"HIIT健身";
        }
            break;
            case 1:
        {
            //养生
            healthPlanCell.healthPlanImageView.image = [UIImage imageNamed:@"img-jkjh2"];
            healthPlanCell.titleLabel.text = @"养生操";
        }
            break;
            case 2:
        {
            //减肥
            healthPlanCell.healthPlanImageView.image = [UIImage imageNamed:@"img-jkjh3"];
            healthPlanCell.titleLabel.text = @"身体塑形";
        }
            break;
            
        default:
            break;
    }
    
    return healthPlanCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(160, 90);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DDLogError(@"点击－－%ld",(long)indexPath.section);
    if (self.healthPlanClick) {
        self.healthPlanClick(indexPath);
    }
}

#pragma mark - getter
- (UICollectionView *)healthPlanCollectionView {
    
    if (!_healthPlanCollectionView) {
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _healthPlanCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _healthPlanCollectionView.backgroundColor = [UIColor whiteColor];
        _healthPlanCollectionView.showsHorizontalScrollIndicator = NO;
        _healthPlanCollectionView.delegate = self;
        _healthPlanCollectionView.dataSource = self;
        
        [_healthPlanCollectionView registerClass:[BATHomeHealthPlanCollectionViewCell class] forCellWithReuseIdentifier:HEALTH_PLAN_COLLECTIONVIEW_CELL];
    }
    return _healthPlanCollectionView;
}

#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
