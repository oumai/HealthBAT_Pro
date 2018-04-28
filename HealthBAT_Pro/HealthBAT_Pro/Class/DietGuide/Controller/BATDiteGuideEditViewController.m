//
//  BATDiteGuideEditViewController.m
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/10/23.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATDiteGuideEditViewController.h"
#import "BATDiteGuideBottomSegementView.h"
#import "BATDiteGuideEditFilterCell.h"
#import "BATDiteGuideEditTagCell.h"
#import "UITextView+InputLimit.h"
#import "UITextView+Placeholder.h"
#import "BATDiteGuideEditTagButton.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
#import "UIImage+Zoom.h"
#import "UIButton+ImagePosition.h"
#import "UIColor+Gradient.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "BATDiteGuideListViewController.h"

#import "BATPerson.h"
#import "BATTextView.h"

static NSString *const FilterCellID = @"BATDiteGuideEditFilterCell";
static NSString *const TagCellID = @"BATDiteGuideEditTagCell";
#define kTag 100
#define kTagTopAndBottomMargin 5
#define kTagRightMargin 10
#define kTagBtnWidth 78
#define kTagBtnHeight 17

@interface BATDiteGuideEditViewController ()<UITextViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) BATTextView *textView;
@property (nonatomic, strong) UICollectionView *bottomCollectionView;
@property (nonatomic, strong) BATDiteGuideBottomSegementView *bottomSegementView;
@property (nonatomic, strong) UIScrollView *selectTagBgScrollView;
@property (nonatomic, strong) NSMutableArray *filterImageDataSouce;
@property (nonatomic, strong) NSArray *filterNameDataSource;
@property (nonatomic, strong) NSArray<NSString *> *tagDataSource;
/**
 点击标签 item 后存储对应的 IndexPath
 */
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *didItemSelectedTagArryM;
/**
 选中的滤镜图片
 */
@property (nonatomic, assign) NSInteger  filterImageSelectedIndex;
/**
 存储删除的标签按钮
 (点击 scrollView上已经选中的按钮获通过按钮 Tag获取 Item的 IndexPath)
 */
@property (nonatomic, strong) NSMutableArray <NSIndexPath *>*didScrollViewTagBtnDeleteTagM;
/**
 选中的标签按钮
 */
@property (nonatomic, strong) NSMutableArray<UIButton *> *selTagsButtonM;
@property (nonatomic, strong) BATPerson *loginUserModel;
/**
 最大输入提示
 */
@property (nonatomic, strong) UILabel *maxInputLabel;
/**
 ScrollView 底部分割线
 */
@property (nonatomic, strong) UIView *selTagBottomLineView;
/**
 图片卡路里值
 */
@property (nonatomic, assign) NSInteger calorieValue;
/**
 上传后的图片的 URL
 */
@property (nonatomic, strong) NSString *updatePhotoURLStr;
/**
 格式化后的标签字符串
 */
@property (nonatomic, strong) NSString *selTagFormatStr;

@end

@implementation BATDiteGuideEditViewController
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    DDLogDebug(@"====BATDiteGuideEditViewController===dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupNav];
    [self initializeData];
    [self setupUI];
    [self addNotification];

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

    [IQKeyboardManager sharedManager].enable = NO;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_WIDTH*0.9);
    }];
    
    [self.bottomSegementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.equalTo(@40);
    }];
    
    [self.selTagBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomCollectionView.mas_top);
    }];
    
    [self.bottomCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomSegementView.mas_top);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(@100);
    }];
    
    [self.selectTagBgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.selTagBottomLineView.mas_top);
        make.height.equalTo(@27);
    }];
    
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7.5);
        make.right.mas_equalTo(-7.5);
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(4);
    make.bottom.mas_equalTo(self.selectTagBgScrollView.mas_top).offset(-4);
        
    }];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [_textView resignFirstResponder];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
}
#pragma mark - private

- (void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.selTagBottomLineView];
    [self.view addSubview:self.selectTagBgScrollView];
    [self.view addSubview:self.bottomCollectionView];
    [self.view addSubview:self.bottomSegementView];
}
- (void)initializeData{
    
    self.loginUserModel = PERSON_INFO;
    
    //标签
    _tagDataSource = @[@"元气午餐",@"私房菜",@"深夜食堂",@"一人食",@"早安晨光",@"素食主义",@"肉食动物",@"轻实晚餐",@"下午茶",@"零食控"];
    
    //滤镜名称

    _filterNameDataSource = @[@"原图",@"LOMO",@"复古",@"哥特",@"淡雅",@"酒红",@"青柠",@"浪漫",@"梦幻"];
    
    //异步获取滤镜图片
    _filterImageDataSouce = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        for (int index =0 ; index<_filterNameDataSource.count; index++) {
            [_filterImageDataSouce addObject:[self getFilterImageWithIndexPath:index scalePercent:0.5]];
            
        }
    });
    

}

