//
//  BATChatConsultController.m
//  HealthBAT_Pro
//
//  Created by kmcompany on 16/9/27.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "UIScrollView+EmptyDataSet.h"
#import "BATSegmentControl.h"

#import "BATChatConsultController.h"
#import "BATHeaderView.h"

#import "BATChatCell.h"
#import "BATBookCell.h"

#import "BATOrderChatModel.h"
#import "BATAVModel.h"

#import "BATConfirmPayViewController.h"
#import "BATOrderDetailControllerView.h"
#import "MQChatViewManager.h"
#import "BATWaitingRoomViewController.h"

@interface BATChatConsultController ()<UITableViewDelegate,UITableViewDataSource,BATBookCellDelegate,BATHeaderViewDelegate,BATChatCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,BATSegmentControlDelegate>
@property (nonatomic,strong) BATHeaderView *headerView;
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UITableView *chatTableView;
@property (nonatomic,strong) UITableView *bookTableView;

@property (nonatomic,strong) BATOrderChatModel *chatModel;
@property (nonatomic,strong) BATAVModel *AVModel;
@property (nonatomic,assign) NSInteger chatCurrentPage;
@property (nonatomic,assign) NSInteger videoCurrentPage;

@property (nonatomic,strong) NSMutableArray *chatDataArr;
@property (nonatomic,strong) NSMutableArray *avidoDataArr;

@property (nonatomic,assign) NSInteger cancleNums;
@property (nonatomic,assign) NSInteger refundNums;
@property (nonatomic,strong) NSString *beginTime;
@property (nonatomic,strong) BATSegmentControl *segmentControl;

@property (nonatomic,assign) BOOL isShow;
//@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATChatConsultController

static NSString * const chatReuseString = @"CHATCELL";
static NSString * const bookReuseString = @"BOOKCELL";

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isShow = NO;
    [self.view addSubview:self.segmentControl];
    //医生结束服务时候接收通知刷新状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateState) name:BATENDSEVERICE object:nil];
    if (![[BATTIMManager sharedBATTIM] bat_getLoginStatus]) {
        [[BATTIMManager sharedBATTIM] bat_loginTIM];
    }

    /*
    OrderState Des
     -1:待确认
     0:待支付
     1:已支付
     2:已完成
     3:已取消
     */
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.chatCurrentPage = 1;
    self.videoCurrentPage = 1;
    
    [self layoutControllerSubView];
    
    //[self videoRequest];
    //[self chatConsultRequest];
    
    [self.backScrollView addSubview:self.chatTableView];
    [self.backScrollView addSubview:self.bookTableView];
    
    //判断如果在支付成功界面进入时，进行vc数组处理
    if (self.navigationController.viewControllers.count > 3) {
        NSMutableArray *vcArray = [NSMutableArray array];
        
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if (vc == self.navigationController.viewControllers.firstObject) {
                [vcArray insertObject:vc atIndex:0];
                [self.bookTableView.mj_header beginRefreshing];
                [self.chatTableView.mj_footer  beginRefreshing];
            } else if (vc == self.navigationController.viewControllers.lastObject) {
                [vcArray addObject:vc];
                [self.bookTableView.mj_header beginRefreshing];
                [self.chatTableView.mj_footer  beginRefreshing];
            }
        }
        
        self.navigationController.viewControllers = vcArray;
    }
    
    NSInteger page = (_cusultType == kConsultTypeFree || _cusultType == kConsultTypeTextAndImage) ? 0 : 1;
    
    [self.headerView selectPages:page];
    [self BATHeaderViewSeleWithPage:page];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.chatTableView.mj_header beginRefreshing];
    [self.bookTableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"个人中心-咨询订单" moduleId:4 beginTime:self.beginTime];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.chatTableView) {
        return self.chatDataArr.count;
    }else {
    return self.avidoDataArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.bookTableView) {
        return 100;
    }else {
    return 105;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.chatTableView) {
        
    BATChatCell *cell = [tableView dequeueReusableCellWithIdentifier:chatReuseString];
        if (cell == nil) {
        cell = [[BATChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatReuseString];
    }
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
             [obj removeFromSuperview];
        }
    }];
    cell.delegate = self;
    cell.rowPath = indexPath;
    [cell cellConfigWithChatModel:self.chatDataArr[indexPath.row]];
    return cell;
    }else {
        
    BATBookCell *cell = [tableView dequeueReusableCellWithIdentifier:bookReuseString];
        if (cell == nil) {
            cell = [[BATBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookReuseString];
        }
    [cell.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]]) {
                [obj removeFromSuperview];
            }
    }];
    cell.delegate = self;
    cell.rowPath = indexPath;
    [cell cellConfigWithModel:self.avidoDataArr[indexPath.row]];
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == self.bookTableView) {
        VideoData *dataModel = self.avidoDataArr[indexPath.row];
        BATOrderDetailControllerView *detailCtl = [[BATOrderDetailControllerView alloc]init];
        detailCtl.videoDataModel = dataModel;
        [self.navigationController pushViewController:detailCtl animated:YES];
    }else{
        OrderResData *orderModel = self.chatDataArr[indexPath.row];
        BATOrderDetailControllerView *detailCtl = [[BATOrderDetailControllerView alloc]init];
        detailCtl.orderDataModel = orderModel;
        [self.navigationController pushViewController:detailCtl animated:YES];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.backScrollView) {

        NSInteger pages = scrollView.contentOffset.x/SCREEN_WIDTH;

        [self.headerView setLineViewPostionWihPage:pages];
        
        if (scrollView.contentOffset.x/SCREEN_WIDTH == 1) {
            if (self.avidoDataArr.count == 0) {
                [self.bookTableView reloadData];
            }
        }
    }
    
    /*
        NSInteger page = (scrollView.contentOffset.x / scrollView.frame.size.width);
        
        self.segmentControl.selectedIndex = page;
    */
}

