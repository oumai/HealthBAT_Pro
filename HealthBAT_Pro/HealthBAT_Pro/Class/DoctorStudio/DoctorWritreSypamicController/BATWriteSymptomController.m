//
//  BATSendDynamicViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATWriteSymptomController.h"
#import "BATWriteTextViewTableViewCell.h"
#import "BATAddPicTableViewCell.h"
#import "TZImagePickerController.h"
#import "BATSelectLocationViewController.h"
//#import <CoreLocation/CoreLocation.h>
#import "BATUploadImageModel.h"
#import "TZImageManager.h"
#import "BATPhotoBrowserController.h"
#import "BATTopicTitleCell.h"

//#import "BATPayViewController.h"
#import "BATNewPayViewController.h"

#import "BATDoctorStudioCreateOrderModel.h"

#import "BATGraditorButton.h"

@interface BATWriteSymptomController () <UITableViewDelegate,UITableViewDataSource,YYTextViewDelegate,BATAddPicTableViewCellDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/**
 *
 */
@property (nonatomic,strong) UIBarButtonItem *sendBarButtonItem;

/**
 *  图片数组
 */
@property (nonatomic,strong) NSMutableArray *picDataSource;

/**
 *  图片asset信息数据源
 */
@property (nonatomic,strong) NSMutableArray *picAsset;

/**
 *  待上传的图片数组URL
 */
@property (nonatomic,strong) NSMutableArray *dynamicImgArray;

/**
 *  输入的动态内容
 */
@property (nonatomic,strong) NSString *dynamicContent;


/**
 *  地址
 */
@property (nonatomic,strong) NSString *address;

/**
 *  动态类型
 */
@property (nonatomic,assign) BATGroupDetailDynamicOpration groupDetailDynamicOpration;


/**
 临时数据
 */
@property (nonatomic,strong) NSMutableArray *tempPicArray;

@property (nonatomic,assign) BOOL isCommit;

@property (nonatomic,strong) BATGraditorButton *clickBtn;

@end

@implementation BATWriteSymptomController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _sendDynamicView.tableView.delegate = nil;
    _sendDynamicView.tableView.dataSource = nil;
}

