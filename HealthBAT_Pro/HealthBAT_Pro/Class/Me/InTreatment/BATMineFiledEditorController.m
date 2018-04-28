//
//  BATMineFiledEditorController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/9.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMineFiledEditorController.h"
#import "BATFileDetailCell.h"
#import "BATFileHeaderCell.h"
@interface BATMineFiledEditorController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) UITableView *mineFiledTab;

@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) UIView *blackView;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSArray *totalArr;
@property (nonatomic,assign) NSInteger selectType;

@property (nonatomic,assign) BOOL isAgeSelet;
@property (nonatomic,assign) BOOL isSexSelet;

@end

@implementation BATMineFiledEditorController

static NSString *const DetailCell = @"DETAILCELL";
static NSString *const TextFiledDetailCell = @"TEXTFILEDDETAILCELL";
static NSString *const HeaderCell = @"HEADERCELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self  pageLayout];
    
    //完成按钮事件
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStylePlain handler:^(id sender) {
        
        BATFileDetailTextFiledCell *nameCell = (BATFileDetailTextFiledCell *)[self.mineFiledTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        self.model.name = nameCell.detailFiled.text;
        
        BATFileDetailTextFiledCell *phoneCell = (BATFileDetailTextFiledCell *)[self.mineFiledTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        self.model.phoneNumber = phoneCell.detailFiled.text;
        
        BATFileDetailTextFiledCell *idCell = (BATFileDetailTextFiledCell *)[self.mineFiledTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
        self.model.personID = idCell.detailFiled.text;

        //上传信息
        [self updateFiledRequest];
        
    }];
}

-(void)pageLayout {
  
    self.title = @"修改档案信息";
    
    NSMutableArray *ageArr = [NSMutableArray array];
    for (int i=0; i<120; i++) {
        [ageArr addObject:[NSString stringWithFormat:@"%zd",i+1]];
    }
    
    NSMutableArray *sexArr = [NSMutableArray array];
    for (int i=0; i<2; i++) {
        switch (i) {
            case 0:
                [sexArr addObject:@"男"];
                break;
            case 1:
                [sexArr addObject:@"女"];
                break;
            default:
                break;
        }
    }
    
    
//    if ([self.model.Sex isEqualToString:@"1"]) {
//        self.model.Sex = @"男";
//    }else {
//        self.model.Sex = @"女";
//    }
    
    self.totalArr = @[ageArr,sexArr];
    
    [self.view addSubview:self.mineFiledTab];
    
}

//上传信息
-(void)updateFiledRequest {
    
    
  
    if (self.model.name == nil ||[self.model.name isEqualToString:@""]) {
        [self showText:@"请填写名字"];
        return;
    }
    if (self.model.phoneNumber == nil ||[self.model.phoneNumber isEqualToString:@""]) {
        [self showText:@"请填写手机号码"];
        return;
    }
    if (self.model.personID == nil ||[self.model.personID isEqualToString:@""]) {
        [self showText:@"请填写身份证号码"];
        return;
    }else {
        if (![Tools verifyIDCardNumber:self.model.personID]) {
            [self showText:@"请填写正确身份证号码"];
            return;
        }
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setValue:self.model.photoPath forKey:@"PhotoPath"];
    [dict setValue:self.model.name forKey:@"MemberName"];
    [dict setValue:self.model.phoneNumber forKey:@"Mobile"];
    [dict setValue:self.model.ages forKey:@"Ages"];
    
    if ([self.model.Sex isEqualToString:@"0"]) {
        [dict setValue:@(0) forKey:@"Sex"];
    }else {
        [dict setValue:@(1) forKey:@"Sex"];
    }
    
    [dict setValue:self.model.personID forKey:@"IDNumber"];
    
    [dict setValue:@(0) forKey:@"Relation"];
    
    NSInteger isPer = 0;
    if (self.model.IsPerfect) {
        isPer = 1;
    }else {
        isPer = 0;
    }
    [dict setObject:@(isPer) forKey:@"IsPerfect"];
    
    
    NSString *heightStr = [NSString stringWithFormat:@"%@cm",self.model.height];
    NSInteger heightLenght = heightStr.length - 2;
    NSString *subString = [heightStr substringToIndex:heightLenght];
    [dict setValue:subString forKey:@"Height"];
    
    
    NSString *weightStr = [NSString stringWithFormat:@"%@kg",self.model.weight];
    NSInteger weightLength = weightStr.length - 2;
    NSString *weightSubString = [weightStr substringToIndex:weightLength];
    [dict setValue:weightSubString forKey:@"Weight"];
    
    
    [dict setValue:self.model.Exercise forKey:@"Exercise"];
    [dict setValue:self.model.Sleep forKey:@"Sleep"];
    [dict setValue:self.model.Dietary forKey:@"Dietary"];
    [dict setValue:self.model.Mentality forKey:@"Mentality"];
    [dict setValue:self.model.Working forKey:@"Working"];
    
    [dict setValue:self.model.memberID forKey:@"MemberID"];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self showProgressWithText:@"正在提交"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/UpdateUserMember" parameters:dict type:kPOST success:^(id responseObject) {
        [self dismissProgress];
        if (self.refreshBlock) {
            self.refreshBlock(YES);
        }
        if (self.refreshSexAndAge) {
            self.refreshSexAndAge(self.model.name,self.model.Sex,self.model.ages);
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];

        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}


#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 76.5;
    }else {
        return 45;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BATFileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCell];
        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:self.model.photoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
        cell.titleLb.text = @"头像";
        return cell;
    }else if(indexPath.row == 1) {
        BATFileDetailTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFiledDetailCell];
        cell.titleLb.text = @"姓名";
        cell.detailFiled.text = self.model.name;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if(indexPath.row == 2) {
        BATFileDetailTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFiledDetailCell];
        cell.titleLb.text = @"手机";
        cell.detailFiled.keyboardType =  UIKeyboardTypePhonePad;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.detailFiled.text = self.model.phoneNumber;
        return cell;
    }else if(indexPath.row == 3) {
        BATFileDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCell];
        cell.titleLb.text = @"年龄";
        cell.detailLb.text = self.model.ages;
        return cell;
    }else if(indexPath.row == 4) {
        BATFileDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCell];
        cell.titleLb.text = @"性别";
        if ([self.model.Sex isEqualToString:@"0"]) {
            cell.detailLb.text = @"女";
        }else {
            cell.detailLb.text = @"男";
        }
