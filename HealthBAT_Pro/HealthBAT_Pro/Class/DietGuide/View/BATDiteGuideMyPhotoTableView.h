//
//  BATDiteGuideMyPhotoTableView.h
//  HealthBAT_Pro
//
//  Created by Carbon on 2017/10/30.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BATDiteGuideMyPhotoModel.h"
@class BATDiteGuideMyPhotoTableView;
@protocol BATDiteGuideMyPhotoTableViewDelegate <NSObject>
- (void)diteGuideMyPhotoTableView:(BATDiteGuideMyPhotoTableView *)photoView didSelectedPhotoDataModel:(BATDiteGuideMyPhotoDataModel *)photoDataModel;
- (void)diteGuideMyPhotoTableViewHeaderRefresh:(BATDiteGuideMyPhotoTableView *)photoView;
- (void)diteGuideMyPhotoTableViewfooterUploadMore:(BATDiteGuideMyPhotoTableView *)photoView;
@end

@interface BATDiteGuideMyPhotoTableView : UITableView
@property (nonatomic ,weak)     id<BATDiteGuideMyPhotoTableViewDelegate> bat_Delegate;
- (instancetype)initWithStyle:(UITableViewStyle)style;
- (void)setDataWithMyPhotoDataModelArray:(NSArray<BATDiteGuideMyPhotoDataModel *> *)myPhotoDataModelArray;
@end
