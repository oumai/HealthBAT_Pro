//
//  BATTraditionMedicineViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/9/232016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATHomeTraditionMedicineViewController.h"
#import "BATJSObject.h"
#import "BATPerson.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"

@interface BATHomeTraditionMedicineViewController ()<UIWebViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) JSContext *context;

/**
 *  图片数组
 */
@property (nonatomic,strong) NSMutableArray *picDataSource;

/**
 *  待上传的图片数组URL
 */
@property (nonatomic,strong) NSMutableArray *dynamicImgArray;

/**
 临时数据
 */
@property (nonatomic,strong) NSMutableArray *tempPicArray;

@property (nonatomic,copy) NSString *currentURL;

@property (nonatomic,assign) BOOL firstShow;
@property (nonatomic,assign) float firstHeight;
@property (nonatomic,assign) float secondHeight;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATHomeTraditionMedicineViewController

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _picDataSource = [NSMutableArray array];
    _tempPicArray = [NSMutableArray array];
    _dynamicImgArray = [NSMutableArray array];
    
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];

    self.title = @"国医堂";

    [self layoutPages];


    [self webViewRequest:_urlStr];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"首页-国医馆" moduleId:1 beginTime:self.beginTime];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //进入过国医馆才发起通知,发起首页判断你是否进入过国医馆的请求,只通知一次
    BATPerson *person = PERSON_INFO;
    if (person.Data.IsFirstVisitMedicine == YES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ENTER_TRADITIONMEDICINE_SUCCESS" object:nil];
    }

    
    [self dismissProgress];
    
    self.defaultView.hidden = YES;
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    self.currentURL = webView.request.URL.absoluteString;

    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    BATJSObject *jsObject = [[BATJSObject alloc] init];
    self.context[@"HealthBAT"] = jsObject;

    WEAK_SELF(self);
    //chooseCamera
    [jsObject setChooseCameraBlock:^{
        STRONG_SELF(self);
        [self getPhotosFromCamera];

    }];

    [jsObject setChooseImageBlock:^{
        STRONG_SELF(self);

        [self getPhotosFromLocal];
        
    }];
    
    //消息中心点击过来判断
    [jsObject setMessageVCBackVCBlock:^{
        STRONG_SELF(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
    }];
    
    
    [jsObject setExitChineseMedicineBlock:^{
        STRONG_SELF(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    static BOOL isRequestWeb = YES;
    
    if (isRequestWeb) {
        NSHTTPURLResponse *response = nil;
        
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        if (response.statusCode == 404) {
            [self.defaultView showDefaultView];
        } else if (response.statusCode == 403) {
            [self.defaultView showDefaultView];
        }
    }

    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //失败直接返回吧
    
    if(error.code == -999){
        //认为取消请求
        return;
    }
    
    [self.defaultView showDefaultView];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![self.currentURL containsString:@"GygHtmlIndex"]) {
        scrollView.bounds = CGRectMake(self.webView.bounds.origin.x, self.webView.bounds.origin.y-20, CGRectGetWidth(self.webView.bounds), CGRectGetHeight(self.webView.bounds));
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

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    
//    return UIStatusBarStyleLightContent;
//}

#pragma mark - Action

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    WEAK_SELF(self);
    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:(9 - _picDataSource.count) delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;
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
        [_dynamicImgArray removeAllObjects];


        for (NSDictionary *tmpDic in imageArray) {
            NSString *path = tmpDic[@"url"];
            [_dynamicImgArray addObject:[JSValue valueWithObject:path inContext:self.context]];

            JSValue *funcValue = self.context[@"appReturn"];
            [funcValue callWithArguments:_dynamicImgArray];
            [_dynamicImgArray removeAllObjects];
        }
    } failure:^(NSError *error) {

    } fractionCompleted:^(double count) {

        [self showProgres:count];
    }];

//    [HTTPTool requestUploadImageConstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        // 将本地的文件上传至服务器
//        for (int i = 0; i < [_tempPicArray count]; i++) {
//            UIImage *image = [_tempPicArray objectAtIndex:i];
//            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
//            [formData appendPartWithFileData:imageData
//                                        name:[NSString stringWithFormat:@"dynamic_picture%d",i]
//                                    fileName:[NSString stringWithFormat:@"dynamic_picture%d.jpg",i]
//                                    mimeType:@"multipart/form-data"];
//        }
//        
//    } progress:^(NSProgress *uploadProgress) {
//        [self showProgres:uploadProgress.fractionCompleted];
//    } success:^(NSArray *imageArray) {
//        [self dismissProgress];
//        
//        DDLogDebug(@"imageArray %@",imageArray);
//        [_picDataSource addObjectsFromArray:_tempPicArray];
//        [_dynamicImgArray removeAllObjects];
//
//
//        for (NSDictionary *tmpDic in imageArray) {
//            NSString *path = tmpDic[@"url"];
//            [_dynamicImgArray addObject:[JSValue valueWithObject:path inContext:self.context]];
//
//            JSValue *funcValue = self.context[@"appReturn"];
//            [funcValue callWithArguments:_dynamicImgArray];
//            [_dynamicImgArray removeAllObjects];
//        }
//
//
//    } failure:^(NSError *error) {
//        
//    }];
}

#pragma mark - 监视键盘
- (void)keyboardShow:(NSNotification *)noti {
    if (! self.context) {
        return;
    }
    NSValue *rect = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [rect CGRectValue];

    //解决搜狗多次回调不同高度问题
    if (_firstShow) {
        _firstShow = NO;
        _firstHeight = frame.size.height;
    }else{
        _secondHeight = frame.size.height;
        if (_firstHeight != _secondHeight && _secondHeight > _firstHeight) {
            _firstHeight = _secondHeight;
            _secondHeight = 0;
        }
    }

    if (iPhoneX) {
        _firstHeight -=60;
    }
    
    [self autoHeight:_firstHeight];
}
- (void)keyboardHide:(NSNotification *)noti {

    if (! self.context) {
        return;
    }
    
    _firstShow = YES;
    
    
    [self autoHeight:0];
}

- (void)autoHeight:(double)height {
    
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"autoHeight(%@)",[NSString stringWithFormat:@"%f",height]]];
    
}