#pragma mark - 键盘监听
- (void)addNotification{
    // 监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapTopImageCloseKeyBoard) name:@"keyBordClose" object:nil];;
   
    
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notification{
    
    double duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 计算transform
    CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;

    CGFloat ty = keyboardY == SCREEN_HEIGHT ? 0 : - (self.textView.height);
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
#pragma mark - setupNAV
- (void)setupNav{
    
    self.title = @"编辑";
    UIButton *pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    pushBtn.frame =CGRectMake(0, 0, 30, 30);
    [pushBtn addTarget:self action:@selector(pushButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    [pushBtn setImage:[UIImage imageNamed:@"DietGuide_Continue_Word_Nav"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:pushBtn];
}

- (void)pushButtonItemClick{
    
    [self.textView resignFirstResponder];
    
    if ( !LOGIN_STATION) {
        PRESENT_LOGIN_VC;
        return;
    }
    
    //必须选择标签才能发布
    if (!self.didItemSelectedTagArryM.count) {
        [SVProgressHUD showImage:nil status:@"请选择标签~"];
        return;
    }
    
    //防止重复点击
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //组装选中标签的文字
    for (int i = 0 ; i< self.didItemSelectedTagArryM.count; i++) {
        NSIndexPath *indexPath = self.didItemSelectedTagArryM[i];
        if (i == 0) {
            self.selTagFormatStr = self.tagDataSource[indexPath.row];
            continue;
        }
        self.selTagFormatStr = [NSString stringWithFormat:@"%@,%@", self.selTagFormatStr,self.tagDataSource[indexPath.row]];
    }
    
    //获取卡路里
    [self requestCalorieWithImage:self.image];
    
    

}
#pragma mark - 添加标签按钮
- (void)addTagButtonWithTag:(NSInteger )tag{
    
    UIColor *textColor = [UIColor gradientFromColor:START_COLOR toColor:END_COLOR withHeight:20];
    NSString *tagText = self.tagDataSource[tag];
    UIButton *tagButton = [[UIButton alloc]init];
    tagButton.layer.borderColor = textColor.CGColor;
    tagButton.layer.cornerRadius = kTagBtnHeight * 0.5;
    tagButton.layer.borderWidth = 0.5;
    tagButton.layer.masksToBounds = YES;
    tagButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [tagButton setTitleColor:textColor forState:UIControlStateNormal];
    tagButton.tag = tag+kTag;
    [tagButton setTitle:tagText forState:UIControlStateNormal];
    [tagButton setImage:[UIImage imageNamed:@"DietGuide_Delete_Tag"] forState:UIControlStateNormal];
    [tagButton setImagePosition:ImagePositionRight spacing:3];
    
    NSInteger count = self.selTagsButtonM.count;
    CGFloat tagBtnX = kTagRightMargin  + count * kTagBtnWidth +count *kTagRightMargin;
    tagButton.frame = CGRectMake(tagBtnX, kTagTopAndBottomMargin, kTagBtnWidth, kTagBtnHeight);
    [tagButton addTarget:self action:@selector(removeTagButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectTagBgScrollView addSubview:tagButton];
    [self.selTagsButtonM addObject:tagButton];
    //更改selectTagBgScrollView滚动范围
    self.selectTagBgScrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.selTagsButtonM.lastObject.frame)+kTagRightMargin, 0);
    
}
#pragma mark - 删除标签按钮
- (void)removeTagButton:(UIButton *)tagBtn{
    //从数组中删除当前标签
    [self.selTagsButtonM removeObject:tagBtn];
    
    //更新位置
    [self updateAllTagFrame];
    
    if (self.bottomSegementView.leftButton.selected) {
        [self collectionView:self.bottomCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:(tagBtn.tag-kTag) inSection:0]];
    }else{
        
        NSInteger index = tagBtn.tag - kTag;
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        [self.didScrollViewTagBtnDeleteTagM addObject:path];
        
    }
    
}
#pragma mark - 更新选中标签 Frame
- (void)updateAllTagFrame{
    
    //移除 UIScrollView 上所有标签，
    for (UIView *subView in self.selectTagBgScrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    
    //重新布局
    for (int i= 0 ; i<self.selTagsButtonM.count; i++) {
        UIButton *tagButton = self.selTagsButtonM[i];
        CGFloat tagBtnX = kTagRightMargin  + i * kTagBtnWidth +i *kTagRightMargin;
        tagButton.frame = CGRectMake(tagBtnX, kTagTopAndBottomMargin, kTagBtnWidth, kTagBtnHeight);
        [self.selectTagBgScrollView addSubview:tagButton];
        
    }
    //更改selectTagBgScrollView滚动范围
    self.selectTagBgScrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.selTagsButtonM.lastObject.frame)+kTagRightMargin, 0);
}
#pragma mark - Request
#pragma mark - 组装参数提交数据
- (void)requestUpdateData{
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"FoodLable"] = self.selTagFormatStr; //标签
    dictM[@"FoodName"] = self.textView.text;  //输入内容
    dictM[@"FoodPic"] = self.updatePhotoURLStr; //上传后的图片 URL
    dictM[@"PicToCalories"] = @(self.calorieValue); //卡路里数值
    
    [HTTPTool requestWithURLString:@"api/EatCircle/AddEatCircle" parameters:dictM type:kPOST success:^(id responseObject) {

        [self showSuccessWithText:@"发布成功"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        //通知列表页面加载最新数据
        [[NSNotificationCenter defaultCenter]postNotificationName:BATDiteGuideEditPushSuccessNotification object:nil];
        
        //回到列表页面
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        });
        
        
    } failure:^(NSError *error) {
//         NSLog(@"%@=====",error);
        [self showErrorWithText:@"发布失败"];
       
        
    }];
}
#pragma mark - 上传图片获取图片 URL
- (void)requestUpdatePhoto:(UIImage *)photo {
    
    [HTTPTool requestUploadImageToBATWithParams:nil constructingBodyWithBlock:^(XMRequest *request) {
        
        UIImage * compressImg  = [Tools compressImageWithImage:photo ScalePercent:0.5];
        NSData *imageData = UIImagePNGRepresentation(compressImg);
        [request addFormDataWithName:[NSString stringWithFormat:@"dite_guide_photo"]
                            fileName:[NSString stringWithFormat:@"dite_guide_photo.jpg"]
                            mimeType:@"multipart/form-data"
                            fileData:imageData];
        
    } success:^(NSArray *imageArray) {
        
        //[self showSuccessWithText:@"发布成功"];
        
        NSMutableArray *imageModelArray = [BATImage mj_objectArrayWithKeyValuesArray:imageArray];
        BATImage *imageModel = [imageModelArray firstObject];
        self.updatePhotoURLStr = imageModel.url;
        
        //组装参数上传内容
        [self requestUpdateData];
        
    } failure:^(NSError *error) {
        
        [self showErrorWithText:@"发布失败"];
        
    } fractionCompleted:^(double count) {
        
//        [self showProgres:count];
        
    }];
}

