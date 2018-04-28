//
//  BATPersonContentCell.m
//  CancerNeighbour
//
//  Created by Wilson on 15/10/28.
//  Copyright © 2015年 KM. All rights reserved.
//

#import "BATPersonContentCell.h"
#import "BATLoginModel.h"

@implementation BATPersonContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = UIColorFromRGB(51, 51, 51,1);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];

        _contentLabel = [[UILabel alloc] init];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.textColor = UIColorFromRGB(153, 153, 153,1);
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [_contentLabel sizeToFit];
        [self addSubview:_contentLabel];

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
        make.width.mas_equalTo(80);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.right.equalTo(self.mas_right).offset(-35);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(_titleLabel.mas_right).offset(10);
    }];
}

- (void)configrationCell:(NSIndexPath *)indexPath Model:(BATPerson *)model {
    
    

    switch (indexPath.row) {
        case 1:
            //手机号
            _titleLabel.text = @"手机号";
            _contentLabel.text = model.Data.PhoneNumber;
            break;
        case 2:
            //昵称
            _titleLabel.text = @"昵称";
            _contentLabel.text = model.Data.UserName;
            break;
        case 3:
            //性别
            _titleLabel.text = @"性别";
            if ([model.Data.Sex isEqualToString:@"0"]) {
                _contentLabel.text = @"女性";
            }
            else {
                _contentLabel.text = @"男性";
            }
            break;
        //去掉 已往病史、过敏史、家族遗传病
//        case 4:
//            //过往病史
//            _titleLabel.text = @"已往病史";
//            _contentLabel.text =([model.Data.Anamnese isEqualToString:@""] || model.Data.Anamnese==nil )?@"无已往病史":model.Data.Anamnese;
//            break;
//        case 5:
//            //体重
//            _titleLabel.text = @"过敏史";
//            _contentLabel.text = ([model.Data.Allergies isEqualToString:@""] || model.Data.Allergies==nil)?@"无过敏史":model.Data.Allergies;;
//            break;
//        case 6:
//            //家族遗传病
//            _titleLabel.text = @"家族遗传病";
//            _contentLabel.text = ([model.Data.GeneticDisease isEqualToString:@""] || model.Data.GeneticDisease==nil)?@"无家族遗传病":model.Data.GeneticDisease;
//            break;
        case 4:
            //昵称
            _titleLabel.text = @"出生日期";
//            _contentLabel.text = nil;
            _contentLabel.text = [model.Data.Birthday substringToIndex:10];
            break;
        case 5:
            //个性签名
            _titleLabel.text = @"个性签名";
            _contentLabel.text = ([model.Data.Signature isEqualToString:@""] || model.Data.Signature==nil)?@"这家伙很懒，什么都没留下":model.Data.Signature;
            break;
        default:
            break;
    }
    
//    switch (indexPath.row) {
//        case 1: {
//            //账号
//            _titleLabel.text = @"账号";
//            
//            BATLoginModel *loginModel = LOGIN_INFO;
//            
//            _contentLabel.text = loginModel.Data.AccountName;
////            self.accessoryType = UITableViewCellAccessoryNone;
//        }
//            break;
//        case 2:
//            //昵称
//            _titleLabel.text = @"昵称";
//            _contentLabel.text = model.Data.UserName;
//            break;
//        case 3:
//            //手机
//            _titleLabel.text = @"电话号码";
//            _contentLabel.text = model.Data.PhoneNumber;
////            self.accessoryType = UITableViewCellAccessoryNone;
//            break;
//        case 4:
//            //性别
//            _titleLabel.text = @"性别";
//            if ([model.Data.Sex isEqualToString:@"0"]) {
//                _contentLabel.text = @"男性";
//            }
//            else {
//                _contentLabel.text = @"女性";
//            }
//            break;
//        case 5:
//            //出生日期
//            _titleLabel.text = @"出生日期";
//            _contentLabel.text = [model.Data.Birthday substringToIndex:10];
//            break;
//        case 6:
//            //身高
//            _titleLabel.text = @"身高";
//            _contentLabel.text = [NSString stringWithFormat:@"%ld",(long)model.Data.Height];
//            break;
//        case 7:
//            //体重
//            _titleLabel.text = @"体重";
//            _contentLabel.text = [NSString stringWithFormat:@"%ld",(long)model.Data.Weight];
//            break;
//        case 8:
//            //籍贯
//            _titleLabel.text = @"籍贯";
//            _contentLabel.text = [NSString stringWithFormat:@"%@%@",model.Data.NativeProvince,model.Data.NativeCity];
//            break;
//        case 9:
//            //常住地区
//            _titleLabel.text = @"常住地区";
//            _contentLabel.text = [NSString stringWithFormat:@"%@%@",model.Data.Province,model.Data.City];
//            break;
//        case 10:
//            //过往病史
//            _titleLabel.text = @"过往病史";
//            _contentLabel.text = model.Data.Anamnese;
//            break;
//        case 11:
//            //体重
//            _titleLabel.text = @"过敏史";
//            _contentLabel.text = model.Data.Allergies;
//            break;
//        case 12:
//            //家族遗传病
//            _titleLabel.text = @"家族遗传病";
//            _contentLabel.text = model.Data.GeneticDisease;
//            break;
//        case 13:
//            //个性签名
//            _titleLabel.text = @"个性签名";
//            _contentLabel.text = model.Data.Signature;
//            break;
//        default:
//            break;
//    }
    
//    if ([_contentLabel.text containsString:@"null"]) {
//        _contentLabel.text = @"";
//    }
    
}


@end
