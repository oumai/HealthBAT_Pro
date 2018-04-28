//
//  BATSendDynamicViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/8/31.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATSendDynamicViewController.h"
#import "BATWriteTextViewTableViewCell.h"
#import "BATAddPicTableViewCell.h"
#import "TZImagePickerController.h"
#import "BATSelectLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "BATUploadImageModel.h"
#import "TZImageManager.h"
#import "BATPhotoBrowserController.h"
#import "BATTopicTitleCell.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "BATGraditorButton.h"
#import "BATMoreTopicsFootView.h"
@interface BATSendDynamicViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
YYTextViewDelegate,
BATAddPicTableViewCellDelegate,
TZImagePickerControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
BATMoreTopicsFootViewDelegate
>

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
 *  输入的动态标题
 */
@property (nonatomic,strong) NSString *TopicTitle;

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
/**
 选择话题示图
 */
@property (nonatomic ,weak)   BATMoreTopicsFootView                     *topicsFootView;
@property (nonatomic ,strong) BATTopicListModel                         *topicModel;
@property (nonatomic ,assign) NSInteger                                 currentPage;

@property (nonatomic,assign) BOOL isCommit;

@end

@implementation BATSendDynamicViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    _sendDynamicView.tableView.delegate = nil;
    _sendDynamicView.tableView.dataSource = nil;
}

