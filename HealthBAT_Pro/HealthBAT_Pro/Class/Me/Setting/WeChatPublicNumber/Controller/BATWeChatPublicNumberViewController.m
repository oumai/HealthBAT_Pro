//
//  BATWeChatPublicNumberViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/9/24.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATWeChatPublicNumberViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <Photos/Photos.h> 

//相册名字
static NSString *photoAssetCollectionName = @"健康BAT相册";
@interface BATWeChatPublicNumberViewController ()
@end

@implementation BATWeChatPublicNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关注微信公众号";
}

//  获得相簿
-(PHAssetCollection *)createAssetCollection{
    
    //判断是否已存在
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection * assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:photoAssetCollectionName]) {
            //说明已经有哪对象了
            return assetCollection;
        }
    }
    
    //创建新的相簿
    __block NSString *assetCollectionLocalIdentifier = nil;
    NSError *error = nil;
    //同步方法
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:photoAssetCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error)return nil;
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}

- (IBAction)saveQRCodeImage:(id)sender {
    
    /*
     保存图片方式一
    UIImage *qrcodeImage =[UIImage imageNamed:@"weixin_QRC"];
    UIImageWriteToSavedPhotosAlbum(qrcodeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
     */
    
    UIImage *qrcodeImage =[UIImage imageNamed:@"weixin_QRC"];
    __block  NSString *assetLocalIdentifier;
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        
        //1.保存图片到相机胶卷中----创建图片的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:qrcodeImage].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if(success == NO){
            DDLogDebug(@"保存图片失败----(创建图片的请求)");
            return ;
        }
        
        // 2.获得相簿
        PHAssetCollection *createdAssetCollection = [self createAssetCollection];
        if (createdAssetCollection == nil) {
            DDLogDebug(@"保存图片成功----(创建相簿失败!)");
            return;
        }
        
        // 3.将刚刚添加到"相机胶卷"中的图片到"自己创建相簿"中
        [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
            
            //获得图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            //添加图片到相簿中的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            // 添加图片到相簿
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if(success){
                DDLogDebug(@"保存图片到创建的相簿成功");
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            }else{
                DDLogDebug(@"保存图片到创建的相簿失败");
                [SVProgressHUD showErrorWithStatus:@"保存失败"];
            }
        }];
    }];
  
    
}

/*
//保存图片方式1
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{

    NSString *msg = nil ;

    if(error != NULL){

        msg = @"保存图片失败" ;

    }else{

        msg = @"保存图片成功" ;

    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"

                                                    message:msg

                                                   delegate:self

                                          cancelButtonTitle:@"确定"

                                          otherButtonTitles:nil];

    [alert show];
}

*/
- (IBAction)shareQRCodeImage:(UIButton *)sender {
    
    
    OSMessage *msg=[[OSMessage alloc]init];
    msg.title = @"二维码";
    msg.desc = @"二维码";
    msg.image = [UIImage imageNamed:@"weixin_QRC"];
    msg.thumbnail = [UIImage imageNamed:@"Icon-Share"];
//    msg.multimediaType = OSMultimediaTypeNews;
    
    [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
        [self showSuccessWithText:@"分享成功"];

    } Fail:^(OSMessage *message, NSError *error) {
        [self showErrorWithText:@"分享失败"];

    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
