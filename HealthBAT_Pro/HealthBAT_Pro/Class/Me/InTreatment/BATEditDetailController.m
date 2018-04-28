//
//  BATEditDetailController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 2016/12/6.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATEditDetailController.h"
#import "BATFileHeaderCell.h"
#import "BATFileDetailCell.h"
@interface BATEditDetailController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) UITableView *fileTab;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *totalArr;
@property (nonatomic,assign) NSInteger selectType;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) UIView *blackView;
@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,strong) NSString *nameString;
@property (nonatomic,strong) NSString *phoneString;
@property (nonatomic,strong) NSString *ageString;
@property (nonatomic,strong) NSString *sexString;
@property (nonatomic,strong) NSString *idString;
@property (nonatomic,strong) NSString *relateString;
@property (nonatomic,strong) NSString *heightString;
@property (nonatomic,strong) NSString *weightString;

@property (nonatomic,strong) NSString *photoPath;

@property (nonatomic,assign) BOOL isAgeSelet;
@property (nonatomic,assign) BOOL isSexSelet;
@property (nonatomic,assign) BOOL isRelateSelet;
@property (nonatomic,assign) BOOL isHeightSelet;
@property (nonatomic,assign) BOOL isWeightSelet;
@end

@implementation BATEditDetailController

static NSString *const HeaderCell = @"HEADERCELL";
static NSString *const detailCell = @"DETAILCELL";
static NSString *const textfiledDetailCell = @"TEXTFILEDDETAILCELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self pageLayout];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStylePlain handler:^(id sender) {
       
        [self uploadFiledRequest];
        
    }];
}

-(void)pageLayout {

    if (self.model) {
        self.photoPath = self.model.photoPath;
        self.nameString = self.model.name;
        self.phoneString = self.model.phoneNumber;
        self.ageString = self.model.ages;
        if ([self.model.Sex isEqualToString:@"1"]) {
            self.sexString = @"男";
        }else {
            self.sexString = @"女";
        }
        self.idString = self.model.personID;
        
        self.relateString = self.model.relateship;
        if (self.model.weight !=0 ) {
            self.weightString = [NSString  stringWithFormat:@"%@kg",self.model.weight];
        }
        if (self.model.height != 0) {
            self.heightString = [NSString  stringWithFormat:@"%@cm",self.model.height];
        }
    }
    
    if (self.isAdd) {
        self.title = @"添加档案信息";
    }else {
        self.title = @"编辑档案信息";
    }
    
    self.selectType = 9;
    
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
    
    NSArray *relateshipArr=  @[@"配偶",@"父亲",@"母亲",@"儿子",@"女儿",@"其他"];
    
    NSMutableArray *heightArr = [NSMutableArray array];
    for (int i=0; i<151; i++) {
        [heightArr addObject:[NSString stringWithFormat:@"%zd",i+100]];
    }
    
    NSMutableArray *weightArr = [NSMutableArray array];
    for (int i=0; i<250; i++) {
        [weightArr addObject:[NSString stringWithFormat:@"%zd",i+1]];
    }
    
    self.totalArr = @[ageArr,sexArr,relateshipArr,heightArr,weightArr];
    
    self.titleArr = @[@[@"头像",@"姓名",@"手机",@"年龄",@"性别",@"身份证"],@[@"关系"],@[@"身高",@"体重"]];
    
    [self.view addSubview:self.fileTab];
}

