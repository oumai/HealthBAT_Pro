//
//  BATAlbumDetailOtherAlbumVideoCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailOtherAlbumVideoCell.h"

#import "BATAlbumDetailOtherAlbumVideoCollectionViewCell.h"

#import "BATAlbumDetailModel.h"

@implementation BATAlbumDetailOtherAlbumVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(10);
        }];
        
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.lineView.mas_bottom).offset(10);
        }];
        
        [self.contentView addSubview:self.videoCountLabel];
        [self.videoCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.titleLabel.mas_right).offset(10);
            make.centerY.equalTo(self.titleLabel.mas_centerY);
        }];
        
        [self.contentView addSubview:self.videoCollectionView];
        [self.videoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.bottom.equalTo(@-10);
        }];
        
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
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
    
    BATAlbumDetailOtherAlbumVideoCollectionViewCell *albumVideoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATAlbumDetailOtherAlbumVideoCollectionViewCell" forIndexPath:indexPath];
    
    BATAlbumProjectVideoData *data = self.dataArray[indexPath.row];
    
    albumVideoCell.titleLabel.text = data.Name;
    [albumVideoCell.videoImageView sd_setImageWithURL:[NSURL URLWithString:data.Poster] placeholderImage:[UIImage imageNamed:@"默认图"]];
    
    return albumVideoCell;
}

//每个item 的视图的宽高  只有宽高，没有frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake(115, 70);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DDLogError(@"点击－－%ld",(long)indexPath.item);
    if (self.videoClick) {
        self.videoClick(indexPath);
    }
}

#pragma mark - public
- (void)sendAlbumVideoData:(BATAlbumDetailModel *)model {
    
    self.dataArray = model.Data.ProjectVideoList;
    
    if(model.Data.ProjectVideoList.count > 0){
        self.titleLabel.hidden = NO;
        self.videoCountLabel.hidden = NO;
        self.titleLabel.text = model.Data.Theme;
        self.videoCountLabel.text = [NSString stringWithFormat:@"(%ld)",(unsigned long)model.Data.ProjectVideoList.count];
    }else{
        self.titleLabel.hidden = YES;
        self.videoCountLabel.hidden = YES;
    }

    [self.videoCollectionView reloadData];
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)videoCountLabel {
    if (!_videoCountLabel) {
        _videoCountLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:UIColorFromHEX(0x999999, 1) textAlignment:NSTextAlignmentLeft];
    }
    return _videoCountLabel;
}

- (UICollectionView *)videoCollectionView {
    if (!_videoCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _videoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _videoCollectionView.backgroundColor = [UIColor whiteColor];
        _videoCollectionView.showsHorizontalScrollIndicator = NO;
        _videoCollectionView.delegate = self;
        _videoCollectionView.dataSource = self;
        
        [_videoCollectionView registerClass:[BATAlbumDetailOtherAlbumVideoCollectionViewCell class] forCellWithReuseIdentifier:@"BATAlbumDetailOtherAlbumVideoCollectionViewCell"];
    }
    return _videoCollectionView;
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
