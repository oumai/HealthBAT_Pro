//
//  ChooseTreatmentCell.m
//  TableViewTest
//
//  Created by kmcompany on 16/9/23.
//  Copyright © 2016年 sword. All rights reserved.
//

#import "ChooseTreatmentCell.h"
#import "ChooseTreatmentModel.h"

@interface ChooseTreatmentCell()
@property (nonatomic,strong) UIImageView *chooseIcon;
@property (nonatomic,strong) UILabel *nameLb;
@property (nonatomic,strong) UILabel *relateshipLb;
@property (nonatomic,strong) UILabel *phoneNumberLb;
@property (nonatomic,strong) UILabel *personID;
@property (nonatomic,strong) UISwitch *isDefaultPerson;
@property (nonatomic,strong) UILabel *DefaultLb;
@property (nonatomic,strong) UILabel *editBtn;
@property (nonatomic,strong) UILabel *deletBtn;

@property (nonatomic,strong) UILabel *shownameLb;
@property (nonatomic,strong) UILabel *showrelateshipLb;
@property (nonatomic,strong) UILabel *showphoneNumberLb;
@property (nonatomic,strong) UILabel *showpersonID;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIImageView *editImg;
@property (nonatomic,strong) UIImageView *deleteImg;

@property (nonatomic,strong) UIButton  *deletClearBtn;
@property (nonatomic,strong) UIButton *editClearBtn;;


@end
@implementation ChooseTreatmentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isCanSelect:(BOOL)isCanSelect{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAK_SELF(self)
        
        if (isCanSelect) {
            
            [self.contentView addSubview:self.chooseIcon];
            [self.chooseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self)
                make.left.equalTo(self.contentView).offset(15);
                make.top.equalTo(self.contentView.mas_top).offset(40);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            
            [self.contentView addSubview:self.phoneNumberLb];
            [self.phoneNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self)
                make.left.equalTo(self.chooseIcon.mas_right).offset(10);
                make.centerY.equalTo(self.chooseIcon.mas_centerY);
            }];
            
        }else {
            
            [self.contentView addSubview:self.phoneNumberLb];
            [self.phoneNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
                STRONG_SELF(self)
                make.left.equalTo(self.contentView).offset(15);
                make.top.equalTo(self.contentView.mas_top).offset(40);
            }];
            
        }
        
        
        
        [self.contentView addSubview:self.nameLb];
        [self.nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self)
            make.left.equalTo(self.phoneNumberLb.mas_left);
            make.bottom.equalTo(self.phoneNumberLb.mas_top).offset(-12.5);
        }];
        
        [self.contentView addSubview:self.personID];
        [self.personID mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.top.equalTo(self.phoneNumberLb.mas_bottom).offset(12.5);
            make.left.equalTo(self.phoneNumberLb.mas_left);
        }];
        
        [self.contentView addSubview:self.shownameLb];
        [self.shownameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLb.mas_right).offset(10);
            make.centerY.equalTo(self.nameLb.mas_centerY);
        }];
        
        [self.contentView addSubview:self.relateshipLb];
        [self.relateshipLb mas_makeConstraints:^(MASConstraintMaker *make) {
           STRONG_SELF(self)
            make.centerY.equalTo(self.nameLb.mas_centerY);
            make.left.equalTo(self.shownameLb.mas_right).offset(100);
            
        }];
        
        [self.contentView addSubview:self.showphoneNumberLb];
        [self.showphoneNumberLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneNumberLb.mas_right).offset(10);
            make.centerY.equalTo(self.phoneNumberLb.mas_centerY);
        }];
        
        [self.contentView addSubview:self.showpersonID];
        [self.showpersonID mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.personID.mas_right).offset(10);
            make.centerY.equalTo(self.personID.mas_centerY);
        }];
        
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(0);
            make.right.equalTo(self.contentView.mas_right).offset(0);
            make.top.equalTo(self.personID.mas_bottom).offset(17);
            make.height.equalTo(@1);
        }];
        
        [self.contentView addSubview:self.isDefaultPerson];
        [self.isDefaultPerson mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.lineView.mas_bottom).offset(7);
            make.size.mas_equalTo(CGSizeMake(51, 31));
        }];
        
        [self.contentView addSubview:self.DefaultLb];
        [self.DefaultLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.isDefaultPerson.mas_right).offset(15);
            make.centerY.equalTo(self.isDefaultPerson.mas_centerY);
        }];
        
        [self.contentView addSubview:self.deletBtn];
        [self.deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.centerY.equalTo(self.isDefaultPerson.mas_centerY);
        }];
        
        [self.contentView addSubview:self.deleteImg];
        [self.deleteImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.deletBtn.mas_left).offset(-10);
            make.centerY.equalTo(self.isDefaultPerson.mas_centerY);
         }];
        
        [self.contentView addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.deleteImg.mas_left).offset(-22);
            make.centerY.equalTo(self.isDefaultPerson.mas_centerY);
        }];
        
        [self.contentView addSubview:self.editImg];
        [self.editImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.editBtn.mas_left).offset(-10);
            make.centerY.equalTo(self.isDefaultPerson.mas_centerY);
        }];
        
        [self.contentView addSubview:self.showrelateshipLb];
        [self.showrelateshipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.relateshipLb.mas_right).offset(10);
            make.centerY.equalTo(self.relateshipLb.mas_centerY);
        }];
        
        [self.contentView addSubview:self.editClearBtn];
        [self.editClearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.editImg.mas_left).offset(0);
            make.right.equalTo(self.editBtn.mas_right).offset(0);
            make.height.equalTo(@45);
            make.centerY.equalTo(self.isDefaultPerson.mas_centerY);
        }];
        
        [self.contentView addSubview:self.deletClearBtn];
        [self.deletClearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.deleteImg.mas_left).offset(0);
            make.right.equalTo(self.deletBtn.mas_right).offset(0);
            make.height.equalTo(@45);
            make.centerY.equalTo(self.isDefaultPerson.mas_centerY);
        }];
    }
    return self;
}

