//
//  BATPersonInfoViewController.m
//  CancerNeighbour
//
//  Created by Wilson on 15/10/27.
//  Copyright © 2015年 KM. All rights reserved.
//

#import "BATPersonInfoViewController.h"
//ShareCategory

//model
#import "BATPerson.h"
//view
#import "BATSexPickerView.h"
#import "BATAreaPickerView.h"
#import "BATDatePickerView.h"
//cell
#import "BATPersonAvatarCell.h"
#import "BATPersonContentCell.h"
#import "BATPersonContentWithImageCell.h"
//vc
#import "BATEditInfoViewController.h"
#import "BATBindingPhoneViewController.h"
#import "BATChangePhoneViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface BATPersonInfoViewController ()
<
BATSexPickerViewDelegate,
BATDatePickerViewDelegate
>
//<BATSexPickerViewDelegate,BATAreaPickerViewDelegate,BATDatePickerViewDelegate>

/**
 *  个人信息
 */
@property (nonatomic,strong) BATPerson *person;

/**
 *  性别选择
 */
@property (nonatomic,strong) BATSexPickerView *sexPickerView;

/**
 *  籍贯
 */
//@property (nonatomic,strong) BATAreaPickerView *birthplacePickerView;

/**
 *  常住地区
 */
//@property (nonatomic,strong) BATAreaPickerView *areaResidentPickerView;

/**
 *  日期选择
 */
@property (nonatomic,strong) BATDatePickerView *datePickerView;
@property (nonatomic ,strong) NSIndexPath      *datePickerVIndexPath;



/**
 修改前数据
 */
@property (nonatomic,copy) NSString *tmpString;

/**
 临时存储修改类型
 */
@property (nonatomic,assign) EditType tmpType;
@end

@implementation BATPersonInfoViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    self.tvContent.delegate = nil;
    self.tvContent.dataSource = nil;
    self.sexPickerView.delegate = nil;
//    self.birthplacePickerView.delegate = nil;
//    self.areaResidentPickerView.delegate = nil;
//    self.datePickerView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.sexPickerView hide];
//    [self.birthplacePickerView hide];
//    [self.areaResidentPickerView hide];
    [self.datePickerView hide];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    
    //更换手机成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePhoneSucess) name:@"CHANGE_PHONE_SUCCESS" object:nil];
    
    //第三方绑定手机成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindingPhoneSucess) name:@"DINDING_PHONE_SUCCESS" object:nil];
    
    [self pagesLayout];
    
    [self requestGetPersonInfoList];
}

- (void)bindingPhoneSucess{
    [self requestGetPersonInfoList];
}

- (void)changePhoneSucess{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PRESENT_LOGIN_VC;
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 6;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        if (indexPath.row == 0) {
            return 54;
        }
        return 44;
    }else{
        return 44;
    }
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 ) {
        //基本信息
        if (indexPath.row == 0) {
            BATPersonAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATPersonAvatarCell" forIndexPath:indexPath];
            [cell configrationCell:self.person];
            return cell;
        } else {
            BATPersonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATPersonContentCell" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            //手机号暂时不能修改
            if (indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryNone;

            }
            [cell configrationCell:indexPath Model:self.person];
            return cell;
        }
    }else{
        //登入方式
        BATPersonContentWithImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATPersonContentWithImageCell" forIndexPath:indexPath];
        [cell loginAccountCell:indexPath Model:self.person];
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 ) {
        return CGFLOAT_MIN;
    }else{
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.sexPickerView hide];
    [self.datePickerView hide];
//    [self.birthplacePickerView hide];
//    [self.areaResidentPickerView hide];
    
    if (indexPath.section == 0 ) {
        switch (indexPath.row) {
            case 0:
            {
                //头像
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"头像" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                
                UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self getPhotosFromCamera];
                }];
                
                UIAlertAction *photoGalleryAction = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self getPhotosFromLocal];
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertController addAction:cameraAction];
                [alertController addAction:photoGalleryAction];
                [alertController addAction:cancelAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
                break;
            case 2:
            {
                //昵称
                [self editPersonInfoWithType:kEditUserName];
                
            }
                break;
            case 3:
            {
                //性别
                [self.sexPickerView show];
                
            }
                break;
            case 4:
            {
                [self.datePickerView showWithBirthday:self.person.Data.Birthday];
            }
                break;
            case 5:
            {
                //个性签名
                [self editPersonInfoWithType:kEditSignature];
                
            }
                break;
            default:
                break;
        }

    }

}

#pragma mark - BATDatePickerViewDelegate
- (void)batDatePickerView:(BATDatePickerView *)datePickerView didSelectDate:(NSString *)dateString {
    self.person.Data.Birthday = dateString;
    [self dealWithUploadParamas];
}

