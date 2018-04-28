//
//  WriteSingleDiseaseViewController.m
//  HealthBAT
//
//  Created by cjl on 16/8/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATWriteSingleDiseaseViewController.h"
#import "Masonry.h"
#import "BATTitleTableViewCell.h"
#import "BATWriteTextViewTableViewCell.h"
#import "BATAddPicTableViewCell.h"
#import "BATDiseaseDescriptionModel.h"
#import "BATPerson.h"
#import "BATConfirmPayViewController.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "BATUploadImageModel.h"
#import "BATChooseEntiyModel.h"
#import "BATChatConsultController.h"
#import <Photos/Photos.h>
#import "BATNetWorkMedicalImageModel.h"
#import "BATHealthFilesListVC.h"
#import "BATPhotoBrowserController.h"
#import "BATWriteDiseaseNameTableViewCell.h"


@interface BATWriteSingleDiseaseViewController ()<UITableViewDelegate,UITableViewDataSource,BATWriteSingleDiseaseViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BATAddPicTableViewCellDelegate,TZImagePickerControllerDelegate,YYTextViewDelegate>
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
@property (nonatomic,strong) NSMutableArray *picArray;


/**
 *  病症描述
 */
@property (nonatomic,strong) NSString *diseaseDescription;

/**
 *  家庭成员
 */
@property (nonatomic,strong) MyResData *myResData;


/**
 *  memberID
 */
@property (nonatomic,strong) NSString  *memberID;

@property (nonatomic,strong) NSString *beginTime;

/**
 临时数据
 */
@property (nonatomic,strong) NSMutableArray *tempPicArray;

@property (nonatomic,assign) NSInteger count;


@end

@implementation BATWriteSingleDiseaseViewController

- (void)dealloc
{
    _writeSingleDiseaseView.tableView.delegate = nil;
    _writeSingleDiseaseView.tableView.dataSource = nil;
    _writeSingleDiseaseView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ***** UI *****
#pragma mark -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self popAction];
}

-(void)popAction {

    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:self.pathName moduleId:3 beginTime:self.beginTime];
    
}

