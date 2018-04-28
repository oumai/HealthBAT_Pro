//
//  BATPhotoView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/3/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPhotoView.h"
#import "SDPhotoBrowser.h"
#import "BATInvitationModel.h"
#define itemWidth (SCREEN_WIDTH - 60.0f - 20.0f - 2 * 5) / 3
#define itemHeight itemWidth

@interface BATPhotoView()<SDPhotoBrowserDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation BATPhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
         _dataSource = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Action

- (void)loadImageData:(NSArray *)imageArray
{
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    [_dataSource removeAllObjects];
    
    [_dataSource addObjectsFromArray:imageArray];
    
    
    CGFloat imageWidth = _dataSource.count == 1 ? 120 : itemWidth;
    CGFloat imageHeight = imageWidth;
    
    CGFloat margin = 5;
    
    WEAK_SELF(self);
    [_dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        STRONG_SELF(self);
        
        long columnIndex = idx % 3;
        long rowIndex = idx / 3;
        
        InvitationDataImage *imgs = obj;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(columnIndex * (imageWidth + margin), rowIndex * (imageHeight + margin), imageWidth, imageHeight)];
        
    
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgs.ImageUrl] placeholderImage:[UIImage imageNamed:@"icon_pictures_default"]];
      
        
        imageView.userInteractionEnabled = YES;
        imageView.tag = idx;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        
    }];
    
}

#pragma mark - 图片点击
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = _dataSource.count;
    browser.delegate = self;
    [browser show];
    
    [[Tools getCurrentVC].view endEditing:YES];
    
}


#pragma mark - SDPhotoBrowserDelegate

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    InvitationDataImage *imgs = _dataSource[index];
    
    
   return [NSURL URLWithString:imgs.ImageUrl];

    
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}


@end
