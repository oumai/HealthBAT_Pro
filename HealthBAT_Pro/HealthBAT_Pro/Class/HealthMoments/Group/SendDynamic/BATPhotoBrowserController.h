//
//  BATPhotoBrowser.h
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/1/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//


typedef void(^reloadBlock)(NSMutableArray *BrowserPicDataSourceArr,NSMutableArray *BrowserDynamicImgArray,NSMutableArray *BrowserPicAssetArr);
#import <UIKit/UIKit.h>
@interface BATPhotoBrowserController : UIViewController<UIScrollViewDelegate>{
    CGFloat offset;
}

@property (nonatomic,strong)  NSMutableArray *BrowserPicAssetArr;
@property (nonatomic,strong) NSMutableArray *BrowserPicDataSourceArr;
@property (nonatomic,strong) NSMutableArray *BrowserDynamicImgArray;
@property (nonatomic,strong) reloadBlock iSReloadBlock;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic, retain) UIScrollView *imageScrollView;
-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center;
@end
