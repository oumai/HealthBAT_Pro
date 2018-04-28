//
//  BATHealthThreeSecondsStatisCell.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsStatisCell.h"
#import "ZFChart.h"

@interface BATHealthThreeSecondsStatisCell ()
<
ZFGenericChartDataSource,
ZFLineChartDelegate
>
@property (nonatomic ,strong) ZFLineChart                   *lineChartV;
@property (nonatomic ,strong) UIView                        *lineChartBGView;
@property (nonatomic ,strong) UILabel                       *titleLabel;
@property (nonatomic ,strong) NSIndexPath                   *indexPath;
@property (nonatomic ,strong) NSMutableArray                *dataArr;
@property (nonatomic ,copy)   NSArray                       *nameArr;
@end

@implementation BATHealthThreeSecondsStatisCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- private
- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.lineChartBGView];
    [self.lineChartBGView addSubview:self.lineChartV];
    [self.contentView addSubview:self.titleLabel];
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"bat_healthThreeSec_circular"];
    [self.contentView addSubview:imageV];
    [self.lineChartBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(7);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageV.mas_right).offset(10);
        make.right.equalTo(self.contentView);
    }];
}

- (void)setupDataWith:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath nameArray:(NSArray<NSString *> *)nameArray animate:(BOOL)animate{
    self.titleLabel.text = [nameArray objectWithIndex:indexPath.row];
    self.indexPath = indexPath;
    self.nameArr = [[dict allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    self.dataArr = [NSMutableArray array];
    for (NSString *key in self.nameArr) {
        [self.dataArr addObject:dict[key]];
    }
    self.lineChartV.isAnimated = animate;
    [self.lineChartV strokePath];
}

- (CGFloat)axisYLineValueWith:(NSIndexPath *)indexPath dataArray:(NSArray<NSString *> *)dataArray nameArray:(NSArray<NSString *> *)nameArray titleLabel:(UILabel *)titleLabel {
    if (indexPath.row == 0) {
        return [self axisYLineValueWith:dataArray numInt:500 defautNum:500];
    } else if (indexPath.row == 1) {
        return [self axisYLineValueWith:dataArray numInt:5 defautNum:5];
    } else if (indexPath.row == 2) {
        return [self axisYLineValueWith:dataArray numInt:5 defautNum:5];
    } else if (indexPath.row == 3) {
        return [self axisYLineValueWith:dataArray numInt:5000 defautNum:5000];
    } else {
        return 0;
    }
}

- (CGFloat)axisYLineValueWith:(NSArray<NSString *> *)dataArray numInt:(NSInteger)numInt defautNum:(CGFloat)defautNum {
    NSMutableArray *numArray = [[NSMutableArray alloc] init];
    for (NSString *value in dataArray) {
        CGFloat f = [value floatValue];
        [numArray addObject:[NSNumber numberWithFloat:f]];
    }
    NSArray *tempArr = [numArray sortedArrayUsingSelector:@selector(compare:)];
    CGFloat value = [self adjustValue:[[tempArr lastObject] floatValue] numInt:numInt];
    if (value > defautNum) {
        return value;
    }
    return defautNum;
}

- (CGFloat)adjustValue:(CGFloat)value numInt:(NSInteger)numInt {
    return (ceil(value/numInt/1.0)*1)*numInt;
}

+ (CGFloat)getHeight {
    return 180;
}

#pragma mark -- ZFGenericChartDataSource & ZFLineChartDelegate
- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart {
    return self.dataArr;
}

- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart {
    return self.nameArr;
}

- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[UIColorFromRGB(44, 204, 186, 1)];
}

- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart {
    return [self axisYLineValueWith:self.indexPath dataArray:self.dataArr nameArray:self.nameArr titleLabel:self.titleLabel];
}

- (CGFloat)axisLineMinValueInGenericChart:(ZFGenericChart *)chart {
    return 0;
}

- (NSUInteger)axisLineSectionCountInGenericChart:(ZFGenericChart *)chart {
    return 5;
}

- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart {
    return 3.0;
}

- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart {
    return 1.2;
}

#pragma mark -- setter & getter
- (ZFLineChart *)lineChartV {
    if (!_lineChartV) {
        _lineChartV = [[ZFLineChart alloc] initWithFrame:CGRectMake(-10, -50, SCREEN_WIDTH-10, 200)];
        _lineChartV.backgroundColor = [UIColor clearColor];
        _lineChartV.delegate = self;
        _lineChartV.dataSource = self;
        _lineChartV.isShowYLineSeparate = YES;
        _lineChartV.isShowAxisLineValue = NO;
        _lineChartV.isShowAxisArrows = NO;
        _lineChartV.isResetAxisLineMaxValue = YES;
        _lineChartV.separateColor = UIColorFromRGB(224, 224, 224, 1);
        _lineChartV.xLineNameLabelToXAxisLinePadding = 5;
        _lineChartV.yAxisColor = [UIColor clearColor];
        _lineChartV.xAxisColor = UIColorFromRGB(224, 224, 224, 1);
    }
    return _lineChartV;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLabel;
}

- (UIView *)lineChartBGView {
    if (!_lineChartBGView) {
        _lineChartBGView = [[UIView alloc] init];
        _lineChartBGView.backgroundColor = [UIColor whiteColor];
        _lineChartBGView.layer.cornerRadius = 4;
        _lineChartBGView.layer.masksToBounds = YES;
    }
    return _lineChartBGView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
