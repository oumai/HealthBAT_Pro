//
//  BATHomeNewConsultationTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeNewConsultationTableViewCell.h"
#import "BATHomeNewConsultationCollectionViewCell.h"

static  NSString * const CONSULTATION_COLLECTIONVIEW_CELL = @"ConsultationCollectionViewCell";

@implementation BATHomeNewConsultationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.dataArray = @[
                           @"症状自诊",
                           @"预约挂号",
                           @"健康咨询"
                           ];
        self.detailDataArray = @[
                                 @"哪里不舒服 快搜一下",
                                 @"绿色通道 方便快达",
                                 @"海量医生为您提供在线咨询服务"
                                 ];
        self.imageArray = @[
                            @"home-Guide-1",
                            @"home-register-pic-1",
                            @"home-doctor-bgd-new"
                            ];

        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.consultationCollectionView];
        [self.consultationCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    BATHomeNewConsultationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CONSULTATION_COLLECTIONVIEW_CELL forIndexPath:indexPath];
    cell.nameLabel.text = self.dataArray[indexPath.row];
    cell.detailLabel.text = self.detailDataArray[indexPath.row];
    cell.consultationImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArray[indexPath.row]]];
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
    
    return 0.5;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake((SCREEN_WIDTH)/3.0, 159);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DDLogError(@"点击－－%ld",(long)indexPath.row);
    if (self.consultationClick) {
        self.consultationClick(indexPath);
    }
}


#pragma mark - getter
- (UICollectionView *)consultationCollectionView {
    
    if (!_consultationCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _consultationCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _consultationCollectionView.backgroundColor = BASE_BACKGROUND_COLOR;
        _consultationCollectionView.showsHorizontalScrollIndicator = NO;
        _consultationCollectionView.delegate = self;
        _consultationCollectionView.dataSource = self;
        _consultationCollectionView.pagingEnabled = YES;
        
        [_consultationCollectionView registerClass:[BATHomeNewConsultationCollectionViewCell class] forCellWithReuseIdentifier:CONSULTATION_COLLECTIONVIEW_CELL];
    }
    return _consultationCollectionView;
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
