//
//  BATHealthThreeSecondsStatisController.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/12/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthThreeSecondsStatisController.h"
#import "BATHealthThreeSecondStatisTableView.h"
#import "BATHealthThreeSecondStatisticsModel.h"

typedef NS_ENUM(NSInteger, BATRequestType) {
    BATRequestTypeUnkonwn = -1,
    BATRequestTypeDay = 0,
    BATRequestTypeWeek = 1,
    BATRequestTypeMonth = 2
};

@protocol BATStatisSegmentControlDelegate <NSObject>
- (void)segmentControlByClickWithIndex:(NSInteger)index;
@end

@interface BATStatisSegmentControl : UIView
@property (nonatomic ,weak)   id<BATStatisSegmentControlDelegate>     delegate;
@property (nonatomic ,copy)   NSArray<UIButton *>                     *buttonArray;

- (instancetype)initWithFrame:(CGRect)frame itemsName:(NSArray<NSString *> *)items;
@end

@implementation BATStatisSegmentControl
- (instancetype)initWithFrame:(CGRect)frame itemsName:(NSArray<NSString *> *)items {
    if (self = [super initWithFrame:frame]) {
        [self setupUIWith:items];
    }
    return self;
}

- (void)setupUIWith:(NSArray *)items {
    NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
    CGFloat width = self.width/items.count;
    for (NSInteger i = 0; i < items.count; i++) {
        NSString *name = [items objectWithIndex:i];
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(44, 204, 186, 1) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setBackgroundImage:[self buttonBackBGColorWith:@[START_COLOR,END_COLOR]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonByClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(i*width, 0, width, self.height);
        [buttonArray addObject:button];
        [self addSubview:button];
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(i*width, 0, 1, self.height)];
        lineV.backgroundColor = UIColorFromRGB(44, 204, 186, 1);
        [self addSubview:lineV];
        if (i == 0) {
            button.selected = YES;
        }
    }
    self.buttonArray = buttonArray;
}

- (UIImage *)buttonBackBGColorWith:(NSArray *)colorArray {
    NSMutableArray *colorArr = [[NSMutableArray alloc] init];
    for (UIColor *color in colorArray) {
        [colorArr addObject:(id)color.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colorArray lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)colorArr, NULL);
    CGPoint start = CGPointZero;
    CGPoint end = CGPointMake(self.frame.size.width, 0);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

- (void)buttonByClick:(UIButton *)sender {
    for (UIButton *btn in self.buttonArray) {
        btn.selected = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentControlByClickWithIndex:)]) {
        [self.delegate segmentControlByClickWithIndex:sender.tag];
    }
    sender.selected = YES;
}
@end

@interface BATHealthThreeSecondsStatisController ()
<
BATHealthThreeSecondStatisTableViewDelegate,
BATStatisSegmentControlDelegate
>
@property (nonatomic ,weak)     BATHealthThreeSecondStatisTableView           *statisticsTableView;
@property (nonatomic ,strong)   BATHealthThreeSecondsModel                    *model;
@property (nonatomic ,strong)   NSDate                                        *todayDate;
@property (nonatomic ,assign)   NSInteger                                     currentSelectedIndex;
@property (nonatomic ,strong)   BATStatisSegmentControl                       *segmentControl;
@end

@implementation BATHealthThreeSecondsStatisController

- (instancetype)initWithModel:(BATHealthThreeSecondsModel *)model todayDate:(NSDate *)todayDate {
    if (self = [super init]) {
        _model = model;
        _todayDate = todayDate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.statisticsTableView.mj_header beginRefreshing];
}

#pragma mark -- private
- (void)setupUI {
    self.title = @"统计";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentControl];
    BATHealthThreeSecondStatisTableView *statisticsTableView = [[BATHealthThreeSecondStatisTableView alloc] initWithStyle:UITableViewStylePlain];
    statisticsTableView.bat_Delegate = self;
    [self.view addSubview:statisticsTableView];
    self.statisticsTableView = statisticsTableView;
    [self.statisticsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
}

#pragma mark -- network
- (void)statisticsDataRequestWith:(BATRequestType)type {
    NSString *requestStr = [NSString stringWithFormat:@"%ld",(long)type];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params jk_setObj:requestStr forKey:@"type"];
    [HTTPTool requestWithURLString:@"/api/EatCircle/HealthDataStatistics" parameters:params type:kGET success:^(id responseObject) {
        BATHealthThreeSecondStatisticsModel *statisticsDataModel = [BATHealthThreeSecondStatisticsModel healthThreeSecondStatisticsModelWith:responseObject];
        
        [self.statisticsTableView updateDataWith:statisticsDataModel];
        [self.statisticsTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.statisticsTableView.mj_header endRefreshing];
    }];
}

#pragma mark -- BATHealthThreeSecondStatisTableViewDelegate
- (void)healthThreeSecondStatisTableViewHeaderRefresh:(BATHealthThreeSecondStatisTableView *)statisTableView {
    [self statisticsDataRequestWith:self.currentSelectedIndex];
}

#pragma mark -- BATStatisSegmentControlDelegate
- (void)segmentControlByClickWithIndex:(NSInteger)index {
    if (self.currentSelectedIndex != index) {
        BATRequestType requestType = BATRequestTypeUnkonwn;
        switch (index) {
            case BATRequestTypeDay:   requestType = BATRequestTypeDay; break;
            case BATRequestTypeWeek:  requestType = BATRequestTypeWeek; break;
            case BATRequestTypeMonth: requestType = BATRequestTypeMonth; break;
            default: break;
        }
        [self statisticsDataRequestWith:requestType];
        self.currentSelectedIndex = index;
    }
}

#pragma mark -- setter & getter
- (BATStatisSegmentControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[BATStatisSegmentControl alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-20*2, 35) itemsName:@[@"日",@"周",@"月"]];
        _segmentControl.delegate = self;
        _segmentControl.layer.borderWidth = 1.0;
        _segmentControl.layer.cornerRadius = 6.0;
        _segmentControl.layer.masksToBounds = YES;
        _segmentControl.layer.borderColor = UIColorFromRGB(44, 204, 186, 1).CGColor;
    }
    return _segmentControl;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