#pragma mark - 根据图片获取卡路里
- (void)requestCalorieWithImage:(UIImage *)image{
    
    [self showProgressWithText:@"正在提交数据~"];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
    NSString *base64DataStr = [imageData base64EncodedStringWithOptions:0];
    
    WeakSelf
    [HTTPTool requestWithURLString:@"api/EatCircle/GetCalorieFromPic" parameters:@{@"imageFile":base64DataStr} type:kPOST success:^(id responseObject) {
        
        DDLogDebug(@"%@===",responseObject);
        //获取卡路里数值
        weakSelf.calorieValue = [responseObject[@"Data"] integerValue];
        //上传图片上传图片获取图片 URL
        [weakSelf requestUpdatePhoto:weakSelf.imageView.image];
        
    } failure:^(NSError *error) {
        NSLog(@"%@===",error);
    }];
}

#pragma mark - UITextViewDelegate
- (void)tapTopImageCloseKeyBoard{
    
    [self.textView resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    if ([text isEqualToString:@"\n"]){
        
        [self.textView resignFirstResponder];
        return NO;
    }
    
    return YES;
    
}

#pragma mark - UICollectionViewDelegate &&  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.bottomSegementView.leftButton.selected ? self.tagDataSource.count : self.filterNameDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.bottomSegementView.leftButton.selected) {
        BATDiteGuideEditTagCell *tagCell = [collectionView dequeueReusableCellWithReuseIdentifier:TagCellID forIndexPath:indexPath];
        tagCell.textLabel.text = self.tagDataSource[indexPath.row];
        tagCell.backgroundColor = [UIColor whiteColor];
        
        for (NSIndexPath *path in self.didItemSelectedTagArryM) {
            if (indexPath == path) {
                tagCell.selected = YES;
            }
        }
        return tagCell;
        
    }else{
        
        BATDiteGuideEditFilterCell *fileterCell = [collectionView dequeueReusableCellWithReuseIdentifier:FilterCellID forIndexPath:indexPath];
        if (indexPath.row == self.filterImageSelectedIndex) {
            fileterCell.selected = YES;
        }
        
        fileterCell.imageView.image = self.filterImageDataSouce[indexPath.row];
        fileterCell.titleLabel.text = self.filterNameDataSource[indexPath.row];
        return fileterCell;
        
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.bottomSegementView.leftButton.selected) {
        if ([self.didItemSelectedTagArryM containsObject:indexPath]) {
            [self.didItemSelectedTagArryM removeObject:indexPath];
            [self.selTagsButtonM removeObject:[self.selectTagBgScrollView viewWithTag:indexPath.row+kTag]];
            [self updateAllTagFrame];
            
        }else{
            [self addTagButtonWithTag:indexPath.row];
            [self.didItemSelectedTagArryM addObject:indexPath];
            
        }
        
        
    }else{
        
        if (indexPath.row != self.filterImageSelectedIndex) {
            self.filterImageSelectedIndex = indexPath.row;
            self.imageView.image = [self getFilterImageWithIndexPath:indexPath.row scalePercent:0.9];
        }
        
    }
    
    [collectionView reloadData];
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didItemSelectedTagArryM.count > 3 && self.bottomSegementView.leftButton.selected && ![self.didItemSelectedTagArryM containsObject:indexPath]) {
        [SVProgressHUD showImage:nil status:@"最多选择4个哦~"];
        return NO;
    }
    return YES;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.bottomSegementView.leftButton.selected ? CGSizeMake(200/2, 100) : CGSizeMake(146/2, 100);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 32/2, 0, 32/2);
    
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.bottomSegementView.leftButton.selected) {
        return 20;
    }
    return 0;
}

