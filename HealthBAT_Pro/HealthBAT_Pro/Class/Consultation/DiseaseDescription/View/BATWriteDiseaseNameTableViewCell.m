//
//  BATWriteDiseaseNameTableViewCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/7/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATWriteDiseaseNameTableViewCell.h"

#import "BATWriteDiseaseNameCollectionViewCell.h"

@interface BATWriteDiseaseNameTableViewCell ()

@property (nonatomic,assign) NSInteger currentRow;
@property (nonatomic,assign) BOOL noNotFirst;

@end

@implementation BATWriteDiseaseNameTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        self.dataArr = @[@"湿疹",@"鼻炎",@"咳嗽",@"瘙痒",@"颈椎病",@"前列腺炎",@"脂溢性皮炎",@"乳房疼痛"];
        self.currentRow = 0;
        self.noNotFirst = NO;
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.top.equalTo(self.mas_top).offset(15);
        }];
        
        [self.contentView addSubview:self.diseaseNameCollectionView];
        [self.diseaseNameCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
            make.bottom.equalTo(@0);
        }];

    }
    
    return self;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATWriteDiseaseNameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATWriteDiseaseNameCollectionViewCell" forIndexPath:indexPath];
    
    cell.diseaseNameLabel.text = self.dataArr[indexPath.row];
    
    if(indexPath.row == self.currentRow && self.noNotFirst == YES){
        cell.diseaseNameLabel.textColor = END_COLOR;
        cell.layer.borderColor = END_COLOR.CGColor;
    }else{
        cell.diseaseNameLabel.textColor = UIColorFromHEX(0x999999, 1);
        cell.layer.borderColor = UIColorFromHEX(0x999999, 1).CGColor;
    }
    
    return cell;
}

//每个item 的视图的宽高  只有宽高，没有frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize titleSize = [self.dataArr[indexPath.row] sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}];
    
    CGSize size = CGSizeMake(titleSize.width + 20, 25);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.currentRow = indexPath.row;
    self.noNotFirst = YES;
    [self.diseaseNameCollectionView reloadData];
    
    DDLogError(@"点击－－%ld",(long)indexPath.item);
    if (self.videoClick) {
        self.videoClick(indexPath);
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:UIColorFromHEX(0x333333, 1) textAlignment:NSTextAlignmentLeft];
        _titleLabel.text = @"你想咨询";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UICollectionView *)diseaseNameCollectionView {
    if (!_diseaseNameCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 10;
        flow.minimumInteritemSpacing = 10;
        flow.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _diseaseNameCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _diseaseNameCollectionView.backgroundColor = [UIColor whiteColor];
        _diseaseNameCollectionView.showsVerticalScrollIndicator = NO;
        _diseaseNameCollectionView.delegate = self;
        _diseaseNameCollectionView.dataSource = self;
        _diseaseNameCollectionView.bounces = NO;
        _diseaseNameCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [_diseaseNameCollectionView registerClass:[BATWriteDiseaseNameCollectionViewCell class] forCellWithReuseIdentifier:@"BATWriteDiseaseNameCollectionViewCell"];
    }
    return _diseaseNameCollectionView;
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