-(void)isInsertFiled:(BOOL)isadd {
    
    if (self.photoPath == nil) {
//        [self showText:@"请先上传头像"];
        self.photoPath = @"";
    }
    if (self.nameString == nil || [self.nameString isEqualToString:@""]) {
        [self showText:@"请填写名字"];
        return;
    }
    if (self.phoneString == nil || [self.phoneString isEqualToString:@""]) {
        [self showText:@"请输入手机号码"];
        return;
    }
    if (self.sexString == nil) {
        [self showText:@"请选择性别"];
        return;
    }
    if (self.idString == nil || [self.idString isEqualToString:@""]) {
        [self showText:@"请输入身份证号码"];
        return;
    }else {

            BOOL isRight =  [Tools verifyIDCardNumber:self.idString];
            if (!isRight) {
                [self showText:@"请输入正确身份证号码"];
                return;
            }
        }
    
    
    if (self.relateString == nil || [self.relateString isEqualToString:@""]) {
        [self showText:@"请选择身份"];
        return;
    }
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.photoPath forKey:@"PhotoPath"];
    [dict setValue:self.nameString forKey:@"MemberName"];
    [dict setValue:self.phoneString forKey:@"Mobile"];
    if (self.ageString != nil) {
         [dict setValue:self.ageString forKey:@"Ages"];
    }
    
    [dict setValue:self.model.memberID forKey:@"MemberID"];
    
    NSInteger isPer = 0;
    if (self.model.IsPerfect) {
        isPer = 1;
    }else {
        isPer = 0;
    }
    [dict setObject:@(isPer) forKey:@"IsPerfect"];
    
    NSInteger sexTag = 0;
    if ([self.sexString isEqualToString:@"女"]) {
        sexTag = 0;
    }else {
        sexTag = 1;
    }
    [dict setValue:@(sexTag) forKey:@"Sex"];
    
    [dict setValue:self.idString forKey:@"IDNumber"];

    NSInteger relateTag = 0;
    if ([self.relateString isEqualToString:@"配偶"]) {
        relateTag = 1;
    }
    if ([self.relateString isEqualToString:@"父亲"]) {
        relateTag = 2;
    }
    if ([self.relateString isEqualToString:@"母亲"]) {
        relateTag = 3;
    }
    if ([self.relateString isEqualToString:@"儿子"]) {
        relateTag = 4;
    }
    if ([self.relateString isEqualToString:@"女儿"]) {
        relateTag = 5;
    }
    if ([self.relateString isEqualToString:@"其他"]) {
        relateTag = 6;
    }
    [dict setValue:@(relateTag) forKey:@"Relation"];
    if (self.heightString != nil) {
        NSInteger length = self.heightString.length;
        NSString *subString = [self.heightString substringToIndex:length-2];
        [dict setValue:subString forKey:@"Height"];
    }
    if (self.weightString != nil) {
        NSInteger length = self.weightString.length;
        NSString *subString = [self.weightString substringToIndex:length-2];
        [dict setValue:subString forKey:@"Weight"];
    }
    
    [self showProgressWithText:@"正在提交"];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (isadd) {
        
        [HTTPTool requestWithURLString:@"/api/NetworkMedical/InsertUserMember" parameters:dict type:kPOST success:^(id responseObject) {
            [self showText:@"添加成功"];
             self.navigationItem.rightBarButtonItem.enabled = YES;
            if (self.RefreshBlock) {
                self.RefreshBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self showErrorWithText:error.localizedDescription];

             self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
        
    }else {
     
        [HTTPTool requestWithURLString:@"/api/NetworkMedical/UpdateUserMember" parameters:dict type:kPOST success:^(id responseObject) {
            [self showText:@"更新成功"];
              self.navigationItem.rightBarButtonItem.enabled = YES;
            if (self.RefreshBlock) {
                self.RefreshBlock();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self dismissProgress];

              self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    }
}


#pragma mark -UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return 6;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    return 0;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    backView.backgroundColor = BASE_BACKGROUND_COLOR;
    return backView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 54.5;
        }else {
            return 45;
        }
    }else {
        return 45;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BATFileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCell];
            [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:self.photoPath] placeholderImage:[UIImage imageNamed:@"医生"]];
            cell.titleLb.text = @"头像";
            return cell;
        } else if (indexPath.row == 1) {    
            BATFileDetailTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textfiledDetailCell];
            cell.titleLb.text = @"姓名";
            if (self.nameString != nil) {
                cell.detailFiled.text = self.nameString;
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else if(indexPath.row == 2){
            BATFileDetailTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textfiledDetailCell];
            cell.titleLb.text = @"手机";
            if (self.phoneString != nil) {
                cell.detailFiled.text = self.phoneString;
            }
            cell.detailFiled.keyboardType = UIKeyboardTypePhonePad;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        } else if(indexPath.row == 5) {
            BATFileDetailTextFiledCell *cell = [tableView dequeueReusableCellWithIdentifier:textfiledDetailCell];
            cell.titleLb.text = @"身份证";
            if (self.idString != nil) {
                cell.detailFiled.text = self.idString;
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else{
            BATFileDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCell];
            cell.titleLb.text = self.titleArr[indexPath.section][indexPath.row];
            switch (indexPath.row) {
                case 3: {
                    if (self.ageString == nil) {
                        cell.detailLb.text = @"选填";
                    }else {
                        cell.detailLb.text = self.ageString;
                    }
                     cell.detailLb.textColor = UIColorFromHEX(0X999999, 1);
                }
                    break;
                case 4: {
                    if (self.sexString == nil) {
                        cell.detailLb.text = @"必填";
                        cell.detailLb.textColor = UIColorFromHEX(0Xff3b3b, 1);
                    }else {
                        cell.detailLb.text = self.sexString;
                        cell.detailLb.textColor = UIColorFromHEX(0X999999, 1);
                    }
                }
                    break;
            }
            return cell;
        }
    }else if(indexPath.section == 1) {
        BATFileDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCell];
        cell.titleLb.text = self.titleArr[indexPath.section][indexPath.row];
        if (self.relateString == nil) {
            cell.detailLb.text = @"必填";
            cell.detailLb.textColor = UIColorFromHEX(0Xff3b3b, 1);
        }else{
            cell.detailLb.text = self.relateString;
            cell.detailLb.textColor = UIColorFromHEX(0X999999, 1);
        }
        return cell;
    }else {
        BATFileDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCell];
        cell.titleLb.text = self.titleArr[indexPath.section][indexPath.row];
        switch (indexPath.row) {
            case 0:
                if (self.heightString == nil) {
                    cell.detailLb.text = @"选填";
                }else {
                    cell.detailLb.text = self.heightString;
                }
                 cell.detailLb.textColor = UIColorFromHEX(0X999999, 1);
                break;
            case 1:
                if (self.weightString == nil) {
                    cell.detailLb.text = @"选填";
                }else {
                    cell.detailLb.text = self.weightString;
                }
                 cell.detailLb.textColor = UIColorFromHEX(0X999999, 1);
                break;
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
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
        }else if (indexPath.row == 3) {
            self.selectType = 0;
            [self showViewCommomModthWithTage:19];
            self.isAgeSelet = NO;
        }else if(indexPath.row == 4){
            self.selectType = 1;
            self.isSexSelet = NO;
            [self showViewCommomModthWithTage:0];
        }
    }else if(indexPath.section == 1) {
        self.selectType = 2;
        self.isRelateSelet = NO;
        [self showViewCommomModthWithTage:3];
    }else if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            self.selectType = 3;
            self.isHeightSelet = NO;
            [self showViewCommomModthWithTage:50];
        }else {
            self.selectType = 4;
            self.isWeightSelet = NO;
            [self showViewCommomModthWithTage:49];
        }
    }    
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
            self.ageString = selectString;
            self.isAgeSelet = YES;
        }
            break;
        case 1: {
            self.sexString = selectString;
            self.isSexSelet = YES;
        }
            break;
        case 2: {
            self.relateString = selectString;
            self.isRelateSelet = YES;
        }
            break;
        case 3: {
            self.heightString = [NSString stringWithFormat:@"%@cm",selectString];
            self.isHeightSelet = YES;
        }
            break;
        case 4: {
            self.weightString = [NSString stringWithFormat:@"%@kg",selectString];
            self.isWeightSelet = YES;
        }
            break;
        default:
            break;
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = self.totalArr[self.selectType][row];
    return string;
}

