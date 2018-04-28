//
//  BATProgramPunchCardTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATProgramPunchCardTableViewCell.h"
#import "BATProgramDetailModel.h"

@implementation BATProgramPunchCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self pageLayout];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Action
- (void)loadUsers:(NSArray *)array
{
    for (UIView *subView in self.usersView.subviews) {
        [subView removeFromSuperview];
    }
    
    UIView *preView = nil;
    
    CGFloat width = 0;
    
    NSInteger count = array.count >= 7 ? 7 : array.count;
    
    for (int i = 0; i < count; i++) {
        
        BATClockInItem *clockInItem = array[i];
        
        
        if (width > SCREEN_WIDTH - 110 - 10 - 40 - 10) {
            
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setImage:[UIImage imageNamed:@"icon-ggg"]];
            [self.usersView addSubview:imageView];
            [self.usersView sendSubviewToBack:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.usersView.mas_centerY);
                make.left.equalTo(preView.mas_right);
                make.size.mas_offset(CGSizeMake(20, 5));
            }];
            
            
            break;
        }
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 40 / 2;
        
        [self.usersView addSubview:bgView];
        [self.usersView sendSubviewToBack:bgView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:clockInItem.PhotoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 35 / 2;

//        imageView.layer.borderWidth = 2;
//        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [bgView addSubview:imageView];
        
//        [self.usersView sendSubviewToBack:imageView];
        
        WEAK_SELF(self);
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            if (i == 0) {
                make.left.equalTo(self.usersView.mas_left);
            } else {
                make.left.equalTo(preView.mas_right).offset(-10);
            }
            
            make.size.mas_offset(CGSizeMake(40, 40));
            make.centerY.equalTo(self.usersView.mas_centerY);
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bgView);
            make.size.mas_offset(CGSizeMake(35, 35));
        }];
        
        preView = bgView;
        
        width = 40 * (i + 1);
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.countLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.usersView];
    [self.contentView addSubview:self.arrowImageView];
    
    WEAK_SELF(self);
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.width.mas_offset(110);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.countLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
    }];
    
    [self.usersView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.countLabel.mas_right).offset(10);
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_equalTo(CGSizeMake(7, 11));
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

#pragma mark - get & set
- (UILabel *)countLabel
{
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:15];
        _countLabel.textColor = STRING_DARK_COLOR;
    }
    return _countLabel;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = STRING_DARK_COLOR;
    }
    return _titleLabel;
}

- (UIView *)usersView
{
    if (_usersView == nil) {
        _usersView = [[UIView alloc] init];
        _usersView.backgroundColor = [UIColor redColor];
    }
    return _usersView;
}

- (UIImageView *)arrowImageView
{
    if (_arrowImageView == nil) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-jt"]];
    }
    return _arrowImageView;
}

@end
