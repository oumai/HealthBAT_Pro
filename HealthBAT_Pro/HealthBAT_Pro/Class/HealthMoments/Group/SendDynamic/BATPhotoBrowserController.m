//
//  BATPhotoBrowser.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2017/1/9.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPhotoBrowserController.h"
#import "SDPhotoBrowser.h"
@interface BATPhotoBrowserController ()
@property float scale_;
@property (nonatomic,strong) UILabel *countLb;
@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,assign) BOOL isMagnify;
@property (nonatomic,strong) UIView *navView;
@end

@implementation BATPhotoBrowserController
@synthesize imageScrollView;
@synthesize scale_;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    
//    self.index = self.index + 1;
    
    self.view.backgroundColor = [UIColor blackColor];
    offset = 0.0;
    scale_ = 1.0;
    
    self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.imageScrollView.backgroundColor = [UIColor clearColor];
    self.imageScrollView.scrollEnabled = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.delegate = self;
    self.imageScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.BrowserPicDataSourceArr.count, 0);
    
    for (int i = 0; i<self.BrowserPicDataSourceArr.count; i++){
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UITapGestureRecognizer *signleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTapAction:)];
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        s.tag = i+1;
        [s setZoomScale:1.0];
        
        UIImageView *imageview = [[UIImageView alloc] init];

        imageview.image = self.BrowserPicDataSourceArr[i];
        //        imageview.frame = [self resizeImageSize:imageview.image];
        imageview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.userInteractionEnabled = YES;
        imageview.tag = i+1;
        [imageview addGestureRecognizer:doubleTap];
        [imageview addGestureRecognizer:signleTap];
        [s addSubview:imageview];
        
        [self.imageScrollView addSubview:s];
    }
    self.imageScrollView.contentOffset = CGPointMake((self.index)*SCREEN_WIDTH, 0);
    [self.view addSubview:self.imageScrollView];
    
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.navView.backgroundColor = BASE_COLOR;
    
    UIImageView *backImg = [[UIImageView alloc]initWithFrame:CGRectMake(8, 35, 10, 20)];
    backImg.image = [UIImage imageNamed:@"back_icon"];
    backImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backAction)];
    [backImg addGestureRecognizer:backTap];
    
    [self.navView addSubview:backImg];
    
    UIImageView *deleImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 29, 29, 25, 25)];
    deleImg.userInteractionEnabled = YES;
    deleImg.image = [UIImage imageNamed:@"icon-delete-white"];
    UITapGestureRecognizer *deleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(delePhoto)];
    [deleImg addGestureRecognizer:deleTap];
    [self.navView addSubview:deleImg];
    
    self.countLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 54)];
    self.countLb.textAlignment = NSTextAlignmentCenter;
    self.countLb.textColor = [UIColor whiteColor];
    self.countLb.text = [NSString stringWithFormat:@"%zd/%zd",self.index+1,self.BrowserPicDataSourceArr.count];
    [self.navView addSubview:self.countLb];

    
    [self.view addSubview:self.navView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.navView.frame = CGRectMake(0, -64, SCREEN_WIDTH, 64);
        }];
    });

}

