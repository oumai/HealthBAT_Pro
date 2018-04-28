//
//  BATBATTrainStudioCourseDetailInfoCell.h
//  HealthBAT_Pro
//
//  Created by four on 17/4/1.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
#import "BATTrainStudioCourseDetailModel.h"

typedef void(^FoldAction)(void);

@interface BATBATTrainStudioCourseDetailInfoCell : UITableViewCell

/**
 标题
 */
@property (nonatomic,strong) UILabel *titleLabel;

/**
 详细
 */
@property (nonatomic,strong) YYLabel *descLabel;

/**
 是否展开
 */
@property (nonatomic,assign) BOOL isFold;

/**
 展开收起Block
 */
@property (nonatomic,strong) FoldAction foldAction;

- (void)configData:(BATTrainStudioCourseDetailModel *)courseDetailModel;

//@property (nonatomic,strong) UILabel *introduceLabel;
//
//@property (nonatomic,strong) UIView *lineView;
//
///**
// 标题
// */
//@property (nonatomic,strong) UILabel *titleLabel;
//
///**
// 详细
// */
//@property (nonatomic,strong) UILabel *descLabel;
//
///**
// 评论
// */
//@property (nonatomic,strong) UILabel *commentLabel;
//
///**
// 评论个数
// */
//@property (nonatomic,strong) UILabel *commentNumberLabel;
//
//- (void)configData:(BATTrainStudioCourseDetailModel *)courseDetailModel withCommentNumber:(NSInteger )commentNumber;

@end
