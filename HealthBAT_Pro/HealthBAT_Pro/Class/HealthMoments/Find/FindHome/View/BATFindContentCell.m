//
//  BATFindContentCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATFindContentCell.h"
#import "BATFindDoctorCollectionViewCell.h"
#import "BATFindGroupCollectionViewCell.h"
#import "BATFindFriendsCollectionViewCell.h"
#import "BATRecommendUserModel.h"
#import "BATRecommendGroupModel.h"

@interface BATFindContentCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) BATFindType type;

@end

@implementation BATFindContentCell

- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _dataSource = [NSMutableArray array];
    
    _flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 2 * 10.0f) / 3, self.contentView.frame.size.height);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"BATFindDoctorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BATFindDoctorCollectionViewCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"BATFindGroupCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BATFindGroupCollectionViewCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"BATFindFriendsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"BATFindFriendsCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configrationCell:(NSArray *)data type:(BATFindType)type
{
    _type = type;
    
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:data];
    
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == BATFindDoctor) {
        BATFindDoctorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATFindDoctorCollectionViewCell" forIndexPath:indexPath];
        
        if (_dataSource.count > 0) {
            BATRecommendUserData *recommendUserData = _dataSource[indexPath.row];
            
            if ([recommendUserData.PhotoPath hasPrefix:@"http://"]) {
//                [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:recommendUserData.PhotoPath] placeholderImage:[UIImage imageNamed:@"医生"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    if (image) {
//                        cell.avatarImageView.image = [Tools findFace:image];
//                    }
//                }];

                [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:recommendUserData.PhotoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
            } else {

//                [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,recommendUserData.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                    if (image) {
//                        cell.avatarImageView.image = [Tools findFace:image];
//                    }
//                }];
                [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_WEB_DOMAIN_URL,recommendUserData.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"]];
            }
            
            cell.userNameLabel.text = recommendUserData.UserName;
            cell.masterImageView.hidden = !recommendUserData.IsMaster;
            
            cell.followButton.tag = indexPath.row;
            
            [cell.followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }

        
        return cell;
    } else if (_type == BATFindGroup) {
        
        BATFindGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATFindGroupCollectionViewCell" forIndexPath:indexPath];
        
        if (_dataSource.count > 0) {
            BATRecommendGroupData *recommendGroupData = _dataSource[indexPath.row];
            
            [cell.groupIconImageView sd_setImageWithURL:[NSURL URLWithString:recommendGroupData.GroupIcon] placeholderImage:[UIImage imageNamed:@"默认图"]];
            cell.groupNameLabel.text = recommendGroupData.GroupName;
            cell.groupMemberCountLabel.text = [NSString stringWithFormat:@"%ld位成员",(long)recommendGroupData.MemberCount];
        }
        
        return cell;
        
    } else if (_type == BATFindFriends) {
        
        BATFindFriendsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATFindFriendsCollectionViewCell" forIndexPath:indexPath];
        
        if (_dataSource.count > 0) {
            BATRecommendUserData *recommendUserData = _dataSource[indexPath.row];
            
            if ([recommendUserData.PhotoPath hasPrefix:@"http://"]) {
                [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:recommendUserData.PhotoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
            } else {
                [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_WEB_DOMAIN_URL,recommendUserData.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"]];
            }
            
//            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,recommendUserData.PhotoPath]] placeholderImage:[UIImage imageNamed:@"医生"]];
//            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:recommendUserData.PhotoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
            cell.userNameLabel.text = recommendUserData.UserName;
            cell.masterImageView.hidden = !recommendUserData.IsMaster;
            
            cell.followButton.tag = indexPath.row;
            
            [cell.followButton addTarget:self action:@selector(followButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
        
    }
    return nil;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectedCell) {
        self.didSelectedCell(indexPath);
    }
}

#pragma mark - Action

#pragma mark - 关注方法
- (void)followButtonAction:(UIButton *)button
{
    if (self.followUser) {
         BATRecommendUserData *recommendUserData = _dataSource[button.tag];
        self.followUser(recommendUserData);
    }
}

@end
