//
//  BATRelatedProgramTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATRelatedProgramTableViewCell.h"
#import "BATRelateProgramItemCollectionViewCell.h"
#import "BATProgramDetailModel.h"

@interface BATRelatedProgramTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation BATRelatedProgramTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self pageLayout];
        
        _dataSource = [NSMutableArray array];
        
        [self.collectionView registerClass:[BATRelateProgramItemCollectionViewCell class] forCellWithReuseIdentifier:@"BATRelateProgramItemCollectionViewCell"];
        
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

#pragma mark - Action
- (void)loadData:(NSArray *)array
{
    
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:array];
    
    WEAK_SELF(self);
    [self.collectionView performBatchUpdates:^{
        
        STRONG_SELF(self);
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
    } completion:^(BOOL finished) {
        STRONG_SELF(self);
        
        if (self.dataSource.count >= 3) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count >= 3 ? 3 : _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BATRelateProgramItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATRelateProgramItemCollectionViewCell" forIndexPath:indexPath];
    
    if (_dataSource.count > 0) {
        BATRelevantSolutionItem *item = [_dataSource objectAtIndex:indexPath.row];
        
        [cell.bgView sd_setImageWithURL:[NSURL URLWithString:item.TemplateImage] placeholderImage:[UIImage imageNamed:@"默认图"]];
        cell.titleLabel.text = item.Remark;
        
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.relatedProgramBlock) {
        self.relatedProgramBlock(indexPath);
    }
}

#pragma makr - Layout
- (void)pageLayout
{
    [self.contentView addSubview:self.collectionView];
    
//    WEAK_SELF(self);
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        STRONG_SELF(self);
//        make.edges.equalTo(self.contentView);
//        make.height.mas_offset(150);
//    }];
}

#pragma mark - get&set
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.itemSize = CGSizeMake(172, 104);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 124) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        
    }
    return _collectionView;
}

@end