- (BOOL)navigationShouldPopOnBackButton {
    
    if (_dynamicContent.length !=0) {
        WEAK_SELF(self);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定退出编辑?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            STRONG_SELF(self);
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }];
        
        [alertController addAction:otherAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

- (void)loadView
{
    [super loadView];
    
    if (_sendDynamicView == nil) {
        _sendDynamicView = [[BATSendDynamicView alloc] init];
        _sendDynamicView.tableView.delegate = self;
        _sendDynamicView.tableView.dataSource = self;
        _sendDynamicView.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [self.view addSubview:_sendDynamicView];
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
        self.clickBtn = [[BATGraditorButton alloc]initWithFrame:CGRectMake(20, 30, SCREEN_WIDTH - 40, 40)];
//        self.clickBtn.enabled = NO;
//        self.clickBtn.backgroundColor = UIColorFromHEX(0X999999 , 1);
        [self.clickBtn setGradientColors:@[START_COLOR,END_COLOR]];
        self.clickBtn.enablehollowOut = YES;
//        [self.clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.clickBtn.titleColor = [UIColor whiteColor];
        [self.clickBtn setTitle:@"提交" forState:UIControlStateNormal];
        self.clickBtn.clipsToBounds = YES;
        self.clickBtn.layer.cornerRadius = 5;
        [self.clickBtn addTarget:self action:@selector(requestSendGroupsDynamic) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:self.clickBtn];
        
        _sendDynamicView.tableView.tableFooterView = footView;
        
        WEAK_SELF(self);
        [_sendDynamicView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
    
//    WEAK_SELF(self);
//    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"发布" style:UIBarButtonItemStyleDone handler:^(id sender) {
//        STRONG_SELF(self);
//        [self requestSendGroupsDynamic];
//    }];
    
//    [sendBarButtonItem setTintColor:BASE_COLOR];
    
//    self.navigationItem.rightBarButtonItem = sendBarButtonItem;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@的工作室",self.doctorName];
    _picDataSource = [NSMutableArray array];
    _tempPicArray = [NSMutableArray array];
    _dynamicImgArray = [NSMutableArray array];
    
    _groupDetailDynamicOpration = BATGroupDetailDynamicOprationDynamic;
    _address = @"";
    [_sendDynamicView.tableView registerClass:[BATWriteTextViewTableViewCell class] forCellReuseIdentifier:@"BATWriteTextViewTableViewCell"];
    [_sendDynamicView.tableView registerClass:[BATAddPicTableViewCell class] forCellReuseIdentifier:@"BATAddPicTableViewCell"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   if(indexPath.row == 0) {
        return 125;
    } else {
        
        NSInteger picCount = _picDataSource.count < 9 ? _picDataSource.count + 1 : _picDataSource.count;
        
        if (picCount <= 4) {
            return ItemWidth + 30;
        } else if (picCount <= 8) {
            return 2 * ItemWidth + 10 + 30;
        } else {
            return 3 * ItemWidth + 20 + 30;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //    if (section == 0) {
    //        return 0;
    //    }
    //    return 10;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (indexPath.row == 0) {
        BATWriteTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATWriteTextViewTableViewCell" forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.textView.placeholderText = @"请详细描述您的身体情况、病情和症状,让医生准确的了解您的身体情况。(最少20个字符)";
        cell.textView.text = _dynamicContent;
        cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/600",(unsigned long)_dynamicContent.length];
    
        return cell;
    }else {
        
        BATAddPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAddPicTableViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.messageLabel.text = @"病症部位、检查报告或者其他病情资料";
        [cell reloadCollectionViewData:_picDataSource];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView
{
     if(textView.tag == 1) {
        BATWriteTextViewTableViewCell *cell = [_sendDynamicView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        

            if (textView.text.length > 600) {
                [self showText:@"最多输入600个字"];
                textView.text = [textView.text substringToIndex:600];
            }

        
        _dynamicContent = textView.text;
        

        cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/600",(unsigned long)_dynamicContent.length];
         
         if (textView.text.length == 0) {
             self.clickBtn.enabled = NO;
             self.clickBtn.backgroundColor = UIColorFromHEX(0X999999, 1);
         }else {
             self.clickBtn.enabled = YES;
             self.clickBtn.backgroundColor = BASE_COLOR;
         }
        
    }
    
}


#pragma mark - BATAddPicTableViewCellDelegate
- (void)collectionViewItemClicked:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == _picDataSource.count) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        
        WEAK_SELF(self);
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF(self);
            [self getPhotosFromCamera];
        }];
        
        UIAlertAction *photoGalleryAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            STRONG_SELF(self);
            [self getPhotosFromLocal];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:cameraAction];
        [alertController addAction:photoGalleryAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        [self deletePic:indexPath];
        
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [[info objectForKey:UIImagePickerControllerEditedImage] copy];
    
    [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error) {
        if (!error) {
            [_tempPicArray removeAllObjects];
            [_tempPicArray addObject:image];
            [self requestUpdateImages];
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

#pragma mark - Action

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    WEAK_SELF(self);
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:(9 - _picDataSource.count) delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;
    if (_picDataSource.count > 0) {
        tzImagePickerVC.selectedAssets = _picAsset;
    }
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        STRONG_SELF(self);

        [_tempPicArray removeAllObjects];
        if (photos.count > 0) {
            for (UIImage *image in photos) {
                //对图片进行压缩处理
                if (!isSelectOriginalPhoto) {
                    UIImage *imageCompress = [Tools compressImageWithImage:image ScalePercent:0.05];
                    [_tempPicArray addObject:imageCompress];
                } else {
                    [_tempPicArray addObject:image];
                }
            }
            
            [self requestUpdateImages];
        }
        
    }];
    
    [self presentViewController:tzImagePickerVC animated:YES completion:nil];
    
}

#pragma mark - 从相机中获取图片
- (void)getPhotosFromCamera
{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
    
    switch (AVstatus) {
        case AVAuthorizationStatusAuthorized:
            DDLogDebug(@"Authorized");
            break;
        case AVAuthorizationStatusDenied:
        {
            DDLogDebug(@"Denied");
            //提示开启相机
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"相机权限已关闭" message:@"请到设置->隐私->相机开启权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
                
                return ;
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
            break;
        case AVAuthorizationStatusNotDetermined:
            DDLogDebug(@"not Determined");
            break;
        case AVAuthorizationStatusRestricted:
            DDLogDebug(@"Restricted");
            break;
        default:
            break;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else {
        NSLog(@"模拟器中无法打开相机，请在真机中使用");
    }
}

#pragma mark 删除图片11
- (void)deletePic:(NSIndexPath *)indexPath
{
    
    //设置容器视图,父视图
    BATPhotoBrowserController *browserVC = [[BATPhotoBrowserController alloc]init];
    browserVC.BrowserPicAssetArr = _picAsset;
    browserVC.BrowserPicDataSourceArr = _picDataSource;
    browserVC.BrowserDynamicImgArray = _dynamicImgArray;
    browserVC.index = indexPath.item;
    browserVC.iSReloadBlock = ^(NSMutableArray *BrowserPicDataSourceArr,NSMutableArray *BrowserDynamicImgArray,NSMutableArray *BrowserPicAssetArr) {
        [_sendDynamicView.tableView reloadData];
    };
    [self.navigationController pushViewController:browserVC animated:YES];
    
}





#pragma mark - NET

#pragma mark - 批量上传图片
- (void)requestUpdateImages
{
    [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(XMRequest *request) {
        
        // 将本地的文件上传至服务器
        for (int i = 0; i < [_tempPicArray count]; i++) {
            UIImage *image = [_tempPicArray objectAtIndex:i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            [request addFormDataWithName:[NSString stringWithFormat:@"dynamic_picture%d",i]
                                fileName:[NSString stringWithFormat:@"dynamic_picture%d.jpg",i]
                                mimeType:@"multipart/form-data"
                                fileData:imageData];
        }
    } success:^(NSArray *imageArray) {
        
        [self dismissProgress];
        
        DDLogDebug(@"imageArray %@",imageArray);
        [_picDataSource addObjectsFromArray:_tempPicArray];
        [_dynamicImgArray addObjectsFromArray:[BATImage mj_objectArrayWithKeyValuesArray:imageArray]];
        [_sendDynamicView.tableView reloadData];
    } failure:^(NSError *error) {
        
    } fractionCompleted:^(double count) {
        
        [self showProgres:count];
        
    }];
    
}

#pragma mark - 发表群组动态
- (void)requestSendGroupsDynamic
{
    
    
    [self.view endEditing:YES];
    
    
    if (_dynamicContent.length <= 0) {
        [self showText:@"内容不能为空"];
        return;
    }
    
    if (_dynamicContent.length < 20) {
        [self showText:@"内容不能少于20个"];
        return;
    }
    
    NSArray *arr = [_dynamicContent componentsSeparatedByString:@"\n"];
    if (arr.count > 0) {
        for (NSString *string in arr) {
            if (![string isEqualToString:@""]) {
                self.isCommit = YES;
            }
        }
    }else {
        self.isCommit = YES;
    }
    
    
    
    
    if (!self.isCommit) {
        [self showText:@"内容不能为空"];
        self.isCommit = NO;
        return;
    }
    
    
    
    NSMutableArray *dynamicImg = [[NSMutableArray alloc] init];
    
    for (BATImage *batImage in _dynamicImgArray) {
        [dynamicImg addObject:batImage.url];
    }

    
    NSDictionary *param = @{@"DoctorID":self.DoctorID,
                            @"OrderType":@(self.OrderType),
                            @"OrderMoney":self.OrderMoney,
                            @"IllnessDescription":_dynamicContent,
                            @"Images":[dynamicImg componentsJoinedByString:@","]};
    [self showProgress];
    
    self.clickBtn.enabled = NO;
    self.clickBtn.backgroundColor = UIColorFromHEX(0X999999, 1);
    
    [HTTPTool requestWithURLString:@"/api/order/CreateConsultOrder" parameters:param type:kPOST success:^(id responseObject) {
        
        self.clickBtn.enabled = YES;
        self.clickBtn.backgroundColor = BASE_COLOR;
        
        BATDoctorStudioCreateOrderModel *model = [BATDoctorStudioCreateOrderModel mj_objectWithKeyValues:responseObject];
        if (model.ResultCode == 0) {
            [self showSuccessWithText:responseObject[@"ResultMessage"]];
            
            //去支付页面
//            BATPayViewController *payVC = [[BATPayViewController alloc] init];
//            payVC.type = self.OrderType;
//            payVC.momey = self.OrderMoney;
//            payVC.orderNo = responseObject[@"Data"];
//            payVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:payVC animated:YES];
            
            BATNewPayViewController *payVC = [[BATNewPayViewController alloc] init];
            payVC.type = self.OrderType;
            payVC.momey = self.OrderMoney;
            payVC.doctorName = self.doctorName;
            payVC.doctorPhotoPath = self.doctorPhotoPath;
            payVC.dept = self.dept;
            payVC.isTheNormalProcess = YES;
            payVC.orderNo = responseObject[@"Data"];
            payVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:payVC animated:YES];
        }
        else {
            
            [self showErrorWithText:model.ResultMessage];
        }
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
        
        self.clickBtn.enabled = YES;
        self.clickBtn.backgroundColor = BASE_COLOR;
        

    }];
    
    
}

@end
