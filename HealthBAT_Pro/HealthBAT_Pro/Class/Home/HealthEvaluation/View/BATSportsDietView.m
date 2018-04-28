//
//  BATSportsDietView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSportsDietView.h"
#import "BATDateCollectionViewCell.h"
#import "BATSportsDietItemView.h"
#import "NSString+Common.h"
#import "BATGetUserStatus.h"

#define LATAG 100
@interface BATSportsDietView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSMutableArray *itemDataSource;

@property (nonatomic, strong) BATGetUserStatus *needStatus;

@property (strong, nonatomic) NSMutableArray *mArray;
@end

@implementation BATSportsDietView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataSource = [NSMutableArray arrayWithObjects:
                       [@{@"name":@"周一",@"image":@"icon_ty_q",@"IMGUrl":@""} mutableCopy],
                       [@{@"name":@"周二",@"image":@"icon_pb_q",@"IMGUrl":@""}mutableCopy],
                       [@{@"name":@"周三",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],
                       [@{@"name":@"周四",@"image":@"icon_ymq_q",@"IMGUrl":@""}mutableCopy],
                       [@{@"name":@"周五",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],
                       [@{@"name":@"周六",@"image":@"icon_pb_q",@"IMGUrl":@""}mutableCopy],
                       [@{@"name":@"周日",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],nil];
        
        
        //关于图片名称的转换
        NSMutableArray *imageNameArray_Selected1 = [NSMutableArray array];
        //    [imageNameArray_Selected1 makeObjectsPerformSelector:@selector(mutableCopy)];
        
        for (NSMutableDictionary *dic in _dataSource) {
            NSString *newStr = [self.needStatus changeStringByStatusWithString:dic[@"image"]];
            [dic setObject:newStr forKey:@"image"];
            [imageNameArray_Selected1 addObject:dic];
        }
        _dataSource = imageNameArray_Selected1;
        //
        
        
        _itemDataSource = [NSMutableArray arrayWithObjects:
                           @{@"name":@"谷薯类",@"percent":@"52.5%",@"image":@"icon_gsl_q"},
                           @{@"name":@"蔬菜类",@"percent":@"5.0%",@"image":@"icon_scl_q"},
                           @{@"name":@"肉蛋类",@"percent":@"5.0%",@"image":@"icon_drl_q"},
                           @{@"name":@"水果类",@"percent":@"5.0%",@"image":@"icon_sgl_q"},
                           @{@"name":@"豆奶类",@"percent":@"12.5%",@"image":@"icon_dll_q"},
                           @{@"name":@"油脂类",@"percent":@"12.5%",@"image":@"icon_yzl_q"},nil];
        
        
        
        [self pageLayout];
        
        [self.collectionView registerClass:[BATDateCollectionViewCell class] forCellWithReuseIdentifier:@"BATDateCollectionViewCell"];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BATDateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATDateCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *dic = _dataSource[indexPath.row];
    
    NSString *name = dic[@"name"];
    NSString *image = dic[@"image"];
    NSString *url = dic[@"IMGUrl"];
    
    
    
    cell.titleLabel.text = name;
    cell.titleLabel.textColor = UIColorFromHEX([self returnSmallItemColor], 1);
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:image]];
    return cell;
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.collectionView];
    [self addSubview:self.dietImageView];
    [self addSubview:self.dietTitleLabel];
    
    WEAK_SELF(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.top.equalTo(self);
        if (iPhone5 || iPhone4) {
            make.height.mas_offset(80 * scaleValue);
        } else {
            make.height.mas_offset(80);
        }
    }];
    
    [self.dietImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        
        if (iPhone5 || iPhone4) {
            make.size.mas_offset(CGSizeMake(175.5 * scaleValue, 175.5 * scaleValue));
            make.top.equalTo(self.collectionView.mas_bottom).offset(30 * scaleValue);

        } else {
            make.size.mas_offset(CGSizeMake(175.5, 175.5));
            make.top.equalTo(self.collectionView.mas_bottom).offset(30);
        }
        
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.dietTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.center.equalTo(self.dietImageView);
    }];
    
    _mArray = [NSMutableArray array];
    
    for (int i = 0; i < _itemDataSource.count; i++) {
        
        NSDictionary *dic = _itemDataSource[i];
        
        BATSportsDietItemView *itemView = [[BATSportsDietItemView alloc] init];
        itemView.titleLabel.text = dic[@"name"];
        itemView.titleLabel.textColor = UIColorFromHEX([self returnSmallItemColor], 1);
        
        itemView.percentLabel.text = dic[@"percent"];
        itemView.percentLabel.textColor = UIColorFromHEX([self returnSmallItemColor], 1);
        itemView.imageView.image = [UIImage imageNamed:dic[@"image"]];
        [self addSubview:itemView];
        [_mArray addObject:itemView];
        itemView.tag = LATAG + i;
        
        WEAK_SELF(self);
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            
            if (i == 0 || i == 1) {
                make.top.equalTo(self.dietImageView.mas_top).offset(10);
            } else if (i == 2 || i == 3) {
                make.centerY.equalTo(self.dietImageView.mas_centerY);
            } else {
                make.bottom.equalTo(self.dietImageView.mas_bottom).offset(-10);
            }
            
            if (i % 2 == 0) {
                make.left.equalTo(self.mas_left).offset(10);
            } else {
                make.right.equalTo(self.mas_right).offset(-10);
            }
            
            if (iPhone5 || iPhone4) {
                make.size.mas_offset(CGSizeMake(80 * scaleValue, 50 *scaleValue));
            } else {
                make.size.mas_offset(CGSizeMake(80, 50));
            }
            
            
        }];
    }
}

