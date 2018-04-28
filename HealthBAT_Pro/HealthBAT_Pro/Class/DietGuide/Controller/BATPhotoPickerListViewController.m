//
//  BATPhotoPickerListViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATPhotoPickerListViewController.h"
#import <Photos/Photos.h>
#import "BATDiteGuideEditViewController.h"
#import "BATPhotoPickerSeeBigPictureViewController.h"
#import "BATPhotoPickerListCell.h"
#import "BATDiteGuideBottomSegementView.h"
#import "BATPhotoPickerListTopView.h"
#import "UIImage+Zoom.h"
#import "UIViewController+Message.h"
#import "BATPhotoPickHelper.h"


#define kItemSzie CGSizeMake((SCREEN_WIDTH-5*5)/4, (SCREEN_WIDTH-5*5)/4)

static NSString *const  PhotoCellID = @"BATPhotoPickerListCell";

@interface BATPhotoPickerListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray<PHAsset *> *assetDataSource;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BATPhotoPickerListTopView *topView;
@property (nonatomic, strong) BATDiteGuideBottomSegementView *bottomSegementView;
@property (nonatomic, assign) NSInteger  selectIndex;
@property (nonatomic, strong) UIImage *topBigImage;
@property (nonatomic, strong) NSMutableArray *dataSouce;
@end

@implementation BATPhotoPickerListViewController
- (void)dealloc{
    
    NSLog(@"====BATPhotoPickerListViewController====");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNav];
    [self setupUI];
    
    //请求授权获取数据
    [self requestAuthorization];

}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.bottom.mas_equalTo(self.bottomSegementView.mas_top);
    }];
    
    [self.bottomSegementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.equalTo(@40);
    }];
}
#pragma mark - 请求授权获取数据
- (void)requestAuthorization{

    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized) return;
        
        //耗时操作
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            
            self.dataSouce = [self getAllPhotos];
            
            //回到主线程刷新 UI
            dispatch_async(dispatch_get_main_queue(), ^{

                [self.collectionView reloadData];
                [self getOriginImageWith:[self.assetDataSource firstObject]];
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            });
            
        });
    }];
    
    
}
- (void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomSegementView];
    
}
#pragma mark - 设置导航栏
- (void)setupNav{
    
    self.title = @"选择图片";
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame =CGRectMake(0, 0, 30, 30);
    [nextButton setImage:[UIImage imageNamed:@"DietGuide_Continue_Word_Nav"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nextButtonItem = [[UIBarButtonItem alloc]initWithCustomView:nextButton];
    self.navigationItem.rightBarButtonItem = nextButtonItem;
}
//点击继续调用
- (void)nextButtonItemClick{
    
    BATDiteGuideEditViewController *editVC = [[BATDiteGuideEditViewController alloc]init];
    editVC.image = self.topView.imageView.image;
    editVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editVC animated:YES];
    
  //  NSLog(@"点击了照相机按钮");
}
#pragma mark - 查看大图
- (void)seeBigPicture{
    
    BATPhotoPickerSeeBigPictureViewController *seeBigPictureVc = [[BATPhotoPickerSeeBigPictureViewController alloc]init];
    seeBigPictureVc.image = self.topView.imageView.image;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:seeBigPictureVc animated:YES completion:nil];
    
}

#pragma mark - UITabelViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSouce.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BATPhotoPickerListCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellID forIndexPath:indexPath];
    photoCell.imageView.image = self.dataSouce[indexPath.row];
    return photoCell;
    
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5); //上、左、下、右
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self getOriginImageWith:self.assetDataSource[indexPath.row]];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeZero;
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

#pragma mark - 获取所有缩略图片
/**
 resizeMode：对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
 deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。这个属性只有在 synchronous 为 true 时有效。
 targetSize : 即你想要的图片尺寸，若想要原尺寸则可输入PHImageManagerMaximumSize
 */

