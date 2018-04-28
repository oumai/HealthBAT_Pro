//
//  BATMessageViewController.m
//  HealthBAT_Pro
//
//  Created by KM on 16/8/222016.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMessageViewController.h"

#import "YCXMenu.h"

#import "BATMessageCell.h"

#import "BATMessageModel.h"

#import "BATSystemMessageViewController.h"
#import "BATTeacherMessageViewController.h"
#import "BATChatConsultController.h"
#import "BATHomeTraditionMedicineViewController.h"
#import "BATMyFamilyDoctorOrderListViewController.h"

static  NSString * const MESSAGE_ONDURY_DOCTOR_CELL = @"OnDuryDoctorCell";
static  NSString * const MESSAGE_SYSTEM_CELL = @"SystemCell";
static  NSString * const MESSAGE_CONSULTING_CELL = @"ConsultingCell";
static  NSString * const MESSAGE_TEACHER_CELL = @"TeacherCell";
static  NSString * const MESSAGE_FAMILYDOCTOR_CELL = @"FamilyDcotorCell";

@interface BATMessageViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView        *messageTableView;

@property (nonatomic,strong) NSMutableArray     *onDutyDoctorArray;
@property (nonatomic,strong) NSMutableArray     *systemArray;
@property (nonatomic,strong) NSMutableArray     *consultingDoctorArray;
@property (nonatomic,strong) NSMutableArray     *teacherArray;
@property (nonatomic,strong) NSMutableArray     *familyDoctorArray;

@property (nonatomic,strong) NSArray            *items;
@property (nonatomic,assign) NSInteger          type;

@property (nonatomic,strong) BATMessageModel    *messageModel;

@property (nonatomic,assign) BOOL               isShowBlankImage;
@property (nonatomic,assign) NSInteger          unReadNums;
//@property (nonatomic,assign) BOOL               isFirstComing;

@property (nonatomic,strong) BATDefaultView *defaultView;

@end

@implementation BATMessageViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isShowBlankImage = NO;
    self.unReadNums = 0;
//    self.isFirstComing = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apnsReloadMessageData) name:@"NEW_APNS_MESSAGE_RELOAD" object:nil];
    
    self.onDutyDoctorArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.systemArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.consultingDoctorArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.teacherArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.familyDoctorArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.title = @"消息中心";
    
