//
//  BATMemberCenterViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 2018/1/17.
//  Copyright © 2018年 KMHealthCloud. All rights reserved.
//

#import "BATMemberCenterViewController.h"
#import "BATMemberTableViewCell.h"
#import "BATNotMemberTableViewCell.h"
#import "BATMemberCenterSectionTableViewCell.h"
#import "BATMemberCenterItemTableViewCell.h"
#import "BATMemberIntroductionTableViewCell.h"
#import "BATPerson.h"
#import "BATPayManager.h"
#import "BATMemberInfoModel.h"

@interface BATMemberCenterViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) BATMemberInfoModel *memberInfoModel;

@end

@implementation BATMemberCenterViewController

- (void)dealloc
{
    DDLogDebug(@"%s",__func__);
}

- (void)loadView
{
    [super loadView];
    
    [self pageLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"会员中心";
    
    [self.memberCenterView.tableView registerNib:[UINib nibWithNibName:@"BATMemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATMemberTableViewCell"];
    [self.memberCenterView.tableView registerNib:[UINib nibWithNibName:@"BATNotMemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATNotMemberTableViewCell"];
    [self.memberCenterView.tableView registerNib:[UINib nibWithNibName:@"BATMemberCenterSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATMemberCenterSectionTableViewCell"];
    [self.memberCenterView.tableView registerNib:[UINib nibWithNibName:@"BATMemberCenterItemTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATMemberCenterItemTableViewCell"];
    [self.memberCenterView.tableView registerNib:[UINib nibWithNibName:@"BATMemberIntroductionTableViewCell" bundle:nil] forCellReuseIdentifier:@"BATMemberIntroductionTableViewCell"];
    
    self.dataSource = [NSMutableArray arrayWithObjects:@{@"image":@"img-1gy",@"productIdentifier":@"VIP1",@"month":@"1",@"sellPrice":@"12",@"originalPrice":@""},
                   @{@"image":@"img-3gy",@"productIdentifier":@"VIP3",@"month":@"3",@"sellPrice":@"28",@"originalPrice":@"36"},
                   @{@"image":@"img-6gy",@"productIdentifier":@"VIP6",@"month":@"6",@"sellPrice":@"50",@"originalPrice":@"72"},
                   @{@"image":@"img-12gy",@"productIdentifier":@"VIP12",@"month":@"12",@"sellPrice":@"78",@"originalPrice":@"144"},nil];
    
    self.memberInfoModel = MEMBER_INFO;
    
//    if (IS_VIP) {
//        [self showProgress];
//        [self requestGetUserCard];
//    }
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.memberInfoModel.Data.Status != 0) {
            return 205;
        }
        return 130;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 50;
        } else if (indexPath.row == 4) {
            return 73;
        }
        return 63;
    }
    return 116;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (self.memberInfoModel.Data.Status != 0) {
            BATMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATMemberTableViewCell" forIndexPath:indexPath];
            
            BATPerson *person = PERSON_INFO;
            
            [cell.avatorImageView sd_setImageWithURL:[NSURL URLWithString:person.Data.PhotoPath] placeholderImage:[UIImage imageNamed:@"用户"]];
            
            cell.userNameLabel.text = person.Data.UserName;
            
            if (self.memberInfoModel.Data.Status == 1) {
                cell.timeLabel.text = [NSString stringWithFormat:@"会员到期时间：%@",self.memberInfoModel.Data.ExpireTime];
            } else if (self.memberInfoModel.Data.Status == 2) {
                cell.timeLabel.text = @"会员已过期";
            }
            
            return cell;
        } else {
            BATNotMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATNotMemberTableViewCell" forIndexPath:indexPath];
            return cell;

        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            BATMemberCenterSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATMemberCenterSectionTableViewCell" forIndexPath:indexPath];
            return cell;
        } else {
            BATMemberCenterItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATMemberCenterItemTableViewCell" forIndexPath:indexPath];
            cell.cellIndexPath = indexPath;
            
            NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row - 1];
            
            cell.bgView.image = [UIImage imageNamed:dic[@"image"]];
            
            NSString *sellPrice = [dic objectForKey:@"sellPrice"];
            NSString *originalPrice = [dic objectForKey:@"originalPrice"];
            
            [cell setSellPrice:[NSString stringWithFormat:@"￥%@",sellPrice]];
            [cell setOriginalPrice:originalPrice.length > 0 ? [NSString stringWithFormat:@"￥%@",originalPrice] : @""];
            
//            [cell.payBtn setTitle:IS_VIP ? @"续费" : @"购买" forState:UIControlStateNormal];
            [cell.payBtn setBackgroundImage:self.memberInfoModel.Data.Status != 0 ? [UIImage imageNamed:@"but-xf"] : [UIImage imageNamed:@"but-gm"] forState:UIControlStateNormal];
            
            WEAK_SELF(self);
            cell.payBlock = ^(NSIndexPath *cellIndexPath) {
                STRONG_SELF(self);
                DDLogDebug(@"点击了购买");
                
                self.view.userInteractionEnabled = NO;
                
                NSDictionary *model = [self.dataSource objectAtIndex:cellIndexPath.row - 1];
                
                DDLogDebug(@"productIdentifier %@",[model objectForKey:@"productIdentifier"]);
                
                [self requestEditUserCardOrder:[model objectForKey:@"month"] money:[model objectForKey:@"sellPrice"] productIdentifier:[model objectForKey:@"productIdentifier"]];
                
            };
            return cell;
        }
    }
    BATMemberIntroductionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BATMemberIntroductionTableViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - Net
#pragma mark - 提交订单
- (void)requestEditUserCardOrder:(NSString *)month money:(NSString *)money productIdentifier:(NSString *)productIdentifier
{
    [HTTPTool requestWithURLString:@"/api/Account/EditUserCardOrder" parameters:@{@"OpenMonth":month,@"OrderMoney":money,@"PayMoney":money} type:kPOST success:^(id responseObject) {
        
        NSString *orderNo = [[responseObject objectForKey:@"Data"] objectForKey:@"OrderNo"];
        
        if (orderNo.length > 0 && ![orderNo isEqualToString:@""]) {
            //测试购买
            [[BATPayManager shareManager] pay:@{@"productIdentifier":productIdentifier} payType:BATPayType_IAP orderNo:orderNo complete:^(BOOL isSuccess) {
                self.view.userInteractionEnabled = YES;
                if (isSuccess) {
                    //购买成功
                    DDLogDebug(@"购买成功");
                    
//                    //修改vip状态
//                    SET_VIP(YES);
                    
                    if (self.isFromNews) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:BATReloadWebViewNotification object:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    } else {
                        //获取会员信息
                        [self requestGetUserCard];
                    }
                }
                
                
            }];
        } else {
            self.view.userInteractionEnabled = YES;
            [self showErrorWithText:@"生成订单失败"];
        }
        
    } failure:^(NSError *error) {
        self.view.userInteractionEnabled = YES;
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - 获取会员信息
- (void)requestGetUserCard
{
    [HTTPTool requestWithURLString:@"/api/Account/GetUserCard" parameters:nil type:kGET success:^(id responseObject) {
        
        [self dismissProgress];
        
        self.memberInfoModel = [BATMemberInfoModel mj_objectWithKeyValues:responseObject];
        
        //保存个人信息
        NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MemberInfo.data"];
        [NSKeyedArchiver archiveRootObject:self.memberInfoModel toFile:file];
        
        [self.memberCenterView.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        [self showErrorWithText:error.localizedDescription];
    }];
}

#pragma mark - pagelayout
- (void)pageLayout
{
    [self.view addSubview:self.memberCenterView];
    
    WEAK_SELF(self);
    [self.memberCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self);
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - get & set
- (BATMemberCenterView *)memberCenterView
{
    if (_memberCenterView == nil) {
        _memberCenterView = [[BATMemberCenterView alloc] init];
        _memberCenterView.tableView.delegate = self;
        _memberCenterView.tableView.dataSource = self;
        _memberCenterView.tableView.estimatedRowHeight = 0;
        _memberCenterView.tableView.estimatedSectionFooterHeight = 0;
        _memberCenterView.tableView.estimatedSectionHeaderHeight = 0;
    }
    return _memberCenterView;
}

@end
