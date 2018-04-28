//
//  BATGroupAccouncementDetailViewController.m
//  HealthBAT_Pro
//
//  Created by cjl on 16/9/1.
//  Copyright © 2016年 KMHealthCloud. All rights reserved.
//

#import "BATGroupAccouncementDetailViewController.h"

@interface BATGroupAccouncementDetailViewController ()

@end

@implementation BATGroupAccouncementDetailViewController

- (void)dealloc
{
    DDLogWarn(@"%@",self);
}

- (void)loadView
{
    [super loadView];
    
    if (_groupAccouncementDetailView == nil) {
        _groupAccouncementDetailView = [[UINib nibWithNibName:@"BATGroupAccouncementDetailView" bundle:nil] instantiateWithOwner:self options:nil].firstObject;
        [self.view addSubview:_groupAccouncementDetailView];
        
        WEAK_SELF(self);
        [_groupAccouncementDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            STRONG_SELF(self);
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"公告详情";
    
    _groupAccouncementDetailView.creatorLabel.text = _groupAccouncementListData.Creater;
    _groupAccouncementDetailView.timeLabel.text = _groupAccouncementListData.CreatedTime;
    _groupAccouncementDetailView.contentLabel.text = _groupAccouncementListData.NoticeContent;
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

@end
