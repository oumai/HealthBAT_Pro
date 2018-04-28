//
//  BATConsultionHomeNewCollectionView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATConsultionHomeNewTopCollectionView.h"

#import "BATConsultionHomeNewTopCollectionViewDeptCell.h"
#import "BATConsultionHomeNewTopCollectionViewDoctorCell.h"
#import "BATConsultionHomeNewTopCollectionViewHeaderViewCell.h"
#import "BATConsultionHomeNewTopCollectionViewOneDoctorCell.h"

#import "BATFreeClinicDoctorModel.h"

@interface BATConsultionHomeNewTopCollectionView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation BATConsultionHomeNewTopCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self pagesLayouts];
        
    }
    
    return self;
}

- (void)remakelayouts{
//    [self pagesLayouts];
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource&UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    if (section == 0 ) {
//        if(self.todayFreeClinicArray.count == 0){
//            return 0;
//        }
//        return 1;
//    }
//    if (section == 1) {
//        if(self.todayFreeClinicArray.count >=2){
//            return 2;
//        }
//        return self.todayFreeClinicArray.count;
//    }
    if (section == 0) {
        return 1;
    }if (section == 1){
        return self.deptArray.count;
    }else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        BATConsultionHomeNewTopCollectionViewHeaderViewCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATConsultionHomeNewTopCollectionViewHeaderViewCell" forIndexPath:indexPath];
//        titleCell.titleLable.text = @"今日义诊";
//        titleCell.titleLable.hidden = NO;
//        titleCell.backgroundColor = [UIColor whiteColor];
//        return titleCell;
//
//    }if (indexPath.section == 1) {
//        if(self.todayFreeClinicArray.count == 1){
//
//            BATConsultionHomeNewTopCollectionViewOneDoctorCell *doctorCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATConsultionHomeNewTopCollectionViewOneDoctorCell" forIndexPath:indexPath];
//
//            FreeClinicDoctorData *data = self.todayFreeClinicArray[indexPath.row];
//
//            [doctorCell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:data.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
//            doctorCell.doctorNameLabel.text = data.DoctorName;
//            doctorCell.doctorTitleLabel.text = data.Title;
//            doctorCell.deptLable.text = data.DepartmentName;
//
//            return doctorCell;
//        }else{
//
//            BATConsultionHomeNewTopCollectionViewDoctorCell *doctorCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATConsultionHomeNewTopCollectionViewDoctorCell" forIndexPath:indexPath];
//
//            FreeClinicDoctorData *data = self.todayFreeClinicArray[indexPath.row];
//
//            [doctorCell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:data.User.PhotoUrl] placeholderImage:[UIImage imageNamed:@"医生"]];
//            doctorCell.doctorNameLabel.text = data.DoctorName;
//            doctorCell.doctorTitleLabel.text = data.Title;
//            doctorCell.deptLable.text = data.DepartmentName;
//
//            return doctorCell;
//        }
//
//
//
//    }
    if (indexPath.section == 0) {
        BATConsultionHomeNewTopCollectionViewHeaderViewCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATConsultionHomeNewTopCollectionViewHeaderViewCell" forIndexPath:indexPath];
        titleCell.titleLable.text = @"按科室找医生";
        titleCell.titleLable.hidden = NO;
        titleCell.backgroundColor = BASE_BACKGROUND_COLOR;
        return titleCell;
    }if (indexPath.section == 1){
        
        NSDictionary *dict = self.deptArray[indexPath.row];
        
        BATConsultionHomeNewTopCollectionViewDeptCell *deptCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATConsultionHomeNewTopCollectionViewDeptCell" forIndexPath:indexPath];
        
        deptCell.deptLable.text = [dict objectForKey:@"deptName"];;
        deptCell.deptImageView.image = [UIImage imageNamed:[dict objectForKey:@"imageName"]];
        
        return deptCell;
    } else {
        BATConsultionHomeNewTopCollectionViewHeaderViewCell *titleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATConsultionHomeNewTopCollectionViewHeaderViewCell" forIndexPath:indexPath];
        titleCell.backgroundColor = [UIColor whiteColor];
        titleCell.titleLable.hidden = YES;
        return titleCell;
    }
    
    return nil;
  
}

//每个item 的视图的宽高  只有宽高，没有frame
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0 ) {
//        return CGSizeMake(SCREEN_WIDTH - 20,50);
//    }if (indexPath.section == 1) {
//        if(self.todayFreeClinicArray.count == 1){
//            return  CGSizeMake(SCREEN_WIDTH - 20, 100);
//        }else{
//            return  CGSizeMake((SCREEN_WIDTH - 20 - 1)/2.0, 100);
//        }
//    }
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH - 20,50);
    }if (indexPath.section == 1) {
        return CGSizeMake((SCREEN_WIDTH - 20 - 4)/4.0, (SCREEN_WIDTH - 20 - 4)/4.0*156/176);
    }    else{
        return CGSizeMake(SCREEN_WIDTH - 20,30);
    }

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DDLogError(@"点击－－%ld",(long)indexPath.item);
    if (self.deptClickBlock) {
        self.deptClickBlock(indexPath);
    }
}