- (void)batDatePickerView:(BATDatePickerView *)datePickerView selectDateValueChange:(NSString *)dateString {
    self.person.Data.Birthday = dateString;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];//todo(可优化-最好不要写死)
    [self.tvContent reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - BATSexPickerViewDelegate
- (void)BATSexPickerView:(BATSexPickerView *)sexPickerView didSelectRow:(NSInteger)row titleForRow:(NSString *)title
{
    self.person.Data.Sex = [NSString stringWithFormat:@"%ld",(long)row];
    
    [self dealWithUploadParamas];
}

#pragma mark - BATAreaPickerViewDelegate
//- (void)BATAreaPickerView:(BATAreaPickerView *)areaPickerView province:(NSString *)province city:(NSString *)city
//{
//    if (areaPickerView == self.birthplacePickerView) {
//        //籍贯
//        self.person.Data.NativeProvince = province;
//        self.person.Data.NativeCity = city;
//        
//        [self dealWithUploadParamas];
//        
//    } else if (areaPickerView == self.areaResidentPickerView) {
//        //常住
//        self.person.Data.Province = province;
//        self.person.Data.City = city;
//        
//        [self dealWithUploadParamas];
//    }
//}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [[info objectForKey:UIImagePickerControllerEditedImage] copy];
    
    [self requestChangePersonHeadIcon:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NET
#pragma mark - 获取个人信息请求
- (void)requestGetPersonInfoList
{
    
    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:nil type:kGET success:^(id responseObject) {
        
        self.person = [BATPerson mj_objectWithKeyValues:responseObject];
        
        [self.tvContent reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - 更新头像
- (void)requestChangePersonHeadIcon:(UIImage *)img {


    [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(XMRequest *request) {

        UIImage * compressImg  = [Tools compressImageWithImage:img ScalePercent:0.001];
        NSData *imageData = UIImagePNGRepresentation(compressImg);
        [request addFormDataWithName:[NSString stringWithFormat:@"person_headicon"]
                            fileName:[NSString stringWithFormat:@"person_headicon.jpg"]
                            mimeType:@"multipart/form-data"
                            fileData:imageData];
        
    } success:^(NSArray *imageArray) {

        [self showSuccessWithText:@"上传头像成功"];

        NSMutableArray *imageModelArray = [BATImage mj_objectArrayWithKeyValuesArray:imageArray];
        BATImage *imageModel = [imageModelArray firstObject];
        self.person.Data.PhotoPath = imageModel.url;
        [self dealWithUploadParamas];
    } failure:^(NSError *error) {

        [self showErrorWithText:@"上传失败"];

    } fractionCompleted:^(double count) {

        [self showProgres:count];

    }];
}

#pragma mark - 更新个人信息
- (void)requestChangePersonAllInfo:(NSDictionary *)dictParamas
{
    DDLogDebug(@"dictParamas ==== %@",dictParamas);
    [HTTPTool requestWithURLString:@"/api/Patient/Info" parameters:dictParamas type:kPOST success:^(id responseObject) {
        [self.tvContent reloadData];
        [self showText:@"个人信息修改成功" withInterval:1.5];
       // [TalkingData trackEvent:@"100011" label:@"修改个人信息"];
        
    } failure:^(NSError *error) {

        switch (self.tmpType) {
            case kEditUserName: {
                self.person.Data.UserName = self.tmpString ;
                break;
            }
            case kEditSignature: {
                self.person.Data.Signature = self.tmpString;

                break;
            }
            case kEditHeight: {

                break;
            }
            case kEditWeight: {

                break;
            }
            case kEditPastHistory: {
                self.person.Data.Anamnese = self.tmpString;
                break;
            }
            case kEditAllergyHistory: {
                self.person.Data.Allergies = self.tmpString;

                break;
            }
            case kEditHereditaryDisease: {
                self.person.Data.GeneticDisease = self.tmpString;
                break;
            }
            default:
                break;
        }

    }];
}

#pragma mark - Action
#pragma mark - 组装上传参数
- (void)dealWithUploadParamas
{
    
    NSDictionary * dic = @{
                           @"PhotoPath":self.person.Data.PhotoPath == nil?@"0":self.person.Data.PhotoPath,
                           @"UserName":self.person.Data.UserName == nil?@"0":self.person.Data.UserName,
                           @"Sex":self.person.Data.Sex == nil?@"0":self.person.Data.Sex,
                           @"Birthday":[NSString stringWithFormat:@"%@ 00:00:00",self.person.Data.Birthday],
//                           @"Birthday":@"",
//                           @"Province":self.person.Data.Province == nil?@"":self.person.Data.Province,
//                           @"City":self.person.Data.City == nil?@"":self.person.Data.City,
//                           @"Height":[NSNumber numberWithInteger:self.person.Data.Height],
//                           @"Weight":[NSNumber numberWithInteger:self.person.Data.Weight],
//                           @"NativeProvince":self.person.Data.NativeProvince == nil?@"":self.person.Data.NativeProvince,
//                           @"NativeCity":self.person.Data.NativeCity == nil?@"":self.person.Data.NativeCity,
                           @"Signature":self.person.Data.Signature == nil?@"这家伙很懒，什么都没留下":self.person.Data.Signature,
                           @"PatientID":[NSNumber numberWithInteger:self.person.Data.PatientID],
                           @"GeneticDisease":self.person.Data.GeneticDisease == nil?@"无家族遗传病":self.person.Data.GeneticDisease,
                           @"Allergies":self.person.Data.Allergies == nil?@"无过敏史":self.person.Data.Allergies,
                           @"Anamnese":self.person.Data.Anamnese == nil?@"无已往病史":self.person.Data.Anamnese,
                           @"PhoneNumber":self.person.Data.PhoneNumber == nil?@"":self.person.Data.PhoneNumber
                           };
    
    [self requestChangePersonAllInfo:dic];
}

#pragma mark - 修改用户名、体重和身高
- (void)editPersonInfoWithType:(EditType)type
{
    BATEditInfoViewController *editInfoVCtrl = [[BATEditInfoViewController alloc] init];
    editInfoVCtrl.hidesBottomBarWhenPushed = YES;
    self.tmpType = type;
    switch (type) {
        case kEditUserName: {
            self.tmpString = self.person.Data.UserName;
            break;
        }
        case kEditSignature: {
            self.tmpString = self.person.Data.Signature;

            break;
        }
        case kEditHeight: {
//            self.tmpString = self.person.Data.Height;

            break;
        }
        case kEditWeight: {
//            self.tmpString = self.person.Data.Weight;

            break;
        }
        case kEditPastHistory: {
            self.tmpString = self.person.Data.Anamnese;
            break;
        }
        case kEditAllergyHistory: {
            self.tmpString =  self.person.Data.Allergies;

            break;
        }
        case kEditHereditaryDisease: {
            self.tmpString = self.person.Data.GeneticDisease;
            break;
        }
        default:
            break;
    }

    editInfoVCtrl.person = self.person;
    editInfoVCtrl.type = type;
    editInfoVCtrl.editPersonInfoBlock = ^ (BATPerson *pModel) {
        
        switch (type) {
            case kEditUserName: {
                self.person.Data.UserName = pModel.Data.UserName;

                break;
            }
            case kEditSignature: {
                self.person.Data.Signature = pModel.Data.Signature;
                
                break;
            }
            case kEditHeight: {
                self.person.Data.Height = pModel.Data.Height;
                
                break;
            }
            case kEditWeight: {
                self.person.Data.Weight = pModel.Data.Weight;
                
                break;
            }
            case kEditPastHistory: {
                self.person.Data.Anamnese = pModel.Data.Anamnese;
                break;
            }
            case kEditAllergyHistory: {
                self.person.Data.Allergies = pModel.Data.Allergies;
                break;
            }
            case kEditHereditaryDisease: {
                self.person.Data.GeneticDisease = pModel.Data.GeneticDisease;
                break;
            }
            default:
                break;
        }
        
        [self dealWithUploadParamas];
    };
    [self.navigationController pushViewController:editInfoVCtrl animated:YES];
}

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 拍照
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
#pragma mark - pagesLayout
- (void)pagesLayout{
    [self.view addSubview:self.tvContent];
    [self.view addSubview:self.sexPickerView];
//    [self.view addSubview:self.birthplacePickerView];
//    [self.view addSubview:self.areaResidentPickerView];
    [self.view addSubview:self.datePickerView];
}

#pragma mark - set & get

- (UITableView *)tvContent
{
    if (!_tvContent) {
        // 初始化TableView
        _tvContent = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _tvContent.backgroundColor = [UIColor clearColor];
        _tvContent.delegate = self;
        _tvContent.dataSource = self;
        _tvContent.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tvContent registerClass:[BATPersonAvatarCell class] forCellReuseIdentifier:@"BATPersonAvatarCell"];
        [_tvContent registerClass:[BATPersonContentCell class] forCellReuseIdentifier:@"BATPersonContentCell"];
        [_tvContent registerClass:[BATPersonContentWithImageCell class] forCellReuseIdentifier:@"BATPersonContentWithImageCell"];
    }
    return _tvContent;
}

- (BATSexPickerView *)sexPickerView
{
    if (!_sexPickerView) {
        _sexPickerView = [[BATSexPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 256)];
        _sexPickerView.delegate = self;
    }
    return _sexPickerView;
}

//- (BATAreaPickerView *)birthplacePickerView
//{
//    if (!_birthplacePickerView) {
//        _birthplacePickerView = [[BATAreaPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 256)];
//        _birthplacePickerView.delegate = self;
//    }
//    return _birthplacePickerView;
//}

//- (BATAreaPickerView *)areaResidentPickerView
//{
//    if (!_areaResidentPickerView) {
//        _areaResidentPickerView = [[BATAreaPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 256)];
//        _areaResidentPickerView.delegate = self;
//    }
//    return _areaResidentPickerView;
//}

- (BATDatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[BATDatePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 256)];
        _datePickerView.delegate = self;
    }
    return _datePickerView;
}

@end