#pragma mark -BATChatCellDelegate
//进入环信聊天
-(void)BATChatCellStartBtnAction:(NSIndexPath *)rowPath {
    DDLogDebug(@"BATChatCellStartBtnAction");
    
    OrderResData *orderModel = self.chatDataArr[rowPath.row];
    
    [[BATTIMManager sharedBATTIM] bat_currentConversationWithType:TIM_GROUP receiver:[NSString stringWithFormat:@"%ld",(long)orderModel.Room.ChannelID]];
    
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setNavTitleText:@"图文咨询"];
    if (orderModel.Doctor.Gender == 0) {
        //男
        [chatViewManager setincomingDefaultAvatarImage:[UIImage imageNamed:@"img-nys"]];
    } else {
        //女，或者未知
        [chatViewManager setincomingDefaultAvatarImage:[UIImage imageNamed:@"img-ysv"]];
    }
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:orderModel.Doctor.User.PhotoUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [chatViewManager setincomingDefaultAvatarImage:image];
    }];
    
    chatViewManager.chatViewStyle.enableRoundAvatar = YES;
    chatViewManager.chatViewStyle.navBarRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatViewManager setInPutBarHide:NO];
    chatViewManager.chatViewStyle.outgoingBubbleImage = [UIImage imageNamed:@"chat-2"];
    chatViewManager.chatViewStyle.incomingBubbleImage = [UIImage imageNamed:@"chat-1"];
    chatViewManager.chatViewStyle.outgoingMsgTextColor = UIColorFromHEX(0xffffff, 1);
    chatViewManager.chatViewStyle.incomingMsgTextColor = UIColorFromHEX(0x333333, 1);
    [chatViewManager enableShowNewMessageAlert:NO];
    chatViewManager.chatViewStyle.backgroundColor = BASE_BACKGROUND_COLOR;


    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 50, 50)];
    [backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    chatViewManager.chatViewStyle.navBarLeftButton = backButton;
    
    [chatViewManager pushMQChatViewControllerInViewController:self];
}
//进入支付界面
-(void)BATChatCellPayBtnAction:(NSIndexPath *)rowPath {
    OrderResData *orderModel = self.chatDataArr[rowPath.row];
    DDLogDebug(@"BATChatCellPayBtnAction");
    BATConfirmPayViewController *confirmPayVC = [[BATConfirmPayViewController alloc] init];
    confirmPayVC.type = kConsultTypeTextAndImage;
    confirmPayVC.orderNo = orderModel.Order.OrderNo;
    confirmPayVC.momey = [NSString stringWithFormat:@"%.2f",orderModel.Order.TotalFee];
    [self.navigationController pushViewController:confirmPayVC animated:YES];
}
//原本的取消订单按钮，但已取消此功能，暂时作为显示作用
-(void)BATChatCellCancleBtnAction:(NSIndexPath *)rowPath {
   [self showText:@"请先支付"];
}
//订单已经完成了，也就是服务完毕了，此按钮点击后进入图文界面，但不能输入，因为订单完成了
-(void)BATChatCellFinishBtnAction:(NSIndexPath *)rowPath {
    OrderResData *orderModel = self.chatDataArr[rowPath.row];
    
    [[BATTIMManager sharedBATTIM] bat_currentConversationWithType:TIM_GROUP receiver:[NSString stringWithFormat:@"%ld",(long)orderModel.Room.ChannelID]];
    
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setNavTitleText:@"图文咨询"];
    if (orderModel.Doctor.Gender == 0) {
        //男
        [chatViewManager setincomingDefaultAvatarImage:[UIImage imageNamed:@"img-nys"]];
    } else {
        //女，或者未知
        [chatViewManager setincomingDefaultAvatarImage:[UIImage imageNamed:@"img-ysv"]];
    }
    
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:orderModel.Doctor.User.PhotoUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [chatViewManager setincomingDefaultAvatarImage:image];
    }];
    
    chatViewManager.chatViewStyle.enableRoundAvatar = YES;
    chatViewManager.chatViewStyle.backgroundColor = BASE_BACKGROUND_COLOR;
    chatViewManager.chatViewStyle.navBarRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatViewManager setInPutBarHide:YES];
    chatViewManager.chatViewStyle.outgoingBubbleImage = [UIImage imageNamed:@"chat-2"];
    chatViewManager.chatViewStyle.incomingBubbleImage = [UIImage imageNamed:@"chat-1"];
    chatViewManager.chatViewStyle.outgoingMsgTextColor = UIColorFromHEX(0xffffff, 1);
    chatViewManager.chatViewStyle.incomingMsgTextColor = UIColorFromHEX(0x333333, 1);
    [chatViewManager enableShowNewMessageAlert:NO];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, 50, 50)];
    [backButton setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    chatViewManager.chatViewStyle.navBarLeftButton = backButton;
    
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

#pragma mark -BATBookCellDelegate
//立即支付事件代理
-(void)BATBookCellDelegatePayActionWithRowPath:(NSIndexPath *)rowPath {
    VideoData *dataModel = self.avidoDataArr[rowPath.row];
//"OPDType": 3,//医生服务类型 1-图文咨询、2-语音咨询、3-视频咨询、4-家庭医生、5-远程会诊
    BATConfirmPayViewController *confirmPayVC = [[BATConfirmPayViewController alloc] init];
    switch (dataModel.OPDType) {
        case 2:
            confirmPayVC.type = kConsultTypeAudio;
            break;
        case 3:
            confirmPayVC.type = kConsultTypeVideo;
            break;
        default:
            break;
    }
    confirmPayVC.orderNo = dataModel.Order.OrderNo;
    confirmPayVC.momey = [NSString stringWithFormat:@"%.2f",dataModel.Order.TotalFee];
    [self.navigationController pushViewController:confirmPayVC animated:YES];
}
//取消订单事件代理
-(void)BATBookCellDelegateCancleActionWithRowPath:(NSIndexPath *)rowPath {
    
    WEAK_SELF(self)
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否取消订单" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        STRONG_SELF(self)
        VideoData *dataModel = self.avidoDataArr[rowPath.row];
        [self cancleOrderRequestWithOrderID:dataModel.Order.OrderNo];
    }];
    
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
//进入诊室事件代理
-(void)BATBookCellDelegateStartActionWithRowPath:(NSIndexPath *)rowPath {
    VideoData *dataModel = self.avidoDataArr[rowPath.row];
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetNowSysTime" parameters:nil type:kGET success:^(id responseObject) {
        
        NSString *timeStr = responseObject[@"Data"];
        NSDate *date = [Tools dateWithDateString:timeStr Format:@"yyyy-MM-dd HH:mm:ss"];
        
         //预约开始跟结束时间段
         NSString *yearTime = [dataModel.OPDDate substringToIndex:10];
//         NSInteger startTime = [dataModel.Schedule.StartTime integerValue];
//         NSInteger endTime = [dataModel.Schedule.EndTime integerValue];
        
        NSDate *startDate = [Tools dateWithDateString:[NSString stringWithFormat:@"%@ %@",yearTime,dataModel.Schedule.StartTime] Format:@"yyyy-MM-dd HH:mm"];
        NSDate *endDate = [Tools dateWithDateString:[NSString stringWithFormat:@"%@ %@",yearTime,dataModel.Schedule.EndTime] Format:@"yyyy-MM-dd HH:mm"];
         /*
         NSDate *date = [NSDate date];
         NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
         formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
         NSString *timeStr=[formatter stringFromDate:date];
          */
//         NSString *yearString = [timeStr substringToIndex:10];
//         NSString *currentTimeString = [timeStr substringWithRange:NSMakeRange(11, 2)];
         //用户当前时间 24小时制
//         NSInteger currentData = [currentTimeString integerValue];
         
        if ([date timeIntervalSinceDate:startDate] > 0 && [date timeIntervalSinceDate:endDate] < 0) {
            if (dataModel.Room.RoomState == -1) {
                
                NSString *title = @"预约中，请稍后";
                [self showErrorWithText:title];
                [self.bookTableView.mj_header beginRefreshing];
                
                return;
            }
            
            //     "OPDType": 3,//医生服务类型 1-图文咨询、2-语音咨询、3-视频咨询、4-家庭医生、5-远程会诊
            BATWaitingRoomViewController *waitingVC = [[BATWaitingRoomViewController alloc] init];
            waitingVC.roomID = dataModel.Room.ChannelID;
            waitingVC.doctorID = dataModel.Doctor.DoctorID;
            waitingVC.Gender = dataModel.Doctor.Gender;
            if (dataModel.OPDType == 2) {
                //跳转到语音咨询
                waitingVC.type = kDoctorServerAudioType;
            }
            else if(dataModel.OPDType == 3) {
                //跳转到视频
                waitingVC.type = kDoctorServerVideoType;
            }
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:waitingVC];
            [self presentViewController:nav animated:YES completion:nil];
            
        }else {
            
            [self showText:@"请您到预约时间段再进入诊室"];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
   
}