- (void)loadView
{
    [super loadView];
    
    if (_writeSingleDiseaseView == nil) {
        _writeSingleDiseaseView = [[BATWriteSingleDiseaseView alloc] init];
        _writeSingleDiseaseView.tableView.delegate = self;
        _writeSingleDiseaseView.tableView.dataSource = self;
        _writeSingleDiseaseView.delegate = self;
        [self.view addSubview:_writeSingleDiseaseView];
        
        WEAK_SELF(self)
        [_writeSingleDiseaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
    
    self.title = _type == kConsultTypeFree ? @"问诊信息" : @"图文咨询";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    _picDataSource = [NSMutableArray array];
    _tempPicArray = [NSMutableArray array];
    _picArray = [NSMutableArray array];
    _count = 0;
    
    [_writeSingleDiseaseView.tableView registerClass:[BATTitleTableViewCell class] forCellReuseIdentifier:@"TitleTableViewCell"];
    [_writeSingleDiseaseView.tableView registerClass:[BATWriteTextViewTableViewCell class] forCellReuseIdentifier:@"WriteTextViewTableViewCell"];
    [_writeSingleDiseaseView.tableView registerClass:[BATAddPicTableViewCell class] forCellReuseIdentifier:@"AddPicTableViewCell"];
    [_writeSingleDiseaseView.tableView registerClass:[BATWriteDiseaseNameTableViewCell class] forCellReuseIdentifier:@"BATWriteDiseaseNameTableViewCell"];
    
    

    [self requestGetDefaultUserMembers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Delegate

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        return 105;
    }
    
    if (indexPath.section == 2) {
         if (indexPath.row == 0) {
            return 100;
        }
         else if (indexPath.row == 1) {
            
            NSInteger picCount = _picDataSource.count < 9 ? _picDataSource.count + 1 : _picDataSource.count;
            
            if (picCount <= 4) {
                return ItemWidth + 30;
            }
            else if (picCount <= 8) {
                return 2 * ItemWidth + 10 + 30;
            }
            else {
                return 3 * ItemWidth + 20 + 30;
            }
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 2){
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {

        if (indexPath.section == 0) {
            BATTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TitleTableViewCell" forIndexPath:indexPath];
            NSString *string = _myResData != nil ? [NSString stringWithFormat:@"就诊人信息: %@",_myResData.MemberName] : @"就诊人信息: 请选择就诊人信息";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(5, string.length - 5)];
            
            cell.textLabel.attributedText = attributedString;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else if (indexPath.section == 1) {
            BATWriteDiseaseNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATWriteDiseaseNameTableViewCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            WEAK_SELF(self);
            [cell setVideoClick:^(NSIndexPath *indexPath){
                STRONG_SELF(self);
                self.diseaseDescription = @"";
                NSArray  *dataArr = @[@"湿疹",@"鼻炎",@"咳嗽",@"瘙痒",@"颈椎病",@"前列腺炎",@"脂溢性皮炎",@"乳房疼痛"];
                
                BATWriteTextViewTableViewCell *cell = [self.writeSingleDiseaseView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
                cell.textView.text = [NSString stringWithFormat:@"医生您好，我想咨询下关于%@方面的一些问题",dataArr[indexPath.row]];
                self.diseaseDescription = [NSString stringWithFormat:@"医生您好，我想咨询下关于%@方面的一些问题",dataArr[indexPath.row]];
            }];

            return cell;
        }
        else if (indexPath.section == 2){
            
            if (indexPath.row == 0) {
                BATWriteTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WriteTextViewTableViewCell" forIndexPath:indexPath];
                cell.textView.delegate = self;
                cell.textView.tag = indexPath.section;
                cell.textView.placeholderText = @"请详细描述您的身体状况和病情，我们将会在24小时内回复您（最少20个字符）";
                cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/600",(unsigned long)_diseaseDescription.length];

                return cell;
            }
        }
    }else{
        if (indexPath.section == 2){
            BATAddPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPicTableViewCell" forIndexPath:indexPath];
            cell.delegate = self;
            [cell reloadCollectionViewData:_picDataSource];
            return cell;
        }
    }

    return nil;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //选择就诊人信息
            BATHealthFilesListVC *chooseTreatmentPersonVC = [[BATHealthFilesListVC alloc] init];
            chooseTreatmentPersonVC.isConsultionAndAppointmentYes = YES;
            [chooseTreatmentPersonVC setChooseBlock:^(ChooseTreatmentModel *chooseTreatmentModel) {
                
                _myResData = [[MyResData alloc] init];
                _myResData.MemberName = chooseTreatmentModel.name;
                _myResData.MemberID = chooseTreatmentModel.memberID;
                _myResData.UserID = chooseTreatmentModel.userID;
                _myResData.Mobile = chooseTreatmentModel.phoneNumber;
                _myResData.IsPerfect = chooseTreatmentModel.IsPerfect;
                self.memberID = chooseTreatmentModel.memberID;
                [_writeSingleDiseaseView.tableView reloadData];
                
            }];

            chooseTreatmentPersonVC.hidesBottomBarWhenPushed = YES;
//            chooseTreatmentPersonVC.pathName = @"咨询-免费咨询-选择就诊人";
            [self.navigationController pushViewController:chooseTreatmentPersonVC animated:YES];
        }
    }
}

#pragma mark YYTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView
{
//    _currentTextViewIndex = textView.tag;
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView
{
    BATWriteTextViewTableViewCell *cell = [_writeSingleDiseaseView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:textView.tag]];
    
    if (textView.tag == 2) {
        //获取填写的病症描述
        if (textView.text.length >= 600) {
            [self showText:@"病症描述最多600个字符"];
            textView.text = [textView.text substringToIndex:600];
        }
        _diseaseDescription = textView.text;
        cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/600",(unsigned long)_diseaseDescription.length];
    }
    
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //实现textView.delegate  实现回车发送,return键发送功能
    if ([@"\n" isEqualToString:text]) {
        DDLogDebug(@"发送");
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//#pragma mark 键盘出现
//- (void)keyboardWillShow:(NSNotification *)notif
//{
//    CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    DDLogDebug(@"keyboardFrame.size.height == %f", keyboardFrame.size.height);
//    
//    //解决搜狗多次回调不同高度问题
//    if (firstShow) {
//        firstShow = NO;
//        firstShowHight = keyboardFrame.size.height;
//    }else{
//        secondShowHight = keyboardFrame.size.height;
//        if (firstShowHight != secondShowHight && secondShowHight > firstShowHight) {
//            firstShowHight = secondShowHight;
//            secondShowHight = 0;
//        }
//    }
//    
//    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    
//    
//    BATWriteTextViewTableViewCell *cell = [_writeSingleDiseaseView.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:_currentTextViewIndex]];
//    
//    CGRect rect = [_writeSingleDiseaseView.tableView convertRect:cell.frame toView:MAIN_WINDOW];
//
//
//    float offsetY = (rect.origin.y + rect.size.height) - firstShowHight;
//    
//    if (offsetY > 0) {
//        [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
//            _writeSingleDiseaseView.transform = CGAffineTransformMakeTranslation(0, -(offsetY + rect.size.height));
//        } completion:nil];
//    } else {
//        [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
//            _writeSingleDiseaseView.transform = CGAffineTransformIdentity;
//        } completion:nil];
//    }
//    
//
//}

//- (void)keyboardWillHide:(NSNotification *)notif
//{
//    firstShow = YES;
//
//    double duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    
//    NSInteger animation = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
//    
//    [UIView animateWithDuration:duration delay:0.0f options:animation animations:^{
//        _writeSingleDiseaseView.transform = CGAffineTransformIdentity;
//    } completion:nil];
//    
//}


#pragma mark - WriteSingleDiseaseViewDelegate
- (void)consultBtnClickedAction
{
    //提交图文咨询
    [self requestInsertUserConsults];
//    //保存病情单
//    [self requestSaveConsultRecord];
}

#pragma mark - BATAddPicTableViewCellDelegate
- (void)collectionViewItemClicked:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == _picDataSource.count) {
        
        _count = 0;

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];

        WEAK_SELF(self);
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
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


#pragma mark - Actionx

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{

    TZImagePickerController *tzImagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:(9 - _picDataSource.count) delegate:self];
    tzImagePickerVC.allowPickingVideo = NO;
//    if (_picDataSource.count > 0) {
//        tzImagePickerVC.selectedAssets = _picAsset;
//    }
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [tzImagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        [_picAsset removeAllObjects];
//        [_picDataSource removeAllObjects];
//        [_picAsset addObjectsFromArray:assets];
        [_tempPicArray removeAllObjects];
        if (photos.count > 0) {
            for (UIImage *image in photos) {
                //对图片进行压缩处理
                if (isSelectOriginalPhoto) {
                    [_tempPicArray addObject:image];
                }
                else {
                    UIImage *imageCompress = [Tools compressImageWithImage:image ScalePercent:0.05];
                    [_tempPicArray addObject:imageCompress];
                }
            }
        }
        [self requestUpdateImages];
//        [_writeSingleDiseaseView.tableView reloadData];
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

#pragma mark 删除图片
- (void)deletePic:(NSIndexPath *)indexPath
{
//    [_picAsset removeObjectAtIndex:indexPath.row];
    
//    [_picDataSource removeObjectAtIndex:indexPath.row];
//    [_picArray removeObjectAtIndex:indexPath.row];
//    [_writeSingleDiseaseView.tableView reloadData];
    
    BATPhotoBrowserController *browserVC = [[BATPhotoBrowserController alloc]init];
    browserVC.BrowserPicAssetArr = _picArray;
    browserVC.BrowserPicDataSourceArr = _picDataSource;
    browserVC.index = indexPath.item;
    browserVC.iSReloadBlock = ^(NSMutableArray *BrowserPicDataSourceArr,NSMutableArray *BrowserDynamicImgArray,NSMutableArray *BrowserPicAssetArr) {
        _picArray = BrowserPicAssetArr;
        _picDataSource = BrowserPicDataSourceArr;
        [_writeSingleDiseaseView.tableView reloadData];
    };
    [self.navigationController pushViewController:browserVC animated:YES];
}


#pragma mark Action
//- (void)goToChatVC:(BATDiseaseDescriptionModel *)ddm {
//
//    KMChatViewController *kmChatVC = [[KMChatViewController alloc] init];
//    kmChatVC.consultID = [NSString stringWithFormat:@"%ld",(long)ddm.ID];
//    kmChatVC.doctiorPhotoPath = _doctiorPhotoPath;
//    kmChatVC.doctorName = _doctorName;
//    kmChatVC.accountID = _AccountID;
//    [self.navigationController pushViewController:kmChatVC animated:YES];
//}

#pragma mark NET

#pragma mark - 批量上传图片
- (void)requestUpdateImages
{
    NSMutableArray *imageArray = [NSMutableArray array];
    // 将本地的文件上传至服务器
    for (int i = 0; i < [_tempPicArray count]; i++) {
        UIImage *image = [_tempPicArray objectAtIndex:i];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        [imageArray addObject:imageData];
    }

    [HTTPTool requestUploadImageToKMWithParams:imageArray success:^(NSArray *severImageArray) {

        [self dismissProgress];
        [_picDataSource addObjectsFromArray:_tempPicArray];
        [_picArray addObjectsFromArray:[BATNetWorkMedicalImageModel mj_objectArrayWithKeyValuesArray:severImageArray]];
        [_writeSingleDiseaseView.tableView reloadData];
    } failure:^(NSError *error) {
        
        _count++;
        
        if (_count == 3) {
            _count = 0;
            [self showErrorWithText:@"图片上传失败！"];
        } else {
            [self requestUpdateImages];
        }
        

    } fractionCompleted:^(double count) {

        [self showProgress];
    }];

}

#pragma mark - 获取默认就诊人
- (void)requestGetDefaultUserMembers
{
    [self showProgressWithText:@"正在加载"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetDefaultUserMembers" parameters:nil type:kGET success:^(id responseObject) {
       
        BATChooseEntiyModel *chooseEntiyModel = [BATChooseEntiyModel mj_objectWithKeyValues:responseObject];
        if (chooseEntiyModel.Data.count > 0) {
            self.memberID = [chooseEntiyModel.Data[0] MemberID];
            _myResData = chooseEntiyModel.Data[0];
        }
        
        [_writeSingleDiseaseView.tableView reloadData];
       
        if (!_myResData.IsPerfect) {
            [self showText:@"请完善就诊人信息"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BATHealthFilesListVC *filedVC = [[BATHealthFilesListVC alloc]init];
                filedVC.isConsultionAndAppointmentYes = YES;
                [filedVC setChooseBlock:^(ChooseTreatmentModel *chooseTreatmentModel) {
            
                    _myResData.MemberName = chooseTreatmentModel.name;
                    _myResData.MemberID = chooseTreatmentModel.memberID;
                    _myResData.UserID = chooseTreatmentModel.userID;
                    _myResData.Mobile = chooseTreatmentModel.phoneNumber;
                    _myResData.IsPerfect = chooseTreatmentModel.IsPerfect;
                    
                    self.memberID = chooseTreatmentModel.memberID;
                    [_writeSingleDiseaseView.tableView reloadData];
                    
                }];
                [self.navigationController pushViewController:filedVC animated:YES];
            });
        }else {
         [self dismissProgress];
        }
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];

    }];
}

#pragma mark - 图文咨询提交
- (void)requestInsertUserConsults
{
    //34975c7ca63c43f79cf1c96b0b9d4a13 memberID
    [self.view endEditing:YES];

    
    _writeSingleDiseaseView.footerView.consultBtn.enabled = NO;
    
    if (_myResData == nil) {
        [self showErrorWithText:@"请选择就诊人"];
        
        _writeSingleDiseaseView.footerView.consultBtn.enabled = YES;
        return;
    }
    
    if (!_myResData.IsPerfect) {
        [self showText:@"请完善就诊人信息"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            BATHealthFilesListVC *filedVC = [[BATHealthFilesListVC alloc]init];
            filedVC.isConsultionAndAppointmentYes = YES;
            [self.navigationController pushViewController:filedVC animated:YES];
        });
        return;
    }
    
    if (_diseaseDescription.length <= 0 || !_diseaseDescription) {
        [self showErrorWithText:@"病症描述不能为空"];
        _writeSingleDiseaseView.footerView.consultBtn.enabled = YES;
        return;
    } else if (_diseaseDescription.length < 20) {
        [self showErrorWithText:@"病症描述需要填入最少20个字符"];
        _writeSingleDiseaseView.footerView.consultBtn.enabled = YES;
        return;
    }
    
    NSMutableArray *files = [[NSMutableArray alloc] init];
    
    for (BATNetWorkMedicalImageModel *batImage in _picArray) {
        [files addObject:@{@"FileUrl":batImage.Data.FileName,@"Remark":@"图文咨询"}];
    }
    
    NSDictionary *params;
    params = @{
               @"MemberID":_myResData.MemberID,
               @"ConsultContent":_diseaseDescription,
               @"Fileslst":[Tools dataTojsonString:files],
//               @"Free":(_type == kConsultTypeFree ? [NSNumber numberWithBool:true] : [NSNumber numberWithBool:false]),
               @"DoctorID":_doctorID.length > 0 ? _doctorID : @""
               };
    
    if (self.IsFreeClinicr == YES) {
        //义诊
        params = @{
                   @"MemberID":_myResData.MemberID,
                   @"ConsultContent":_diseaseDescription,
                   @"Fileslst":[Tools dataTojsonString:files],
                   @"DoctorID":_doctorID.length > 0 ? _doctorID : @"",
                   @"Privilege":@2,
//                   @"Free":[NSNumber numberWithBool:false],
                   };
    }
    
    [self showProgressWithText:@"正在咨询医生"];
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/InsertUserConsults" parameters:params type:kPOST success:^(id responseObject) {
        
        BATDiseaseDescriptionModel *diseaseDescriptionModel = [BATDiseaseDescriptionModel mj_objectWithKeyValues:responseObject];
         _writeSingleDiseaseView.footerView.consultBtn.enabled = YES;
        
        if ([diseaseDescriptionModel.Data.ActionStatus isEqualToString:@"Success"]) {
            
            //提交成功
            if (_type == kConsultTypeFree) {
                //免费咨询
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Order_pay_success" object:nil];
                

                
//                [self showSuccessWithText:diseaseDescriptionModel.Data.ErrorInfo];

//                [self.navigationController popToRootViewControllerAnimated:YES];//返回咨询首页

                //进聊天界面
                BATChatConsultController *chatCtl = [[BATChatConsultController alloc]init];
                chatCtl.cusultType = _type;
                chatCtl.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:chatCtl animated:YES];

                [self bk_performBlock:^(id obj) {
                    NSMutableArray *tmArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                    [tmArray removeObject:self];
                    self.navigationController.viewControllers = tmArray;
                } afterDelay:1.5];
                
            } else if (_type == kConsultTypeTextAndImage) {
                [self dismissProgress];

                if (diseaseDescriptionModel.Data.OrderState == -1 || diseaseDescriptionModel.Data.OrderState == 0) {
                    
                    //成功后进入一界面
                    BATConfirmPayViewController *confirmPayVC = [[BATConfirmPayViewController alloc] init];
                    confirmPayVC.type = _type;
                    confirmPayVC.isTheNormalProcess = YES;
                    confirmPayVC.orderNo = diseaseDescriptionModel.Data.OrderNO;
                    confirmPayVC.momey = _momey;
                    [self.navigationController pushViewController:confirmPayVC animated:YES];
                    
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Order_pay_success" object:nil];
                    
//                    BATChatConsultController *chatCtl = [[BATChatConsultController alloc]init];
//                    chatCtl.cusultType = _type;
//                    chatCtl.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:chatCtl animated:YES];
                     [self.navigationController popToRootViewControllerAnimated:YES];
                }

            }

//            if ([_momey doubleValue] == 0 || _IsFreeClinicr) {
//                BATChatConsultController *chatCtl = [[BATChatConsultController alloc]init];
//                chatCtl.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:chatCtl animated:YES];
//            } else {
//                
//            }
            

        } else if ([diseaseDescriptionModel.Data.ActionStatus isEqualToString:@"Repeat"]) {
            
            [self showErrorWithText:@"不能重复预约，或请重新选择就诊人！"];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                BATChatConsultController *chatCtl = [[BATChatConsultController alloc]init];
//                chatCtl.cusultType = _type;
//                chatCtl.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:chatCtl animated:YES];
//            });
            
        } else {
             [self showErrorWithText:diseaseDescriptionModel.Data.ErrorInfo];
        }
        
    } failure:^(NSError *error) {
        
         _writeSingleDiseaseView.footerView.consultBtn.enabled = YES;
        
//        if (![error.userInfo[@"Data"] isKindOfClass:[NSNull class]]) {
//            if ([error.userInfo[@"Data"] isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dic = error.userInfo[@"Data"];
//                if ([dic[@"ErrorInfo"] isKindOfClass:[NSString class]] && ![dic[@"ErrorInfo"] isEqualToString:@""]) {
//                    [self showErrorWithText:error.userInfo[@"Data"][@"ErrorInfo"]];
//                }
//            }
//        }
        [self showErrorWithText:error.localizedDescription];


    }];
    
    