#pragma mark - get & set
- (BATCustomCollectionView *)collectionView
{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 7, 80);
        
        _collectionView = [[BATCustomCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        
    }
    return _collectionView;
}

- (UIImageView *)dietImageView {
    if (_dietImageView == nil) {
        _dietImageView = [[UIImageView alloc] init];
        _dietImageView.lee_theme.LeeConfigImage(RoundGuide_icon_swrl);
    }
    return _dietImageView;
}

- (BATGetUserStatus *)needStatus {
    
    if (!_needStatus) {
        
        _needStatus = [[BATGetUserStatus alloc] init];
    }
    return _needStatus;
    
}

- (UILabel *)dietTitleLabel
{
    if (_dietTitleLabel == nil) {
        _dietTitleLabel = [[UILabel alloc] init];
        
        if (iPhone5 || iPhone4) {
            _dietTitleLabel.font = [UIFont systemFontOfSize:25*scaleValue];
        } else {
            _dietTitleLabel.font = [UIFont systemFontOfSize:25];
        }
        
        
        _dietTitleLabel.textColor = UIColorFromHEX([self returnSmallItemColor], 1);
        _dietTitleLabel.text = @"饮食热量";
        _dietTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_dietTitleLabel sizeToFit];
    }
    return _dietTitleLabel;
}
- (void)setModel:(BATHealthEvalutionModel *)model {

    _model = model;
    
    if (_model) {//Potato
        _itemDataSource = [NSMutableArray arrayWithObjects:
                           @{@"name":@"谷薯类",@"percent":[NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.Potato],@"image":@"icon-gsl"},
                           @{@"name":@"蔬菜类",@"percent":[NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.Vegetables],@"image":@"icon-scl"},
                           @{@"name":@"肉蛋类",@"percent":[NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.MeatEgg],@"image":@"icon-drl"},
                           @{@"name":@"水果类",@"percent":[NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.Fruits],@"image":@"icon-sgl"},
                           @{@"name":@"豆奶类",@"percent":[NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.SoyMilk],@"image":@"icon-dll"},
                           @{@"name":@"油脂类",@"percent":[NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.Fats],@"image":@"icon-yzl"},nil];
    }
    //显示饮食热量
    NSString *Str = @"";
    Str = [NSString stringWithFormat:@"%ldcal", (long)_model.ReturnData.DietAdvice.DietCalory];
    
    if ([Str isEqualToString:@"0cal"]) {
        Str = @"饮食热量";
    }
    
    _dietTitleLabel.text = Str;
    

//    [self.subviews performSelector:@selector(removeFromSuperview)];
//    [self pageLayout];
//    [self.collectionView reloadData];
//    [self pageLayout];
    [self updeteLableWith:model];
    [self updateCollectionViewWithModel:model];
}
- (void)updeteLableWith:(BATHealthEvalutionModel *)model {
    
    NSArray *array = @[[NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.Potato],
                       [NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.Vegetables],
                       [NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.MeatEgg],
                       [NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.Fruits],
                       [NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.SoyMilk],
                       [NSString stringWithFormat: @"%.1f%%",_model.ReturnData.DietAdvice.Fats]
                       ];
    
    NSInteger countOfArray = 0;//记录用的tag值
    for (NSString *string in array) {
        
        if ([string isEqualToString:@"0.0%"]) {
            countOfArray = 1;
        }
    }
    
    if (!countOfArray) { //判断这里面是否有为 @"0.0"的数据，有的话就是空
        
        for (int i = 0;i < _itemDataSource.count; i ++ ) {
            
            BATSportsDietItemView *view = [self viewWithTag:i + LATAG];
            
            view.percentLabel.text = array[i];
            
        }
        
    } else {//咩有点话就不要设置值
        
        return;
    }

}
- (void)updateCollectionViewWithModel:(BATHealthEvalutionModel *)model {
    
    NSArray *dataArr = model.ReturnData.SportAdvice.SportWeekPlanDetailList;
    
    _dataSource = [NSMutableArray arrayWithObjects:
                   [@{@"name":@"周一",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],
                   [@{@"name":@"周二",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],
                   [@{@"name":@"周三",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],
                   [@{@"name":@"周四",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],
                   [@{@"name":@"周五",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],
                   [@{@"name":@"周六",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],
                   [@{@"name":@"周日",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],nil];
    
    
    //关于图片名称的转换
    NSMutableArray *imageNameArray_Selected1 = [NSMutableArray array];
    //    [imageNameArray_Selected1 makeObjectsPerformSelector:@selector(mutableCopy)];
    
    for (NSMutableDictionary *dic in _dataSource) {
        NSString *newStr = [self.needStatus changeStringByStatusWithString:dic[@"image"]];
        [dic setObject:newStr forKey:@"image"];
        [imageNameArray_Selected1 addObject:dic];
    }
    _dataSource = imageNameArray_Selected1;
    //
    
    for (int i = 0; i < dataArr.count; i ++) {
        BATHealthEvalutionSportWeekPlanDetailListModel *model = dataArr[i];
      
        for (NSDictionary *dic in _dataSource) {
            
            if ([dic[@"name"] isEqualToString:model.WeekName]) {
                
                [dic setValue:[NSString checkNull:model.sportfullicon] forKey:@"IMGUrl"];
                
                NSLog(@"%@--------------*************----------------000000000", model.sportfullicon);
                
            }
            
        }
        
    }
    NSInteger countI = 0;
    for (NSMutableDictionary *dicM in _dataSource) {
        
        if (![dicM[@"IMGUrl"] isEqualToString:@""]) {//有值 就 ++
            countI ++;
        }
    }
    
    if (countI == 0) { //如果是0  代表都没有值；
        
        _dataSource = [NSMutableArray arrayWithObjects:
                       [@{@"name":@"周一",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],
                       [@{@"name":@"周二",@"image":@"icon_pb_q",@"IMGUrl":@""}mutableCopy],
                       [@{@"name":@"周三",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],
                       [@{@"name":@"周四",@"image":@"icon_ymq_q",@"IMGUrl":@""}mutableCopy],
                       [@{@"name":@"周五",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],
                       [@{@"name":@"周六",@"image":@"icon_pb_q",@"IMGUrl":@""}mutableCopy],
                       [@{@"name":@"周日",@"image":@"icon_ty_q",@"IMGUrl":@""}mutableCopy],nil];
        //关于图片名称的转换
        NSMutableArray *imageNameArray_Selected1 = [NSMutableArray array];
        //    [imageNameArray_Selected1 makeObjectsPerformSelector:@selector(mutableCopy)];
        
        for (NSMutableDictionary *dic in _dataSource) {
            NSString *newStr = [self.needStatus changeStringByStatusWithString:dic[@"image"]];
            [dic setObject:newStr forKey:@"image"];
            [imageNameArray_Selected1 addObject:dic];
        }
        _dataSource = imageNameArray_Selected1;
        //
        
    }
   
    
    [self.collectionView reloadData];
    
}
- (void)setHelpStrig:(NSString *)helpStrig {
    
    _helpStrig =helpStrig;
    //关于图片名称的转换
    NSMutableArray *imageNameArray_Selected1 = [NSMutableArray array];
    //    [imageNameArray_Selected1 makeObjectsPerformSelector:@selector(mutableCopy)];
    
    for (NSMutableDictionary *dic in _dataSource) {
        NSString *newStr = [self.needStatus changeStringByStatusWithString:dic[@"image"]];
        [dic setObject:newStr forKey:@"image"];
        [imageNameArray_Selected1 addObject:dic];
    }
    _dataSource = imageNameArray_Selected1;
    //
    
   
    _dietTitleLabel.textColor = UIColorFromHEX([self returnSmallItemColor], 1);
    
    for (BATSportsDietItemView *itemView in _mArray) {
        
        if ([itemView isKindOfClass:[BATSportsDietItemView class]]) {

            itemView.titleLabel.textColor = UIColorFromHEX([self returnSmallItemColor], 1);

            itemView.percentLabel.textColor = UIColorFromHEX([self returnSmallItemColor], 1);
            
        }
        
    }
    
}
- (int)returnSmallItemColor { //牛奶这些
    
    int colorX = 0x509AB7; // - > 默认浅蓝
    if (self.needStatus.userStatus == cyanStatus) {
        colorX = 0x4296a3; // - > 青色
    } else if (self.needStatus.userStatus == greenStatus) {
        colorX = 0x509AB7; // - > 默认浅蓝
    } else if(self.needStatus.userStatus == pinkStatus){
        colorX = 0xFFFFFF; // - > 白色
        
    } else { //蓝色
        colorX = 0xFFFFFF; // - > 白色
        
    }
    return colorX;
    
    
}
@end