//申请退款事件代理
-(void)BATBookCellDelegateRefundActionWithRowPath:(NSIndexPath *)rowPath {

    WEAK_SELF(self)
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否申请退款" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        STRONG_SELF(self)
        VideoData *dataModel = self.avidoDataArr[rowPath.row];
        [self orderRefundRequestWithOrderID:dataModel.Order.OrderNo];
    }];
    

    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//申请退款事件代理
-(void)orderRefundRequestWithOrderID:(NSString *)orderString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:orderString forKey:@"OrderNo"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/Cancel" parameters:dict type:kGET success:^(id responseObject) {
        DDLogDebug(@"%@",responseObject[@"ResultMessage"]);
        [self.bookTableView.mj_header beginRefreshing];
        [self showText:@"退款申请成功!"];
    } failure:^(NSError *error) {
        
    }];
}

//取消订单事件
-(void)cancleOrderRequestWithOrderID:(NSString *)orderString {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:orderString forKey:@"OrderNo"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/Cancel" parameters:dict type:kGET success:^(id responseObject) {
        DDLogDebug(@"%@",responseObject[@"ResultMessage"]);
        [self.bookTableView.mj_header beginRefreshing];
    } failure:^(NSError *error) {

    }];
}

#pragma mark - HeaderViewDelegate
-(void)BATHeaderViewSeleWithPage:(NSInteger)pages {
    switch (pages) {
        case 0: {
            [UIView animateWithDuration:0.5 animations:^{
               self.backScrollView.contentOffset = CGPointMake(0, 0);
            }];
            break;
        }
        case 1: {
            [UIView animateWithDuration:0.5 animations:^{
                self.backScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            }];
            
            if (self.avidoDataArr.count == 0) {
                 [self.bookTableView reloadData];
            }
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -layoutControllerSubView
-(void)layoutControllerSubView {
    self.title = @"咨询医生订单";
    WEAK_SELF(self)
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        STRONG_SELF(self)
        make.left.equalTo(self.view.mas_left).offset(0);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@45);
    }];
    [self.view addSubview:self.backScrollView];
    
//    [self.view addSubview:self.defaultView];
//    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.right.left.equalTo(self.view);
//        make.top.equalTo(self.view).offset(30);
//    }];
}
#pragma mark - Action

