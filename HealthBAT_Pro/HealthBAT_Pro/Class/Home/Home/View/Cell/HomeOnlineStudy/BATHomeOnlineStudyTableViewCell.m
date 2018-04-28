//
//  BATHomeOnlineStudyTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/12/72016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeOnlineStudyTableViewCell.h"
#import "BATHomeOnlineStudyCollectionViewCell.h"

static  NSString * const ONLINE_STUDY_COLLECTIONVIEW_CELL = @"OnlineStudyCollectionViewCell";

@implementation BATHomeOnlineStudyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.studyCollectionView];
        [self.studyCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(@10);
            make.bottom.equalTo(@-10);
            make.right.equalTo(@0);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BATHomeOnlineStudyCollectionViewCell *studyCell = [collectionView dequeueReusableCellWithReuseIdentifier:ONLINE_STUDY_COLLECTIONVIEW_CELL forIndexPath:indexPath];

    switch (indexPath.section) {
            case 0:
        {
            //美容
            studyCell.backImage.image = [UIImage imageNamed:@"img-mr"];
            studyCell.titleLabel.text = @"美容";
        }
            break;
            case 1:
        {
            //养生
            studyCell.backImage.image = [UIImage imageNamed:@"img-ys-home"];
            studyCell.titleLabel.text = @"养生";
        }
            break;
            case 2:
        {
            //减肥
            studyCell.backImage.image = [UIImage imageNamed:@"img-b"];
            studyCell.titleLabel.text = @"减肥";
        }
            break;
        case 3:
        {
            //塑型
            studyCell.backImage.image = [UIImage imageNamed:@"Home_healthFollow_suxing"];
            studyCell.titleLabel.text = @"";
        }
            break;
            
        default:
            break;
    }
    
    return studyCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = CGSizeMake(160, 90);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    DDLogError(@"点击－－%ld",(long)indexPath.section);
    if (self.studyClicked) {
        self.studyClicked(indexPath);
    }
}

#pragma mark - getter
- (UICollectionView *)studyCollectionView {

    if (!_studyCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _studyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _studyCollectionView.backgroundColor = [UIColor whiteColor];
        _studyCollectionView.showsHorizontalScrollIndicator = NO;
        _studyCollectionView.delegate = self;
        _studyCollectionView.dataSource = self;

        [_studyCollectionView registerClass:[BATHomeOnlineStudyCollectionViewCell class] forCellWithReuseIdentifier:ONLINE_STUDY_COLLECTIONVIEW_CELL];
    }
    return _studyCollectionView;
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
