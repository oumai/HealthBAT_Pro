//
//  BATHomeDoctorHorderTableViewCell.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeDoctorHorderTableViewCell.h"
#import "BATDoctorHorderHotNoteTableViewCell.h"
#import "BATDoctorHorderCollectionViewCell.h"

#import "BATHotPostModel.h"

static  NSString * const DOCTOR_HORDER_CELL = @"DoctorHorderCell";
static  NSString * const HOT_NOTE_CELL = @"HotNoteCell";

@implementation BATHomeDoctorHorderTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.dataArray = @[
                           @"跟我一样",
                           @"发现"
                           ];
        self.desArray = @[
                          @"找志同道合的人",
                          @"找感兴趣的东西",
                          ];
        self.imageArray = @[
                            @"img-gwyy",
                            @"img-fx"
                            ];
        WEAK_SELF(self);

        [self.contentView addSubview:self.doctorHorderCollectionView];
        [self.doctorHorderCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.right.equalTo(@0);
            make.height.mas_equalTo(75);
        }];
        
        [self.contentView addSubview:self.hotNoteTableView];
        [self.hotNoteTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.doctorHorderCollectionView.mas_bottom);
            make.left.right.equalTo(@0);
            make.height.mas_equalTo(0);
        }];
    }
    return self;
}
#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATDoctorHorderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DOCTOR_HORDER_CELL forIndexPath:indexPath];
    cell.nameLabel.text = self.dataArray[indexPath.row];
    cell.desLabel.text = self.desArray[indexPath.row];
    cell.doctorHorderImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArray[indexPath.row]]];
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
    
    return CGFLOAT_MIN;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize size = CGSizeMake((SCREEN_WIDTH)/((float)self.dataArray.count)-0.25, 75);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DDLogError(@"点击－－%ld",(long)indexPath.row);
    if (self.doctorHorderClick) {
        self.doctorHorderClick(indexPath);
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.hotNoteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BATDoctorHorderHotNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HOT_NOTE_CELL forIndexPath:indexPath];
    
    HotPostData *data = self.hotNoteArray[indexPath.row];
    cell.titleLabel.text = data.Title;
    cell.detailLabel.text = data.PostContent;
    cell.readCountLabel.text = [NSString stringWithFormat:@"阅读\u3000%ld",(long)data.ReadNum];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.hotNoteClick) {
        self.hotNoteClick(indexPath);
    }
}

#pragma mark - getter
- (UICollectionView *)doctorHorderCollectionView {
    
    if (!_doctorHorderCollectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _doctorHorderCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _doctorHorderCollectionView.backgroundColor = BASE_BACKGROUND_COLOR;
        _doctorHorderCollectionView.showsHorizontalScrollIndicator = NO;
        _doctorHorderCollectionView.delegate = self;
        _doctorHorderCollectionView.dataSource = self;
        _doctorHorderCollectionView.pagingEnabled = YES;
        
        [_doctorHorderCollectionView registerClass:[BATDoctorHorderCollectionViewCell class] forCellWithReuseIdentifier:DOCTOR_HORDER_CELL];
        
        [_doctorHorderCollectionView setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5];
    }
    return _doctorHorderCollectionView;
}

- (UITableView *)hotNoteTableView {
    
    if (!_hotNoteTableView) {
        _hotNoteTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _hotNoteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_hotNoteTableView registerClass:[BATDoctorHorderHotNoteTableViewCell class] forCellReuseIdentifier:HOT_NOTE_CELL];
        _hotNoteTableView.delegate = self;
        _hotNoteTableView.dataSource = self;
        _hotNoteTableView.rowHeight = 100;
        _hotNoteTableView.scrollEnabled = NO;
    }
    return _hotNoteTableView;
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