- (NSMutableArray *)getAllPhotos{
   
      // 测试发现，如果scale在plus真机上取到3.0，内存会增大特别多。故这里写死成2.0
  CGFloat  screenScale = 2;
    if (SCREEN_WIDTH > 700) {
        screenScale = 1.5;
    }
    CGSize  targetSize = CGSizeMake(kItemSzie.width * screenScale, kItemSzie.width * screenScale);
    
    NSMutableArray *photosDataSource = [NSMutableArray array];
    // 所有智能相册
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
     [self showProgressWithText:@"正在加载..."];
    for (PHAssetCollection *collection in smartAlbums) {
        
        if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
        if (collection.assetCollectionSubtype != PHAssetCollectionSubtypeSmartAlbumUserLibrary)
            continue;
        if ([collection.localizedTitle containsString:@"Hidden"] || [collection.localizedTitle isEqualToString:@"已隐藏"]) continue;
        if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"])
            continue;
       // NSLog(@"%@====",collection.localizedTitle);
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        if (fetchResult.count < 1) continue;
            for (PHAsset *asset in fetchResult) {
                //去除非照片
                if (asset.mediaType != PHAssetMediaTypeImage) continue;
                //保存所有的asset
                [self.assetDataSource addObject:asset];
        
                PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
                opt.deliveryMode =  PHImageRequestOptionsDeliveryModeOpportunistic;
                opt.resizeMode = PHImageRequestOptionsResizeModeNone;
                opt.synchronous = true;
                PHImageManager *imageManager = [[PHImageManager alloc] init];
                [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if (result) {
                        
                        [photosDataSource addObject:result];
                    }
                }];
        
            }
    }
    [self dismissProgress];
    
    return photosDataSource;
}
- (BOOL)isCameraRollAlbum:(id)metadata {
    if ([metadata isKindOfClass:[PHAssetCollection class]]) {
        NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
        if (versionStr.length <= 1) {
            versionStr = [versionStr stringByAppendingString:@"00"];
        } else if (versionStr.length <= 2) {
            versionStr = [versionStr stringByAppendingString:@"0"];
        }
        CGFloat version = versionStr.floatValue;
        // 目前已知8.0.0 ~ 8.0.2系统，拍照后的图片会保存在最近添加中
        if (version >= 800 && version <= 802) {
            return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded;
        } else {
            return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
        }
    }
    
    
    return NO;
}
#pragma mark - 获取原图
- (void)getOriginImageWith:(PHAsset *)asset{
    
    WeakSelf
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;
    //防止是iCloud中图片
    imageOptions.networkAccessAllowed = YES;
    imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    imageOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeDefault options:imageOptions resultHandler:^(UIImage * _Nullable originImage, NSDictionary * _Nullable info) {
        weakSelf.topView.imageView.image = originImage;
        
    }];
    
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//     NSLog(@"%@-------=======",info);
    // 选取完图片后跳转回原控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 从info中将图片取出，并加载到imageView当中
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.topView.imageView.image = image;
    
    // 创建保存图像时需要传入的选择器对象（回调方法格式固定）
    SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
    // 将图像保存到相册（第三个参数需要传入上面格式的选择器对象）
    UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
    
}
// 保存图片后到相册后，回调的相关方法，查看是否保存成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil){
        NSLog(@"%@-------=======",contextInfo);
        //保存照片成功后重新加载数据
        
    } else {
        NSLog(@"保存照片失败");
    }
}

#pragma mark - lazy load
- (BATPhotoPickerListTopView *)topView{
    if (!_topView) {
        _topView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BATPhotoPickerListTopView class]) owner:nil options:nil].lastObject;
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(seeBigPicture)];
        [_topView addGestureRecognizer:tap];
        
    }
    return _topView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing      = 5;
        layout.itemSize = kItemSzie;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BATPhotoPickerListCell class]) bundle:nil] forCellWithReuseIdentifier:PhotoCellID];
        
    }
    return _collectionView;
}

- (BATDiteGuideBottomSegementView *)bottomSegementView{
    if (!_bottomSegementView) {
        
        _bottomSegementView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BATDiteGuideBottomSegementView class]) owner:nil options:nil]lastObject];
        _bottomSegementView.backgroundColor = [UIColor whiteColor];
        _bottomSegementView.frame = CGRectMake(0,SCREEN_HEIGHT-40-64, SCREEN_WIDTH, 40);
        [_bottomSegementView.leftButton setImage:[UIImage imageNamed:@"DietGuide_Photos_Word_Segment_Sel"] forState:UIControlStateSelected];
        [_bottomSegementView.leftButton setImage:[UIImage imageNamed:@"DietGuide_Photos_Word_Segment_Sel"] forState:UIControlStateNormal];
        
//        [_bottomSegementView.rightButton setImage:[UIImage imageNamed:@"DietGuide_camera_Word_Segment_Sel"] forState:UIControlStateSelected];
        [_bottomSegementView.rightButton setImage:[UIImage imageNamed:@"DietGuide_camera_Word_Segment_Nor"] forState:UIControlStateNormal];
        
        
        _bottomSegementView.leftButtonBlock = ^(UIButton *leftButton, UIButton *rightButton) {
            NSLog(@"点击了相册");
            leftButton.selected = YES;
            rightButton.selected = NO;
        };
        
        WeakSelf
        _bottomSegementView.rightButtonBlock = ^(UIButton *rightButton, UIButton *leftButton) {
            rightButton.selected = YES;
            leftButton.selected = NO;
            NSLog(@"点击了相机");
            if (![BATPhotoPickHelper checkCameraAuthorizationStatus]) {
                return;
            }
            UIImagePickerController *pickerVc = [[UIImagePickerController alloc]init];
            pickerVc.delegate = weakSelf;
            pickerVc.sourceType =  UIImagePickerControllerSourceTypeCamera;
            [weakSelf presentViewController:pickerVc animated:YES completion:nil];
        };
    }
    return _bottomSegementView;
}
- (NSMutableArray *)dataSouce{
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray array];
    }
    return _dataSouce;
}
- (NSMutableArray <PHAsset *>*)assetDataSource{
    if (!_assetDataSource) {
        _assetDataSource = [NSMutableArray array];
    }
    return _assetDataSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