-(void)cellConfigWithModel:(ChooseTreatmentModel *)model {
    self.shownameLb.text = model.name;
    self.showrelateshipLb.text = model.relateship;
    self.showphoneNumberLb.text = model.phoneNumber;
    self.showpersonID.text = model.personID;
    
    if (model.isSelect) {
        self.chooseIcon.image = [UIImage imageNamed:@"ic-multableSelectHigh"];
    }else {
        self.chooseIcon.image = [UIImage imageNamed:@"ic-multableSelect"];
    }
    
    if (model.isDefault) {
        [self.isDefaultPerson setOn:YES];
    }else {
        [self.isDefaultPerson setOn:NO];
    }
    
    if (model.CommPersonID) {
        if ([model.memberID isEqualToString:model.CommPersonID]) {
            self.chooseIcon.image = [UIImage imageNamed:@"ic-multableSelectHigh"];
            model.isSelect = YES;
        }
    }
}

#pragma mark - ActionDelegate

-(void)changeState {
    if ([self.delegate respondsToSelector:@selector(ChooseTreatmentCellDefaultActionWithRow:)]) {
        [self.delegate ChooseTreatmentCellDefaultActionWithRow:self.rowPath];
    }
}

//-(void)changeSelectState {
//    if ([self.delegate respondsToSelector:@selector(ChooseTreatmentCellSelectActionWithRow:)]) {
//        [self.delegate ChooseTreatmentCellSelectActionWithRow:self.rowPath];
//    }
//}

-(void)editAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ChooseTreatmentCellEditActionWithRow:)]) {
        [self.delegate ChooseTreatmentCellEditActionWithRow:self.rowPath];
    }
}

-(void)deleteAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(ChooseTreatmentCellDeleteActionWithRow:)]) {
        [self.delegate ChooseTreatmentCellDeleteActionWithRow:self.rowPath];
    }
}

#pragma mark - SETTER - GETTER
-(UIImageView *)chooseIcon {
    if (!_chooseIcon) {
        _chooseIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic-multableSelect"]];
        _chooseIcon.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeSelectState)];
//        [_chooseIcon addGestureRecognizer:tap];
    }
    return _chooseIcon;
}

-(UILabel *)nameLb {
    if (!_nameLb) {
        _nameLb = [[UILabel alloc]init];
        _nameLb.text = @"姓名:";
        _nameLb.textColor = UIColorFromHEX(0X666666, 1);
        _nameLb.font = [UIFont systemFontOfSize:14];
    }
    return _nameLb;
}

-(UILabel *)relateshipLb {
    if (!_relateshipLb) {
        _relateshipLb = [[UILabel alloc]init];
        _relateshipLb.text = @"关系:";
        _relateshipLb.textColor = UIColorFromHEX(0X666666, 1);
        _relateshipLb.font = [UIFont systemFontOfSize:14];
    }
    return _relateshipLb;
}