-(void)delePhoto {
    
    if (self.BrowserPicDataSourceArr.count == 1) {
        [self.BrowserPicDataSourceArr removeObjectAtIndex:0];
        [self.BrowserDynamicImgArray removeObjectAtIndex:0 ];
        [self.BrowserPicAssetArr removeObjectAtIndex:0];
        //NSMutableArray *BrowserPicDataSourceArr,NSMutableArray *BrowserDynamicImgArray,NSMutableArray *BrowserPicAssetArr
        if (self.iSReloadBlock) {
            self.iSReloadBlock(self.BrowserPicDataSourceArr,self.BrowserDynamicImgArray,self.BrowserPicAssetArr);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    if (self.BrowserPicDataSourceArr.count !=1 && self.BrowserPicDataSourceArr.count > 0) {
        
        
        [self.BrowserPicDataSourceArr removeObjectAtIndex:self.index];
        
        if (self.BrowserDynamicImgArray != nil && self.BrowserDynamicImgArray.count>0) {
             [self.BrowserDynamicImgArray removeObjectAtIndex:self.index];
        }
       
        if (self.BrowserPicAssetArr != nil) {
            [self.BrowserPicAssetArr removeObjectAtIndex:self.index];
        }
       
        
        if (self.iSReloadBlock) {
            self.iSReloadBlock(self.BrowserPicDataSourceArr,self.BrowserDynamicImgArray,self.BrowserPicAssetArr);
        }
       
    }
    
    
   

   
    
    [self.imageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i<self.BrowserPicDataSourceArr.count; i++){
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UITapGestureRecognizer *signleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signleTapAction:)];
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        s.tag = i+1;
        [s setZoomScale:1.0];
        
        UIImageView *imageview = [[UIImageView alloc] init];
        
        imageview.image = self.BrowserPicDataSourceArr[i];
        //        imageview.frame = [self resizeImageSize:imageview.image];
        imageview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [imageview setContentMode:UIViewContentModeScaleAspectFit];
        imageview.userInteractionEnabled = YES;
        imageview.tag = i+1;
        [imageview addGestureRecognizer:doubleTap];
        [imageview addGestureRecognizer:signleTap];
        [s addSubview:imageview];
        
        [self.imageScrollView addSubview:s];
    }
    
    if (self.BrowserPicDataSourceArr.count !=0) {
        
        if (self.BrowserPicDataSourceArr.count == self.index) {
            self.index --;
        }
        
        self.countLb.text = [NSString stringWithFormat:@"%zd/%zd",self.index+1,self.BrowserPicDataSourceArr.count];
        
        self.imageScrollView.contentOffset = CGPointMake((self.index)*SCREEN_WIDTH, 0);
        self.imageScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.BrowserPicDataSourceArr.count, 0);
       
       
        
    }else {
        
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.imageScrollView){
        CGFloat x = scrollView.contentOffset.x;
        
        self.index = scrollView.contentOffset.x/SCREEN_WIDTH;
        
        self.countLb.text = [NSString stringWithFormat:@"%zd/%zd",self.index+1,self.BrowserPicDataSourceArr.count];
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in scrollView.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    UIImageView *image = [[s subviews] objectAtIndex:0];
                    image.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }
            }
        }
    }
}

-(void)signleTapAction:(UITapGestureRecognizer *)taper {
    if (!self.isShow) {

            [UIView animateWithDuration:0.3 animations:^{
                self.navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
            }];
        self.isShow = YES;

    }else {

            [UIView animateWithDuration:0.3 animations:^{
                self.navView.frame = CGRectMake(0, -64, SCREEN_WIDTH, 64);
            }];
        self.isShow = NO;

    }
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}



- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"Did zoom!");
    UIView *v = [scrollView.subviews objectAtIndex:0];
    if ([v isKindOfClass:[UIImageView class]]){
        if (scrollView.zoomScale<1.0){
            //         v.center = CGPointMake(scrollView.frame.size.width/2.0, scrollView.frame.size.height/2.0);
        }
    }
}

#pragma mark -
-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = 0.0;
    if (!self.isMagnify) {
       newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 2.0;
        self.isMagnify = YES;
    }else {
        newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 0.5;
        self.isMagnify = NO;
    }
    
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    UIView *view = gesture.view.superview;
    if ([view isKindOfClass:[UIScrollView class]]){
        UIScrollView *s = (UIScrollView *)view;
        [s zoomToRect:zoomRect animated:YES];
    }
}

#pragma mark - Utility methods

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = [scrollView frame].size.height / scale;
    zoomRect.size.width  = [scrollView frame].size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(CGRect)resizeImageSize:(CGRect)rect{
    //    NSLog(@"x:%f y:%f width:%f height:%f ", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    CGRect newRect;
    
    CGSize newSize;
    CGPoint newOri;
    
    CGSize oldSize = rect.size;
    if (oldSize.width>=SCREEN_WIDTH || oldSize.height>=SCREEN_HEIGHT){
        float scale = (oldSize.width/SCREEN_WIDTH>oldSize.height/SCREEN_HEIGHT?oldSize.width/SCREEN_WIDTH:oldSize.height/SCREEN_HEIGHT);
        newSize.width = oldSize.width/scale;
        newSize.height = oldSize.height/scale;
    }
    else {
        newSize = oldSize;
    }
    newOri.x = (SCREEN_WIDTH-newSize.width)/2.0;
    newOri.y = (SCREEN_HEIGHT-newSize.height)/2.0;
    
    newRect.size = newSize;
    newRect.origin = newOri;
    
    return newRect;
}




@end
