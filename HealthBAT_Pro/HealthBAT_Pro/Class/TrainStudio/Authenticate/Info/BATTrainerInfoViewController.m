//
//  BATTrainerInfoViewController.m
//  HealthBAT_Pro
//
//  Created by Skybrim on 2017/3/20.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATTrainerInfoViewController.h"
#import "BATTrainStudioAvatarTableViewCell.h"
#import "BATTrainInfoTableViewCell.h"
#import "BATTrainInfoFooterView.h"
#import "BATTrainStudioSelectView.h"
#import "BATTitlePickerView.h"
#import "BATDepartmentPickerView.h"

#import "BATBaseModel.h"
#import "BATLoginModel.h"

#import "BATTrainResultViewController.h"

#import <AVFoundation/AVFoundation.h>

static  NSString * const TRAIN_AVATAR_CELL = @"BATTrainStudioAvatarTableViewCell";
static  NSString * const TRAIN_INFO_CELL = @"BATTrainInfoTableViewCell";

@interface BATTrainerInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,BATDepartmentPickerViewDelegate,BATTitlePickerViewDelegate>

@property (nonatomic,strong) UITableView *trainerInfoTableView;
@property (nonatomic,copy) NSArray *titleArray;
@property (nonatomic,copy) NSArray *placeholderArray;

@property (nonatomic,copy) NSString *doctorPic;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *hospital;
@property (nonatomic,copy) NSString *departmentID;
@property (nonatomic,copy) NSString *department;
@property (nonatomic,copy) NSString *positionalTitle;
@property (nonatomic,assign) NSInteger positionalTitleType;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *identificationCard;
@property (nonatomic,copy) NSString *course;

@property (nonatomic,copy) NSArray *positionalTitleArray;
@property (nonatomic,copy) NSArray *courseArray;

@property (nonatomic,strong) BATTrainStudioSelectView *selectView;
@property (nonatomic,strong) BATTitlePickerView *titlePickerView;
@property (nonatomic,strong) BATDepartmentPickerView *departmentPickerView;

@property (nonatomic,strong) BATTrainInfoFooterView *footerView;

@end

@implementation BATTrainerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"培训认证";
    
    self.titleArray = @[
                        @"",
                        @"*姓名",
                        @"*医院",
                        @"*科室",
                        @"*职称",
                        @"*手机",
                        @"*身份证号",
                        @"*擅长课程",
                        ];
    self.placeholderArray = @[
                              @"",
                              @"请输入姓名",
                              @"请输入医院",
                              @"请选择科室",
                              @"请选择职称",
                              @"请输入手机号码",
                              @"请输入身份证号码",
                              @"最多可选择2个擅长的课程",
                              ];
    
    self.doctorPic = @"";
    self.name = @"";
    self.hospital = @"";
    self.departmentID = @"";
    self.department = @"";
    self.positionalTitle = @"";
    self.phone = @"";
    self.identificationCard = @"";
    self.course = @"";

    self.positionalTitleArray = @[@"住院医师", @"主治医师",@"副主任医师", @"主任医师"];
    self.courseArray = @[@"护理学",@"内科护理",@"外科护理",@"妇产科护理",@"儿科护理",@"社区护理 ",@"养老护理",];
    
    [self pagesLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        //头像
        BATTrainStudioAvatarTableViewCell *avatarCell = [tableView dequeueReusableCellWithIdentifier:TRAIN_AVATAR_CELL forIndexPath:indexPath];
        
        NSDictionary * attDic = @{NSForegroundColorAttributeName:[UIColor redColor]};
        NSRange range = NSMakeRange(0, 1);
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:@"*头像"];
        [attStr setAttributes:attDic range:range];
        avatarCell.titleLabel.attributedText = attStr;

        [avatarCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.doctorPic] placeholderImage:[UIImage imageNamed:@"医生"]];

        return avatarCell;
    }
    
    BATTrainInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TRAIN_INFO_CELL forIndexPath:indexPath];
    
    NSDictionary * attDic = @{NSForegroundColorAttributeName:[UIColor redColor]};
    NSRange range = NSMakeRange(0, 1);
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:self.titleArray[indexPath.row]];
    [attStr setAttributes:attDic range:range];
    cell.titleLabel.attributedText = attStr;
    
