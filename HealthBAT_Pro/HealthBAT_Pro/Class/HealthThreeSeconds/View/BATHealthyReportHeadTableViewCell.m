//
//  BATHealthyReportHeadTableViewCell.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/16.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthyReportHeadTableViewCell.h"
#import "BATHealthyAssessModel.h"
@implementation BATHealthyReportHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    //先试试富文本
    NSString *str = @"85";
//    NSString *str1 = @"分";
    

    //有数据了还要重新写
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.priceLab.text];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:25.0f]
                    range:NSMakeRange(0, str.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor orangeColor]
                    range:NSMakeRange(0, str.length)];

   
    self.priceLab.attributedText = attrStr;
    
    
    _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAssessModel:(BATHealthyAssessModel *)assessModel {
    _assessModel = assessModel;
    
    NSString *score = [NSString stringWithFormat:@"%ld", (long)assessModel.ReturnData.TotalScore];
    NSString *feng = @"分";
    NSString *str = [NSString stringWithFormat:@"%@%@", score, feng];
    _priceLab.text = str;
    //有数据了还要重新写
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.priceLab.text];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:25.0f]
                    range:NSMakeRange(0, score.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor orangeColor]
                    range:NSMakeRange(0, score.length)];
    self.priceLab.attributedText = attrStr;
    
    _dateLab.text = [NSString stringWithFormat:@"(%@)", [self dateConverStr]];
   
    _FatIndexLab.text = [NSString stringWithFormat:@"体重指数：%.1f）",  assessModel.ReturnData.BMI];
    _FatIndexLab.attributedText = [self updeteOurBigWithTitle:@"体重指数：" andContent:[NSString stringWithFormat:@"%.1f",  assessModel.ReturnData.BMI]];
    
    
    NSString *strL = @"属于：";
    _lab.text = [NSString stringWithFormat:@"%@%@",strL, assessModel.ReturnData.BMIStatus];
    
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:_lab.text];
    [attrStr1 addAttribute:NSForegroundColorAttributeName
                    value:RGB(245, 99, 65)
                    range:NSMakeRange(strL.length, assessModel.ReturnData.BMIStatus.length)];
    [attrStr1 addAttribute:NSForegroundColorAttributeName
                     value:RGB(102, 102, 102)
                     range:NSMakeRange(0, strL.length)];
    
    
    self.lab.attributedText = attrStr1;
    
    
    
    
}
- (NSString *)dateConverStr{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return  [formatter stringFromDate:date];
}

//富文本
- (NSMutableAttributedString *)updeteOurBigWithTitle:(NSString *)title andContent:(NSString *)content {
    
    NSString *strL = title;
    NSString *totalStr = [NSString stringWithFormat:@"%@%@",strL, content];
    NSMutableAttributedString *attrStr1 = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [attrStr1 addAttribute:NSForegroundColorAttributeName
                     value:RGB(102, 102, 102)
                     range:NSMakeRange(0 ,title.length)];
    return attrStr1;
}
- (IBAction)cellInfoBtn:(id)sender {
    if (self.infoButtonBlock) {
        
        self.infoButtonBlock();
    }
}
- (void)setDateStr:(NSString *)dateStr {
    _dateStr = dateStr;
     _dateLab.text = [NSString stringWithFormat:@"(%@)", _dateStr];
}
@end