#pragma mark -Action
-(void)comfrimAction {
    self.blackView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    }];
    switch (self.selectType) {
        case 0:
            if (!self.isAgeSelet) {
                self.ageString = self.totalArr[self.selectType][19];
            }
             [self.fileTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case 1:
            if (!self.isSexSelet) {
                self.sexString = self.totalArr[self.selectType][0];
            }
            [self.fileTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case 2:
            if (!self.isRelateSelet) {
                self.relateString = self.totalArr[self.selectType][3];
            }
             [self.fileTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case 3:
            if (!self.isHeightSelet) {
                self.heightString = [NSString stringWithFormat:@"%@cm",self.totalArr[self.selectType][50]];
            }
             [self.fileTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case 4:
            if (!self.isWeightSelet) {
                self.weightString = [NSString stringWithFormat:@"%@kg",self.totalArr[self.selectType][49]];
            }
            [self.fileTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        default:
            break;
    }
}

-(void)cancleAction {
    self.blackView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.showView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 250);
    }];
    
    switch (self.selectType) {
        case 0: {
            self.isAgeSelet = NO;
        }
            break;
        case 1: {
            self.isSexSelet = NO;
        }
            break;
        case 2: {
            self.isRelateSelet = NO;
        }
            break;
        case 3: {
            self.isHeightSelet = NO;
        }
            break;
        case 4: {
            self.isWeightSelet = NO;
        }
            break;
        default:
            break;
    }
    
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
        DDLogDebug(@"%@",imageModel.url);
        self.photoPath = imageModel.url;
        [self.fileTab reloadData];
    } failure:^(NSError *error) {

        [self showErrorWithText:@"上传失败"];

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
//        
//        NSMutableArray *imageModelArray = [BATImage mj_objectArrayWithKeyValuesArray:imageArray];
//        BATImage *imageModel = [imageModelArray firstObject];
//        NSLog(@"%@",imageModel.url);
//        self.photoPath = imageModel.url;
//        [self.fileTab reloadData];
//    } failure:^(NSError *error) {
//        [self showErrorWithText:@"上传失败"];
//        
//    }];
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

#pragma mark -NET
-(void)uploadFiledRequest {
    
    BATFileDetailTextFiledCell *nameCell = (BATFileDetailTextFiledCell *)[self.fileTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    self.nameString = nameCell.detailFiled.text;
    
    BATFileDetailTextFiledCell *phoneCell = (BATFileDetailTextFiledCell *)[self.fileTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    self.phoneString = phoneCell.detailFiled.text;
    
    BATFileDetailTextFiledCell *idCell = (BATFileDetailTextFiledCell *)[self.fileTab cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    self.idString = idCell.detailFiled.text;
    
    [self isInsertFiled:self.isAdd];
    
}

#pragma mark -Setter
-(UITableView *)fileTab {
    if (!_fileTab) {
        _fileTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];

        [_fileTab setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_fileTab registerClass:[BATFileHeaderCell class] forCellReuseIdentifier:HeaderCell];
        [_fileTab registerClass:[BATFileDetailCell class] forCellReuseIdentifier:detailCell];
        [_fileTab registerClass:[BATFileDetailTextFiledCell class] forCellReuseIdentifier:textfiledDetailCell];
        _fileTab.tableFooterView = [self tableFooterView];

        _fileTab.delegate = self;
        _fileTab.dataSource = self;
        _fileTab.backgroundColor = BASE_BACKGROUND_COLOR;
        _fileTab.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    }
    return _fileTab;
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
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = BASE_BACKGROUND_COLOR;
        [_showView addSubview:lineView];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 40)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:cancelBtn];
        
        UIButton *comfirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40)];
        [comfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [comfirmBtn setTitleColor:BASE_COLOR forState:UIControlStateNormal];
        [comfirmBtn addTarget:self action:@selector(comfrimAction) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:comfirmBtn];
        
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 41, SCREEN_WIDTH, 210)];
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        [_showView addSubview:self.pickerView];

        [self.view addSubview:_showView]; 
        
    }
    return _showView;
}

