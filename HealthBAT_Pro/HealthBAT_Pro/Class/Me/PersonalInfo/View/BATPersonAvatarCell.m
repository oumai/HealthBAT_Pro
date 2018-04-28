//
//  BATPersonAvatarCell.m
//  CancerNeighbour
//
//  Created by Wilson on 15/10/28.
//  Copyright © 2015年 KM. All rights reserved.
//

#import "BATPersonAvatarCell.h"

@implementation BATPersonAvatarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLabel];
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
        [self addSubview:_avatarImageView];
        
        //设置cell的separator
        [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
        
        [self setupConstraints];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupConstraints
{
    WEAK_SELF(self);
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(120);
    }];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.mas_right).offset(-35);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}


- (void)configrationCell:(BATPerson *)model
{
    _titleLabel.text = @"头像";
    
//    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, model.Data.PhotoPath]] placeholderImage:[UIImage imageNamed:@"portrait_default"]];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.Data.PhotoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
}

@end