//    [self getDataResquest];
    [self.messageTableView.mj_header beginRefreshing];
    
    [self layoutPages];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
   
        return self.familyDoctorArray.count;
        
    }else if (section == 1) {
        if (self.onDutyDoctorArray.count == 0) {
            return 0;
        }else{
            return 1;
        }
    }else if (section == 2){
        if (self.systemArray.count == 0) {
            return 0;
        }else{
            return 1;
        }
    }else if (section == 3){

        return self.consultingDoctorArray.count;
        
    }else {
        return self.teacherArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BATMessagesData *dict = self.familyDoctorArray[indexPath.row];
        
        BATMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGE_FAMILYDOCTOR_CELL];
        if (messageCell == nil) {
            messageCell = [[BATMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MESSAGE_FAMILYDOCTOR_CELL];
        }
        
        messageCell.iconImageV.image = [UIImage imageNamed:@"message_doctor"];
        messageCell.nameLabel.text = dict.MsgTypeName;
        messageCell.descLabel.text = dict.Title;
        messageCell.timeLabel.text = dict.CreatedTime;
        if (dict.MsgCount == 0) {
            messageCell.unreadLabel.hidden = YES;
        }else{
            messageCell.unreadLabel.hidden = NO;
            messageCell.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)dict.MsgCount];
        }
        
        return messageCell;

    }
    else if (indexPath.section == 1) {
        //值班医生
        BATMessagesData *dict = self.onDutyDoctorArray[indexPath.row];
        
        BATMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGE_ONDURY_DOCTOR_CELL];
        if (messageCell == nil) {
            messageCell = [[BATMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MESSAGE_ONDURY_DOCTOR_CELL];
        }
        
        messageCell.iconImageV.image = [UIImage imageNamed:@"message_doctor"];
        messageCell.nameLabel.text = dict.MsgTypeName;
        messageCell.descLabel.text = dict.Title;
        messageCell.timeLabel.text = dict.CreatedTime;
        if (dict.MsgCount == 0) {
            messageCell.unreadLabel.hidden = YES;
        }else{
            messageCell.unreadLabel.hidden = NO;
            messageCell.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)dict.MsgCount];
        }
        
        return messageCell;
        
    }else if (indexPath.section == 2){
        //系统消息
        BATMessagesData *dict = self.systemArray[indexPath.row];
        
        BATMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGE_SYSTEM_CELL];
        if (messageCell == nil) {
            messageCell = [[BATMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MESSAGE_SYSTEM_CELL];
        }

        messageCell.iconImageV.image = [UIImage imageNamed:@"message_system"];
        messageCell.nameLabel.text = dict.MsgTypeName;
        messageCell.descLabel.text = dict.Title;
        messageCell.timeLabel.text = dict.CreatedTime;
        if (dict.MsgCount == 0) {
            messageCell.unreadLabel.hidden = YES;
        }else{
            messageCell.unreadLabel.hidden = NO;
            messageCell.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)dict.MsgCount];
        }
        
        return messageCell;
        
    }else if (indexPath.section == 3){
        //咨询医生
        BATMessagesData *dict = self.consultingDoctorArray[indexPath.row];
        
        BATMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGE_CONSULTING_CELL];
        if (messageCell == nil) {
            messageCell = [[BATMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MESSAGE_CONSULTING_CELL];
        }
        
        messageCell.iconImageV.image = [UIImage imageNamed:@"message_consult"];
        messageCell.nameLabel.text = dict.MsgTypeName;
        messageCell.descLabel.text = dict.Title;
        messageCell.timeLabel.text = dict.CreatedTime;
        if (dict.MsgCount == 0) {
            messageCell.unreadLabel.hidden = YES;
        }else{
            messageCell.unreadLabel.hidden = NO;
            messageCell.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)dict.MsgCount];
        }

        
        return messageCell;
        
    }else{
        //老师
        BATMessagesData *dict = self.teacherArray[indexPath.row];
        
        BATMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:MESSAGE_TEACHER_CELL];
        if (messageCell == nil) {
            messageCell = [[BATMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MESSAGE_TEACHER_CELL];
        }
   
        [messageCell.iconImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict.ObjPicUrl]] placeholderImage:[UIImage imageNamed:@"医生"]];
        messageCell.nameLabel.text = dict.MsgTypeName;
        messageCell.descLabel.text = dict.Title;
        messageCell.timeLabel.text = dict.CreatedTime;
        if (dict.MsgCount == 0) {
            messageCell.unreadLabel.hidden = YES;
        }else{
            messageCell.unreadLabel.hidden = NO;
            messageCell.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)dict.MsgCount];
        }
        
        return messageCell;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BATMessagesData *pic = self.familyDoctorArray[indexPath.row];
        
        [self deleteFamilyDoctorMessageRequestWithMessageID:pic.ID];
    }
    else if (indexPath.section == 1) {
        //值班医生
        BATMessagesData *pic = self.onDutyDoctorArray[indexPath.row];
        
        [self deleteOneMessageRequest:pic.MsgType andMessageID:pic.ObjAccountID];
        
    }else if (indexPath.section == 2){
        //系统消息
        BATMessagesData *pic = self.systemArray[indexPath.row];
        
        [self deleteOneMessageRequest:pic.MsgType andMessageID:pic.ObjAccountID];
        
    }else if (indexPath.section == 3){
        //咨询医生
        BATMessagesData *pic = self.consultingDoctorArray[indexPath.row];
        
        [self deleteOneMessageRequest:pic.MsgType andMessageID:pic.ObjAccountID];

    }else {
        //老师
        BATMessagesData *pic = self.teacherArray[indexPath.row];
        
        [self deleteOneMessageRequest:pic.MsgType andMessageID:pic.ObjAccountID];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BATMessagesData *pict;
    if (indexPath.section == 0) {
        //值班医生
        pict = self.familyDoctorArray[indexPath.row];
        
    }else if (indexPath.section == 1) {
        //值班医生
        pict = self.onDutyDoctorArray[indexPath.row];
        
    }else if (indexPath.section == 2){
        //系统消息
        pict = self.systemArray[indexPath.row];
        
    }else if (indexPath.section == 3){
        //咨询医生
        pict = self.consultingDoctorArray[indexPath.row];
        
    }else {
        //老师
        pict = self.teacherArray[indexPath.row];
        
    }

    //先标记已读
    if(indexPath.section == 0){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Do the work in background
            [self setFamilyDoctorReadRequest:pict.ID];
        });
        
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Do the work in background
            [self setOneReadRequest:pict.ObjAccountID messageType:pict.MsgType];
        });
    }

    
    //跳转
    if (indexPath.section == 0) {
        //家庭医生订单
        
        
        BATMyFamilyDoctorOrderListViewController *myFamilyDoctorOrderListVC = [[BATMyFamilyDoctorOrderListViewController alloc]init];
        myFamilyDoctorOrderListVC.hidesBottomBarWhenPushed = YES;
        if(pict.OrderState == 2){
            myFamilyDoctorOrderListVC.selectedIndex = 2;
        }else{
            myFamilyDoctorOrderListVC.selectedIndex = 0;
        }
        [self.navigationController pushViewController:myFamilyDoctorOrderListVC animated:YES];
        
    }else if (indexPath.section == 1) {
        //值班医生
        
        BATHomeTraditionMedicineViewController *onDuryDoctorVC = [[BATHomeTraditionMedicineViewController alloc]init];
        onDuryDoctorVC.urlStr = [NSString stringWithFormat:@"%@&message=1",pict.ExtrasContent];
        onDuryDoctorVC.isMessageCenterPush = YES;
        [self.navigationController pushViewController:onDuryDoctorVC animated:YES];
        
    }else if (indexPath.section == 2){
        //系统消息
        BATSystemMessageViewController *systemMessageVC = [[BATSystemMessageViewController alloc]init];
        systemMessageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:systemMessageVC animated:YES];
        
    }else if (indexPath.section == 3){
        //咨询医生
        BATChatConsultController *chatCtl = [[BATChatConsultController alloc]init];
        chatCtl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatCtl animated:YES];
        