#pragma mark - 返回滤镜图片

- (UIImage *)getFilterImageWithIndexPath:(NSInteger)index scalePercent:(CGFloat)scalePercent{
    
    
    UIImage *image = [Tools compressImageWithImage:self.image ScalePercent:scalePercent];
    
    switch (index) {
            
        case 0:
            return self.image;
            
        case 1:
            //LOMO
            return [ImageUtil imageWithImage:image withColorMatrix:colormatrix_lomo];

        case 2:
            //复古
            return [ImageUtil imageWithImage:image withColorMatrix:colormatrix_huaijiu];
            
        case 3:
            //哥特
            return [ImageUtil imageWithImage:image withColorMatrix:colormatrix_gete];

            
        case 4:
            //淡雅
            return [ImageUtil imageWithImage:image withColorMatrix:colormatrix_danya];
            
        case 5:
            //酒红
            return [ImageUtil imageWithImage:image withColorMatrix:colormatrix_jiuhong];
            
        case 6:
            //青柠
            return [ImageUtil imageWithImage:image withColorMatrix:colormatrix_qingning];
            
        case 7:
            //浪漫
            return [ImageUtil imageWithImage:image withColorMatrix:colormatrix_langman];
    
        case 8:
            //梦幻
            return [ImageUtil imageWithImage:image withColorMatrix:colormatrix_menghuan];
            
            
    }
    return nil;
}

#pragma mark - 懒加载
- (UICollectionView *)bottomCollectionView{
    if (!_bottomCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _bottomCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _bottomCollectionView.backgroundColor = [UIColor whiteColor];
        _bottomCollectionView.delegate = self;
        _bottomCollectionView.dataSource = self;
        _bottomCollectionView.allowsMultipleSelection = YES;
        
        [_bottomCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BATDiteGuideEditFilterCell class]) bundle:nil] forCellWithReuseIdentifier:FilterCellID];
        
        [_bottomCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BATDiteGuideEditTagCell class]) bundle:nil] forCellWithReuseIdentifier:TagCellID];
        
    }
    return _bottomCollectionView;
}

