//
//  BATSectionOneCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/8.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATSectionOneCell.h"
#import "BATCustomButton.h"
@interface BATSectionOneCell()

@property (nonatomic,strong) BATCustomButton *moreBtn;

@end

@implementation BATSectionOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        WEAK_SELF(self);
        
        [self.contentView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.contentView.mas_top).offset(20);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            
        }];
        
        [self.contentView addSubview:self.contentLb];
        [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.top.equalTo(self.titleLb.mas_bottom).offset(20);
             make.right.equalTo(self.contentView.mas_right).offset(-10);
            
        }];
        
        [self.contentView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            STRONG_SELF(self);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.contentLb.mas_bottom).offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.size.mas_equalTo(CGSizeMake(100, 40));
            
        }];
    }
    return self;

}

- (void)setContentString:(NSString *)contentString {

    _contentString = contentString;
    
//    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]
//                                                  initWithData:[contentString dataUsingEncoding:NSUTF8StringEncoding]
//                                                  options:@{NSFontAttributeName :[UIFont systemFontOfSize:14]}
//                                                  documentAttributes:nil error:nil];
//    
//    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14]
//                            range:NSMakeRange(0, contentString.length)];
//    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle1 setLineSpacing:10];
//    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1
//                            range:NSMakeRange(0, [contentString length])];
    
    _contentLb.text = [self filterHTML:contentString];
}

-(NSString *)getZZwithString:(NSString *)string{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    string=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}

#pragma mark - Lazy Load
- (UILabel *)titleLb {

    if (!_titleLb) {
        _titleLb = [[UILabel alloc]init];
        _titleLb.font  = [UIFont systemFontOfSize:15];
        _titleLb.textColor = UIColorFromHEX(0X333333, 1);
        _titleLb.text = @"疾病百科";
        [_titleLb sizeToFit];
    }
    return _titleLb;
}

- (UILabel *)contentLb {

    if (!_contentLb) {
        _contentLb = [[UILabel alloc]init];
        _contentLb.font = [UIFont systemFontOfSize:14];
        _contentLb.textColor = UIColorFromHEX(0X666666, 1);
        _contentLb.numberOfLines = 4;
    }
    return _contentLb;
}

- (BATCustomButton *)moreBtn {

    if (!_moreBtn) {
        _moreBtn = [[BATCustomButton alloc]init];
        _moreBtn.userInteractionEnabled = NO;
        [_moreBtn setImage:[UIImage imageNamed:@"icon_arrow_right"] forState:UIControlStateNormal];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        _moreBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _moreBtn.titleRect = CGRectMake(47, 10, 40, 30);
        _moreBtn.imageRect = CGRectMake(92, 22, 7.5, 7.5);
       // [_moreBtn addTarget:self action:@selector(pushToDetailVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

//- (void)pushToDetailVC {
//
//    if (self.dieaseBlock) {
//        self.dieaseBlock();
//    }
//}

@end