#pragma mark - upDateState
-(void)upDateState {
    [self.bookTableView.mj_header beginRefreshing];
}

#pragma mark - NET
//语音咨询
-(void)videoRequest {
    
    //语音咨询
    NSMutableDictionary *vudiodict = [NSMutableDictionary dictionary];
    [vudiodict setValue:@(self.videoCurrentPage) forKey:@"CurrentPage"];
    [vudiodict setValue:@"10" forKey:@"PageSize"];
    [vudiodict setValue:NULL forKey:@"OPDType"];
    [vudiodict setValue:@"" forKey:@"Keyword"];
    [vudiodict setValue:NULL forKey:@"BeginDate"];
    [vudiodict setValue:NULL forKey:@"EndDate"];
    
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetUserOPDRegister" parameters:vudiodict type:kPOST success:^(id responseObject) {
        
      _bookTableView.mj_footer.hidden = NO;
     self.isShow = YES;
     [_bookTableView.mj_footer endRefreshing];
     [_bookTableView.mj_header endRefreshing];
        
        if (self.videoCurrentPage == 1) {
            [self.avidoDataArr removeAllObjects];
        }
        self.AVModel = [BATAVModel mj_objectWithKeyValues:responseObject];
        [self.avidoDataArr addObjectsFromArray:self.AVModel.Data];
        
        
        if (self.AVModel.Data.count == 0) {
            [self.bookTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (self.avidoDataArr.count == 0) {
            self.bookTableView.mj_footer.hidden = YES;
        }
        
        [self.bookTableView reloadData];
        
        
        [self dismissProgress];
    } failure:^(NSError *error) {
        self.isShow = YES;
        [_bookTableView.mj_footer endRefreshing];
        [_bookTableView.mj_header endRefreshing];
        
    }];
}