//    [HTTPTool requestWithURLString:@"api/NetworkMedical/InsertUserConsults" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//        // 将本地的文件上传至服务器
//        for (int i = 0; i < [_picDataSource count]; i++) {
//            UIImage *image = [_picDataSource objectAtIndex:i];
//            NSData *imageData = UIImageJPEGRepresentation(image,0.8);
//            [formData appendPartWithFileData:imageData
//                                        name:[NSString stringWithFormat:@"disease_description_%d",i]
//                                    fileName:[NSString stringWithFormat:@"disease_description_%d.jpg",i]
//                                    mimeType:@"multipart/form-data"];
//        }
//        
//    } progress:^(NSProgress *uploadProgress) {
//        [self showProgres:uploadProgress.fractionCompleted];
//        
//    } success:^(id responseObject) {
//        
//        [self dismissProgress];
//        
//        BATDiseaseDescriptionModel *ddm = [BATDiseaseDescriptionModel mj_objectWithKeyValues:[responseObject objectForKey:@"Data"]];
//        
//        if (_type == kConsultTypeFree) {
//            //添加咨询过的医生通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDARA_CONSULTED_DOCTOR_FREE" object:self userInfo:nil];
//            
//            [self requestUpdatePayConsultRecord:ddm];
//            
//        } else {
//            //成功后进入一界面
//            BATConfirmPayViewController *confirmPayVC = [[BATConfirmPayViewController alloc] init];
//            confirmPayVC.type = _type;
//            confirmPayVC.accountID = _AccountID;
//            confirmPayVC.momey = _momey;
//            confirmPayVC.doctiorPhotoPath = _doctiorPhotoPath;
//            confirmPayVC.doctorName = _doctorName;
//            confirmPayVC.diseaseDescriptionModel = ddm;
//            [self.navigationController pushViewController:confirmPayVC animated:YES];
//        }
//        
//        
//    } failure:^(NSError *error) {
//        
//        [self dismissProgress];
//    }];
}