-(UILabel *)phoneNumberLb {
    if (!_phoneNumberLb) {
        _phoneNumberLb = [[UILabel alloc]init];
        _phoneNumberLb.text = @"手机号:";
        _phoneNumberLb.textColor = UIColorFromHEX(0X666666, 1);
        _phoneNumberLb.font = [UIFont systemFontOfSize:14];
    }
    return _phoneNumberLb;
}

-(UILabel *)personID {
    if (!_personID) {
        _personID = [[UILabel alloc]init];
        _personID.text = @"身份证:";
        _personID.textColor = UIColorFromHEX(0X666666, 1);
        _personID.font = [UIFont systemFontOfSize:14];
    }
    return _personID;
}

-(UILabel *)shownameLb {
    if (!_shownameLb) {
        _shownameLb = [[UILabel alloc]init];
        _shownameLb.textColor = UIColorFromHEX(0X333333, 1);
        _shownameLb.font = [UIFont systemFontOfSize:14];
    }
    return _shownameLb;
}

-(UILabel *)showrelateshipLb {
    if (!_showrelateshipLb) {
        _showrelateshipLb = [[UILabel alloc]init];
        _showrelateshipLb.textColor = UIColorFromHEX(0X333333, 1);
        _showrelateshipLb.font = [UIFont systemFontOfSize:14];
    }
    return _showrelateshipLb;
}

-(UILabel *)showphoneNumberLb {
    if (!_showphoneNumberLb) {
        _showphoneNumberLb = [[UILabel alloc]init];
        _showphoneNumberLb.textColor = UIColorFromHEX(0X333333, 1);
        _showphoneNumberLb.font = [UIFont systemFontOfSize:14];
    }
    return _showphoneNumberLb;
}

-(UILabel *)showpersonID {
    if (!_showpersonID) {
        _showpersonID = [[UILabel alloc]init];
        _showpersonID.textColor = UIColorFromHEX(0X333333, 1);
        _showpersonID.font = [UIFont systemFontOfSize:14];
    }
    return _showpersonID;
}

-(UISwitch *)isDefaultPerson {
    if (!_isDefaultPerson) {
        _isDefaultPerson = [[UISwitch alloc]init];
        [_isDefaultPerson addTarget:self action:@selector(changeState) forControlEvents:UIControlEventValueChanged];
      //  _isDefaultPerson.tintColor = UIColorFromHEX(0Xfc9f26, 1);
        _isDefaultPerson.tintColor = UIColorFromHEX(0Xe6e6e6, 1);
        _isDefaultPerson.onTintColor = UIColorFromHEX(0Xfc9f26, 1);
    }
    return _isDefaultPerson;
}

-(UILabel *)DefaultLb {
    if (!_DefaultLb) {
        _DefaultLb = [UILabel new];
        _DefaultLb.text = @"默认成员";
        _DefaultLb.textColor = UIColorFromHEX(0X666666, 1);
        _DefaultLb.font = [UIFont systemFontOfSize:12];
    }
    return _DefaultLb;
}

-(UILabel *)editBtn {
    if (!_editBtn) {
        _editBtn = [UILabel new];
        _editBtn.text = @"编辑";
        _editBtn.textColor = UIColorFromHEX(0X666666, 1);
        _editBtn.font = [UIFont systemFontOfSize:12];
    }
    return _editBtn;
}

-(UILabel *)deletBtn {
    if (!_deletBtn) {
        _deletBtn = [UILabel new];
        _deletBtn.text = @"删除";
        _deletBtn.textColor = UIColorFromHEX(0X666666, 1);
        _deletBtn.font = [UIFont systemFontOfSize:12];
    }
    return _deletBtn;
}

-(UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    }
    return _lineView;
}

-(UIImageView *)editImg {
    if (!_editImg) {
        _editImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic-edit"]];
    }
    return _editImg;
}

-(UIImageView *)deleteImg {
    if (!_deleteImg) {
        _deleteImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic-delete"]];
    }
    return _deleteImg;
}

-(UIButton *)editClearBtn {
    if (!_editClearBtn) {
        _editClearBtn = [UIButton new];
        [_editClearBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editClearBtn;
}

-(UIButton *)deletClearBtn {
    if (!_deletClearBtn) {
        _deletClearBtn = [UIButton new];
        [_deletClearBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletClearBtn;
}

@end
