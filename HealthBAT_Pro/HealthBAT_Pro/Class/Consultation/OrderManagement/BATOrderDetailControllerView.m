//
//  BATOrderDetailControllerView.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/29.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATOrderDetailControllerView.h"
#import "BATOrderDetailCell.h"
@interface BATOrderDetailControllerView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *orderTableView;
@property (nonatomic,strong) NSArray *titleArry;
@property (nonatomic,strong) NSMutableArray *videoOderArr;
@property (nonatomic,strong) NSMutableArray *chatOderArr;
@property (nonatomic,strong) UIView *tableHeaderView;
@end

@implementation BATOrderDetailControllerView

static NSString *const DetailCellReuse = @"ORDERDETAILCELL";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self layoutPages];
    
}

#pragma mark -UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 3;
    }else {
        return 2;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else {
        return 10;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BATOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellReuse];
    if (cell == nil) {
        cell = [[BATOrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailCellReuse];
    }

    cell.nameLb.text = self.titleArry[indexPath.section][indexPath.row];
    cell.detailLb.text = self.videoOderArr[indexPath.section][indexPath.row];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *sectionView = [[UIView alloc]init];
        sectionView.backgroundColor = UIColorFromHEX(0Xf6f6f6, 1);
        sectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 10);
        return sectionView;
    }else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -layoutPages
-(void)layoutPages {
    self.title = @"订单详情";
    _titleArry = @[@[@"订单号",@"下单时间",@"订单类型"],@[@"支付状态",@"付款金额"]];
    
    if (self.orderDataModel) {
        NSString *orderNo = self.orderDataModel.Order.OrderNo;
        NSString *orderTime = self.orderDataModel.Order.OrderTime;
        NSString *orderType = @"图文咨询";
        
        NSArray *sectionOneArr = @[orderNo,orderTime,orderType];
        NSString *orderState = @"";
        switch (self.orderDataModel.Order.OrderState) {
            case -1:
            case 0:
                orderState = @"未支付";
                break;
            case 1:
                orderState = @"已支付";
                break;
            case 2:
                orderState = @"已完成";
                break;
            case 3:
                orderState = @"已取消";
                break;
//            default:
//                orderState = @"未支付";
//                break;
        }
        
        NSString *orderMoney = [NSString stringWithFormat:@"¥ %.2f元",self.orderDataModel.Order.TotalFee];
        
        NSArray *sectionTwoArr = @[orderState,orderMoney];
        
        [self.videoOderArr addObject:sectionOneArr];
        [self.videoOderArr addObject:sectionTwoArr];
    }
    
    if (self.videoDataModel) {
        NSString *orderNo = self.videoDataModel.Order.OrderNo;
        NSString *orderTime = self.videoDataModel.Order.OrderTime;
        NSString *orderType = @"";
        if (self.videoDataModel.OPDType == 1) {
            orderType = @"图文咨询";
        }else if(self.videoDataModel.OPDType == 2) {
            orderType = @"语音咨询";
        }else if(self.videoDataModel.OPDType == 3) {
            orderType = @"视频咨询";
        }
        
        NSArray *sectionOneArr = @[orderNo,orderTime,orderType];
        NSString *orderState = @"";
        switch (self.videoDataModel.Order.OrderState) {
            case -1:
            case 0:
                orderState = @"未支付";
                break;
            case 1:
                orderState = @"已支付";
                break;
            case 2:
                orderState = @"已完成";
                break;
            case 3:
                orderState = @"已取消";
                break;
//                default:
//                orderState = @"未支付";
//                break;
        }
        
        NSString *orderMoney = [NSString stringWithFormat:@"¥ %.2f元",self.videoDataModel.Order.TotalFee];
        
        NSArray *sectionTwoArr = @[orderState,orderMoney];
        
        [self.videoOderArr addObject:sectionOneArr];
        [self.videoOderArr addObject:sectionTwoArr];
        
    }
    
    [self.view addSubview:self.orderTableView];
}

#pragma mark  - SETTER - GETTER
-(UITableView *)orderTableView {
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        _orderTableView.backgroundColor = UIColorFromHEX(0Xf6f6f6, 1);
        _orderTableView.tableHeaderView = self.tableHeaderView;
        [_orderTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_orderTableView registerClass:[BATOrderDetailCell class] forCellReuseIdentifier:DetailCellReuse];
    }
    return _orderTableView;
}

-(NSMutableArray *)videoOderArr {
    if (!_videoOderArr) {
        _videoOderArr = [NSMutableArray array];
    }
    return _videoOderArr;
}

-(NSMutableArray *)chatOderArr {
    if (!_chatOderArr) {
        _chatOderArr = [NSMutableArray array];
    }
    return _chatOderArr;
}

-(UIView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 113)];
        _tableHeaderView.backgroundColor = UIColorFromHEX(0Xf6f6f6, 1);
        UIImageView *img = [[UIImageView alloc]init];
        [_tableHeaderView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tableHeaderView.mas_centerY);
            make.left.equalTo(_tableHeaderView.mas_left).offset(40);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        UILabel *tipsLb = [[UILabel alloc]init];
        tipsLb.numberOfLines = 0;
        tipsLb.font = [UIFont systemFontOfSize:14];
        tipsLb.textColor = UIColorFromHEX(0X333333, 1);
       
        
        NSInteger stateCount = 0;
        if (self.videoDataModel) {
            stateCount = self.videoDataModel.Order.OrderState;
        }
        
        if (self.orderDataModel) {
            stateCount = self.orderDataModel.Order.OrderState;
        }
        
        NSString *tipsString = nil;
        switch (stateCount) {
            case -1:
            case 0: {
                tipsString = @"请您在提交订单后30分钟内完成支付,否则订单会自动取消";
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:tipsString];
                
                [AttributedStr addAttribute:NSFontAttributeName
                 
                                      value:[UIFont systemFontOfSize:14.0]
                 
                                      range:NSMakeRange(0, tipsString.length)];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                 
                                      value:UIColorFromHEX(0Xff0000, 1)
                 
                                      range:NSMakeRange(8, 4)];
                tipsLb.attributedText = AttributedStr;
                
                img.image = [UIImage imageNamed:@"ic-zfsb"];
                break;
            }
            case 1:
                tipsString = @"该订单已支付成功";
                tipsLb.text = tipsString;
                img.image = [UIImage imageNamed:@"iconfont-Payment-success"];
                break;
            case 2:
                tipsString = @"该订单已完成";
                tipsLb.text = tipsString;
                img.image = [UIImage imageNamed:@"iconfont-Payment-success"];
                break;
            case 3:
                tipsString = @"该订单已取消";
                tipsLb.text = tipsString;
                img.image = [UIImage imageNamed:@"ic-zfsb"];
                break;
                /*
            default:
                tipsString = @"请您在提交订单后30分钟内完成支付,否则订单会自动取消";
                NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:tipsString];
                
                [AttributedStr addAttribute:NSFontAttributeName
                 
                                      value:[UIFont systemFontOfSize:14.0]
                 
                                      range:NSMakeRange(0, tipsString.length)];
                
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                 
                                      value:UIColorFromHEX(0Xff0000, 1)
                 
                                      range:NSMakeRange(8, 4)];
                tipsLb.attributedText = AttributedStr;
                
                img.image = [UIImage imageNamed:@"ic-Symbol"];
                break;
                 */
        }
        
        [_tableHeaderView addSubview:tipsLb];
        [tipsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(img.mas_centerY);
            make.left.equalTo(img.mas_right).offset(10);
            make.right.equalTo(_tableHeaderView.mas_right).offset(-40);
        }];
    }
    return _tableHeaderView;
}
@end

