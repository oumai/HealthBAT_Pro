//
//  BATCourseKeyTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2016/12/9.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATCourseKeyTableViewCell.h"
#import "BATCourseKeyCollectionViewCell.h"
#import "BATHotKeyModel.h"

@interface BATCourseKeyTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) BATHotKeyModel *hotKeyModel;

@end

@implementation BATCourseKeyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self pageLayout];
        
        [self.collectionView registerClass:[BATCourseKeyCollectionViewCell class] forCellWithReuseIdentifier:@"BATCourseKeyCollectionViewCell"];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)confirgationCell:(BATHotKeyModel *)hotKeyModel
{
    self.hotKeyModel = hotKeyModel;
    
    [self.contentView layoutIfNeeded];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hotKeyModel.Data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BATCourseKeyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATCourseKeyCollectionViewCell" forIndexPath:indexPath];
    
    if (self.hotKeyModel.Data.count > 0) {
        
        HotKeyData *data = self.hotKeyModel.Data[indexPath.row];
        
        cell.keyLabel.text = data.Keyword;
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hotKeyModel.Data.count > 0) {
        if (self.courseKeyTapBlock) {
            HotKeyData *data = self.hotKeyModel.Data[indexPath.row];
            self.courseKeyTapBlock(indexPath,data.Keyword);
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.hotKeyModel.Data.count > 0) {
        HotKeyData *data = self.hotKeyModel.Data[indexPath.row];
        
        CGSize textSize = [data.Keyword boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
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
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
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