//        cell.detailLb.text = self.model.Sex;
        return cell;
    }else {
        BATFileDetailTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:TextFiledDetailCell];
        cell.titleLb.text = @"身份证";
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.detailFiled.text = self.model.personID;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.isAgeSelet = NO;
    self.isSexSelet = NO;
    
    if (indexPath.row == 3) {
        self.selectType = 0;
        [self showViewCommomModthWithTage:19];
    }else if(indexPath.row == 4) {
        self.selectType = 1;
        [self showViewCommomModthWithTage:0];
    }
    
    
    if(indexPath.row == 0) {
     
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
}

-(void)showViewCommomModthWithTage:(NSInteger)tage{
    
    self.blackView.hidden = NO;
    
    [self.pickerView reloadAllComponents];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT-250-64, SCREEN_WIDTH, 250);
    }];
    
    [self.pickerView selectRow:tage inComponent:0 animated:YES];
    [self.pickerView reloadAllComponents];
    
}

#pragma mark -UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = [self.totalArr[self.selectType] count];
    return count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 180;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString *selectString = self.totalArr[self.selectType][row];
    switch (self.selectType) {
        case 0: {
            self.model.ages = selectString;
            self.isAgeSelet = YES;
        }
            break;
        case 1: {
            if ([selectString isEqualToString:@"女"]) {
                self.model.Sex = @"0";
            }else {
                self.model.Sex = @"1";
            }
           // self.model.Sex = selectString;
            self.isSexSelet = YES;
        }
            break;
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = self.totalArr[self.selectType][row];
    return string;
}

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

#pragma mark - Action 
-(void)cancleAction {
    self.blackView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    }];
    
    self.isSexSelet = NO;
    self.isAgeSelet = NO;
}

