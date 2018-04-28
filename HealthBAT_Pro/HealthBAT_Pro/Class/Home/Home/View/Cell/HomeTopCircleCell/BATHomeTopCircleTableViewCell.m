//
//  BATTopCircleCollectionViewCell.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/192016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeTopCircleTableViewCell.h"

@implementation BATHomeTopCircleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.circlePictureView];
        [self.circlePictureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {

    if (self.TopPicClick) {
        self.TopPicClick(index);
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index  {

}

#pragma mark - getter

- (SDCycleScrollView *)circlePictureView {
    if (!_circlePictureView) {
        _circlePictureView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"home_default_img"]];
        _circlePictureView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _circlePictureView.showPageControl = YES;
        _circlePictureView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _circlePictureView.pageDotColor = [UIColor lightGrayColor];
        _circlePictureView.currentPageDotColor = START_COLOR;
        _circlePictureView.autoScrollTimeInterval = 15.0f;
    }
    return _circlePictureView;
}
@end
