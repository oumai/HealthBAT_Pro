//
//  BATDiteGuideDetailsPraiseCell.m
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/26.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideDetailsPraiseCell.h"
@interface BATDiteGuideDetailsPraiseCell ()
@property (nonatomic ,strong) UIButton                        *praiseBtn;
@property (nonatomic ,strong) UILabel                         *praiseNumLabel;
@property (nonatomic ,strong) BATDiteGuideDetailModel         *diteGuideDetailModel;
@end

@implementation BATDiteGuideDetailsPraiseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark -- private
- (void)setupUI {
    [self.contentView addSubview:self.praiseBtn];
    [self.contentView addSubview:self.praiseNumLabel];
    self.backgroundColor = UIColorFromRGB(245, 245, 245, 1);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
//        make.bottom.equalTo(self.contentView).offset(-5).priority(250);
        make.centerX.equalTo(self.contentView).offset(-10);
        make.height.width.mas_equalTo(40);
    }];
    [self.praiseNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.praiseBtn);
        make.left.equalTo(self.praiseBtn.mas_right).offset(-5);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.praiseBtn).offset(3);
    }];
}

- (void)setDataDiteGuideDetailModel:(BATDiteGuideDetailModel *)diteGuideDetailModel {
    self.diteGuideDetailModel = diteGuideDetailModel;
    self.praiseBtn.selected = diteGuideDetailModel.IsSetStar;
    self.praiseNumLabel.text = [NSString stringWithFormat:@"%ld",(long)diteGuideDetailModel.SetStarNum];
}

- (void)setDiteGuideDetailPraiseStarStatus:(BOOL)status {
    self.praiseBtn.selected = status;
    [UIView animateKeyframesWithDuration: 0.5 delay: 0 options: 0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime: 0
                                relativeDuration: 1/3.0
                                      animations: ^{
                                          self.praiseBtn.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 1/3.0
                                relativeDuration: 1/3.0
                                      animations: ^{
                                          self.praiseBtn.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 2/3.0
                                relativeDuration: 1/3.0
                                      animations: ^{
                                          self.praiseBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      }];
    } completion: ^(BOOL finished) {
        [self praiseBtnAnimateCompleteWithStatus:status];
    }];
}

#pragma mark -- click
- (void)praiseBtnByClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(diteGuideDetailsPraiseCell:diteGuideDetailModel:buttonStatus:)]) {
        [self.delegate diteGuideDetailsPraiseCell:self diteGuideDetailModel:self.diteGuideDetailModel buttonStatus:!sender.selected];
    }
}

- (void)praiseBtnAnimateCompleteWithStatus:(BOOL)status {
    NSInteger starNum = status? ++self.diteGuideDetailModel.SetStarNum : --self.diteGuideDetailModel.SetStarNum;
    self.praiseNumLabel.text = [NSString stringWithFormat:@"%ld",(long)starNum];
}

#pragma mark -- setter & getter

- (UIButton *)praiseBtn {
    if (!_praiseBtn) {
        _praiseBtn = [[UIButton alloc] init];
        [_praiseBtn setImage:[UIImage imageNamed:@"dietGuide_fabulous"] forState:UIControlStateNormal];
        [_praiseBtn setImage:[UIImage imageNamed:@"dietGuide_Fabulous_choose"] forState:UIControlStateSelected];
        [_praiseBtn addTarget:self action:@selector(praiseBtnByClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _praiseBtn;
}

- (UILabel *)praiseNumLabel {
    if (!_praiseNumLabel) {
        _praiseNumLabel = [[UILabel alloc] init];
        _praiseNumLabel.textAlignment = NSTextAlignmentLeft;
        _praiseNumLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _praiseNumLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