-(void)comfrimAction {
    self.blackView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    }];
    switch (self.selectType) {
        case 0: {
            if (!self.isAgeSelet) {
                self.model.ages = self.totalArr[self.selectType][19];
            }
            NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
            [self.mineFiledTab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
        case 1: {
            if (!self.isSexSelet) {
                self.model.Sex = @"1";
            }
            NSIndexPath *path = [NSIndexPath indexPathForRow:4 inSection:0];
            [self.mineFiledTab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
    }
}

#pragma mark - 拍照
- (void)getPhotosFromCamera
{
    
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

#pragma mark - 从本地相册获取图片
- (void)getPhotosFromLocal
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - 更新头像
- (void)requestChangePersonHeadIcon:(UIImage *)img {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(XMRequest *request) {

        UIImage * compressImg  = [Tools compressImageWithImage:img ScalePercent:0.001];
        NSData *imageData = UIImagePNGRepresentation(compressImg);
        [request addFormDataWithName:[NSString stringWithFormat:@"person_headicon"]
                            fileName:[NSString stringWithFormat:@"person_headicon.jpg"]
                            mimeType:@"multipart/form-data"
                            fileData:imageData];
    
    } success:^(NSArray *imageArray) {
        [self showSuccessWithText:@"上传头像成功"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSMutableArray *imageModelArray = [BATImage mj_objectArrayWithKeyValuesArray:imageArray];
        BATImage *imageModel = [imageModelArray firstObject];
        self.model.photoPath = imageModel.url;

        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.mineFiledTab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {

        [self showErrorWithText:@"上传失败"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } fractionCompleted:^(double count) {

        [self showProgres:count];

    }];

//    [HTTPTool requestUploadImageConstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        UIImage * compressImg  = [Tools compressImageWithImage:img ScalePercent:0.001];
//        NSData *imageData = UIImagePNGRepresentation(compressImg);
//        [formData appendPartWithFileData:imageData
//                                    name:[NSString stringWithFormat:@"person_headicon"]
//                                fileName:[NSString stringWithFormat:@"person_headicon.jpg"]
//                                mimeType:@"multipart/form-data"];
//    } progress:^(NSProgress *uploadProgress) {
//        [self showProgres:uploadProgress.fractionCompleted];
//        
//    } success:^(NSArray *imageArray) {
//        [self showSuccessWithText:@"上传头像成功"];
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//        NSMutableArray *imageModelArray = [BATImage mj_objectArrayWithKeyValuesArray:imageArray];
//        BATImage *imageModel = [imageModelArray firstObject];
//        self.model.photoPath = imageModel.url;
//        
//        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.mineFiledTab reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//    } failure:^(NSError *error) {
//        [self showErrorWithText:@"上传失败"];
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }];
}

#pragma mark -SETTER
-(UITableView *)mineFiledTab {
    if (!_mineFiledTab) {
        _mineFiledTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _mineFiledTab.delegate = self;
        _mineFiledTab.dataSource = self;
        _mineFiledTab.backgroundColor = BASE_BACKGROUND_COLOR;
        [_mineFiledTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _mineFiledTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_mineFiledTab registerClass:[BATFileDetailCell class] forCellReuseIdentifier:DetailCell];
        [_mineFiledTab registerClass:[BATFileDetailTextFiledCell class] forCellReuseIdentifier:TextFiledDetailCell];
        [_mineFiledTab registerClass:[BATFileHeaderCell class] forCellReuseIdentifier:HeaderCell];
    }
    return _mineFiledTab;
}

-(UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        UIColor *color = [UIColor blackColor];
        _blackView.backgroundColor = [color colorWithAlphaComponent:0.6];
        _blackView.hidden = YES;
        [self.view addSubview:_blackView];
    }
    return _blackView;
}

-(UIView *)showView {
    if (!_showView) {
        _showView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250)];
        _showView.backgroundColor = [UIColor whiteColor];
        
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        btnView.backgroundColor = UIColorFromHEX(0Xf2f2f2, 1);
        [_showView addSubview:btnView];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 40)];
        [cancelBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:cancelBtn];
        
        UILabel *cancelLb = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH/2-14, 40)];
        cancelLb.text = @"取消";
        cancelLb.textColor = UIColorFromHEX(0X333333, 1);
        [btnView addSubview:cancelLb];
        
        UIButton *comfirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40)];
        [comfirmBtn addTarget:self action:@selector(comfrimAction) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:comfirmBtn];
        
        UILabel *comfirmLB = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2-14, 40)];
        comfirmLB.text = @"确定";
        comfirmLB.textAlignment = NSTextAlignmentRight;
        comfirmLB.textColor = UIColorFromHEX(0X0182eb, 1);
        [btnView addSubview:comfirmLB];
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 210)];
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        [_showView addSubview:self.pickerView];
        
        [self.view addSubview:_showView];
        
    }
    return _showView;
}

@end
