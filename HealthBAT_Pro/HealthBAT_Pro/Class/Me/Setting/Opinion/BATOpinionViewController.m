//
//  SendPublishViewController.m
//  CancerNeighbour
//
//  Created by Wilson on 15/10/27.
//  Copyright © 2015年 KM. All rights reserved.
//

#import "BATOpinionViewController.h"
#import "NSString+Common.h"
#import "BATMenusModel.h"
#import "BATBaseModel.h"

//#import "StarsView.h"
#import "YYText.h"

#import "BATWriteTextViewTableViewCell.h"
#import "BATAddPicTableViewCell.h"
#import "TZImagePickerController.h"
#import "BATUploadImageModel.h"
#import "TZImageManager.h"
#import "BATOpinionFooterView.h"
#import "BATFeedbackCell.h"
@interface BATOpinionViewController () <YYTextViewDelegate,BATAddPicTableViewCellDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

//@property (nonatomic,strong) YYTextView *feedBackContentTextView;
//@property (nonatomic,strong) UILabel *wordNumberLabel;


@property (nonatomic,strong) UITableView *tableView;

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

/**
 意见反馈
 */
@property (nonatomic,copy) NSString *feekback;
/**
 邮箱
 */
@property (nonatomic,copy) NSString *emailStr;
/**
 提交
 */
@property (nonatomic,strong) BATOpinionFooterView *opinionFooterView;

@end

@implementation BATOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"意见反馈";
    [self.tableView registerClass:[BATFeedbackCell class] forCellReuseIdentifier:NSStringFromClass([BATFeedbackCell class])];
    
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction:)];
//    rightItem.enabled = NO;
//    self.navigationItem.rightBarButtonItem = rightItem;
//    
//    if (self.navigationController.viewControllers.count == 1) {
//        WEAK_SELF(self);
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"关闭" style:UIBarButtonItemStyleDone handler:^(id sender) {
//            STRONG_SELF(self);
//            [self.view endEditing:YES];
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
//        
//        self.navigationItem.leftBarButtonItem = backItem;
//    }
    
    [self layoutPages];
    
    [self.tableView registerClass:[BATWriteTextViewTableViewCell class] forCellReuseIdentifier:@"BATWriteTextViewTableViewCell"];
    [self.tableView registerClass:[BATAddPicTableViewCell class] forCellReuseIdentifier:@"BATAddPicTableViewCell"];
    
//    [self.feedBackContentTextView becomeFirstResponder];
    
    _picDataSource = [NSMutableArray array];
    _tempPicArray = [NSMutableArray array];
    _dynamicImgArray = [NSMutableArray array];
    
    _feekback = @"";

}

- (void)didReceiveMemoryWarning {
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
    return 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return 45;
    }else if (indexPath.row == 1) {
        return 150;
    }else{
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        BATFeedbackCell *feedbackCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BATFeedbackCell class])];
//        feedbackCell.backgroundColor = [UIColor redColor];
        return feedbackCell;
    }else if (indexPath.row == 1) {
        BATWriteTextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATWriteTextViewTableViewCell" forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.textView.placeholderText = @"您的意见和建议，对我们非常重要";
        cell.textView.text = _feekback;
        cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/800",(unsigned long)_feekback.length];
        return cell;
    }else {
        
    BATAddPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATAddPicTableViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.titleLabel.text = @"添加照片";
    cell.messageLabel.text = @"具体反馈页面或其它图片";
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
    BATWriteTextViewTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if (textView.text.length > 0) {
        _opinionFooterView.submitBtn.enabled = YES;
    } else if (_picDataSource.count == 0 && textView.text.length == 0) {
        _opinionFooterView.submitBtn.enabled = NO;
    }
    
//    if (textView.text.length > 0) {
//        _opinionFooterView.submitBtn.enabled = YES;
//    }
//    else if (textView.text.length <= 0) {
//        _opinionFooterView.submitBtn.enabled = NO;
//    }
    
    if (textView.text.length > 800) {
        [self showText:@"最多输入800个字"];
        textView.text = [textView.text substringToIndex:800];
    }
    _feekback = textView.text;
    cell.wordCountLabel.text = [NSString stringWithFormat:@"%ld/800",(unsigned long)_feekback.length];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //实现textView.delegate  实现回车发送,return键发送功能
    if ([@"\n" isEqualToString:text]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - BATAddPicTableViewCellDelegate
- (void)collectionViewItemClicked:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.row == _picDataSource.count) {
        
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
        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"操作" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        WEAK_SELF(self);
//        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            STRONG_SELF(self);
//            [self deletePic:indexPath];
//        }];
//        
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        
//        [alertController addAction:deleteAction];
//        [alertController addAction:cancelAction];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
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
    [_picDataSource removeObjectAtIndex:indexPath.row];
    [_dynamicImgArray removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    
    if (_picDataSource.count == 0 && _feekback.length == 0 ) {
        _opinionFooterView.submitBtn.enabled = NO;
    }
    
}

- (void)submitBtnAction:(UIButton *)button
{
    BATFeedbackCell *emailCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _emailStr = emailCell.textFiled.text;
//    NSLog(@"%@---",emailCell.textFiled.text);
    if (![_emailStr isEmail]) {
        [self showText:@"邮箱格式错误"];
        return;
    }
    if (_picDataSource.count !=0 || _feekback.length !=0) {
        _opinionFooterView.submitBtn.enabled = NO;
    }else{
        _opinionFooterView.submitBtn.enabled = NO;
    }
    
    
    if (self.className.length == 0) {
        //没有从别的界面过来
        self.className = @"";
        self.titleName = @"";
    }
    
    [self feedBackRequest];

}

- (void)hiddenKeyboard:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
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
        [self.tableView reloadData];

        _opinionFooterView.submitBtn.enabled = YES;
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
//        [_dynamicImgArray addObjectsFromArray:[BATImage mj_objectArrayWithKeyValuesArray:imageArray]];
//        [self.tableView reloadData];
//        
//        _opinionFooterView.submitBtn.enabled = YES;
//        
//    } failure:^(NSError *error) {
//        
//    }];
}


//#pragma mark - YYTextViewDelegate
//- (void)textViewDidChange:(YYTextView *)textView {
//
//    if (textView.text.length >= 800) {
//        [self showText:@"最多800个字"];
//        textView.text = [textView.text substringToIndex:800];
//    }
//    self.wordNumberLabel.text = [NSString stringWithFormat:@"%ld/800",(unsigned long)textView.text.length];
//
//    if (textView.text.length > 0) {
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }
//    if (textView.text.length == 0) {
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    }
//}
//
//#pragma mark - action
//- (void) rightBtnAction:(id)sender {
//
//    NSString *text = [self.feedBackContentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//
//    if (text.length == 0) {
//        [self showText:@"请输入意见"];
//        return;
//    }
//
//    if (self.className.length == 0) {
//        //没有从别的界面过来
//        self.className = @"";
//        self.titleName = @"";
//    }
//    
//    [self feedBackRequest];
//}