//图文咨询请求
-(void)chatConsultRequest {
//    [self showProgressWithText:@"正在加载"];
    //图文咨询
    NSMutableDictionary *chatdict = [NSMutableDictionary dictionary];
    [chatdict setValue:@(self.chatCurrentPage) forKey:@"CurrentPage"];
    [chatdict setValue:@"10" forKey:@"pageSize"];
    [chatdict setValue:@"" forKey:@"keyWord"];
    [chatdict setValue:@"" forKey:@"consultType"];
    [HTTPTool requestWithURLString:@"/api/NetworkMedical/GetUserConsults" parameters:chatdict type:kGET success:^(id responseObject) {
        _chatTableView.mj_footer.hidden = NO;
        [_chatTableView.mj_footer endRefreshing];
        [_chatTableView.mj_header endRefreshing];

        if (self.chatCurrentPage == 1) {
            [self.chatDataArr removeAllObjects];
        }
        self.chatModel = [BATOrderChatModel mj_objectWithKeyValues:responseObject];
        [self.chatDataArr addObjectsFromArray:self.chatModel.Data];
        
        if (self.chatDataArr.count == self.chatModel.RecordsCount) {
            [self.chatTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        if (self.chatDataArr.count == 0) {
            self.chatTableView.mj_footer.hidden = YES;
        }
        self.isShow = YES;
        [self.chatTableView reloadData];
       
        [self dismissProgress];
    } failure:^(NSError *error) {
        self.isShow = YES;
        [_chatTableView.mj_footer endRefreshing];
        [_chatTableView.mj_header endRefreshing];
    }];
}

#pragma mark - DZNEmptyDataSetSource
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    return -50;
}
//返回标题文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    if (self.isShow) {
        NSInteger page = self.backScrollView.contentOffset.x/SCREEN_WIDTH;
        
        
        if (page == 0) {
            if (self.chatDataArr.count ==0) {
                NSString *text = @"暂无咨询记录";
                NSDictionary *outAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: UIColorFromHEX(0x666666, 1)};
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:outAttributes];
                NSRange range;
                range.length = text.length;
                range.location = 0;
                [string setAttributes:outAttributes range:range];
                return string;
            }
        }
        
        if (page == 1) {
            if (self.avidoDataArr.count==0) {
                NSString *text = @"暂无问诊记录";
                NSDictionary *outAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16], NSForegroundColorAttributeName: UIColorFromHEX(0x666666, 1)};
                
                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:outAttributes];
                NSRange range;
                range.location = 0;
                range.length = text.length;
                [string setAttributes:outAttributes range:range];
                return string;
            }
        }
    }

    return nil;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    
    if (self.isShow) {
        NSInteger page = self.backScrollView.contentOffset.x/SCREEN_WIDTH;
        
        if (page == 0) {
            if (self.chatDataArr.count == 0) {
                return [UIImage imageNamed:@"无订单"];
            }
        }
        
        if (page == 1) {
            if (self.avidoDataArr.count == 0) {
                return [UIImage imageNamed:@"无订单"];
            }
        }
        
    }
    return nil;
}



