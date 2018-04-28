//
//  BATHomeDoctorTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeDoctorTableViewCell.h"
#import "BATHomeDoctorCollectionViewCell.h"

static  NSString * const DOCTOR_COLLECTIONVIEW_CELL = @"DoctorCollectionViewCell";

@implementation BATHomeDoctorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.dataArray = @[
                           @"医生工作室",
                           @"培训工作室",
                           @"国医馆",
                           @"家庭医生"
                           ];
        self.imageArray = @[
                            @"img-ysgzs-home",
                            @"img-pxgzs",
                            @"img-gyg",
                            @"img-jtys"
                            ];

        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.doctorCollectionView];
        [self.doctorCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self);
        }];
        
        
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
    
    BATHomeDoctorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DOCTOR_COLLECTIONVIEW_CELL forIndexPath:indexPath];
    cell.nameLabel.text = self.dataArray[indexPath.row];
    cell.doctorImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArray[indexPath.row]]];
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
    
    CGSize size = CGSizeMake((SCREEN_WIDTH)/4.0, 95);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DDLogError(@"点击－－%ld",(long)indexPath.row);
    if (self.doctorClick) {
        self.doctorClick(indexPath);
    }
}


#pragma mark - getter
- (UICollectionView *)doctorCollectionView {
    
    if (!_doctorCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _doctorCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _doctorCollectionView.backgroundColor = [UIColor whiteColor];
        _doctorCollectionView.showsHorizontalScrollIndicator = NO;
        _doctorCollectionView.delegate = self;
        _doctorCollectionView.dataSource = self;
        _doctorCollectionView.pagingEnabled = YES;
        
        [_doctorCollectionView registerClass:[BATHomeDoctorCollectionViewCell class] forCellWithReuseIdentifier:DOCTOR_COLLECTIONVIEW_CELL];
    }
    return _doctorCollectionView;
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