//        [self bk_performBlock:^(id obj) {
//            
//            [self.navigationController popToRootViewControllerAnimated:NO];
//        } afterDelay:0.5];
//        
//        [self.tabBarController setSelectedIndex:2];
        
    }else {
        
        //老师
        BATTeacherMessageViewController *teacherMessageVC = [[BATTeacherMessageViewController alloc]init];
        teacherMessageVC.hidesBottomBarWhenPushed = YES;
        teacherMessageVC.teacherID = [pict.ObjAccountID integerValue];
        teacherMessageVC.teacherName = pict.MsgTypeName;
        [self.navigationController pushViewController:teacherMessageVC animated:YES];
    }
    
    
}

#pragma mark - net

- (void)apnsReloadMessageData{
    [self getDataResquest];
}

//消息列表
- (void)getDataResquest{
    
//    if (self.isFirstComing) {
//         [self showProgress];
//    }
//    
    [HTTPTool requestWithURLString:@"/api/MessagePush/GetAllMessageLst?pageIndex=0&pageSize=10" parameters:nil type:kGET success:^(id responseObject) {
        
        [self.messageTableView.mj_header endRefreshing];
        [self.messageTableView.mj_footer endRefreshing];
        
//        if (self.isFirstComing) {
//            [self dismissProgress];
//        }
        
        //先清空
        [self.onDutyDoctorArray removeAllObjects];
        [self.systemArray removeAllObjects];
        [self.consultingDoctorArray removeAllObjects];
        [self.teacherArray removeAllObjects];
        [self.familyDoctorArray removeAllObjects];
        self.unReadNums = 0;
        
        self.messageModel = [BATMessageModel mj_objectWithKeyValues:responseObject];
        
        if (self.messageModel.Data.count == 0) {
            [self.defaultView showDefaultView];
        }
        
        for(BATMessagesData *pic in self.messageModel.Data) {
            
            if (pic.MsgType == kBATMessageType_System) {
                //系统消息
                [self.systemArray addObject:pic];
            }else if(pic.MsgType == kBATMessageType_OnduryDoctor){
                //值班医生
                [self.onDutyDoctorArray addObject:pic];
            }else if(pic.MsgType == kBATMessageType_ConsultingDoctor){
                //咨询医生
                [self.consultingDoctorArray addObject:pic];
            }else if(pic.MsgType == kBATMessageType_Teacher){
                //教师
                [self.teacherArray addObject:pic];
            }else if(pic.MsgType == kBATMessageType_FamilyDoctor){
                //家庭医生
                [self.familyDoctorArray addObject:pic];
            }
            self.unReadNums = self.unReadNums + pic.MsgCount;
        }
        
        //是否显示空白图片
        if (self.messageModel.Data.count == 0) {
            self.isShowBlankImage = YES;
        }
        
        //判断是否还有未读数据
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:self.unReadNums];
        [JPUSHService setBadge:self.unReadNums];
        
        if (_consultingDoctorArray.count== 0 && _onDutyDoctorArray.count == 0 && _systemArray.count == 0 && _teacherArray.count == 0 && _familyDoctorArray.count == 0) {
            [self.defaultView showDefaultView];
            self.defaultView.reloadButton.hidden = YES;
        }
        
        [self.messageTableView reloadData];
        
    } failure:^(NSError *error) {
        [self.messageTableView.mj_header endRefreshing];
        [self.messageTableView.mj_footer endRefreshing];
        [self dismissProgress];
        [self.defaultView showDefaultView];
    }];
}

