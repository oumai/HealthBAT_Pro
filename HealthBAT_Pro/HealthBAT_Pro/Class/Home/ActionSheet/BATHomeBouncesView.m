//
//  BATHomeBouncesView.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/11/15.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHomeBouncesView.h"
#import "BATHomeBounesTableViewCell.h"
#import "UIButton+TouchAreaInsets.h"
static NSString *ID = @"BATHomeBounesTableViewCell";
@interface BATHomeBouncesView()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *contentViewHead;
@property (strong, nonatomic) UIView *contentViewMiddle;
@property (strong, nonatomic) UIView *contentViewBottom;
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) UILabel *titleLab;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) UIButton *XBtn;
@property (nonatomic,strong) UIButton *closeBtn;

@property (strong, nonatomic) UILabel *holLab;

@property (strong, nonatomic) NSArray *dataArr;
@property (strong, nonatomic) UIView *footerView;
@end;
@implementation BATHomeBouncesView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
     
        [self layoutSelf];
    }
    return self;
}

- (void)layoutSelf {
    
    _count = 5;
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    [self.contentView addSubview:self.contentViewHead];
    [self.contentView addSubview:self.contentViewMiddle];
    [self.contentView addSubview:self.contentViewBottom];
    
    [self.contentViewMiddle addSubview:self.tableView];
    
    [self.contentViewBottom addSubview:self.contentLab];
    [self.contentViewHead addSubview:self.titleLab];
    [self.contentViewHead addSubview:self.closeBtn];
    
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.center.mas_equalTo(self);
        //        make.height.mas_greaterThanOrEqualTo(300);
        
    }];
    
    [self.contentViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.contentView);
        make.height.mas_equalTo(@50);
        
    }];
    
    [self.contentViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.leading.trailing.mas_equalTo(self.contentView);
        //         make.height.mas_equalTo(@60);
        
    }];
    
    [self.contentViewMiddle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentViewHead.mas_bottom).offset(1);
        make.bottom.mas_equalTo(self.contentViewBottom.mas_top).offset(-1);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentViewBottom);
        make.bottom.mas_equalTo(self.contentViewBottom.mas_bottom).offset(-10);
        make.leading.mas_equalTo(self.contentViewBottom.mas_leading).offset(10);
        make.trailing.mas_equalTo(self.contentViewBottom.mas_trailing).offset(-10);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(self.contentViewMiddle);
        make.height.mas_equalTo(50 * _count + 50);
    }];
    
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentViewHead);
        make.left.mas_equalTo(self.contentViewHead.mas_left).offset(10);
        
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_offset(CGSizeMake(20, 20));
        make.centerY.equalTo(self.titleLab.mas_centerY);
        make.right.equalTo(self.contentViewHead.mas_right).offset(-10);
    }];
    self.closeBtn.touchAreaInsets = UIEdgeInsetsMake(0, 20, 0, 10);
    [self.holLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 10, 0, 0));
    }];
    
}
//- (void)layoutSubviews {
//    
//    [super layoutSubviews];
//    
//    
//}
#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    

   BATHomeBounesTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArr) {
        
        cell.status = self.status;
        cell.dic = _dataArr[indexPath.row];
        
    }
    
    return cell;
    
}


#pragma mark - getter
- (UIView *)contentView {
    
    if (!_contentView) {
       
        _contentView =[[UIView alloc] init];
        _contentView.backgroundColor = [UIColor grayColor];
        
        
    }
    return  _contentView;
    
}
- (UIView *)contentViewHead {
    
    if (!_contentViewHead) {
        
        _contentViewHead =[[UIView alloc] init];
        _contentViewHead.backgroundColor = [UIColor whiteColor];
        
        
    }
    return  _contentViewHead;
    
}
- (UIView *)contentViewMiddle {
    
    if (!_contentViewMiddle) {
        
        _contentViewMiddle =[[UIView alloc] init];
        _contentViewMiddle.backgroundColor = [UIColor whiteColor];
        
        
    }
    return  _contentViewMiddle;
    
}
- (UIView *)contentViewBottom {
    
    if (!_contentViewBottom) {
        
        _contentViewBottom =[[UIView alloc] init];
        _contentViewBottom.backgroundColor = [UIColor whiteColor];
        
        
    }
    return  _contentViewBottom;
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[BATHomeBounesTableViewCell class] forCellReuseIdentifier:ID];
        _tableView.rowHeight = 50;
        _tableView.scrollEnabled = NO;
        _tableView.allowsSelection = NO;
        [_tableView setSeparatorColor:[UIColor clearColor]];
        
        UIView *footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0, 0, self.width, 50);
        footerView.backgroundColor = [UIColor whiteColor];
        [footerView addSubview:self.holLab];
        _footerView = footerView;
        _tableView.tableFooterView = footerView;
       
    }
    return  _tableView;
    
}
- (UIView *)bgView {
    
    if (!_bgView) {
        
        _bgView =[[UIView alloc] init];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.frame = self.frame;
        _bgView.alpha = 0.3;
        
        
    }
    return  _bgView;
    
}
- (UILabel *)contentLab {
    
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.numberOfLines = 0;
        _contentLab.text = @"评估结果";
        _contentLab.font = [UIFont systemFontOfSize:14];
    }
    
    return _contentLab;
    
    
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        
        _titleLab = [[UILabel alloc] init];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = @"健康评估结果";
    }
    return _titleLab;
}

