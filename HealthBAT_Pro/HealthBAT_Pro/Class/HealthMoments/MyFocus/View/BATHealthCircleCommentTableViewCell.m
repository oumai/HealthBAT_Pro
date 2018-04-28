//
//  BATHealthCircleCommentTableViewCell.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/24.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHealthCircleCommentTableViewCell.h"

@implementation BATHealthCircleCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _commentLabel.backgroundColor = [UIColor clearColor];
    _commentLabel.numberOfLines = 0;
    _commentLabel.textAlignment = NSTextAlignmentLeft;
    _commentLabel.font = [UIFont systemFontOfSize:12];
    
    YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
    mod.fixedLineHeight = 15.0f;
    _commentLabel.linePositionModifier = mod;
    
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)confirgationCell:(BATComments *)model
{
    NSMutableAttributedString *comment = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",model.UserName,model.CommentContent]];
    
    NSRange hightRange;
    hightRange.location = 0;
    hightRange.length = model.UserName.length;
    
    [comment setYy_font:[UIFont systemFontOfSize:12]];
    [comment yy_setColor:UIColorFromRGB(48, 153, 251, 1) range:hightRange];
    [comment yy_setColor:UIColorFromRGB(103, 103, 103, 1) range:NSMakeRange(hightRange.length + hightRange.location, comment.length - hightRange.length)];
//    [comment yy_setColor:UIColorFromHEX(0X666666, 1) range:hightRange];
//    [comment yy_setColor:UIColorFromHEX(0X666666, 1) range:NSMakeRange(hightRange.length + hightRange.location, comment.length - hightRange.length)];
    
    WEAK_SELF(self);
    [comment yy_setTextHighlightRange:hightRange color:nil backgroundColor:[UIColor grayColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        STRONG_SELF(self);
        if (self.clickUser) {
            self.clickUser(_indexPath);
        }
    }];

    
    _commentLabel.attributedText = comment;
}


@end
