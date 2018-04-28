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
    
    self.contentLb.font = [UIFont systemFontOfSize:15];
    self.contentLb.textColor = UIColorFromHEX(0X333333, 1);
    self.contentLb.numberOfLines = 0;
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        
    }];
    
    [self.contentView addSubview:self.photoView];
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentLb.mas_bottom).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        
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
    
    [self.contentView layoutIfNeeded];


}

- (BATPhotoView *)photoView {

    if (!_photoView) {
        _photoView = [[BATPhotoView alloc]init];
    }
    return _photoView;
}

@end