- (UILabel *)holLab {
    if (!_holLab) {
        
        _holLab = [[UILabel alloc] init];
        _holLab.textAlignment = NSTextAlignmentLeft;
        _holLab.text = @"健康评估结果";
    }
    return _holLab;
}
- (UIButton *)XBtn {
    
    if (!_XBtn) {
        _XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _XBtn;
    
}
- (UIButton *)closeBtn
{
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon-gbb"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
#pragma mark - Action
- (void)closeBtnAction:(UIButton *)button
{
    if (self.closeContentBlock) {
        self.closeContentBlock();
    }
}
#pragma mark - setter


- (void)setModel:(BATHealthEvalutionModel *)model {
    
    
    _model = model;
    _dataArr = [NSArray array];
    
    if (self.status == SHstatus) {
        
        _dataArr = @[@{@"title":@"社会适应", @"score":@(_model.ReturnData.SocialResult.Score), @"item":@(_model.ReturnData.SocialResult.Item1)},
                     @{@"title":@"社会接触", @"score":@(_model.ReturnData.SocialResult.Score), @"item":@(_model.ReturnData.SocialResult.Item2)},
                     @{@"title":@"社会支持", @"score":@(_model.ReturnData.SocialResult.Score), @"item":@(_model.ReturnData.SocialResult.Item3)}] ;
        _count = _dataArr.count;
        
        _contentLab.text = _model.ReturnData.SocialResult.AppGeneralConclusion;
        _titleLab.text = @"社会健康评估";
        [_tableView reloadData];
        
    } else if(self.status == XLstatus) {
     
        _dataArr = @[@{@"title":@"焦虑", @"score":@(_model.ReturnData.PsychologyResult.Score), @"item":@(_model.ReturnData.PsychologyResult.Item1)},
                     @{@"title":@"抑郁", @"score":@(_model.ReturnData.PsychologyResult.Score), @"item":@(_model.ReturnData.PsychologyResult.Item2)},
                     @{@"title":@"睡眠", @"score":@(_model.ReturnData.PsychologyResult.Score), @"item":@(_model.ReturnData.PsychologyResult.Item3),
                       },
                     @{@"title":@"心理躯体化", @"score":@(_model.ReturnData.PsychologyResult.Score), @"item":@(_model.ReturnData.PsychologyResult.Item4),
                       
                       }] ;
        
        _count = _dataArr.count;
         _contentLab.text = _model.ReturnData.PsychologyResult.AppGeneralConclusion;
        _titleLab.text = @"心理健康评估";
        [_tableView reloadData];
        
        
    } else {
        
        NSInteger countOfHeal = _model.ReturnData.HealthDeseaseCategoryList.count;
        NSMutableArray *arrM = [NSMutableArray array];
        
        for (int i = 0; i < countOfHeal; i ++) {
            BATHealthEvalutionHealthDeseaseCategoryListModel *model = _model.ReturnData.HealthDeseaseCategoryList[i];
            
            NSDictionary *dic = @{@"title":model.HealthDeseaseName, @"score":@(_model.ReturnData.PsychologyResult.Score), @"item":@(model.DangerLevelID), @"DangerLevelName":model.DangerLevelName};
     
            [arrM addObject:dic];
            
        }
        _dataArr = [arrM copy];
        
        _count = _dataArr.count;
         _contentLab.text = @"";
        _titleLab.text = @"生理健康评估";
        [_tableView reloadData];
        
        
        
    }
     
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(self.contentViewMiddle);
        make.height.mas_equalTo(50 * _count + 50);
    }];
    
    
   
    
    [self.tableView setNeedsDisplay];
    [self setNeedsDisplay];
    
}
@end