#pragma mark - pagesLayouts
- (void)pagesLayouts{
    
    CGFloat deptCellHeight = (SCREEN_WIDTH - 20 - 4)/4.0*156/176;
    
    WEAK_SELF(self);
    
//    if (self.todayFreeClinicArray.count > 0) {
//
//        [self addSubview:self.blackView];
//        [self.blackView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.left.right.bottom.equalTo(self);
//            make.top.equalTo(@0);
//        }];
//
//        [self addSubview:self.searchBGview];
//        [self.searchBGview mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(10);
//            make.right.equalTo(self.mas_right).offset(-10);
//            make.top.equalTo(@0);
//            make.height.mas_equalTo(50);
//        }];
//
//        [self.searchBGview addSubview:self.searchTF];
//        [self.searchTF mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(20);
//            make.right.equalTo(self.mas_right).offset(-20);
//            make.centerY.equalTo(self.searchBGview);
//            make.height.mas_offset(30);
//        }];
//
//        [self addSubview:self.collectionView];
//        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.top.equalTo(self.searchBGview.mas_bottom);
//            make.left.equalTo(self.mas_left).offset(10);
//            make.right.equalTo(self.mas_right).offset(-10);
//            make.height.mas_offset(50*2+100+deptCellHeight*3+30);
//        }];
//
//        [self addSubview:self.lineView];
//        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.left.equalTo(@20);
//            make.right.equalTo(@-20);
//            make.top.equalTo(self.collectionView.mas_bottom).offset(-0.5);
//            make.height.mas_equalTo(0.5);
//        }];
//
//        [self addSubview:self.pushImageView];
//        [self.pushImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            STRONG_SELF(self);
//            make.centerX.equalTo(self.mas_centerX);
//            make.top.equalTo(self.collectionView.mas_bottom).offset(-0.5);
//            make.width.mas_equalTo(35);
//            make.height.mas_equalTo(20);
//        }];
//
//    }else{
        [self addSubview:self.blackView];
        [self.blackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(@0);
        }];
        
        [self addSubview:self.searchBGview];
        [self.searchBGview mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(@0);
            make.height.mas_equalTo(50);
        }];
        
        [self.searchBGview addSubview:self.searchTF];
        [self.searchTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.centerY.equalTo(self.searchBGview);
            make.height.mas_offset(30);
        }];
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.top.equalTo(self.searchTF.mas_bottom);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.height.mas_offset(50+deptCellHeight*3+30);
        }];
        
        [self addSubview:self.lineView];
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.collectionView.mas_bottom).offset(-0.5);
            make.height.mas_equalTo(0.5);
        }];
        
        [self addSubview:self.pushImageView];
        [self.pushImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.collectionView.mas_bottom).offset(-0.5);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(20);
        }];
//    }
}


#pragma mark - setter&gettter

- (UIView *)blackView{
    if (!_blackView) {
        _blackView = [[UIView alloc]init];
        _blackView.backgroundColor = [UIColor clearColor];
        [_blackView bk_whenTapped:^{
            if (self.clickHiddenCollectionViewBolok) {
                self.clickHiddenCollectionViewBolok();
            }
        }];
    }
    
    return _blackView;
}

- (UIView *)searchBGview{
    if (!_searchBGview) {
        _searchBGview = [[UIView alloc]init];
        _searchBGview.backgroundColor = BASE_BACKGROUND_COLOR;
        [_searchBGview bk_whenTapped:^{
            if (self.clickBeginEditingBolok) {
                self.clickBeginEditingBolok();
            }
        }];
    }
    
    return _searchBGview;
}


- (UITextField *)searchTF {
    
    if (!_searchTF) {
        
        _searchTF = [UITextField textFieldWithfont:[UIFont systemFontOfSize:13] textColor:nil placeholder:nil BorderStyle:UITextBorderStyleNone];
        _searchTF.clearButtonMode = UITextFieldViewModeNever;
        _searchTF.text = @"搜医生";
        _searchTF.textColor = UIColorFromHEX(0x999999, 1);
        
        UIView *leftIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [leftIcon addSubview:self.searchIcon];
        [self.searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(leftIcon);
        }];
        _searchTF.userInteractionEnabled = NO;
        _searchTF.leftView = leftIcon;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        _searchTF.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 40, 30);
        _searchTF.backgroundColor = [UIColor whiteColor];
        
        _searchTF.layer.cornerRadius = 3.0f;
        _searchTF.clipsToBounds = YES;
    }
    return _searchTF;
}

- (UIImageView *)searchIcon {
    
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-search"]];
    }
    return _searchIcon;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 1;
        flow.minimumInteritemSpacing = 1;
//        flow.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flow.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flow];
        _collectionView.backgroundColor = BASE_BACKGROUND_COLOR;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[BATConsultionHomeNewTopCollectionViewDeptCell class] forCellWithReuseIdentifier:@"BATConsultionHomeNewTopCollectionViewDeptCell"];
        
//        [_collectionView registerClass:[BATConsultionHomeNewTopCollectionViewOneDoctorCell class] forCellWithReuseIdentifier:@"BATConsultionHomeNewTopCollectionViewOneDoctorCell"];
        
//        [_collectionView registerClass:[BATConsultionHomeNewTopCollectionViewDoctorCell class] forCellWithReuseIdentifier:@"BATConsultionHomeNewTopCollectionViewDoctorCell"];
        
        
        [_collectionView registerClass:[BATConsultionHomeNewTopCollectionViewHeaderViewCell class] forCellWithReuseIdentifier:@"BATConsultionHomeNewTopCollectionViewHeaderViewCell"];
        
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BATConsultionHomeNew"];
    }
    return _collectionView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = BASE_LINECOLOR;
    }
    return _lineView;
}


- (UIImageView *)pushImageView{
    if (!_pushImageView) {
        _pushImageView = [[UIImageView alloc]init];
        _pushImageView.image = [UIImage imageNamed:@"icon-consultion-xll"];
        _pushImageView.userInteractionEnabled = YES;
        [_pushImageView bk_whenTapped:^{
            if (self.clickHiddenCollectionViewBolok) {
                self.clickHiddenCollectionViewBolok();
            }
        }];
        
    }
    
    return _pushImageView;
}
@end
