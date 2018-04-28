//
//  BATRelateDieaseCell.m
//  TableViewTest
//
//  Created by mac on 16/9/17.
//  Copyright © 2016年 sword. All rights reserved.
//

#import "BATRelateDieaseCell.h"
#import "BATDieaseDetailModel.h"
#import "BATDieaseDetailEntityModel.h"
#import "BATRelateDieaseCollectionViewCell.h"
#import "EqualSpaceFlowLayout.h"
@interface BATRelateDieaseCell()<UICollectionViewDelegate,UICollectionViewDataSource,EqualSpaceFlowLayoutDelegate>
@property(nonatomic,strong)UIView *verView;

@property(nonatomic,strong)UIView *horView;
@property(nonatomic,strong)BATDieaseDetailEntityModel *model;
@property(nonatomic,strong)UICollectionView *dieaseCollectionView;
@end
@implementation BATRelateDieaseCell

static NSString *const RelateDieaseReuseName = @"RELATEDIEASECELL";
static NSString *const RelateDieaseCollectionViewReuseName = @"RELATEDIEASECOLLECTIONVIEWCELL";

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self)
        
        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(0);
            make.size.mas_equalTo(CGSizeMake(19, 19));
        }];
        
        [self.contentView addSubview:self.verView];
        [self.verView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.iconView.mas_bottom).offset(0);
            make.centerX.equalTo(self.iconView.mas_centerX);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.width.mas_equalTo(2);
        }];

        
        [self.contentView addSubview:self.nameLb];
        self.nameLb.preferredMaxLayoutWidth = SCREEN_WIDTH - 56.5;
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerY.equalTo(self.iconView.mas_centerY);
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [self.contentView addSubview:self.horView];
        [self.horView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.nameLb.mas_bottom).offset(5);
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
        
        [self.contentView addSubview:self.dieaseCollectionView];
        [self.dieaseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.horView.mas_bottom).offset(5);
            make.height.equalTo(self.contentView);
            make.left.equalTo(self.nameLb.mas_left).offset(-10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel) name:@"change" object:nil];
        
    }
    return self;
}

-(void)changeModel {
    [self.dieaseCollectionView reloadData];
}

#pragma mark - 每行刷新时候调用的方法
-(void)configCellWithModel:(BATDieaseDetailEntityModel *)model{
    self.model = model;
    
}

#pragma mark - 计算返回高度
//（这一行的Cell并不需要这个高度的返回，因为在控制器里面已经手动计算高度，所以并未调用这个方法，看看就好）
+(CGFloat)HeightWithModel:(BATDieaseDetailEntityModel *)model {
    BATRelateDieaseCell *cell = [[BATRelateDieaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RelateDieaseReuseName];
    [cell configCellWithModel:model];
    
    [cell layoutIfNeeded];
    
    CGRect frame = cell.dieaseCollectionView.frame;
    CGFloat height = frame.origin.y +frame.size.height +20;
    return height;
}

#pragma mark - CollectionDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.model.relateDieaseArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATRelateDieaseCollectionViewCell * dieaseRelateCell = [collectionView dequeueReusableCellWithReuseIdentifier:RelateDieaseCollectionViewReuseName forIndexPath:indexPath];
    Aboutdiseaselst *dieaseList = self.model.relateDieaseArr[indexPath.row];
    dieaseRelateCell.dieaseNameLb.text = dieaseList.Name;
    return dieaseRelateCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGSize size = CGSizeZero;
    Aboutdiseaselst *dieaseList = self.model.relateDieaseArr[indexPath.row];
    NSString *relateDieaseName = dieaseList.Name;
    CGSize textSize = [relateDieaseName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    size = CGSizeMake(textSize.width+20, 28);
    return size;
}


//上下间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//行间距 每个section items 左右行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 20;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(BATRelateDieaseWithRow:)]) {
        [self.delegate BATRelateDieaseWithRow:indexPath];
    }
    
//    [self.model.relateDieaseArr removeAllObjects];
//    [self.dieaseCollectionView reloadData];
}


-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-xgjb"]];
    }
    return _iconView;
}

-(UIView *)horView{
    if (!_horView) {
        _horView = [[UIView alloc]init];
        _horView.backgroundColor = BASE_LINECOLOR;
    }
    return _horView;
}

-(UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.numberOfLines = 0;
        _nameLb.font = [UIFont systemFontOfSize:16];
        _nameLb.text = @"相关疾病";
        _nameLb.textColor = UIColorFromHEX(0X333333, 1);
    }
    return _nameLb;
}

-(UIView *)verView{
    if (!_verView) {
        _verView = [[UIView alloc]init];
        _verView.backgroundColor = BASE_LINECOLOR;
    }
    return _verView;
}

-(UICollectionView *)dieaseCollectionView{
    if (!_dieaseCollectionView) {
        EqualSpaceFlowLayout * flow = [[EqualSpaceFlowLayout alloc] init];
        flow.delegate = self;
        _dieaseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:flow];
        _dieaseCollectionView.delegate = self;
        _dieaseCollectionView.dataSource = self;
        _dieaseCollectionView.backgroundColor =[UIColor whiteColor];
        [_dieaseCollectionView registerClass:[BATRelateDieaseCollectionViewCell class] forCellWithReuseIdentifier:RelateDieaseCollectionViewReuseName];
    }
    return _dieaseCollectionView;
}
@end
