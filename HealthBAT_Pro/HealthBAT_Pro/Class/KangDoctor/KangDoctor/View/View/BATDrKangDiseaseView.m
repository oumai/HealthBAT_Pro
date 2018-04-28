//
//  BATDrKangDiseaseView.m
//  HealthBAT_Pro
//
//  Created by KM on 17/7/182017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDrKangDiseaseView.h"
#import "BATDrKangDiseaseCollectionViewCell.h"
#import "BATDrKangDiseaseHeaderView.h"

static  NSString * const DISEASE_CELL = @"BATDrKangDiseaseCollectionViewCell";
static  NSString * const DISEASE_HEADER = @"BATDrKangDiseaseHeaderView";

@implementation BATDrKangDiseaseView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromHEX(0x323232,0.8);
        
        [self addSubview:self.topButton];
        [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.right.equalTo(@0);
            make.height.mas_equalTo(@140);
        }];

        
        [self addSubview:self.downButton];
        [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@140);
            make.left.right.equalTo(@0);
            make.height.mas_equalTo(@40);
        }];
        
        [self addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.downButton.mas_bottom).offset(0);
            make.left.right.equalTo(@0);
            make.bottom.equalTo(@0);
        }];
        
        [self addSubview:self.diseaseCollectionView];
        [self.diseaseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.downButton.mas_bottom).offset(10);
            make.left.equalTo(@10);
            make.right.equalTo(@-10);
            make.bottom.equalTo(@-10);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataDic.allKeys.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    NSString *key = self.dataDic.allKeys[section];
    //保证顺序
    if (self.titleArray.count == self.dataDic.allKeys.count) {
        key = self.titleArray[section];
    }
    NSArray *diseaseArray = self.dataDic[key];
    return diseaseArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATDrKangDiseaseCollectionViewCell *diseaseCell = [collectionView dequeueReusableCellWithReuseIdentifier:DISEASE_CELL forIndexPath:indexPath];
    
    NSString *key = self.dataDic.allKeys[indexPath.section];
    //保证顺序
    if (self.titleArray.count == self.dataDic.allKeys.count) {
        key = self.titleArray[indexPath.section];
    }
    NSArray *diseaseArray = self.dataDic[key];
    [diseaseCell.keyWordLabel setTitle:diseaseArray[indexPath.row] forState:UIControlStateNormal];
    
    CGSize textSize = [diseaseArray[indexPath.row] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    CGSize size = CGSizeMake(textSize.width+20, 30);
    
    [diseaseCell.keyWordLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width);
    }];
    return diseaseCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = self.dataDic.allKeys[indexPath.section];
    if (self.titleArray.count == self.dataDic.allKeys.count) {
        key = self.titleArray[indexPath.section];
    }
    NSArray *diseaseArray = self.dataDic[key];
    
    NSString *bottomKey = diseaseArray[indexPath.row];
    
    CGSize textSize = [bottomKey boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    CGSize size = CGSizeMake(textSize.width+20, 30);
    
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        BATDrKangDiseaseHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DISEASE_HEADER forIndexPath:indexPath];
        
        [header.titleBtn setTitle:self.dataDic.allKeys[indexPath.section] forState:UIControlStateNormal];

        return header;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectedDisease) {
        
        NSString *key = self.dataDic.allKeys[indexPath.section];
        if (self.titleArray.count == self.dataDic.allKeys.count) {
            key = self.titleArray[indexPath.section];
        }
        NSArray *diseaseArray = self.dataDic[key];
        
        self.selectedDisease(diseaseArray[indexPath.row]);
    }
}

#pragma mark - getter
- (UIButton *)topButton {
    
    if (!_topButton) {
        
        WEAK_SELF(self);
        _topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _topButton.backgroundColor = UIColorFromHEX(0x323232,0.8);
        [_topButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.topBlock) {
                self.topBlock();
            }
        }];
    }
    return _topButton;
}

- (UIButton *)downButton {
    
    if (!_downButton) {
        
        WEAK_SELF(self);
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downButton.backgroundColor = [UIColor whiteColor];
        [_downButton setImage:[UIImage imageNamed:@"icon-tk"] forState:UIControlStateNormal];
        [_downButton bk_whenTapped:^{
            STRONG_SELF(self);
            if (self.downBlock) {
                self.downBlock();
            }
        }];
    }
    return _downButton;
}

- (UIView *)backView {
    
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UICollectionView *)diseaseCollectionView {
    
    if (!_diseaseCollectionView) {
        
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        _diseaseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _diseaseCollectionView.backgroundColor = [UIColor whiteColor];
        _diseaseCollectionView.showsHorizontalScrollIndicator = NO;
        _diseaseCollectionView.delegate = self;
        _diseaseCollectionView.dataSource = self;
        
        [_diseaseCollectionView registerClass:[BATDrKangDiseaseCollectionViewCell class] forCellWithReuseIdentifier:DISEASE_CELL];
        [_diseaseCollectionView registerClass:[BATDrKangDiseaseHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DISEASE_HEADER];
    }
    return _diseaseCollectionView;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
