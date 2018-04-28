//
//  BATDoctorScheduleView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/23.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorScheduleView.h"
#import "BATDoctorScheduleTitleCell.h"
#import "BATDoctorScheduleOptionCell.h"

#import "BATGraditorButton.h"

@interface BATDoctorScheduleView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UILabel *slider;

@property (nonatomic,strong) BATDoctorScheduleModel *doctorScheduleModel;

@property (nonatomic,assign) BATNextSevenType type;

@end

@implementation BATDoctorScheduleView

- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_topView];
        
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
        
        _contarinerView = [[UIView alloc] init];
        [_scrollView addSubview:_contarinerView];
        
        UIButton *preButton = nil;
        for (int i = 0 ; i < 2; i++) {
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button setTitleColor:UIColorFromHEX(0x49cc73, 1) forState:UIControlStateSelected];
//            [button setTitleColor:UIColorFromHEX(0x999999, 1) forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont systemFontOfSize:15];
            BATGraditorButton *button = [[BATGraditorButton alloc]initWithFrame:CGRectZero];
            button.enbleGraditor = YES;
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setGradientColors:@[START_COLOR,END_COLOR]];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100 + i;
            
//            if (i == 0) {
//                [button setTitle:@"本周" forState:UIControlStateNormal];
//            } else {
//                [button setTitle:@"下周" forState:UIControlStateNormal];
//            }
            
            [_topView addSubview:button];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(_topView);
                make.width.mas_equalTo(150);
                if (i != 0) {
                    make.left.equalTo(preButton.mas_right);
                } else {
                    make.left.equalTo(_topView.mas_left).offset((SCREEN_WIDTH - 300) / 2);
                }
            }];
            
            if (i == 0) {
                button.selected = YES;
                _type = BATNowSeven;
                _slider = [[UILabel alloc] init];
//                _slider.backgroundColor = UIColorFromHEX(0x45a0f0, 1);
                _slider.backgroundColor = START_COLOR;
                [_topView addSubview:_slider];
                
                [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(button.mas_width);
                    make.height.mas_equalTo(2);
                    make.left.equalTo(_topView.mas_left).offset((SCREEN_WIDTH - 300) / 2);
                    make.bottom.equalTo(_topView.mas_bottom);
                }];
            }
            
            preButton = button;
        }
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 1, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColorFromHEX(0xf6f6f6, 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.layer.borderColor = UIColorFromHEX(0xf6f6f6, 1).CGColor;
        _collectionView.layer.borderWidth = 0.5f;
        _collectionView.scrollEnabled = NO;
        [_contarinerView addSubview:_collectionView];
        
        [_collectionView registerClass:[BATDoctorScheduleTitleCell class] forCellWithReuseIdentifier:@"BATDoctorScheduleTitleCell"];
        [_collectionView registerClass:[BATDoctorScheduleOptionCell class] forCellWithReuseIdentifier:@"BATDoctorScheduleOptionCell"];
        
        _footerView = [[BATDoctorScheduleFooterView alloc] init];
        _footerView.backgroundColor = [UIColor whiteColor];
        [_contarinerView addSubview:_footerView];
        
        [self setupConstraints];
        
    }
    return self;
}

- (void)setupConstraints
{
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(48);
    }];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    
    [_contarinerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.mas_offset(SCREEN_WIDTH);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_topView.mas_bottom);
        make.top.left.right.equalTo(_contarinerView);
    }];
    
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_collectionView.mas_bottom);
//        make.bottom.equalTo(_contarinerView.mas_bottom);
        make.left.right.bottom.equalTo(_contarinerView);
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _doctorScheduleModel.Data.DateWeekList.count > 0 ? 1 + _doctorScheduleModel.Data.ScheduleList.count : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger offset = 0;
    
    if (_type == BATNowSeven) {
        offset = 0;
    } else {
        offset = 7;
    }
    
    if (indexPath.section == 0) {
        BATDoctorScheduleTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATDoctorScheduleTitleCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"";
        } else {
            
            if (_doctorScheduleModel.Data.DateWeekList.count > 0) {
                
                Dateweeklist *dateweeklist = _doctorScheduleModel.Data.DateWeekList[indexPath.row - 1 + offset];
                
                cell.titleLabel.text = [NSString stringWithFormat:@"%@\n%@",dateweeklist.WeekStr,[dateweeklist.DateStr substringFromIndex:5]];
            }
        }
        return cell;
    } else {
        
        if (indexPath.row == 0) {
            BATDoctorScheduleTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATDoctorScheduleTitleCell" forIndexPath:indexPath];
            
            if (_doctorScheduleModel.Data.ScheduleList.count > 0) {
                
                Schedulelist *scheduleList = _doctorScheduleModel.Data.ScheduleList[indexPath.section - 1];
                cell.titleLabel.text = [NSString stringWithFormat:@"%@\n%@",scheduleList.StartTime,scheduleList.EndTime];
                
            }
            
            return cell;
        } else {
            BATDoctorScheduleOptionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATDoctorScheduleOptionCell" forIndexPath:indexPath];
            
            
            if (_doctorScheduleModel.Data.ScheduleList.count > 0) {
                
                Schedulelist *scheduleList = _doctorScheduleModel.Data.ScheduleList[indexPath.section - 1];
                
                if (scheduleList.RegNumList.count > 0) {
                    Regnumlist *regNumList = scheduleList.RegNumList[indexPath.row - 1 + offset];
                    cell.regNumList = regNumList;

                    if (![regNumList.DoctorScheduleID isEqualToString:@"0"]) {
//                        cell.titleLabel.text = @"预约";
//                        cell.borderView.hidden = NO;
                        cell.chooseImageView.hidden = YES;
                        cell.unChooseImageView.hidden = NO;
                    } else {
//                        cell.titleLabel.text = @"";
//                        cell.borderView.hidden = YES;
                        cell.chooseImageView.hidden = YES;
                        cell.unChooseImageView.hidden = YES;
                    }
                }
            }
            
            return cell;
        }
        
    }
    return nil;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath %@",indexPath);
    
    NSInteger offset = 0;
    
    if (_type == BATNowSeven) {
        offset = 0;
    } else {
        offset = 7;
    }
    
    if (indexPath.section != 0) {
        if (indexPath.row != 0) {
            Schedulelist *scheduleList = _doctorScheduleModel.Data.ScheduleList[indexPath.section - 1];
            
            if (scheduleList.RegNumList.count > 0) {
                Regnumlist *regNumList = scheduleList.RegNumList[indexPath.row - 1 + offset];
                
                _selectScheduleIndex = indexPath.section - 1;
                _selectRegnumlistIndex = indexPath.row - 1 + offset;
                
                if (![regNumList.DoctorScheduleID isEqualToString:@"0"]) {
                    
                    //预约

                    
                }
            }
        }
    }
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.frame.size.width - 7) / 8, (self.frame.size.width - 7) / 8);
}