#pragma mark SETTER - GETTER
- (BATSegmentControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[BATSegmentControl alloc]initWithItems:@[@"图文咨询",@"视频语音"]];
        _segmentControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        _segmentControl.backgroundColor = [UIColor whiteColor];
        _segmentControl.delegate = self;
    }
    return _segmentControl;
}


#pragma BATSegmentControlDelagat
- (void)batSegmentedControl:(BATSegmentControl *)segmentedControl selectedIndex:(NSInteger)index{
    
    //    NSLog(@"%ld----",index);
    [self.backScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}
-(UITableView *)chatTableView {
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-55) style:UITableViewStylePlain];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.emptyDataSetSource = self;
        _chatTableView.emptyDataSetDelegate = self;
        _chatTableView.backgroundColor = [UIColor clearColor];
        [_chatTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_chatTableView registerClass:[BATChatCell class] forCellReuseIdentifier:chatReuseString];
        
        WEAK_SELF(self)
        _chatTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.chatCurrentPage = 1;
            [self chatConsultRequest];
        }];
        
        
        _chatTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self)
            self.chatCurrentPage ++ ;
            [self chatConsultRequest];
        }];
        
        _chatTableView.mj_footer.hidden = YES;
    }
    return _chatTableView;
}

-(UITableView *)bookTableView {
    if (!_bookTableView) {
        _bookTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-55-64) style:UITableViewStylePlain];
        _bookTableView.delegate = self;
        _bookTableView.dataSource = self;
        _bookTableView.emptyDataSetSource = self;
        _bookTableView.emptyDataSetDelegate = self;
        _bookTableView.backgroundColor = [UIColor clearColor];
        [_bookTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        WEAK_SELF(self)
        _bookTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            self.videoCurrentPage = 1;
            [self videoRequest];
        }];
        
        
        _bookTableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            STRONG_SELF(self)
            self.videoCurrentPage ++ ;
            [self videoRequest];
        }];
        
        _bookTableView.mj_footer.hidden = YES;
    }
    return _bookTableView;
}

-(UIScrollView *)backScrollView {
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 55, SCREEN_WIDTH, SCREEN_HEIGHT-55-54)];
        _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, SCREEN_HEIGHT-55-54);
        _backScrollView.pagingEnabled = YES;
        _backScrollView.delegate = self;
        _backScrollView.backgroundColor = [UIColor clearColor];
    }
    return _backScrollView;
}

-(BATHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[BATHeaderView alloc]init];
    }
    return _headerView;
}

-(NSMutableArray *)chatDataArr {
    if (!_chatDataArr) {
        _chatDataArr = [NSMutableArray array];
    }
    return _chatDataArr;
}

-(NSMutableArray *)avidoDataArr {
    if (!_avidoDataArr) {
        _avidoDataArr = [NSMutableArray array];
    }
    return _avidoDataArr;
}

//- (BATDefaultView *)defaultView{
//    if (!_defaultView) {
//        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
//        _defaultView.hidden = YES;
//        WEAK_SELF(self);
//        [_defaultView setReloadRequestBlock:^{
//            STRONG_SELF(self);
//            DDLogInfo(@"=====重新开始加载！=====");
//            self.defaultView.hidden = YES;
//            
//        }];
//        
//    }
//    return _defaultView;
//}

@end
