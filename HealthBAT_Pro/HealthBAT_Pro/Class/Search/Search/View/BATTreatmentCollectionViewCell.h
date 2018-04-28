//
//  TreatmentCollectionViewCell.h
//  HealthBAT
//
//  Created by KM on 16/8/12016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATTreatmentCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UILabel * nameLabel;
//厂商名字
@property (nonatomic,strong) UILabel * facturerLbel;
@property (nonatomic,strong) UIImageView * treatmentImageView;
@property (nonatomic,strong) UIImageView * shopcarImageView;

@end
