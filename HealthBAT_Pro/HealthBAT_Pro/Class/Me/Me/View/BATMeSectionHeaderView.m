//
//  BATMeSectionHeaderView.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/9/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//
static NSString *identifier = @"BATMeSectionCollectionViewCellID";


#import "BATMeSectionHeaderView.h"
#import "BATMeSectionCollectionViewCell.h"
@interface BATMeSectionHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionViewFlowLayout    *layout;
@property (nonatomic, strong) UICollectionView              *collectionView;


@end

@implementation BATMeSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    
    
    if (self = [super initWithFrame:frame]) {
        
        
        
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.itemSize = CGSizeMake((SCREEN_WIDTH)/3, 100);
        self.layout.minimumLineSpacing = 0;
        self.layout.minimumInteritemSpacing = 0;
        [self.layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_collectionView];
        
        [self.collectionView registerClass:[BATMeSectionCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];

        
    }
    return self;
}

#pragma mark ------------------------------------------------------------------UICollectionViewDelegateFlowLayout-------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    BATMeSectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    NSArray *titleArray = @[@"优惠码",@"健康咨询",@"家庭医生"];
    NSArray *imageArray = @[@"personalCenter_yhm",@"personalCenter_jkzx",@"personalCenter_jtys"];
    cell.titleLabel.text = titleArray[indexPath.row];
    cell.iconImage.image = [UIImage imageNamed:imageArray[indexPath.row]];
//    __weak BATMeSectionCollectionViewCell*safeCell = cell;
//    [safeCell setPushBlock:^() {
//        
//        
//    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.pushNextVCBlock) {
        
        self.pushNextVCBlock(indexPath.row);
    }
    
    
}

@end