-(UIView *)tableFooterView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    view.backgroundColor = BASE_BACKGROUND_COLOR;
    
    UILabel *deletVeiw = [[UILabel alloc]initWithFrame:CGRectMake(14, 10, SCREEN_WIDTH-28, 44)];
    deletVeiw.text = @"删除此档案";
    deletVeiw.clipsToBounds = YES;
    deletVeiw.layer.cornerRadius = 5;
    deletVeiw.textColor = [UIColor whiteColor];
    deletVeiw.backgroundColor = UIColorFromHEX(0Xff3b3b, 1);
    deletVeiw.textAlignment = NSTextAlignmentCenter;
    deletVeiw.userInteractionEnabled = YES;
    [view addSubview:deletVeiw];
    
    WEAK_SELF(self)
    [deletVeiw bk_whenTapped:^{
        STRONG_SELF(self)
        [self showProgressWithText:@"正在删除档案"];
        deletVeiw.userInteractionEnabled = NO;
        [HTTPTool requestWithURLString:@"/api/NetworkMedical/DeleteUserMember" parameters:@{@"ID":@(self.model.ID)} type:kGET success:^(id responseObject) {
            deletVeiw.userInteractionEnabled = YES;
            [self showText:@"删除成功"];
            if (self.RefreshBlock) {
                self.RefreshBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self showErrorWithText:error.localizedDescription];

            deletVeiw.userInteractionEnabled = YES;
        }];
    }];
    
    
    
    NSString *tipsStr = @"填写身份证便于您使用医疗服务,我们承诺保护您的隐私";
    CGSize size = [tipsStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-28, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    UILabel *tipsLb = [[UILabel alloc]init];
    tipsLb.font = [UIFont systemFontOfSize:14];
    tipsLb.textColor = UIColorFromHEX(0X999999, 1);
    tipsLb.numberOfLines = 0;
    tipsLb.text = tipsStr;
    tipsLb.textAlignment = NSTextAlignmentCenter;
    [view addSubview:tipsLb];
    
    if (self.isAdd) {
        deletVeiw.hidden = YES;
        tipsLb.frame = CGRectMake(14, 20, SCREEN_WIDTH-28, size.height);
    }else {
        tipsLb.frame = CGRectMake(14, CGRectGetMaxY(deletVeiw.frame)+20, SCREEN_WIDTH-28, size.height);
    }
    
    
    return view;
}
@end
