//
//  BATFourthTableViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 17/3/272017.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFourthTableViewCell.h"
#import "BATFourthCollectionViewCell.h"

static  NSString * const FOURTH_COLLECTION_CELL = @"BATFourthCollectionViewCell";

@implementation BATFourthTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.dataArray = @[@"没有",@"很少",@"有时",@"经常",@"总是"];

        [self.contentView addSubview:self.answerCollectionView];
        [self.answerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];

        [self setBottomBorderWithColor:UIColorFromHEX(0xfefefe, 1) width:SCREEN_WIDTH height:1.f];
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

    BATFourthCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FOURTH_COLLECTION_CELL forIndexPath:indexPath];

    cell.answerLabel.text = self.dataArray[indexPath.row];

    if (self.tmpIndexPath && indexPath.row == self.tmpIndexPath.row) {

        cell.answerLabel.backgroundColor = BASE_COLOR;
        cell.answerLabel.textColor = UIColorFromHEX(0xfefefe, 1);
    }
    else {
        cell.answerLabel.backgroundColor = UIColorFromHEX(0xfefefe, 1);
        cell.answerLabel.textColor = UIColorFromHEX(0x333333, 1);
    }

    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(0, 10, 0, -10);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = CGSizeMake((SCREEN_WIDTH-20)/5.0, (SCREEN_WIDTH-20)/5.0);
    return size;
}

//上下间距 每个section items上下行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {

    return CGFLOAT_MIN;
}
//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

    return CGFLOAT_MIN;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (self.answerSelectedIndexPath) {
        self.answerSelectedIndexPath(indexPath);
    }
}

#pragma mark - 
- (UICollectionView *)answerCollectionView {

    if (!_answerCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
//        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _answerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _answerCollectionView.backgroundColor = [UIColor clearColor];
        _answerCollectionView.showsHorizontalScrollIndicator = NO;
        _answerCollectionView.delegate = self;
        _answerCollectionView.dataSource = self;
        _answerCollectionView.pagingEnabled = YES;

        [_answerCollectionView registerClass:[BATFourthCollectionViewCell class] forCellWithReuseIdentifier:FOURTH_COLLECTION_CELL];
    }
    return _answerCollectionView;
}

#pragma mark -
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
