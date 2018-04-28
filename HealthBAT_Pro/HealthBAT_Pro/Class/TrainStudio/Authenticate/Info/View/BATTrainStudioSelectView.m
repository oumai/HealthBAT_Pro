//
//  BATTrainStudioSelectView.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/4/5.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainStudioSelectView.h"
#import "BATTrainStudioSelectedCollectionViewCell.h"

static  NSString * const TRAIN_SELECTED_CELL = @"BATTrainStudioSelectedCollectionViewCell";

@implementation BATTrainStudioSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectedArray = [NSMutableArray array];
        
        [self addSubview:self.selectCollectionView];
        [self.selectCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@10);
            make.right.bottom.equalTo(@-10);
            make.height.mas_equalTo(200);
        }];
        
        [self addSubview:self.confirmBtn];
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(@0);
            make.height.mas_equalTo(50);
        }];
        
        self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = BASE_COLOR.CGColor;
        self.layer.borderWidth = 1.0f;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATTrainStudioSelectedCollectionViewCell *selectedCell = [collectionView dequeueReusableCellWithReuseIdentifier:TRAIN_SELECTED_CELL forIndexPath:indexPath];
    
    selectedCell.titleLabel.text = self.dataArray[indexPath.row];
    
    if ([self.selectedArray containsObject:indexPath]) {
        
        selectedCell.layer.borderColor = BASE_COLOR.CGColor;
        selectedCell.titleLabel.textColor = BASE_COLOR;
    }
    else {
        selectedCell.layer.borderColor = STRING_DARK_COLOR.CGColor;
        selectedCell.titleLabel.textColor = STRING_DARK_COLOR;
    }
    
    return selectedCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize textSize = [self.dataArray[indexPath.row] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    CGSize size = CGSizeMake(textSize.width+30, 30);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.selectedArray containsObject:indexPath]) {
        [self.selectedArray removeObject:indexPath];
    }
    else {
        
        [self.selectedArray addObject:indexPath];
        if (self.selectedArray.count > self.maxSelected) {
            [self.selectedArray removeObject:[self.selectedArray firstObject]];
        }
    }
    

    
    [collectionView reloadData];
}

#pragma mark - getter
- (UICollectionView *)selectCollectionView {
    
    if (!_selectCollectionView) {
        
        BATMyFindEqualCellFlowLayout *flowLayout = [[BATMyFindEqualCellFlowLayout alloc] init];
        flowLayout.delegate = self;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        _selectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        [_selectCollectionView registerClass:[BATTrainStudioSelectedCollectionViewCell class] forCellWithReuseIdentifier:TRAIN_SELECTED_CELL];

        _selectCollectionView.backgroundColor = [UIColor whiteColor];
        _selectCollectionView.showsHorizontalScrollIndicator = NO;
        
        _selectCollectionView.delegate = self;
        _selectCollectionView.dataSource = self;
        
    }
    return _selectCollectionView;
}

- (UIButton *)confirmBtn {
    
    if (!_confirmBtn) {
        
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom Title:@"确定" titleColor:UIColorFromHEX(0xffffff,1) backgroundColor:BASE_COLOR backgroundImage:nil Font:[UIFont systemFontOfSize:13]];
        [_confirmBtn bk_whenTapped:^{
           
            if (self.confirmBlock) {
                self.confirmBlock(self.selectedArray);
            }
        }];
    }
    return _confirmBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