#pragma mark - net

- (void)webViewRequest:(NSString *)url{
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

}

#pragma mark - layout
- (void)layoutPages {

    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(@-20);
//        make.bottom.equalTo(@20);
//        make.top.equalTo(self.view).offset(-20);
    }];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.view);
        make.top.equalTo(@-20);
    }];
}

#pragma mark - setter && getter
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.delegate = self;
//        _webView.scrollView.scrollEnabled = NO;
        _webView.scrollView.delegate = self;
        _webView.multipleTouchEnabled=NO;
        _webView.scrollView.bouncesZoom = NO;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.backgroundColor = BASE_BACKGROUND_COLOR;
    }
    return _webView;
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
            [self.navigationController setNavigationBarHidden:YES];
            self.defaultView.hidden = YES;
            if (self.isMessageCenterPush) {
                
                [self webViewRequest:[NSString stringWithFormat:@"%@&message=1",self.urlStr]];
                
            }else{
                
                BATPerson *person = PERSON_INFO;
                NSString *url;
                if (person.Data.IsFirstVisitMedicine) {
                    //是第一次进来
                    url = [NSString stringWithFormat:@"%@/app/GygHtmlIndex?token=%@",APP_WEB_DOMAIN_URL,LOCAL_TOKEN];
                }else{
                    //不是第一次进来
                    url= [NSString stringWithFormat:@"%@/app/GygHtmlIndex?token=%@&step=5",APP_WEB_DOMAIN_URL,LOCAL_TOKEN];
                }
                
                [self webViewRequest:url];
                
            }
        }];
        
    }
    return _defaultView;
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
