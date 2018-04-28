//
//  BATSearchDoctorCell.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/5/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BATSearchDoctorCellDelegate<NSObject>
-(void)moveToDoctorInfoDetailActionWith:(NSIndexPath *)indexPath;
@end
@interface BATSearchDoctorCell : UITableViewCell

@property (nonatomic,strong) UIImageView * doctorImageView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * departmentLabel;
@property (nonatomic,strong) UILabel * skilfulLabel;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) UILabel *tipsLb;

@property (nonatomic,weak) id <BATSearchDoctorCellDelegate>delegate;

@end
