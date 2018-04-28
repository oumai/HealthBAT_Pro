//
//  BATInvitationContentCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATInvitationContentCell.h"

@interface BATInvitationContentCell()

@end


@implementation BATInvitationContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    WEAK_SELF(self);
    self.contentLb.font = [UIFont systemFontOfSize:15];
    self.contentLb.textColor = UIColorFromHEX(0X333333, 1);
    self.contentLb.numberOfLines = 0;
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(10).priorityHigh();
        
    }];
    
    [self.contentView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.top.equalTo(self.contentLb.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
     //   make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        
    }];
    
    [self.contentView addSubview:self.priseBtn];
    [self.priseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(self.photoView.mas_bottom).offset(45);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-45);
        
    }];
    
    self.lineView.backgroundColor = BASE_BACKGROUND_COLOR;
    
}

- (void)setModel:(BATInvitationModel *)model {

    _model = model;
    
    self.contentLb.text = model.Data.PostContent;
    
    [_photoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(model.Data.collectionImageViewHeight).priorityLow();
    }];
    
    //加载图片数据
    [_photoView loadImageData:model.Data.ImageList];
    
    _priseBtn.selected = model.Data.IsSetStar;
    
    [_priseBtn setTitle:[NSString stringWithFormat:@"%zd",model.Data.StarNum] forState:UIControlStateNormal];
    
    [self.contentView layoutIfNeeded];


}

- (void)priseActon {
    
    if (self.topicDetailPriseBlock) {
        self.topicDetailPriseBlock();
    }

}

- (BATCustomButton *)priseBtn {

    if (!_priseBtn) {
        _priseBtn = [[BATCustomButton alloc]init];
        [_priseBtn setBackgroundImage:[UIImage imageNamed:@"ic-dz-ss"] forState:UIControlStateNormal];
        [_priseBtn setBackgroundImage:[UIImage imageNamed:@"ic-dz"] forState:UIControlStateSelected];
        [_priseBtn addTarget:self action:@selector(priseActon) forControlEvents:UIControlEventTouchUpInside];
        _priseBtn.titleRect = CGRectMake(0, 25, 40, 10);
        _priseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _priseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_priseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _priseBtn;
}

- (BATPhotoView *)photoView {

    if (!_photoView) {
        _photoView = [[BATPhotoView alloc]init];
    }
    return _photoView;
}

@end