- (BATDiteGuideBottomSegementView *)bottomSegementView{
    if (!_bottomSegementView) {
        _bottomSegementView = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BATDiteGuideBottomSegementView class]) owner:nil options:nil].lastObject;
        _bottomSegementView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        [_bottomSegementView.leftButton setImage:[UIImage imageNamed:@"DietGuide_Tag_Word_Segment_Sel"] forState:UIControlStateSelected];
        [_bottomSegementView.leftButton setImage:[UIImage imageNamed:@"DietGuide_Tag_Word_Segment_Nor"] forState:UIControlStateNormal];
        
        [_bottomSegementView.rightButton setImage:[UIImage imageNamed:@"DietGuide_Filter_Word_Segment_Sel"] forState:UIControlStateSelected];
        [_bottomSegementView.rightButton setImage:[UIImage imageNamed:@"DietGuide_Filter_Word_Segment_Nor"] forState:UIControlStateNormal];
        
        WeakSelf
        _bottomSegementView.leftButtonBlock = ^(UIButton *leftButton, UIButton *rightButton) {
            DDLogDebug(@"====点击了左边的按钮");
            leftButton.selected = YES;
            rightButton.selected = NO;
            [weakSelf.didItemSelectedTagArryM removeObjectsInArray:weakSelf.didScrollViewTagBtnDeleteTagM];
            weakSelf.bottomCollectionView.allowsMultipleSelection = YES;
            [weakSelf.bottomCollectionView reloadData];
            
        };
        
        _bottomSegementView.rightButtonBlock = ^(UIButton *rightButton, UIButton *leftButton) {
            DDLogDebug(@"====点击了右边的按钮");
            rightButton.selected = YES;
            leftButton.selected = NO;
            weakSelf.bottomCollectionView.allowsMultipleSelection = NO;
            
            [weakSelf.bottomCollectionView reloadData];
        };
        
    }
    return _bottomSegementView;
}

- (UIScrollView *)selectTagBgScrollView{
    if (!_selectTagBgScrollView) {
        _selectTagBgScrollView = [[UIScrollView alloc]init];
        _selectTagBgScrollView.backgroundColor = [UIColor whiteColor];
        _selectTagBgScrollView.userInteractionEnabled = YES;
        
    }
    return _selectTagBgScrollView;
    
}
- (BATTextView *)textView{
    if (!_textView) {
        _textView = [[BATTextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _textView.delegate = self;
        _textView.layer.borderWidth = 1;
        _textView.layer.borderColor = UIColorFromHEX(0xc9caca, 1).CGColor;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.bat_placeholder = @"分享美食，留住生活...";
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.placeholderColor =UIColorFromHEX(0x999999, 1);
        _textView.maxNumberOfWords = 100;
        _textView.font = [UIFont systemFontOfSize:15.0f];
        _textView.textColor = UIColorFromHEX(0x333333, 1);
        
    }
    return _textView;
}
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        
        _imageView.image = self.image;
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTopImageCloseKeyBoard)];
        [_imageView addGestureRecognizer:tap];
        
    }
    return _imageView;
}

- (UIView *)selTagBottomLineView{
    if (!_selTagBottomLineView) {
        _selTagBottomLineView = [[UIView alloc]init];
        _selTagBottomLineView.backgroundColor = UIColorFromHEX(0xe0e0e0, 1);
    }
    return _selTagBottomLineView;
}
- (UILabel *)maxInputLabel{
    if (!_maxInputLabel) {
        _maxInputLabel = [[UILabel alloc]init];
        _maxInputLabel.textColor = UIColorFromHEX(0x999999, 1);
        _maxInputLabel.font = [UIFont systemFontOfSize:10];
        _maxInputLabel.text = @"0/100";
        _maxInputLabel.textAlignment = NSTextAlignmentRight;
    }
    return _maxInputLabel;
}
- (NSMutableArray <NSIndexPath *>*)didScrollViewTagBtnDeleteTagM{
    if (!_didScrollViewTagBtnDeleteTagM) {
        _didScrollViewTagBtnDeleteTagM = [NSMutableArray array];
    }
    return _didScrollViewTagBtnDeleteTagM;
}
- (NSMutableArray <UIButton *>*)selTagsButtonM{
    if (!_selTagsButtonM) {
        _selTagsButtonM = [NSMutableArray array];
    }
    return _selTagsButtonM;
}
- (NSMutableArray<NSIndexPath *> *)didItemSelectedTagArryM{
    if (!_didItemSelectedTagArryM) {
        _didItemSelectedTagArryM = [NSMutableArray array];
    }
    return _didItemSelectedTagArryM;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
