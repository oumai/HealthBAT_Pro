//
//  BATDieaseDetailCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDieaseDetailCollectionViewCell.h"

//Cell
#import "BATSearchDoctorCell.h"
#import "BATHosptialCell.h"
#import "BATSearchDrugCell.h"

//Model
#import "BATSearchWithTypeModel.h"
#import "BATDefaultView.h"
@interface BATDieaseDetailCollectionViewCell()<UITableViewDelegate,UITableViewDataSource,BATSearchDoctorCellDelegate>

@property (nonatomic,strong) UITableView *dieaseTab;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATDieaseDetailCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame  {

    if (self = [super initWithFrame:frame]) {
        
        WEAK_SELF(self);
        [self.contentView addSubview:self.dieaseTab];
        [self.dieaseTab mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.defaultView];
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            STRONG_SELF(self);
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return self;
}


#pragma mark - BATSearchDoctorCellDelegate
- (void)moveToDoctorInfoDetailActionWith:(NSIndexPath *)indexPath {
  
}

#pragma mark - Setter and Getter
- (void)setModelArray:(NSMutableArray *)modelArray {

    _modelArray = modelArray;
    if (modelArray.count >0) {
        [self.dieaseTab reloadData];
        self.dieaseTab.hidden = NO;
        self.defaultView.hidden = YES;
    }else {
        self.dieaseTab.hidden = YES;
        [self.defaultView showDefaultView];
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SearchWithTypeContent *searchContent = self.modelArray[indexPath.row];
    if ([searchContent.resultType isEqualToString:@"doctor_info"] && searchContent.dataType == 0) {
        BATSearchDoctorCell *doctorCell = [tableView dequeueReusableCellWithIdentifier:@"BATSearchDoctorCell"];
        doctorCell.delegate = self;
        doctorCell.indexPath = indexPath;
        if ([searchContent.titleName isEqualToString:@""]||searchContent.titleName == nil) {
            doctorCell.nameLabel.text = searchContent.resultTitle;
        }else {
            doctorCell.nameLabel.text = [NSString stringWithFormat:@"%@[%@]",searchContent.resultTitle,searchContent.titleName];
        }
//        NSString *holderName = nil;
//        if ([searchContent.sex isEqualToString:@"男"]) {
//            holderName = @"img-nys";
//        }else {
//            holderName = @"img-ysv";
//        }
        
        if (searchContent.dataType == 0) {
            doctorCell.tipsLb.hidden = NO;
        }else {
            doctorCell.tipsLb.hidden = YES;
        }
        
        [doctorCell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.pictureUrl]] placeholderImage:[UIImage imageNamed:@"医生"]];
        doctorCell.departmentLabel.text = searchContent.deptName;
        if ([searchContent.resultDesc isEqualToString:@""]||searchContent.resultDesc == nil) {
            doctorCell.skilfulLabel.text = @"简介:暂无信息";
        }else {
            doctorCell.skilfulLabel.text = [NSString stringWithFormat:@"简介:%@",[searchContent.resultDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        return doctorCell;
    }else if([searchContent.resultType isEqualToString:@"hospital_info"]) {
        
        BATHosptialCell *hospitalCell = [tableView dequeueReusableCellWithIdentifier:@"BATHosptialCell"];
        [hospitalCell.hospitalImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.pictureUrl]] placeholderImage:[UIImage imageNamed:@"默认图"]];
        NSDictionary * nameAttDic = @{NSForegroundColorAttributeName:UIColorFromHEX(0x333333, 1),NSFontAttributeName:[UIFont systemFontOfSize:15]};
        NSDictionary * gradeAttDic = @{NSForegroundColorAttributeName:UIColorFromHEX(0xfc9f26, 1),NSFontAttributeName:[UIFont systemFontOfSize:9]};
        NSMutableAttributedString * name = [[NSMutableAttributedString alloc] initWithString:searchContent.resultTitle attributes:nameAttDic];
        NSInteger level = [searchContent.hospitalLevel integerValue];
        NSString *levelName = nil;
        switch (level) {
            case 1:
                levelName = @"特等医院";
                break;
            case 2:
                levelName = @"三级甲等";
                break;
            case 3:
                levelName = @"三级乙等";
                break;
            case 4:
                levelName = @"三级丙等";
                break;
            case 5:
                levelName = @"二级甲等";
                break;
            case 6:
                levelName = @"二级乙等";
                break;
            case 7:
                levelName = @"二级丙等";
                break;
            case 8:
                levelName = @"一级甲等";
                break;
            case 9:
                levelName = @"一级乙等";
                break;
            case 10:
                levelName = @"一级丙等";
                break;
            case 11:
                levelName = @"其他";
                break;
            default:
                break;
        }
        
        if (searchContent.hospitalLevel.length > 0) {
            NSMutableAttributedString * grade = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[%@]",levelName] attributes:gradeAttDic];
            [name appendAttributedString:grade];
        }
        
        hospitalCell.nameLabel.attributedText = name;
        hospitalCell.titleAddressLabel.text = [NSString stringWithFormat:@"地址:  %@",searchContent.address];
        
        
        if ([searchContent.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            hospitalCell.titlePhoneLabel.text = @"电话:  暂无电话";
        }else {
            hospitalCell.titlePhoneLabel.text = [NSString stringWithFormat:@"电话:  %@",[searchContent.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        return hospitalCell;

    }else if([searchContent.resultType isEqualToString:@"drug_info"]) {
    
        BATSearchDrugCell *treatmentCell = [tableView dequeueReusableCellWithIdentifier:@"BATSearchDrugCell"];
        [treatmentCell.treatmentImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.pictureUrl]] placeholderImage:[UIImage imageNamed:@"默认图"]];
        treatmentCell.nameLabel.text = searchContent.resultTitle;
        treatmentCell.facturerLbel.text = searchContent.manufactorName;
        return treatmentCell;
        
    }else{
        BATSearchDoctorCell *doctorCell = [tableView dequeueReusableCellWithIdentifier:@"BATSearchDoctorCell"];
        doctorCell.delegate = self;
        doctorCell.indexPath = indexPath;
        if ([searchContent.titleName isEqualToString:@""]||searchContent.titleName == nil) {
            doctorCell.nameLabel.text = searchContent.resultTitle;
        }else {
            doctorCell.nameLabel.text = [NSString stringWithFormat:@"%@[%@]",searchContent.resultTitle,searchContent.titleName];
        }
//        NSString *holderName = nil;
//        if ([searchContent.sex isEqualToString:@"男"]) {
//            holderName = @"img-nys";
//        }else {
//            holderName = @"img-ysv";
//        }
        
        if (searchContent.dataType == 0) {
            doctorCell.tipsLb.hidden = NO;
        }else {
            doctorCell.tipsLb.hidden = YES;
        }
        
        [doctorCell.doctorImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",searchContent.pictureUrl]] placeholderImage:[UIImage imageNamed:@"医生"]];
        doctorCell.departmentLabel.text = searchContent.deptName;
        
        if ([searchContent.resultDesc isEqualToString:@""]||searchContent.resultDesc == nil) {
            doctorCell.skilfulLabel.text = @"简介:暂无信息";
        }else {
            doctorCell.skilfulLabel.text = [NSString stringWithFormat:@"简介:%@",[searchContent.resultDesc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        return doctorCell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     SearchWithTypeContent *searchContent = self.modelArray[indexPath.row];
    
    
    
    NSDictionary *dict = @{@"resultId":searchContent.resultId,@"resultTitle":searchContent.resultTitle,@"dataType":@(searchContent.dataType),@"pathName":searchContent.resultTitle,@"type":searchContent.resultType,@"drugSource":searchContent.drugSource};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSHTODEATILCONTROLLER" object:dict];
    
}

#pragma mark - Lazy Load
- (UITableView *)dieaseTab {

    if (!_dieaseTab) {
        _dieaseTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 330) style:UITableViewStylePlain];
        _dieaseTab.delegate = self;
        _dieaseTab.dataSource = self;
        [_dieaseTab registerClass:[BATSearchDoctorCell class] forCellReuseIdentifier:@"BATSearchDoctorCell"];
        [_dieaseTab registerClass:[BATHosptialCell class] forCellReuseIdentifier:@"BATHosptialCell"];
        [_dieaseTab registerClass:[BATSearchDrugCell class] forCellReuseIdentifier:@"BATSearchDrugCell"];
        [_dieaseTab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"123"];
        [_dieaseTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _dieaseTab.scrollEnabled = NO;
    }
    return _dieaseTab;
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        
    }
    return _defaultView;
}

@end
