//
//  MySetViewController.m
//  HealthBAT
//
//  Created by four on 16/5/3.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATMySetViewController.h"

#import "BATChangePasswordViewController.h"
#import "BATLoginViewController.h"
#import "BATOpinionViewController.h"
#import "BATWeChatPublicNumberViewController.h" //微信公众号
#import "BATTIMManager.h"

#import "BATErrorViewController.h"

#import "BATAppDelegate+BATResetLogin.h"
#import "BATGraditorButton.h"
@interface BATMySetViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *settingTableView;
@property (nonatomic,copy  ) NSArray     *dataArray;
@property (nonatomic,strong) BATGraditorButton    *logoutButton;
@property (nonatomic,strong) NSString *beginTime;
@end

@implementation BATMySetViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.beginTime = [Tools getCurrentDateStringByFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.title = @"设置";
    [self pagesLayout];
    [self becomeFirstResponder];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwordChangeSuccess:) name:@"CHANGE_PASSWORD_SUCCESS" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [BATUserPortrayTools saveOperateModuleRequestWithURL:@"/kmStatistical-sync/saveOperateModule" pathName:@"个人中心-设置" moduleId:4 beginTime:self.beginTime];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textColor = UIColorFromRGB(102, 102, 102, 1);
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = [Tools getLocalVersion];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        cell.detailTextLabel.text = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {

        }
            break;
        case 1:
        {
            //意见反馈
            BATOpinionViewController * opinionVC = [[BATOpinionViewController alloc] init];
            [self.navigationController pushViewController:opinionVC animated:YES];

        }
            break;
        case 2:
        {
            BATChangePasswordViewController *view = [[BATChangePasswordViewController alloc]init];
//            [self.navigationController pushViewController:view animated:YES];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:view] animated:YES completion:nil];
        }
            break;
        case 3:
        {
            WEAK_SELF(self)
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否清理缓存" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                STRONG_SELF(self);
                [self showProgress];
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    [self dismissProgress];
                }];
            }];
            
            // Add the actions.
            [alertController addAction:otherAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
            break;
            
        case 4:
        {
            
            NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/jian-kang-bat/id1107478276?l=zh&ls=1&mt=8"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 5:
        {
            
            BATWeChatPublicNumberViewController *weChatVC = [[BATWeChatPublicNumberViewController alloc]init];
            [self.navigationController pushViewController:weChatVC animated:YES];
            
        }
            break;

        default:
            break;
    }
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        Tools *tool = [[Tools alloc]init];
        [tool clearFile:^{
             [self showText:@"清除成功"];
        }];
    }
}

#pragma mark - private 
-(BOOL)canBecomeFirstResponder {

    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent*)event {

    if(event.subtype == UIEventSubtypeMotionShake) {

        BATErrorViewController *errorVC = [[BATErrorViewController alloc] init];
        [self.navigationController pushViewController:errorVC animated:YES];
    }
    
}

#pragma mark - NET
-(void)loginOut{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"您确定要退出登录吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        BATAppDelegate *delegate = (BATAppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate bat_logout];
        //当用户退出登录，通知关注界面模块滚动到精选界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LOGINOUT" object:nil];
        });
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)passwordChangeSuccess:(NSNotification *)info{
    if (!LOGIN_STATION) {
        PRESENT_LOGIN_VC;
    }
}

#pragma mark - layout
- (void)pagesLayout {
    [self.view addSubview:self.settingTableView];
}

#pragma mark - setter && getter
- (UITableView *)settingTableView {
    if (!_settingTableView) {
        _dataArray = @[@"版本信息",@"意见反馈",@"修改密码",@"清理缓存",@"为BAT打分",@"微信公众号"];

        _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _settingTableView.delegate = self;
        _settingTableView.dataSource = self;
        _settingTableView.backgroundColor = UIColorFromRGB(244, 244, 244, 1);
        
        UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        
        BATGraditorButton *loginOutBtn = [BATGraditorButton buttonWithType:UIButtonTypeCustom];
        loginOutBtn.frame = CGRectMake(20,34, SCREEN_WIDTH - 40, 40);
//        loginOutBtn.backgroundColor = BASE_COLOR;
       
         [loginOutBtn setGradientColors:@[START_COLOR,END_COLOR]];
        loginOutBtn.enablehollowOut = YES;
        loginOutBtn.titleColor  = [UIColor whiteColor];
//        [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
        loginOutBtn.layer.cornerRadius = 3.f;
        loginOutBtn.layer.masksToBounds = YES;
        [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [tableFooterView addSubview:loginOutBtn];
        
        _settingTableView.tableFooterView = tableFooterView;
    }
    return _settingTableView;
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