//一条标记已读
- (void)setOneReadRequest:(NSString *)objAccountId messageType:(BATMessageType)messageType{
    
    [HTTPTool requestWithURLString:@"/api/MessagePush/SetIsReadByMsgType" parameters:@{@"msgType":@(messageType),@"objAccountId":objAccountId} type:kGET success:^(id responseObject) {

        //重新获取数据
        [self getDataResquest];

    } failure:^(NSError *error) {
        
    }];
}

//家庭医生标记已读
- (void)setFamilyDoctorReadRequest:(NSInteger )ID{
    
    [HTTPTool requestWithURLString:@"/api/MessagePush/SetIsRead" parameters:@{@"msgId":@(ID)} type:kGET success:^(id responseObject) {
        
        //重新获取数据
        [self getDataResquest];
        
    } failure:^(NSError *error) {
        
    }];
}


//全部已读
- (void)setAllReadRequest{
    
    [HTTPTool requestWithURLString:@"/api/MessagePush/SetIsRead" parameters:nil type:kGET success:^(id responseObject) {
        
        //重置角标
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        //重新获取数据
        [self getDataResquest];
        
    } failure:^(NSError *error) {
        
    }];
}

//数据全部删除
- (void)deleteAllMessageRequest{
    
    [HTTPTool requestWithURLString:@"/api/MessagePush/ClearAllMsg" parameters:nil type:kGET success:^(id responseObject) {
        
        //重置角标
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        //重新获取数据刷表
        [self getDataResquest];
        
    } failure:^(NSError *error) {
        
    }];
}

//单条信息删除
- (void)deleteOneMessageRequest:(BATMessageType)type andMessageID:(NSString *)ID{
    
    [HTTPTool requestWithURLString:@"/api/MessagePush/DeleteByMsgType" parameters:@{@"msgType":@(type),@"objAccountId":ID} type:kGET success:^(id responseObject) {
        
        //重新获取数据刷表
        [self getDataResquest];
        
    } failure:^(NSError *error) {
        
    }];
}