//    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.inputTF.placeholder = self.placeholderArray[indexPath.row];
    cell.currentIndex = indexPath;
    
    WEAK_SELF(self);

    switch (indexPath.row) {
        case 1:
        {
            cell.inputTF.text = self.name;
        }
            break;
        case 2:
        {
            cell.inputTF.text = self.hospital;

        }
            break;
        case 3:
        {
            cell.inputTF.text = self.department;
            cell.inputTF.inputView = self.departmentPickerView;

        }
            break;
        case 4:
        {
            cell.inputTF.text = self.positionalTitle;
            
            cell.inputTF.inputView = self.titlePickerView;

        }
            break;
        case 5:
        {
            cell.inputTF.text = self.phone;
            
        }
            break;
        case 6:
        {
            cell.inputTF.text = self.identificationCard;
            
        }
            break;
        case 7:
        {
            cell.inputTF.text = self.course;
            cell.inputTF.userInteractionEnabled = NO;

        }
            break;
        default:
            break;
    }
    
    [cell setEventBlock:^(NSIndexPath *selectIndexPath){
        
        STRONG_SELF(self);
        [self.selectView removeFromSuperview];
        self.selectView = nil;
    }];
    
    [cell setInputBlock:^(NSString *input, NSIndexPath *selectIndexPath) {
        
        STRONG_SELF(self);
                
        switch (selectIndexPath.row) {
            case 1:
            {
                self.name = input;
            }
                break;
            case 2:
            {
                self.hospital = input;
                
            }
                break;
            case 3:
            {
                self.department = input;
                
            }
                break;
            case 4:
            {
               self.positionalTitle = input;
                
            }
                break;
            case 5:
            {
                self.phone = input;
                
            }
                break;
            case 6:
            {
               self.identificationCard = input;
                
            }
                break;
            case 7:
            {
                self.course = input;
                
            }
            default:
                break;
        }

    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 54;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.selectView removeFromSuperview];
    self.selectView = nil;

    
    if (indexPath.row == 0) {
        
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
    else if (indexPath.row == 4){
        
        self.selectView.dataArray = self.positionalTitleArray;
        self.selectView.maxSelected = 1;
        
        [self.view addSubview:self.selectView];
        [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.centerY.equalTo(@-100);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.75, 250));
        }];
        
    }
    else if (indexPath.row == 7 ) {
        
        self.selectView.dataArray = self.courseArray;
        self.selectView.maxSelected = 2;
        
        [self.view addSubview:self.selectView];
        [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.centerY.equalTo(@-100);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.75, 250));
        }];
        
    }
}

#pragma mark - BATTitlePickerViewDelegate
- (void)BATTitlePickerView:(BATTitlePickerView *)titlePickerView didSelectRow:(NSInteger)row titleForRow:(NSString *)title
{
    self.positionalTitle = title;
    self.positionalTitleType = row;
    [self.trainerInfoTableView reloadData];
}

