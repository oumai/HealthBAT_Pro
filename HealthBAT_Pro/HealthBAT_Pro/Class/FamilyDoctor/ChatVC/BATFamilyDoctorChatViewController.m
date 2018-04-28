//
//  BATFamilyDoctorChatViewController.m
//  HealthBAT_Pro
//
//  Created by four on 2017/4/14.
//  Copyright © 2017年 KMHealthCloud. All rights reserved.
//

#import "BATFamilyDoctorChatViewController.h"
#import "IQKeyboardManager.h"

@interface BATFamilyDoctorChatViewController ()

@end

@implementation BATFamilyDoctorChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:PLUGIN_BOARD_ITEM_LOCATION_TAG];
    
     [[BATRongCloudManager sharedBATRongCloudManager] bat_saveRongCloudUserInfoWithUserId:self.DoctorId name:self.DoctorName portraitUri:self.DoctorPhotoPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
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