#pragma mark - Action
- (void)configrationData:(BATDoctorScheduleModel *)doctorScheduleModel
{
    _doctorScheduleModel = doctorScheduleModel;
    
    //设置分栏，所谓的几月几日-几月几日
    Dateweeklist *dateweeklist1 = _doctorScheduleModel.Data.DateWeekList[0];
    
    Dateweeklist *dateweeklist2 = _doctorScheduleModel.Data.DateWeekList[6];
    
    Dateweeklist *dateweeklist3 = _doctorScheduleModel.Data.DateWeekList[7];
    
    Dateweeklist *dateweeklist4 = _doctorScheduleModel.Data.DateWeekList[13];
    
//    UIButton *button1 = (UIButton *)[_topView viewWithTag:100];
//    [button1 setTitle:[NSString stringWithFormat:@"%@至%@",[self formatButtonTitle:[dateweeklist1.DateStr substringFromIndex:5]],[self formatButtonTitle:[dateweeklist2.DateStr substringFromIndex:5]]] forState:UIControlStateNormal];
//    
//    UIButton *button2 = (UIButton *)[_topView viewWithTag:101];
//    [button2 setTitle:[NSString stringWithFormat:@"%@至%@",[self formatButtonTitle:[dateweeklist3.DateStr substringFromIndex:5]],[self formatButtonTitle:[dateweeklist4.DateStr substringFromIndex:5]]] forState:UIControlStateNormal];
    
    BATGraditorButton *button1 = (BATGraditorButton *)[_topView viewWithTag:100];
    [button1 setTitle:[NSString stringWithFormat:@"%@至%@",[self formatButtonTitle:[dateweeklist1.DateStr substringFromIndex:5]],[self formatButtonTitle:[dateweeklist2.DateStr substringFromIndex:5]]] forState:UIControlStateNormal];
    [button1 setGradientColors:@[START_COLOR,END_COLOR]];
    
    BATGraditorButton *button2 = (BATGraditorButton *)[_topView viewWithTag:101];
    [button2 setTitle:[NSString stringWithFormat:@"%@至%@",[self formatButtonTitle:[dateweeklist3.DateStr substringFromIndex:5]],[self formatButtonTitle:[dateweeklist4.DateStr substringFromIndex:5]]] forState:UIControlStateNormal];
    [button2 setGradientColors:@[UIColorFromHEX(0x999999, 1),UIColorFromHEX(0x999999, 1)]];
    
    //设置collectionView大小
    float collectionHeight = (self.frame.size.width - 7) / 8 * (1+_doctorScheduleModel.Data.ScheduleList.count) + ((1+_doctorScheduleModel.Data.ScheduleList.count) * 1);
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(collectionHeight);
    }];
    
    [_contarinerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(collectionHeight + 150);
    }];
    
    [_collectionView reloadData];
}

- (NSString *)formatButtonTitle:(NSString *)string
{
    return [[string stringByReplacingOccurrencesOfString:@"-" withString:@"月"] stringByAppendingString:@"日"];
}

- (void)buttonAction:(BATGraditorButton *)button
{
    //重置button状态
    for (UIView *subView in _topView.subviews) {
        if ([subView isKindOfClass:[BATGraditorButton class]]) {
            BATGraditorButton *btn = (BATGraditorButton *)subView;
            btn.selected = NO;
            
            if (btn == button) {
                [btn setGradientColors:@[START_COLOR,END_COLOR]];
            }else{
                [btn setGradientColors:@[UIColorFromHEX(0x999999, 1),UIColorFromHEX(0x999999, 1)]];
            }
        }
    }
    
    button.selected = YES;
    
    //设置当前显示的分栏
    if (button.tag == 100) {
        _type = BATNowSeven;
    } else {
        _type = BATNextSeven;
    }
    

    
    //更新滑块
    [_slider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topView.mas_left).offset(button.frame.origin.x);
    }];
    
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_topView setNeedsLayout];
        [_topView layoutIfNeeded];
    } completion:nil];
    
    [_collectionView reloadData];
}

@end
