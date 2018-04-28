//
//  BATPhotoPickerSeeBigPictureViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPhotoPickerSeeBigPictureViewController.h"
@interface BATPhotoPickerSeeBigPictureViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIScrollView *bgScrollView;
@end
@implementation BATPhotoPickerSeeBigPictureViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}
- (void)setupUI{
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, 20, 50, 50);
    [closeBtn setImage:[UIImage imageNamed:@"DietGuide_CloseBigPhoto"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismissSeeBigPictureController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    // 滚动控件
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.delegate = self;
    [self.view insertSubview:scrollView atIndex:0];
    
    // 图片
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.image = self.image;
    [scrollView addSubview:imageView];
    
    // 图片的尺寸
    imageView.x = 0;
    imageView.width = SCREEN_WIDTH;
    imageView.height = self.image.size.height * imageView.width / self.image.size.width;
    if (imageView.height > SCREEN_HEIGHT) { // 图片过长
        imageView.y = 0;
        scrollView.contentSize = CGSizeMake(0, imageView.height);
    } else { // 图片居中显示
        imageView.centerY = SCREEN_HEIGHT * 0.5;
    }
    
    // 伸缩
    CGFloat maxScale = self.image.size.height / imageView.height;
    if (maxScale > 1.0) {
        scrollView.maximumZoomScale = maxScale;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissSeeBigPictureController)];
    [imageView addGestureRecognizer:tap];
    [scrollView addGestureRecognizer:tap];
}

- (void)dismissSeeBigPictureController{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
