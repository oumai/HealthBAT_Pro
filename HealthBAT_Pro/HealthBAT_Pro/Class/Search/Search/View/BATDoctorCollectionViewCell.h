//
//  DoctorCollectionViewCell.h
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BATDoctorCollectionViewCellDelegate<NSObject>
-(void)moveToDoctorInfoDetailActionWith:(NSIndexPath *)indexPath;
@end
@interface BATDoctorCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView * doctorImageView;
@property (nonatomic,strong) UILabel * nameLabel;
@property (nonatomic,strong) UILabel * departmentLabel;
@property (nonatomic,strong) UILabel * skilfulLabel;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) UILabel *tipsLb;

@property (nonatomic,weak) id <BATDoctorCollectionViewCellDelegate>delegate;

@end