- (BOOL)navigationShouldPopOnBackButton {

//    
//    _TopicTitle.length <= 4) {
//        [self showText:@"标题字数限制4~50字之间"];
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//        return;
//    }
//    if (_dynamicContent
    
    if (_dynamicContent.length !=0 || _TopicTitle.length !=0) {
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
        
        WEAK_SELF(self);
        [_sendDynamicView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
    
    BATGraditorButton *customBtn = [[BATGraditorButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [customBtn addTarget:self action:@selector(sendTopicAction) forControlEvents:UIControlEventTouchUpInside];
    [customBtn setTitle:@"发布" forState:UIControlStateNormal];
    customBtn.enbleGraditor = YES;
    [customBtn setGradientColors:@[START_COLOR,END_COLOR]];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:customBtn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    WEAK_SELF(self);
//    UIBarButtonItem *sendBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"发布" style:UIBarButtonItemStyleDone handler:^(id sender) {
//        STRONG_SELF(self);
//        [self requestSendGroupsDynamic];
//    }];
//    
//    [sendBarButtonItem setTintColor:BASE_COLOR];
//    
//    self.navigationItem.rightBarButtonItem = sendBarButtonItem;
}

- (void)sendTopicAction {
 
     [self requestSendGroupsDynamic];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_interactivePopDisabled = YES;
    
    self.title = @"发帖";
    self.isBBS = YES;
    _picDataSource = [NSMutableArray array];
    //    _picAsset = [NSMutableArray array];
    _tempPicArray = [NSMutableArray array];
    _dynamicImgArray = [NSMutableArray array];
    
    _groupDetailDynamicOpration = BATGroupDetailDynamicOprationDynamic;
    _address = @"";
    [_sendDynamicView.tableView registerClass:[BATWriteTextViewTableViewCell class] forCellReuseIdentifier:@"BATWriteTextViewTableViewCell"];
    [_sendDynamicView.tableView registerClass:[BATAddPicTableViewCell class] forCellReuseIdentifier:@"BATAddPicTableViewCell"];
    [_sendDynamicView.tableView registerClass:[BATTopicTitleCell class] forCellReuseIdentifier:@"BATTopicTitleCell"];
    [self topicsRequest];
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 2;
//    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        return 42.5;
      }else if(indexPath.row == 1) {
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
//    if (indexPath.section == 0) {
      if (indexPath.row == 0) {
          BATTopicTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATTopicTitleCell"];
          cell.yyTextView.delegate = self;
          cell.yyTextView.placeholderText = @"标题,诱人的会有更多人看哦~";
          cell.yyTextView.placeholderFont = [UIFont systemFontOfSize:15];
          cell.yyTextView.placeholderTextColor = UIColorFromHEX(0X999999, 1);
          cell.yyTextView.text = _TopicTitle;
          return cell;
          
          }else if (indexPath.row == 1) {
            BATWriteTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATWriteTextViewTableViewCell" forIndexPath:indexPath];
            cell.textView.delegate = self;
            cell.textView.placeholderText = @"内容,描述一下您的内容......";
            cell.textView.text = _dynamicContent;
            if (self.isBBS) {
                 cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/2000",(unsigned long)_dynamicContent.length];
            }else {
            cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/200",(unsigned long)_dynamicContent.length];
            }
            return cell;
          }else {
      
              BATAddPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAddPicTableViewCell" forIndexPath:indexPath];
              cell.delegate = self;
              [cell reloadCollectionViewData:_picDataSource];
               return cell;
          }
//    }
    /*
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = UIColorFromHEX(0x666666, 1);
        cell.detailTextLabel.numberOfLines = 0;
        //设置cell的separator
        [cell setBottomBorderWithColor:UIColorFromHEX(0xeeeeee, 1) width:SCREEN_WIDTH height:0];
    }
    
    
    if (indexPath.row == 0) {
        cell.imageView.image = [UIImage imageNamed:@"icon_leixing"];
        cell.textLabel.text = @"选择类型";
        if (_groupDetailDynamicOpration == BATGroupDetailDynamicOprationDynamic) {
            cell.detailTextLabel.text = @"动态";
        } else if (_groupDetailDynamicOpration == BATGroupDetailDynamicOprationQuestion) {
            cell.detailTextLabel.text = @"问题";
        }
    } else if (indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"icon-dizhi"];
        cell.textLabel.text = _address.length > 0 ? _address : @"地址位置";
    }
    return cell;
     */
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    /*
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //选择类型
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            
            WEAK_SELF(self);
            UIAlertAction *dynamicAction = [UIAlertAction actionWithTitle:@"动态" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                STRONG_SELF(self);
                self.groupDetailDynamicOpration = BATGroupDetailDynamicOprationDynamic;
                [_sendDynamicView.tableView reloadData];
            }];
            
            UIAlertAction *questionAction = [UIAlertAction actionWithTitle:@"问题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                STRONG_SELF(self);
                self.groupDetailDynamicOpration = BATGroupDetailDynamicOprationQuestion;
                [_sendDynamicView.tableView reloadData];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:dynamicAction];
            [alertController addAction:questionAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else if (indexPath.row == 1) {
            //地址位置
            
            if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
                [Tools showSettingWithTitle:@"定位服务已经关闭" message:@"请到设置->隐私->定位服务中开启健康BAT的定位服务，方便我们能准确获取您的地理位置" failure:^{
                    
                }];
            }else{
                BATSelectLocationViewController *selectLocationVC = [[BATSelectLocationViewController alloc] init];
                selectLocationVC.hidesBottomBarWhenPushed = YES;
                
                WEAK_SELF(self);
                selectLocationVC.addressBlock = ^(NSString *address) {
                    STRONG_SELF(self);
                    self.address = address;
                    [self.sendDynamicView.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                };
                
                [self.navigationController pushViewController:selectLocationVC animated:YES];
            }
            
            
        }
    }
     */
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView
{
    if (textView.tag == 0) {
        if (textView.text.length > 50) {
            textView.text = [textView.text substringToIndex:50];
        }
         _TopicTitle = textView.text;
    }else if(textView.tag == 1) {
        BATWriteTextViewTableViewCell *cell = [_sendDynamicView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        
        if (self.isBBS) {
            if (textView.text.length > 2000) {
                [self showText:@"最多输入2000个字" withInterval:1.5];
                textView.text = [textView.text substringToIndex:2000];
            }
        }else {
            if (textView.text.length > 200) {
                [self showText:@"最多输入200个字" withInterval:1.5];
                textView.text = [textView.text substringToIndex:200];
            }
        }
        
        _dynamicContent = textView.text;
        
        if (self.isBBS) {
            cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/2000",(unsigned long)_dynamicContent.length];
        }else {
            cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/200",(unsigned long)_dynamicContent.length];
        }
    }
   
}

/*
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //实现textView.delegate  实现回车发送,return键发送功能
    if (textView.tag == 1) {
 
        if ([@"\n" isEqualToString:text]) {
            [textView resignFirstResponder];
            
        }
        
 //   }
 //    return YES;
//}
*/


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
#pragma mark -- BATMoreTopicsFootViewDelegate
- (void)topicsFootView:(BATMoreTopicsFootView *)topicsFootView didSelectedTopics:(MyTopicListDataModel *)topics {
    self.topicID = topics.ID;
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
        //        [_picAsset removeAllObjects];
        //        [_picDataSource removeAllObjects];
        //        [_picAsset addObjectsFromArray:assets];
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
    //    [_picAsset removeObjectAtIndex:indexPath.row];
   // [_picDataSource removeObjectAtIndex:indexPath.row];
   // [_dynamicImgArray removeObjectAtIndex:indexPath.row];
//[_sendDynamicView.tableView reloadData];
    
    //设置容器视图,父视图
    BATPhotoBrowserController *browserVC = [[BATPhotoBrowserController alloc]init];
    browserVC.BrowserPicAssetArr = _picAsset;
    browserVC.BrowserPicDataSourceArr = _picDataSource;
    browserVC.BrowserDynamicImgArray = _dynamicImgArray;
    browserVC.index = indexPath.item;
    browserVC.iSReloadBlock = ^(NSMutableArray *BrowserPicDataSourceArr,NSMutableArray *BrowserDynamicImgArray,NSMutableArray *BrowserPicAssetArr) {
        
        _picDataSource = BrowserPicDataSourceArr;
        _picAsset = BrowserPicAssetArr;
        _dynamicImgArray = BrowserDynamicImgArray;
        
      [_sendDynamicView.tableView reloadData];
    };
    [self.navigationController pushViewController:browserVC animated:YES];
  
}

#pragma mark -- private
- (void)setDataWithListModel:(BATTopicListModel *)model {
    if (self.topicID != nil ||
        self.topicID.length != 0) {
        for (MyTopicListDataModel *dataModel in model.Data) {
            if ([self.topicID isEqualToString:dataModel.ID]) {
                dataModel.isSelect = YES;
                break;
            }
        }
    }
    CGFloat heigth = self.sendDynamicView.tableView.contentSize.height+64;
    BATMoreTopicsFootView *topicsFootView = [[BATMoreTopicsFootView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, SCREEN_HEIGHT-heigth)];
    topicsFootView.delegate = self;
    self.sendDynamicView.tableView.tableFooterView = topicsFootView;
    self.topicsFootView = topicsFootView;
    [self.topicsFootView setDataWithListModel:model];
}

#pragma mark - NET
- (void)topicsRequest {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params jk_setObj:@"1" forKey:@"CategoryID"];
    [params jk_setObj:@(self.currentPage) forKey:@"pageIndex"];
    [params jk_setObj:@"100" forKey:@"pageSize"];
    [HTTPTool requestWithURLString:@"/api/dynamic/GetTopicList" parameters:params type:kGET success:^(id responseObject) {
        self.topicModel = [BATTopicListModel mj_objectWithKeyValues:responseObject];
        [self setDataWithListModel:self.topicModel];
    } failure:^(NSError *error) {
        
    }];
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
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self.view endEditing:YES];
    
    if (_TopicTitle.length <= 0) {
        [self showText:@"标题不能为空" withInterval:1.5];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    if (_TopicTitle.length < 4) {
        [self showText:@"标题字数限制4~50字之间" withInterval:1.5];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    
    if (_dynamicContent.length <= 0) {
        [self showText:@"内容不能为空" withInterval:1.5];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    
    if (_dynamicContent.length < 20) {
        [self showText:@"内容不能少于20个字" withInterval:1.5];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    
    if (self.topicID == nil ||
        self.topicID.length == 0) {
        [self showText:@"发布帖子前，请至少选择一个帖子话题" withInterval:1.5];
        self.navigationItem.rightBarButtonItem.enabled = YES;
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
        [self showText:@"内容不能为空" withInterval:1.5];
        self.isCommit = NO;
        return;
    }
   
    
    
    NSMutableArray *dynamicImg = [[NSMutableArray alloc] init];
    
    for (BATImage *batImage in _dynamicImgArray) {
        [dynamicImg addObject:batImage.url];
    }
    
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i<_picDataSource.count; i++) {
        UIImage *img = _picDataSource[i];
        NSDictionary *dict = @{@"ImageSize":[NSString stringWithFormat:@"%.0f,%.0f",img.size.width,img.size.height],@"ImageUrl":dynamicImg[i]};
        [dataArr addObject:dict];
    }


    NSDictionary *param = @{@"TopicID":self.topicID,
                            @"Title":_TopicTitle,
                            @"PostContent":_dynamicContent,
                            @"ImageList":dataArr}
    ;
    
    [self showProgress];
    
    [HTTPTool requestWithURLString:@"/api/dynamic/SubmitDynamicPost" parameters:param type:kPOST success:^(id responseObject) {
        [self showText:@"发布成功" withInterval:1.5];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        //通知刷新界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SEND_DYNAMIC_SUCCESS" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self showText:@"发布失败" withInterval:1.5];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
    

    
}
@end
