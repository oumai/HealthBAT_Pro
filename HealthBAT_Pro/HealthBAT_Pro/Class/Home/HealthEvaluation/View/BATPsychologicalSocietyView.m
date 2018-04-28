//
//  BATPsychologicalSocietyView.m
//  HealthBAT_Pro
//
//  Created by cjl on 2017/9/13.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPsychologicalSocietyView.h"
#import "BATGetUserStatus.h"
@interface BATPsychologicalSocietyView()

@property (nonatomic, strong) BATGetUserStatus *needStatus;

@end

@implementation BATPsychologicalSocietyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    [self addSubview:self.contentLabel];
    WEAK_SELF(self);
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(20, 10, 20, 10));
    }];
}

#pragma mark - get & set
- (UILabel *)contentLabel
{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.font = [UIFont systemFontOfSize:15];
//        _contentLabel.textColor = UIColorFromHEX(0xffffff, 1);
        _contentLabel.numberOfLines = 0;
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"心理建议：建议您继续保持良好的生活习惯，如注意科学饮食，作息规律，适度运动等，定期到医院做体检。同时，经常检查自身的心理压力水平，及时处理累积的紧张焦虑等不良情绪，防止这些心理因素躯体化，即表现为各种身体不适感。\n\n社会建议：您能够很好地适应现实环境，建议您继续保持同社会的正常接触，对社会现实保持清晰的认识，能够根据环境的变化以及所处环境对自己的要求，来调整自己的心理和行为，能够保持面对现实、接受现实、适应现实和改造现实"];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;
        
        
        
        if (iPhone5 || iPhone4) {
            [string addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:15 * scaleValue],NSForegroundColorAttributeName:UIColorFromHEX([self returnWeekColor], 1)} range:NSMakeRange(0, string.length)];
        } else {
            [string addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromHEX([self returnWeekColor], 1)} range:NSMakeRange(0, string.length)];
        }
        
        
        _contentLabel.attributedText = string;
    }
    return _contentLabel;
}
- (int)returnWeekColor {  //关于Week颜色
    
    int colorX = 0x509AB7; // - > 默认浅蓝
    if (self.needStatus.userStatus == cyanStatus) {
        colorX = 0x4296a3; // - > 青色
    } else if (self.needStatus.userStatus == greenStatus) {
        colorX = 0x509AB7; // - > 默认浅蓝
    } else if(self.needStatus.userStatus == pinkStatus){
        colorX = 0xF6595C; // - > 粉色
    } else { //蓝色
        colorX = 0xFFFFFF; // - > 白色
    }
    return colorX;
    
}

- (BATGetUserStatus *)needStatus {
    
    if (!_needStatus) {
        
        _needStatus = [[BATGetUserStatus alloc] init];
    }
    return _needStatus;
    
}
- (void)setHelpStrig:(NSString *)helpStrig {

    _helpStrig = helpStrig;
    
     NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"心理建议：建议您继续保持良好的生活习惯，如注意科学饮食，作息规律，适度运动等，定期到医院做体检。同时，经常检查自身的心理压力水平，及时处理累积的紧张焦虑等不良情绪，防止这些心理因素躯体化，即表现为各种身体不适感。\n\n社会建议：您能够很好地适应现实环境，建议您继续保持同社会的正常接触，对社会现实保持清晰的认识，能够根据环境的变化以及所处环境对自己的要求，来调整自己的心理和行为，能够保持面对现实、接受现实、适应现实和改造现实"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    
    
    
    if (iPhone5 || iPhone4) {
        [string addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:15 * scaleValue],NSForegroundColorAttributeName:UIColorFromHEX([self returnWeekColor], 1)} range:NSMakeRange(0, string.length)];
    } else {
        [string addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromHEX([self returnWeekColor], 1)} range:NSMakeRange(0, string.length)];
    }
    
    
    _contentLabel.attributedText = string;
}
//暂时封印
//- (void)setModel:(BATHealthEvalutionModel *)model {
//
//    _model = model;
//
//    NSString *str = _model.ReturnData.PsychologyResult.AppBehaviorSuggestion;
//
//    //
//    _contentLabel.text = str;
//
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
//
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 5;
//    if (iPhone5 || iPhone4) {
//        [string addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:15 * scaleValue],NSForegroundColorAttributeName:UIColorFromHEX([self returnWeekColor], 1)} range:NSMakeRange(0, string.length)];
//    } else {
//        [string addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColorFromHEX([self returnWeekColor], 1)} range:NSMakeRange(0, string.length)];
//    }
//    _contentLabel.attributedText = string;
//}
@end
