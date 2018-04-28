//
//  BATMessageListViewController.h
//  HealthBAT_Pro
//
//  Created by wangxun on 2017/5/12.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATMessageListViewController.h"
#import "BATMessageListModel.h"
#import "BATPersonDetailModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "BATFamilyDoctorChatViewController.h"
#import "BATPerson.h"
#import "BATRongCloudUserModel.h"

@interface BATMessageListViewController ()
//列表无数据占位用
@property (nonatomic, strong)UIView *emptyView;
@end

@implementation BATMessageListViewController

- (instancetype)init{
    if (self = [super init]) {
    
        //设置消息列表中要显那些类型的会话(私聊)
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
        //设置会话列表中用户头像为圆形
        [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
        
        //当网络断开时，是否在Tabel View Header中显示网络连接不可用的提示(默认为 YES)
        self.isShowNetworkIndicatorView = NO;
        
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    //设置无数据时的占位视图
    self.emptyConversationView = self.emptyView;
    self.conversationListTableView.tableFooterView = [[UIView alloc]init];
    
}

//存数据
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //将融云用户信息写入本地
    [[BATRongCloudManager sharedBATRongCloudManager] bat_rongCloudUserWriteToFile];
}

//点击 cell 调用
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    

    BATFamilyDoctorChatViewController *chatVC = [[BATFamilyDoctorChatViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];

    [[BATRongCloudManager sharedBATRongCloudManager] bat_userInfoRequestWithAccountID:model.targetId];

    //设置聊天界面会话类型为私聊
    chatVC.conversationType = ConversationType_PRIVATE;
    //设置会会话标题
    chatVC.title = model.conversationTitle;
    //设置会话目标 ID
    chatVC.DoctorId = model.targetId;
    chatVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:chatVC animated:YES];

    
}

#pragma mark - 懒加载
- (UIView *)emptyView{
    if(!_emptyView){
        _emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-45)];
        _emptyView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-(154/2))/2, (_emptyView.frame.size.height - (130/2))/2 - 30, 154/2, 130/2)];
        imageView.image = [UIImage imageNamed:@"无数据"];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), SCREEN_WIDTH, 30)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"暂无聊天信息";
        titleLabel.textColor = UIColorFromHEX(0x999999, 1);
        titleLabel.font = [UIFont systemFontOfSize:15];
        [_emptyView addSubview:imageView];
        [_emptyView addSubview:titleLabel];
        _emptyView.backgroundColor = UIColorFromHEX(0xf5f5f5, 1);
        
    }
    return _emptyView;
}
@end
