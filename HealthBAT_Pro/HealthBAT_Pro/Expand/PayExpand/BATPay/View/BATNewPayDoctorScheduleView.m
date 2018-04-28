//
//  BATNewPayDoctorScheduleView.m
//  HealthBAT_Pro
//
//  Created by four on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATNewPayDoctorScheduleView.h"

//cell
#import "BATNewPayScheduleCell.h"
#import "BATNewPayScueduleDayCell.h"

@interface BATNewPayDoctorScheduleView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,assign) NSInteger moveInteget;

@property (nonatomic,strong) BATNewDoctorScheduleModel *doctorScheduleModel;


@end

@implementation BATNewPayDoctorScheduleView

- (void)dealloc
{
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        _moveInteget = 0;
        [self layoutPages];
    }
    return self;
}

#pragma mark - Action
- (void)configrationData:(BATNewDoctorScheduleModel *)doctorScheduleModel
{
    self.doctorScheduleModel = doctorScheduleModel;
    
    [_collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return 6;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        BATNewPayScueduleDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATNewPayScueduleDayCell" forIndexPath:indexPath];
        
        NewDoctorScheduleData *newDataWeek = self.doctorScheduleModel.Data[_moveInteget];
        
        if(newDataWeek.DataWeek.WeekStr==nil){
            cell.timeLable.text = @"暂时没有排版信息";
        }else{
            cell.timeLable.text = [NSString stringWithFormat:@"%@%@",newDataWeek.DataWeek.WeekStr,newDataWeek.DataWeek.DateStr];
        }
    
        
        [cell setClickLeftImageIcon:^{
            DDLogInfo(@"向前一天");
            
            if (_moveInteget == 0) {
                return ;
            }else if (_moveInteget <= 0) {
                _moveInteget = 0;
            }else{
                _moveInteget = _moveInteget - 1;
            }
            
            [self.collectionView reloadData];
        }];
        
        [cell setClickRightImageIcon:^{
            DDLogInfo(@"向后一天");
            
            if (_moveInteget == self.doctorScheduleModel.Data.count - 1) {
                return ;
            }else if (_moveInteget < self.doctorScheduleModel.Data.count - 1) {
                _moveInteget = _moveInteget + 1;
            }
            
            [self.collectionView reloadData];
        }];
        
        return cell;
    }else{
        BATNewPayScheduleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BATNewPayScheduleCell" forIndexPath:indexPath];
        
        NewDoctorScheduleData *newDoctorScheduleData = self.doctorScheduleModel.Data[_moveInteget];
        
        NSDictionary *dict = newDoctorScheduleData.ScheduleTimeList[indexPath.row];
        DDLogInfo(@"===%@===%@====",[dict objectForKey:@"IsYueYue"], [dict objectForKey:@"IsLeftNum"]);
        
        //过期 ---> 直接灰色，不显示满，
        //可以预约下 ---> 黑色
        //可以预约满 ---> 灰色
        if ([[dict objectForKey:@"IsYueYue"] intValue] == 0) {
            cell.timeLable.textColor = UIColorFromHEX(0x999999, 1);
            cell.fullImageIcon.hidden = YES;
        }else{
            cell.timeLable.textColor = UIColorFromHEX(0x333333, 1);
            
            if ([[dict objectForKey:@"IsLeftNum"] intValue] == 0) {
                cell.timeLable.textColor = UIColorFromHEX(0x999999, 1);
                cell.fullImageIcon.hidden = NO;
            }else{
                cell.fullImageIcon.hidden = YES;
                cell.timeLable.textColor = UIColorFromHEX(0x333333, 1);
            }
        }
        


        switch (indexPath.row) {
            case 0:
            {
                cell.timeLable.text = @"8:00-10:00";
            }
                break;
            case 1:
            {
                cell.timeLable.text = @"10:00-12:00";
            }
                break;
            case 2:
            {
                cell.timeLable.text = @"14:00-16:00";
            }
                break;
            case 3:
            {
                cell.timeLable.text = @"16:00-18:00";
            }
                break;
            case 4:
            {
                cell.timeLable.text = @"18:00-20:00";
            }
                break;
            case 5:
            {
                cell.timeLable.text = @"20:00-23:59";
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        //先取_moveInteget，再去row
        NewDoctorScheduleData *newDoctorScheduleData = self.doctorScheduleModel.Data[_moveInteget];
        
        NSDictionary *dict = newDoctorScheduleData.ScheduleTimeList[indexPath.row];
        DDLogInfo(@"===%@===%@====",[dict objectForKey:@"IsYueYue"], [dict objectForKey:@"IsLeftNum"]);
        
        //过期 ---> 直接灰色，不显示满，
        //可以预约下 ---> 黑色
        //可以预约满 ---> 灰色
        if ([[dict objectForKey:@"IsYueYue"] intValue] == 0) {
            //不可预约，提示吧
            if (self.noScheduleCanChooseClick) {
                self.noScheduleCanChooseClick();
            }
        }else{
            if ([[dict objectForKey:@"IsLeftNum"] intValue] == 0) {
                //不可预约，提示吧
                if (self.noScheduleCanChooseClick) {
                    self.noScheduleCanChooseClick();
                }
            }else{
                //可预约，进行预约时间赋值
                if (self.chooseScheduleClick) {
                    self.chooseScheduleClick(_moveInteget, indexPath.row);
                }
            }
        }

    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake((self.frame.size.width - 60), 45);
    }
    else{
        return CGSizeMake((self.frame.size.width - 60) / 2, 45);
    }
}


- (void)layoutPages{
    
    WEAK_SELF(self);
    
    [self addSubview:self.blackBGView];
    [self addSubview:self.whiteBGView];
    [self addSubview:self.collectionView];
    
    
    [self.blackBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self);
    }];
    
    [self.whiteBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.centerY.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH - 60);
        make.height.mas_equalTo(180);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.whiteBGView);
    }];
    
}

- (UIView *)blackBGView{
    if (!_blackBGView) {
        _blackBGView = [[UIView alloc] init];
        _blackBGView.backgroundColor = UIColorFromHEX(0x000000, 0.3);
        [_blackBGView bk_whenTapped:^{
            if (self.blackViewClick) {
                self.blackViewClick();
            }
        }];
    }
    
    return _blackBGView;
}

- (UIView *)whiteBGView{
    if (!_whiteBGView) {
        _whiteBGView = [[UIView alloc] init];
        _whiteBGView.backgroundColor = [UIColor whiteColor];
    }
    
    return _whiteBGView;
}


- (UICollectionView *)collectionView{

    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 1, 0);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = UIColorFromHEX(0xf6f6f6, 1);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[BATNewPayScheduleCell class] forCellWithReuseIdentifier:@"BATNewPayScheduleCell"];
        [_collectionView registerClass:[BATNewPayScueduleDayCell class] forCellWithReuseIdentifier:@"BATNewPayScueduleDayCell"];
    }
    
    return _collectionView;
}
@end