#pragma mark - BATDepartmentPickerViewDelegate
- (void)BATDepartmentPickerView:(BATDepartmentPickerView *)departmentPickerView didSelectRow:(NSInteger)row departmentForRow:(NSDictionary *)department
{
    
    self.departmentID = department[@"ID"];
    self.department = department[@"departmentName"];
    
    [self.trainerInfoTableView reloadData];
    
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [[info objectForKey:UIImagePickerControllerEditedImage] copy];
    
    [self uploadAvatarRequest:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private

//从本地相册获取图片
- (void)getPhotosFromLocal
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

// 拍照
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

#pragma mark - net
- (void)trainingCertificationRequest {

    if ([self.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [self showErrorWithText:@"请输入姓名"];
        return;
    }
    //姓名认证中文
    if (![self.name isChinese]) {
        [self showErrorWithText:@"姓名必须为中文"];
        return;
    }
    if (self.name.length > 10 || self.name.length < 2) {
        [self showErrorWithText:@"姓名字数为2-10个"];
        return;
    }
    if ([self.hospital stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [self showErrorWithText:@"请输入医院"];
        return;
    }
    if ([self.department stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [self showErrorWithText:@"请选择科室"];
        return;
    }
    if ([self.positionalTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [self showErrorWithText:@"请选择职称"];
        return;
    }
    if ([self.phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [self showErrorWithText:@"请输入手机号码"];
        return;
    }
    if ([self.identificationCard stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [self showErrorWithText:@"请输入身份证号码"];
        return;
    }
    if ([self.course stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        [self showErrorWithText:@"请选择擅长的课程"];
        return;
    }
    if (self.doctorPic.length <= 0) {
        [self showErrorWithText:@"请上传您的头像"];
        return;
    }
    
    NSString *tmpCourse = @"";
    if ([self.course containsString:@"，"]) {
        
        NSArray *tmpArray = [self.course componentsSeparatedByString:@"，"];
        for (NSString *string in tmpArray) {
            
            NSInteger tmpIndex = [self.courseArray indexOfObject:string];
            tmpCourse = [tmpCourse stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)tmpIndex+1]];
            if (string != [tmpArray lastObject]) {
                tmpCourse = [tmpCourse stringByAppendingString:@","];
            }
        }
    }
    else {
        NSInteger tmpIndex = [self.courseArray indexOfObject:self.course];
        tmpCourse = [tmpCourse stringByAppendingString:[NSString stringWithFormat:@"%ld",(long)tmpIndex]];
    }
    
    
    
    BATLoginModel *login = LOGIN_INFO;
    
    [HTTPTool requestWithURLString:@"/api/Doctor/TrainingCertification"
                        parameters:@{
                                     @"AccountID":@(login.Data.ID),
                                     @"UserName":self.name,
                                     @"IDNumber":self.identificationCard,
                                     @"HospitalName":self.hospital,
                                     @"DeptId":self.departmentID,
                                     @"DepartmentName":self.department,
                                     @"TitleType":@(self.positionalTitleType),
                                     @"GoodAtType":tmpCourse,
                                     @"PhoneNumber":self.phone,
                                     @"DoctorPic":self.doctorPic,
                                     }
                              type:kPOST
                           success:^(id responseObject) {
                               
                               [self.navigationController pushViewController:[BATTrainResultViewController new] animated:YES];
                               
                               //延时操作，去掉栈中的结果页面
                               [self bk_performBlock:^(id obj) {
                                   
                                   NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                                   for (UIViewController *vc in self.navigationController.viewControllers) {
                                       
                                       if ([vc isKindOfClass:self.class]) {
                                           [vcArray removeObject:vc];
                                       }
                                   }
                                   
                                   self.navigationController.viewControllers = vcArray;
                               } afterDelay:1.0];
              
                               
    }
                           failure:^(NSError *error) {
        
                               [self showErrorWithText:error.localizedDescription];
    }];
     
    
}

- (void)uploadAvatarRequest:(UIImage *)img {
    
    
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
        self.doctorPic = imageModel.url;
        
        [self.trainerInfoTableView reloadData];
    } failure:^(NSError *error) {
        
        [self showErrorWithText:@"上传失败"];
        
    } fractionCompleted:^(double count) {
        
        [self showProgres:count];
        
    }];
}

#pragma mark - layout
- (void)pagesLayout {
    
    [self.view addSubview:self.trainerInfoTableView];
    [self.trainerInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

#pragma mark - getter
- (UITableView *)trainerInfoTableView {
    
    if (!_trainerInfoTableView) {
        _trainerInfoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        [_trainerInfoTableView registerClass:[BATTrainInfoTableViewCell class] forCellReuseIdentifier:TRAIN_INFO_CELL];
        [_trainerInfoTableView registerClass:[BATTrainStudioAvatarTableViewCell class] forCellReuseIdentifier:TRAIN_AVATAR_CELL];

        _trainerInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _trainerInfoTableView.backgroundColor = [UIColor clearColor];
        _trainerInfoTableView.tableFooterView = self.footerView;
        
        _trainerInfoTableView.delegate = self;
        _trainerInfoTableView.dataSource = self;
    }
    return _trainerInfoTableView;
}

- (BATTrainInfoFooterView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[BATTrainInfoFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        WEAK_SELF(self);
        _footerView.submitBlock = ^(){
            STRONG_SELF(self);
            [self.view endEditing:YES];
            [self trainingCertificationRequest];
        };
    }
    return _footerView;
}

- (BATTrainStudioSelectView *)selectView {
    
    if (!_selectView) {
        _selectView = [[BATTrainStudioSelectView alloc] initWithFrame:CGRectZero];
        
        WEAK_SELF(self);
        [_selectView setConfirmBlock:^(NSArray *selectedArray){
            STRONG_SELF(self);
            NSString *content = @"";
            for (NSIndexPath *selectedIndexPath in selectedArray) {
                
                content = [content stringByAppendingString:self.selectView.dataArray[selectedIndexPath.row]];
                if (selectedIndexPath != [selectedArray lastObject]) {
                    content = [content stringByAppendingString:@"，"];
                }
            }
            
            if (self.selectView.dataArray == self.positionalTitleArray) {

                self.positionalTitle = content;
            }
            else if (self.selectView.dataArray == self.courseArray) {
                
                self.course = content;
            }
            
            [self.selectView removeFromSuperview];
            self.selectView = nil;
            
            [self.trainerInfoTableView reloadData];
        }];
    }
    return _selectView;
}

- (BATTitlePickerView *)titlePickerView
{
    if (!_titlePickerView) {
        _titlePickerView = [[BATTitlePickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 256)];
        _titlePickerView.delegate = self;
        WEAK_SELF(self);
        _titlePickerView.cancelBlcok = ^(){
            STRONG_SELF(self);
            [self.view endEditing:YES];
        };
    }
    return _titlePickerView;
}

- (BATDepartmentPickerView *)departmentPickerView
{
    if (!_departmentPickerView) {
        _departmentPickerView = [[BATDepartmentPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 256)];
        _departmentPickerView.delegate = self;
        
        WEAK_SELF(self);
        _departmentPickerView.cancelBlcok = ^(){
            STRONG_SELF(self);
            [self.view endEditing:YES];
        };
    }
    return _departmentPickerView;
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