- (void)leaveOpinionVC {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - NET
- (void) feedBackRequest {
    
    NSMutableArray *imgs = [[NSMutableArray alloc] init];
    
    for (BATImage *batImage in _dynamicImgArray) {
        [imgs addObject:batImage.url];
    }
    
    [HTTPTool requestWithURLString:@"/api/FeedBack/InsertFeedBack"
                        parameters:@{
                                     @"OpinionsContent":_feekback,
                                     @"MenuName":self.className,
                                     @"Email":_emailStr,
                                     @"Source":@"iOS",
                                     @"Version":[Tools getLocalVersion],
                                     @"MenuId":@(1),
                                     @"Title":self.titleName.length==0?@"":self.titleName,
                                     @"PictureUrl":[imgs componentsJoinedByString:@","]
                                     }
                              type:kPOST
                           success:^(id responseObject) {
                               _opinionFooterView.submitBtn.enabled = YES;
                               if ([responseObject[@"ResultMessage"] isEqualToString:@"操作成功"]) {
                                   [self showSuccessWithText:@"我们已收到您的反馈意见，谢谢!"];
                               }
//                               [self showSuccessWithText:responseObject[@"ResultMessage"]];
                               [self performSelector:@selector(leaveOpinionVC) withObject:nil afterDelay:1.5];
                               
                           } failure:^(NSError *error) {
                               [self showErrorWithText:error.localizedDescription];
                               _opinionFooterView.submitBtn.enabled = YES;
                           }];
    
}

#pragma mark - layout
- (void)layoutPages {
//    [self.view addSubview:self.feedBackContentTextView];
//    [self.feedBackContentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.equalTo(self.view).offset(10);
//        make.right.equalTo(self.view).offset(-10);
//        make.bottom.equalTo(self.view).offset(-320);
//    }];
//
//    [self.view addSubview:self.wordNumberLabel];
//    [self.wordNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.feedBackContentTextView.mas_bottom);
//        make.right.equalTo(self.view.mas_right).offset(-10);
//    }];
    
    [self.view addSubview:self.tableView];
    
    WEAK_SELF(self);
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.tableFooterView = self.opinionFooterView;
    
}

#pragma mark - getter
//- (YYTextView *)feedBackContentTextView {
//    if (!_feedBackContentTextView) {
//        _feedBackContentTextView = [[YYTextView alloc] init];
//        _feedBackContentTextView.placeholderText = @"您的意见和建议，对我们非常重要";
//        _feedBackContentTextView.placeholderFont = [UIFont systemFontOfSize:15];
//        _feedBackContentTextView.font = [UIFont systemFontOfSize:15];
//        _feedBackContentTextView.delegate = self;
//        _feedBackContentTextView.backgroundColor = UIColorFromRGB(246, 246, 246, 1);;
//    }
//    return _feedBackContentTextView;
//}
//
//- (UILabel *)wordNumberLabel {
//    if (!_wordNumberLabel) {
//        _wordNumberLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:14] textColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentRight];
//        _wordNumberLabel.text = @"0/800";
//    }
//    return _wordNumberLabel;
//}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (BATOpinionFooterView *)opinionFooterView
{
    if (!_opinionFooterView) {
        _opinionFooterView = [[BATOpinionFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80.0f)];
        [_opinionFooterView.submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _opinionFooterView;
}

@end
