//
//  BATDoctorFilterView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDoctorFilterView.h"

@implementation BATDoctorFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _service = [NSMutableArray array];
        _title = [NSMutableArray array];
        
        [self pageLayout];
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

#pragma mark - pageLayout
- (void)pageLayout
{
    [self addSubview:self.serviceView];
    [self addSubview:self.titleView];
    [self addSubview:self.footerView];
    
    
    WEAK_SELF(self);
    [self.serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        if (iPhoneX) {
            if (@available(iOS 11.0, *)) {
                make.left.right.equalTo(self);
                make.top.mas_equalTo(self.mas_top).offset(40);
            }
        } else {
            make.left.top.right.equalTo(self);
        }
        make.height.mas_offset(150);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.serviceView.mas_bottom);
        make.height.mas_offset(150);
    }];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.mas_offset(100);
    }];
}

#pragma mark - get & set

- (BATFilterTypeView *)serviceView
{
    if (_serviceView == nil) {
        _serviceView = [[BATFilterTypeView alloc] init];
        _serviceView.titleLabel.text = @"服务类型";
        [_serviceView loadFilterItem:@[@"图文咨询",@"语音咨询",@"视频咨询"]];
        
        WEAK_SELF(self);
        _serviceView.filterClickBlock = ^(NSInteger index,BOOL isSelect) {
            STRONG_SELF(self);
            if (index == 0) {
                //图文
                if (isSelect) {
                    if (![self.service containsObject:[NSNumber numberWithInteger:BATDoctorStudioOrderServiceType_TextAndImage]]) {
                        [self.service addObject:[NSNumber numberWithInteger:BATDoctorStudioOrderServiceType_TextAndImage]];
                    }
                } else {
                    [self.service removeObject:[NSNumber numberWithInteger:BATDoctorStudioOrderServiceType_TextAndImage]];
                }
            } else if (index == 1) {
                //电话
                if (isSelect) {
                    if (![self.service containsObject:[NSNumber numberWithInteger:BATDoctorStudioOrderServiceType_Audio]]) {
                        [self.service addObject:[NSNumber numberWithInteger:BATDoctorStudioOrderServiceType_Audio]];
                    }
                } else {
                    [self.service removeObject:[NSNumber numberWithInteger:BATDoctorStudioOrderServiceType_Audio]];
                }
            } else if (index == 2) {
                //视频
                if (isSelect) {
                    if (![self.service containsObject:[NSNumber numberWithInteger:BATDoctorStudioOrderServiceType_Video]]) {
                        [self.service addObject:[NSNumber numberWithInteger:BATDoctorStudioOrderServiceType_Video]];
                    }
                } else {
                    [self.service removeObject:[NSNumber numberWithInteger:BATDoctorStudioOrderServiceType_Video]];
                }
            }
        };
    }
    return _serviceView;
}

- (BATFilterTypeView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[BATFilterTypeView alloc] init];
        _titleView.titleLabel.text = @"职称等级";
        [_titleView loadFilterItem:@[@"初级",@"中级",@"高级"]];
        
        WEAK_SELF(self);
        _titleView.filterClickBlock = ^(NSInteger index,BOOL isSelect) {
            STRONG_SELF(self);
            if (index == 0) {
                //初级
                if (isSelect) {
                    if (![self.title containsObject:[NSNumber numberWithInteger:BATDoctorTitleLevel_Junior]]) {
                        [self.title addObject:[NSNumber numberWithInteger:BATDoctorTitleLevel_Junior]];
                    }
                } else {
                    [self.title removeObject:[NSNumber numberWithInteger:BATDoctorTitleLevel_Junior]];
                }
            } else if (index == 1) {
                //中级
                if (isSelect) {
                    if (![self.title containsObject:[NSNumber numberWithInteger:BATDoctorTitleLevel_Intermediate]]) {
                        [self.title addObject:[NSNumber numberWithInteger:BATDoctorTitleLevel_Intermediate]];
                    }
                } else {
                    [self.title removeObject:[NSNumber numberWithInteger:BATDoctorTitleLevel_Intermediate]];
                }
            } else if (index == 2) {
                //高级
                if (isSelect) {
                    if (![self.title containsObject:[NSNumber numberWithInteger:BATDoctorTitleLevel_Advanced_3]]) {
                        [self.title addObject:[NSNumber numberWithInteger:BATDoctorTitleLevel_Advanced_3]];
                        [self.title addObject:[NSNumber numberWithInteger:BATDoctorTitleLevel_Advanced_4]];
                    }
                } else {
                    [self.title removeObject:[NSNumber numberWithInteger:BATDoctorTitleLevel_Advanced_3]];
                    [self.title removeObject:[NSNumber numberWithInteger:BATDoctorTitleLevel_Advanced_4]];
                }
            }
        };
        
    }
    return _titleView;
}

- (BATDoctorFilterFooterView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[BATDoctorFilterFooterView alloc] init];
    }
    return _footerView;
}
@end
