//
//  BATGroupDecsView.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/30.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGroupDecsView.h"
#import "BATGroupDetailModel.h"

@implementation BATGroupDecsView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _groupIconImageView.layer.cornerRadius = _groupIconImageView.frame.size.height / 2;
    _groupIconImageView.layer.masksToBounds = YES;
    
    _joinGroupButton.hidden = YES;
    
    
    [_groupMemberButton setTitleColor:UIColorFromRGB(103, 103, 103, 1) forState:UIControlStateNormal];
    
    //设置cell的separator
    [self setBottomBorderWithColor:BASE_LINECOLOR width:SCREEN_WIDTH height:0];
}

#pragma mark - Action

#pragma mark - 加入群组
- (IBAction)joinGroupAction:(id)sender {

    if (_delegate && [_delegate respondsToSelector:@selector(groupDecsView:joinGroupButtonClicked:)]) {
        [_delegate groupDecsView:self joinGroupButtonClicked:sender];
    }
    
}

#pragma mark - 查看群成员
- (IBAction)groupMemberAction:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(groupDecsView:groupMemberButtonClicked:)]) {
        [_delegate groupDecsView:self groupMemberButtonClicked:sender];
    }
    
}

#pragma mark - 加载数据
- (void)configrationData:(id)model
{
    
    BATGroupDetailModel *groupDetailModel = (BATGroupDetailModel *)model;
    
    //群组头像
    [_groupIconImageView sd_setImageWithURL:[NSURL URLWithString:groupDetailModel.Data.GroupIcon] placeholderImage:[UIImage imageNamed:@"默认图"]];
    
    //群组名称
    _groupNameLabel.text = groupDetailModel.Data.GroupName;
    
    //群组描述
    _groupDescLabel.text = groupDetailModel.Data.Description;
    
    //群组成员
//    NSString *memberCount = [NSString stringWithFormat:@"群成员：%ld/%ld",(long)groupDetailModel.Data.MemberCount,(long)groupDetailModel.Data.GroupTotal];
    NSString *memberCount = [NSString stringWithFormat:@"群成员：%ld",(long)groupDetailModel.Data.MemberCount];
    
    NSMutableAttributedString *attributedMemberCount = [[NSMutableAttributedString alloc] initWithString:memberCount];
    
    [attributedMemberCount addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(103, 103, 103, 1),NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, memberCount.length - 1)];
    
    NSRange range = [memberCount rangeOfString:[NSString stringWithFormat:@"%ld",(long)groupDetailModel.Data.MemberCount]];
    
    
    [attributedMemberCount addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(230, 29, 53, 1) range:range];
    
    [_groupMemberButton setAttributedTitle:attributedMemberCount forState:UIControlStateNormal];
    
    //加入群组按钮
    _joinGroupButton.hidden = groupDetailModel.Data.IsJoined;

}


@end
