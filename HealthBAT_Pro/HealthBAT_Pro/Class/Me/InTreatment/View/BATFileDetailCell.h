//
//  BATFileDetailCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATFileDetailCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UILabel *detailLb;
@end



@interface BATFileDetailTextFiledCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLb;
@property (nonatomic,strong) UITextField *detailFiled;
@end
