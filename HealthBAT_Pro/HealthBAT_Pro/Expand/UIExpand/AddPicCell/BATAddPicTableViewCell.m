//
//  BATAddPicTableViewCell.m
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATAddPicTableViewCell.h"
#import "BATPicCollectionViewCell.h"

@interface BATAddPicTableViewCell ()

@property (nonatomic,strong) NSMutableArray *picDataSource;

@end

@implementation BATAddPicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _picDataSource = [NSMutableArray array];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(ItemWidth, ItemWidth);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
//        flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.contentView addSubview:_collectionView];
        
        [_collectionView registerClass:[BATPicCollectionViewCell class] forCellWithReuseIdentifier:@"BATPicCollectionViewCell"];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"添加图片";
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        [self.contentView addSubview:_titleLabel];
        
        
        _messageLabel = [[UILabel alloc] init];
//        _messageLabel.text = @"病症部位、检查报告或者其他病情资料";
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.textColor = UIColorFromHEX(0x999999, 1);
        [self.contentView addSubview:_messageLabel];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.bottom.top.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(15, 10, 15, 10));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
//        make.left.equalTo(self.contentView).offset(15+ItemWidth);
//        make.right.equalTo(self.contentView);
//        make.centerY.equalTo(_collectionView.mas_centerY).offset(-15);
        make.left.equalTo(self.contentView).offset(15+ItemWidth+15);
//        make.right.equalTo(self.contentView);
        make.centerY.equalTo(_collectionView.mas_centerY);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15+ItemWidth+15);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(_collectionView.mas_centerY).offset(17);
    }];
}

#pragma mark UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_picDataSource.count < 9) {
        return _picDataSource.count + 1;
    }
    return _picDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BATPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATPicCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row == _picDataSource.count) {
        cell.imageView.image = [UIImage imageNamed:@"Add-pictures"];
      //  cell.deleteImageView.hidden = YES;
    } else {
        cell.imageView.image = _picDataSource[indexPath.row];
      //  cell.deleteImageView.hidden = NO;
    }
    return cell;
}

#pragma mark UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(collectionViewItemClicked:)]) {
        [_delegate collectionViewItemClicked:indexPath];
    }
}


#pragma mark Action
- (void)reloadCollectionViewData:(NSMutableArray *)dataSource
{
    [_picDataSource removeAllObjects];
    [_picDataSource addObjectsFromArray:dataSource];
    
    if (_picDataSource.count > 0) {
        _titleLabel.hidden = YES;
        _messageLabel.hidden = YES;
    } else {
        _titleLabel.hidden = NO;
        _messageLabel.hidden = NO;
    }
    

    [_collectionView reloadData];
}

@end
