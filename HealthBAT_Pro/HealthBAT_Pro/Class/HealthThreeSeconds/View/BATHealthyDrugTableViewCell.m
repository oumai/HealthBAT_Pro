//
//  BATHealthyDrugTableViewCell.m
//  HealthBAT_Pro
//
//  Created by 黄帆 on 2017/12/18.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATHealthyDrugTableViewCell.h"
#import "BATHealthyAssessModel.h"
@implementation BATHealthyDrugTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)addToBuyCar:(id)sender {
}

- (void)setAssessModel:(BATHealthyAssessModel *)assessModel {
    _assessModel = assessModel;
    
    NSString *imageStr = [NSString stringWithFormat:@"http://img.km1818.com/product%@",assessModel.ReturnData.RecommendProduct.SKU_IMG_PATH];
    

    [_imageV sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    
    _PriceLab.text = [NSString stringWithFormat:@"%ld元", (long)assessModel.ReturnData.RecommendProduct.SALE_UNIT_PRICE];

    _titleLab.text = assessModel.ReturnData.RecommendProduct.PRODUCT_NAME;
    
}
@end
