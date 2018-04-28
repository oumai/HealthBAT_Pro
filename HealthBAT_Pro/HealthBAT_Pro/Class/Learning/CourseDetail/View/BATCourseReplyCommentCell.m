//
//  BATCourseReplyCommentCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/2/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCourseReplyCommentCell.h"

@implementation BATCourseReplyCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        
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

- (void)confirgationCell:(BATCourseCommentData *)model
{
    
    NSMutableAttributedString *comment = nil;
    if (model.ReplyAccountName.length > 0) {
        comment = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@回复%@：%@",model.AccountName,model.ReplyAccountName,model.Body]];
        [comment setYy_font:[UIFont systemFontOfSize:12]];
        comment.yy_color = UIColorFromHEX(0x666666, 1);
        [comment yy_setColor:UIColorFromHEX(0x0182eb, 1) range:NSMakeRange(0, model.AccountName.length)];
        [comment yy_setColor:UIColorFromHEX(0x0182eb, 1) range:NSMakeRange(model.AccountName.length + 2, model.ReplyAccountName.length)];
    } else {
        comment = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",model.AccountName,model.Body]];
        [comment setYy_font:[UIFont systemFontOfSize:12]];
        comment.yy_color = UIColorFromHEX(0x666666, 1);
        [comment yy_setColor:UIColorFromHEX(0x0182eb, 1) range:NSMakeRange(0, model.AccountName.length)];
    }
    
//    WEAK_SELF(self);
//    [comment yy_setTextHighlightRange:hightRange color:nil backgroundColor:[UIColor grayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        STRONG_SELF(self);
//        if (self.clickUser) {
//            self.clickUser(_indexPath);
//        }
//    }];
    
    
    _commentLabel.attributedText = comment;
}

#pragma mark - pageLayout
- (void)pageLayout
{
    [self.contentView addSubview:self.commentLabel];
    
    WEAK_SELF(self);
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.right.equalTo(self.contentView.mas_right).offset(8);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark - get & set
- (YYLabel *)commentLabel
{
    if (_commentLabel == nil) {
        _commentLabel = [[YYLabel alloc] init];
        _commentLabel.backgroundColor = [UIColor clearColor];
        _commentLabel.numberOfLines = 0;
        _commentLabel.textAlignment = NSTextAlignmentLeft;
        
        YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
        mod.fixedLineHeight = 15.0f;
        _commentLabel.linePositionModifier = mod;
    }
    return _commentLabel;
}

@end