#pragma mark - 提交病情单
//- (void)requestSaveConsultRecord
//{
//    [self.view endEditing:NO];
//    
//    if (_diseaseDescription.length <= 0 || !_diseaseDescription) {
//        [self showErrorWithText:@"病症描述不能为空"];
//        return;
//    } else if (_diseaseDescription.length < 20) {
//        [self showErrorWithText:@"病症描述需要填入最少20个字符"];
//        return;
//    }
//
//    if (_wantAnswer.length <= 0 || !_wantAnswer) {
//        [self showErrorWithText:@"最想要得到医生什么帮助不能为空"];
//        return;
//    } else if (_wantAnswer.length > 20 || _wantAnswer.length < 2) {
//        [self showErrorWithText:@"最想要得到医生什么帮助需要填入最2~20字"];
//        return;
//    }
//    
//    NSDictionary *params = @{
//                             @"ConsultType":@(self.type),
//                             @"DoctorAccountID":self.AccountID,
//                             @"DiseaseDescription":_diseaseDescription,
//                             @"DoctorHelp":_wantAnswer,
//                             @"PayMoney":self.momey};
//
//
//    [HTTPTool requestWithURLString:@"/api/OnlineConsult/SavConsultRecord" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//
//        // 将本地的文件上传至服务器
//        for (int i = 0; i < [_picDataSource count]; i++) {
//            UIImage *image = [_picDataSource objectAtIndex:i];
//            NSData *imageData = UIImageJPEGRepresentation(image,0.8);
//            [formData appendPartWithFileData:imageData
//                                        name:[NSString stringWithFormat:@"disease_description_%d",i]
//                                    fileName:[NSString stringWithFormat:@"disease_description_%d.jpg",i]
//                                    mimeType:@"multipart/form-data"];
//        }
//
//    } progress:^(NSProgress *uploadProgress) {
//        [self showProgres:uploadProgress.fractionCompleted];
//
//    } success:^(id responseObject) {
//
//        [self dismissProgress];
//
//        BATDiseaseDescriptionModel *ddm = [BATDiseaseDescriptionModel mj_objectWithKeyValues:[responseObject objectForKey:@"Data"]];
//
//        if (_type == kConsultTypeFree) {
//            //添加咨询过的医生通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDARA_CONSULTED_DOCTOR_FREE" object:self userInfo:nil];
//
//            [self requestUpdatePayConsultRecord:ddm];
//
//        } else {
//            //成功后进入一界面
//            BATConfirmPayViewController *confirmPayVC = [[BATConfirmPayViewController alloc] init];
//            confirmPayVC.type = _type;
//            confirmPayVC.accountID = _AccountID;
//            confirmPayVC.momey = _momey;
//            confirmPayVC.doctiorPhotoPath = _doctiorPhotoPath;
//            confirmPayVC.doctorName = _doctorName;
//            confirmPayVC.diseaseDescriptionModel = ddm;
//            [self.navigationController pushViewController:confirmPayVC animated:YES];
//        }
//
//
//    } failure:^(NSError *error) {
//
//        [self dismissProgress];
//    }];
//}

////支付状态更新接口 -- 免费咨询才会调用
//- (void)requestUpdatePayConsultRecord:(BATDiseaseDescriptionModel *)ddm
//{
//
//    NSDictionary *params = @{
//                             @"ConsultRecordID":[NSNumber numberWithInteger:ddm.ID],
//                             @"Payment":@1,
//                             @"OrderStatus":@"1", //0未支付 1支付成功
//                             @"PayTime":[Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm"]};
//
//    [HTTPTool requestWithURLString:@"/api/OnlineConsult/UpdatePayConsultRecord" parameters:params type:kPOST success:^(id responseObject) {
//
//
//    } failure:^(NSError *error) {
//
//    }];
//}

@end
