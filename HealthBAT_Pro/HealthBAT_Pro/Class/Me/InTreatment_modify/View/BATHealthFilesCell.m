//
//  BATManagePatientCell.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/6/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthFilesCell.h"
#import "UIColor+HNExtensions.h"
#define KHexColor(stringColor) [UIColor colorForHexString:stringColor]

@implementation BATHealthFilesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = KHexColor(@"#ebebeb");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cellView = [UIView new];
        self.cellView.backgroundColor = KHexColor(@"#ffffff");
        [self.contentView addSubview:_cellView];
        
        
        [_cellView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(0);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(0);
            
        }];
        
        
        self.switchOn = [UISwitch new];
        self.switchOn.on = YES;
        [self.switchOn addTarget:self action:@selector(switchOnClick:) forControlEvents:UIControlEventValueChanged];
        [self.cellView addSubview:_switchOn];
        
        
        [_switchOn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellView.mas_top).offset(10);
            make.left.equalTo(self.cellView.mas_left).offset(10);
            make.width.equalTo(@51);
            make.height.equalTo(@31);
        }];

        
        self.defaultLabel = [UILabel new];
        self.defaultLabel.font = [UIFont systemFontOfSize:14];
        self.defaultLabel.textColor = KHexColor(@"#999999");
        self.defaultLabel.text = [NSString stringWithFormat:@"默认就诊人"];
        [self.cellView addSubview:_defaultLabel];
        
        
        [_defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.switchOn.mas_bottom).offset(0);
            make.left.equalTo(self.switchOn.mas_right).offset(10);
            make.width.equalTo(self.defaultLabel.mas_width);
            make.height.equalTo(self.defaultLabel.mas_height);
        }];

        
        self.titleLabel = [TTTAttributedLabel new];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = KHexColor(@"#666666");
        [self.contentView addSubview:_titleLabel];
        
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.defaultLabel.mas_bottom).offset(0);
            make.left.equalTo(self.cellView.mas_centerX).offset(0);
            make.width.equalTo(self.titleLabel.mas_width);
            make.height.equalTo(self.titleLabel.mas_height);
        }];
        
       
        
      
        
        self.sexLabel = [UILabel new];
        self.sexLabel.font = [UIFont systemFontOfSize:14];
        self.sexLabel.textColor = KHexColor(@"#999999");
        [self.contentView addSubview:_sexLabel];
        
        
        [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.cellView.mas_centerY).offset(-5);
            make.left.equalTo(self.cellView.mas_left).offset(10);
            make.width.equalTo(self.sexLabel.mas_width);
            make.height.equalTo(@14);
        }];
        
        
        self.ageLabel = [UILabel new];
        self.ageLabel.font = [UIFont systemFontOfSize:14];
        self.ageLabel.textColor = KHexColor(@"#999999");
        [self.contentView addSubview:_ageLabel];
        
        
        [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cellView.mas_centerY).offset(5);
            make.left.equalTo(self.cellView.mas_left).offset(10);
            make.width.equalTo(self.ageLabel.mas_width);
            make.height.equalTo(@14);
        }];


        
        self.numberLabel = [UILabel new];
        self.numberLabel.font = [UIFont systemFontOfSize:14];
        self.numberLabel.textColor = KHexColor(@"#999999");
        [self.contentView addSubview:_numberLabel];
        
        
        [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.ageLabel.mas_bottom).offset(10);
            make.left.equalTo(self.cellView.mas_left).offset(10);
            make.width.equalTo(self.ageLabel.mas_width);
            make.height.equalTo(@14);
        }];
        
        
      
    }
    return self;
}

- (void)switchOnClick:(id)sender
{
    
    if (self.switchBlock) {
        self.switchBlock(self,self.path);
    }
    
}

- (void)setModel:(ChooseTreatmentModel *)model
{
    if (nil == model) {
        
        return;
    }
    NSLog(@"model.ages = %ld,model.Sex = %@",(long)model.age,model.Sex);
    
    //self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",model.name,model.relateship];
    
    
    
    [self.titleLabel setText:model.name afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        NSAttributedString *yuan = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",model.relateship]
                                                                   attributes:@{NSForegroundColorAttributeName : KHexColor(@"#999999"),
                                                                                NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        [mutableAttributedString appendAttributedString:yuan];
        return mutableAttributedString;
    }];

    
    NSString *sexString = @"";
    if (model.Gender == 0) {
        sexString = @"男";
    }
    else if (model.Gender ==1) {
        sexString = @"女";
    }
    else  {
        sexString = @"未知";
    }
    
    self.sexLabel.text = [NSString stringWithFormat:@"性别：%@",sexString];
    self.ageLabel.text = [NSString stringWithFormat:@"年龄：%ld",(long)model.age];
    if ([model.phoneNumber length] == 11) {
        self.numberLabel.text = [NSString stringWithFormat:@"手机号码：%@****%@",[model.phoneNumber substringToIndex:3],[model.phoneNumber substringFromIndex:7]];
    }
    
    if (model.isDefault) {
        [self.switchOn setOn:YES];
    }else {
        [self.switchOn setOn:NO];
    }

}
@end
