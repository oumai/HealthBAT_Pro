//
//  BATCheckDetailViewController.m
//  HealthBAT_Pro
//
//  Created by MichaeOu on 2017/10/27.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATCheckDetailViewController.h"
#import "BATGraditorButton.h"
#import "BATBuyOTCViewController.h"
#import "BATAddressModel.h"

@interface BATCheckDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) BATGraditorButton *buyButton;

/**
 收货人
 */
@property (nonatomic,strong) BATAddressData *addressData;

/**
 订单编号
 */
@property (nonatomic,copy) NSString *OrderNo;

/**
 订单状态
 */
@property (nonatomic,assign) NSInteger OrderState;

@end

@implementation BATCheckDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.buyButton]];
    
    [self layoutPageViews];
    
    [self loadRecipeFileUrl];
}

#pragma mark UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Private
- (void)loadRecipeFileUrl {
    
    if (self.RecipeFileUrl.length == 0) {
        return;
    }
    
    [HTTPTool requestWithKmWlyyImageApiURLString:[NSString stringWithFormat:@"%@",self.RecipeFileUrl] success:^(id responseObject) {
        
//        NSLog(@"success");
        
        UIImage *image = [UIImage imageWithData:responseObject];
        
        CGSize endSize = CGSizeMake(SCREEN_WIDTH, image.size.height/image.size.width*SCREEN_WIDTH);
        
        self.scrollView.contentSize = endSize;
        self.imageView.size = endSize;
        self.imageView.image = image;

        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 接口获取地址列表
- (void)requestGetAllAddressList
{
    [self showProgress];
    
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/userAddresses/getUserAddressList" parameters:nil type:kGET success:^(id responseObject) {
        BATAddressModel *addressModel = [BATAddressModel mj_objectWithKeyValues:responseObject];
        
//        [self dismissProgress];
        
        for (BATAddressData *data in addressModel.Data) {
            if (data.IsDefault) {
                //有默认的选择默认
                _addressData = data;
                break;
            }
            
            if (data == addressModel.Data.lastObject) {
                //没有默认的选择列表的第一个
                _addressData = addressModel.Data.firstObject;
            }
        }
        
        [self requestBuyOrder];
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - 购买处方
- (void)requestBuyOrder
{
    //生成订单
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.OPDRegisterID forKey:@"OPDRegisterID"];
    [param setObject:@[self.RecipeNo] forKey:@"RecipeNos"];
    
    if (_addressData) {
        NSString *address = [NSString stringWithFormat:@"%@%@%@%@",_addressData.ProvinceName,_addressData.CityName,_addressData.AreaName,_addressData.DetailAddress];
        
        [param setObject:@{@"Id":_addressData.AddressID,@"Address":address,@"Name":_addressData.UserName,@"Tel":_addressData.Mobile} forKey:@"Consignee"];
    }
    
    [HTTPTool requestWithKmWlyyBaseApiURLString:@"/UserRecipeOrders" parameters:param type:kPOST success:^(id responseObject) {
        
        [self dismissProgress];
        
        self.OrderNo = [[responseObject objectForKey:@"Data"] objectForKey:@"OrderNo"];
        self.OrderState = [[[responseObject objectForKey:@"Data"] objectForKey:@"OrderState"] integerValue];
        
        
        
        BATBuyOTCViewController *buyOTCVC = [[BATBuyOTCViewController alloc] init];
//        buyOTCVC.RecipeFileID = self.RecipeFileID;
//        buyOTCVC.OPDRegisterID = self.OPDRegisterID;
//        buyOTCVC.RecipeNo = self.RecipeNo;
//        buyOTCVC.RecipeName = self.RecipeName;
//        buyOTCVC.Amount = self.Amount;
//        buyOTCVC.ReplaceDose = self.ReplaceDose;
//        buyOTCVC.ReplacePrice = self.ReplacePrice;
//        buyOTCVC.TCMQuantity = self.TCMQuantity;
        buyOTCVC.OrderNo = self.OrderNo;
        buyOTCVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:buyOTCVC animated:YES];
        
        
    } failure:^(NSError *error) {
        
        if (error.code == 601) {
            [self showErrorWithText:@"处方已购买可查看药品订单"];
        } else {
            [self showErrorWithText:error.localizedDescription];
        }
    }];
}

#pragma mark - layout
- (void)layoutPageViews {
    
    self.title = @"详情";

    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.scrollView addSubview:self.imageView];
}

#pragma makr - getter
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale=4.0;
        _scrollView.minimumZoomScale=0.25;

    }
    return _scrollView;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (BATGraditorButton *)buyButton
{
    if (_buyButton == nil) {
        _buyButton = [[BATGraditorButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
//        _buyButton.enablehollowOut = YES;
        [_buyButton setGradientColors:@[START_COLOR,END_COLOR]];
        _buyButton.enbleGraditor = YES;
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_buyButton sizeToFit];
        [_buyButton setTitle:@"购买处方" forState:UIControlStateNormal];
        
        WEAK_SELF(self);
        [_buyButton bk_whenTapped:^{
            STRONG_SELF(self);
            
            [self requestGetAllAddressList];
            
        }];
        
    }
    return _buyButton;
}

@end


