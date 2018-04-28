//
//  KMChatHeaderCollectionReusableView.m
//  HealthBAT
//
//  Created by cjl on 16/8/5.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "KMChatHeaderCollectionReusableView.h"
#import "KMChatHeaderImageCollectionViewCell.h"
#import "UIButton+WebCache.h"

@interface KMChatHeaderCollectionReusableView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *picDataSource;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelConstraintHeigth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionConstraintHeight;

@end

@implementation KMChatHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    _picDataSource = [NSMutableArray array];
    
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 6;
    _contentView.layer.masksToBounds = YES;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"KMChatHeaderImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"KMChatHeaderImageCollectionViewCell"];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    CGSize size = [self.contentView systemLayoutSizeFittingSize:layoutAttributes.size];
    CGRect frame = layoutAttributes.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    layoutAttributes.frame = frame;
    
    return layoutAttributes;
}

#pragma mark Public

- (void)reloadHeader:(NSDictionary *)ddm complete:(void (^)(void))complete
{
    _titleLabel.text = @"病症描述：";
    _detailLabel.text = ddm[@"detail"];
    
    [_picDataSource removeAllObjects];
    [_picDataSource addObjectsFromArray:ddm[@"images"]];
    
    
    [_collectionView reloadData];
    
    if (complete) {
        complete();
    }
}


#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _picDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KMChatHeaderImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KMChatHeaderImageCollectionViewCell" forIndexPath:indexPath];
    
    if (_picDataSource.count > 0) {
        [cell.imageView sd_setImageWithURL:_picDataSource[indexPath.row] placeholderImage:[UIImage imageNamed:@"医生"]
];
    }
    
    [cell bk_whenTapped:^{
        [SJAvatarBrowser showImage:cell.imageView];
    }];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    KMChatHeaderImageCollectionViewCell *cell = (KMChatHeaderImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
     [SJAvatarBrowser showImage:cell.imageView];
}
@end
