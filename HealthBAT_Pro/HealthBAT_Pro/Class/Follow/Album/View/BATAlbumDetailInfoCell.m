//
//  BATAlbumDetailInfoCell.m
//  HealthBAT_Pro
//
//  Created by four on 2017/6/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATAlbumDetailInfoCell.h"

@implementation BATAlbumDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self pageLayout];
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
- (void)configData:(BATAlbumDetailModel *)albumDetailModel
{
    
    self.descLabel.numberOfLines = self.isFold ? 0 : 1;
    
    self.titleLabel.text = albumDetailModel.Data.Topic;
    self.descLabel.attributedText = [self changeDesc:albumDetailModel.Data.Description];
    self.playCountLabel.text = [NSString stringWithFormat:@"播放%@",[self changePlayCount:albumDetailModel.Data.ReadingNum]];
}

#pragma mark - 格式化详细
- (NSMutableAttributedString *)changeDesc:(NSString *)string
{
    if (!string) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"暂无简介"];
        return text;
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) text:text];
    text.yy_font = [UIFont systemFontOfSize:15];
    text.yy_color = UIColorFromHEX(0x999999, 1);
    
    if (layout.lines.count > 1) {
        [text yy_appendString:@"\n收起"];
        [text yy_setColor:UIColorFromHEX(0x0182eb, 1) range:NSMakeRange(text.length - 2, 2)];
        
        UIImage *image = [UIImage imageNamed:@"ic-sq"];
        NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:[UIFont systemFontOfSize:15] alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString: attachment];
        
        
        WEAK_SELF(self);
        [text yy_setTextHighlightRange:NSMakeRange(text.length - 2, 2) color:UIColorFromHEX(0x0182eb, 1) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            STRONG_SELF(self);
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
            if (self.foldAction) {
                self.foldAction();
            }
        }];
        
    }
    
    return text;
}

#pragma mark - 格式化播放量
- (NSString *)changePlayCount:(NSInteger)count
{
    if (count >= 100000000) {
        
        NSInteger billion = count / 100000000;
        
        NSInteger ten_million = (count -  billion * 100000000) / 10000000;
        
        return [NSString stringWithFormat:@"%ld.%ld亿",(long)billion,(long)ten_million];
    } else if (count >= 10000) {
        NSInteger million = count / 10000;
        NSInteger thousand = (count -  million * 10000) / 1000;
        return [NSString stringWithFormat:@"%ld.%ld万",(long)million,(long)thousand];
    }
    return [NSString stringWithFormat:@"%ld",(long)count];
}

- (void)collectButtonAction:(UIButton *)button
{
    if (self.collectionAction) {
        self.collectionAction();
    }
}

- (void)shareButtonAction:(UIButton *)button
{
    if (self.shareAction) {
        self.shareAction();
    }
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.playCountLabel];
    [self.contentView addSubview:self.collectButton];
    [self.contentView addSubview:self.shareButton];
    
    WEAK_SELF(self);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.playCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.descLabel.mas_bottom).offset(16);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-19);
    }];
    
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.playCountLabel.mas_centerY);
        make.left.greaterThanOrEqualTo(self.playCountLabel.mas_right).offset(10);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.playCountLabel.mas_centerY);
        make.left.equalTo(self.collectButton.mas_right).offset(30);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0.5 leftOffset:10 rightOffset:10];
}

#pragma mark - get & set
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = UIColorFromHEX(0x333333, 1);
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (YYLabel *)descLabel
{
    if (_descLabel == nil) {
        _descLabel = [[YYLabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:15];
        _descLabel.textColor = UIColorFromHEX(0x999999, 1);
        _descLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30;
        [_descLabel sizeToFit];
        
        NSMutableAttributedString *fold = [[NSMutableAttributedString alloc] initWithString:@"...全文"];
        fold.yy_font = [UIFont systemFontOfSize:15];
        fold.yy_color = UIColorFromHEX(0x0182eb, 1);
        
        WEAK_SELF(self);
        [fold yy_setTextHighlightRange:NSMakeRange(0, fold.length) color:UIColorFromHEX(0x0182eb, 1) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            STRONG_SELF(self);
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
            if (self.foldAction) {
                self.foldAction();
            }
            
        }];
        
        YYLabel *foldLabel = [YYLabel new];
        foldLabel.attributedText = fold;
        [foldLabel sizeToFit];
        
        NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:foldLabel contentMode:UIViewContentModeCenter attachmentSize:foldLabel.frame.size alignToFont:fold.yy_font alignment:YYTextVerticalAlignmentCenter];
        _descLabel.truncationToken = truncationToken;
        
    }
    return _descLabel;
}

- (UILabel *)playCountLabel
{
    if (_playCountLabel == nil) {
        _playCountLabel = [[UILabel alloc] init];
        _playCountLabel.font = [UIFont systemFontOfSize:14];
        _playCountLabel.textColor = UIColorFromHEX(0x666666, 1);
        [_playCountLabel sizeToFit];
    }
    return _playCountLabel;
}

- (UIButton *)collectButton
{
    if (_collectButton == nil) {
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon-sc"] forState:UIControlStateNormal];
        [_collectButton setBackgroundImage:[UIImage imageNamed:@"icon-sc-d"] forState:UIControlStateSelected];
        [_collectButton addTarget:self action:@selector(collectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectButton;
}

- (UIButton *)shareButton
{
    if (_shareButton == nil) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setBackgroundImage:[UIImage imageNamed:@"ic-fx"] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

@end