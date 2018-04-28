//
//  addTreatmentCell.m
//  TableViewTest
//
//  Created by kmcompany on 16/9/23.
//  Copyright © 2016年 sword. All rights reserved.
//

#import "addTreatmentCell.h"
@interface addTreatmentCell()
@property (nonatomic,strong) UILabel *addLb;
@end
@implementation addTreatmentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.addLb];
        [self.addLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView).offset(0);
            make.height.equalTo(@45);
        }];
    }
    return self;
}

-(UILabel *)addLb {
    if (!_addLb) {
        _addLb = [[UILabel alloc]init];
        _addLb.textColor = UIColorFromHEX(0Xfc9f26, 1);
        _addLb.font = [UIFont systemFontOfSize:15];
        _addLb.text = @"+ 添加就诊人";
        _addLb.textAlignment = NSTextAlignmentCenter;
    }
    return _addLb;
}

@end