//家庭医生删除
- (void)deleteFamilyDoctorMessageRequestWithMessageID:(NSInteger )ID{
    
    [HTTPTool requestWithURLString:@"/api/MessagePush/ClearAllMsg" parameters:@{@"msgId":@(ID)} type:kGET success:^(id responseObject) {
        
        //重新获取数据刷表
        [self getDataResquest];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - action
- (void)moreAction:(id)sender{
    
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        [YCXMenu setHasShadow:YES];
        [YCXMenu setBackgrounColorEffect:YCXMenuBackgrounColorEffectSolid];
        [YCXMenu setSeparatorColor:BASE_LINECOLOR];
        [YCXMenu setCornerRadius:5.f];
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(SCREEN_WIDTH - 55, 0, 60, 0) menuItems:self.items selected:^(NSInteger index, YCXMenuItem *item) {
            DDLogDebug(@"%@",item.userInfo);
            
            self.type = [item.userInfo[@"type"] intValue];
            [YCXMenu dismissMenu];
            
            if (self.type) {
                //全部标记已读,并且全部删除!
                DDLogInfo(@"全部标记已读！并且全部删除！");
                
                [self deleteAllMessageRequest];
            }else{
                //全部标记已读
                DDLogInfo(@"全部标记已读！");
                
                [self  setAllReadRequest];
            }
        }];
        [YCXMenu setTintColor:[UIColor whiteColor]];
    }
}

- (void)notificationBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - layout
- (void)layoutPages {
    [self.view addSubview:self.messageTableView];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 6)];
    [rightBtn setImage:[UIImage imageNamed:@"icon-zwzd-gd"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem = item;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-zwzd-gd"] style:UIBarButtonItemStylePlain target:self action:@selector(moreAction:)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 40);
    [btn bk_whenTapped:^{
        [self notificationBack:btn];
    }];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.top.equalTo(self.view);
    }];
}



#pragma mark - getter && setter
- (UITableView *)messageTableView {

    if (!_messageTableView) {

        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.emptyDataSetSource = self;
        _messageTableView.emptyDataSetDelegate = self;
        _messageTableView.tableFooterView = [[UIView alloc] init];
        _messageTableView.backgroundColor = [UIColor clearColor];
        
        WEAK_SELF(self);
        _messageTableView.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
            STRONG_SELF(self);
            [self getDataResquest];
        }];
        _messageTableView.mj_footer.hidden = YES;
    }
    return _messageTableView;
}


- (NSArray *)items {
    if (!_items) {
        _items = @[
                   [YCXMenuItem menuItem:@"全部标记为已读"
                                   image:nil
                                     tag:0
                                userInfo:@{@"type":@0}],
                   [YCXMenuItem menuItem:@"全部清除"
                                   image:nil
                                     tag:0
                                userInfo:@{@"type":@1}]
                   ];
        
        YCXMenuItem *allMenuTitle = _items[0];
        allMenuTitle.foreColor = UIColorFromHEX(0x666666, 1);
        allMenuTitle.titleFont = [UIFont boldSystemFontOfSize:15.0f];
        
        
        YCXMenuItem *deleteMenuTitle = _items[1];
        deleteMenuTitle.foreColor = UIColorFromHEX(0x666666, 1);
        deleteMenuTitle.titleFont = [UIFont boldSystemFontOfSize:15.0f];
        
    }
    return _items;
}

- (BATDefaultView *)defaultView{
    if (!_defaultView) {
        _defaultView = [[BATDefaultView alloc]initWithFrame:CGRectZero];
        _defaultView.hidden = YES;
        WEAK_SELF(self);
        [_defaultView setReloadRequestBlock:^{
            STRONG_SELF(self);
            DDLogInfo(@"=====重新开始加载！=====");
            self.defaultView.hidden = YES;
            
            [self.messageTableView.mj_header beginRefreshing];
        }];
        
    }
    return _defaultView;
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
